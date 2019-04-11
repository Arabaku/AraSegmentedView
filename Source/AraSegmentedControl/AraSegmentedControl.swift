//
//  AraSegmentedControl.swift
//  AraSegmentedView
//
//  Created by 刘靖禹 on 2019/4/7.
//  Copyright © 2019 Arabaku. All rights reserved.
//

import UIKit

/*
 TabViewStyle:
 
 left -> 根据 buttonMarginMin 自左向右排版
 average -> 先根据 left 计算 contentTotalWidth，小于 tabScrollView 就重新计算 buttonMarginMin
 averageForce -> 先根据 left 计算 contentTotalWidth，小于 tabScrollView 就强制设置 button 的平均长度
 */
public enum TabViewAlign {
    case left
    case average
}

open class AraSegmentedControl: UIView {
    
    private let titlesArray: [String]
    private var buttonsArray: [UIButton] = []
    
    private var contentTotalWidth: CGFloat = 0
    private var buttonMarginReal: CGFloat = 0
    
    // 宽度间隙最小值
    open var buttonMarginMin: CGFloat = 15 {
        didSet {
            guard buttonMarginMin != oldValue else { return }
            contentTotalWidth = 0
            for i in 0 ..< buttonsArray.count {
                if i == 0 {
                    contentTotalWidth += buttonMarginMin + buttonsArray[i].ara.titleRealWidth + buttonMarginMin
                } else {
                    contentTotalWidth += buttonsArray[i].ara.titleRealWidth + buttonMarginMin
                }
            }
            setupFrame()
        }
    }
    // text font
    open var titleFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            guard titleFont != oldValue else { return }
            contentTotalWidth = 0
            for i in 0 ..< buttonsArray.count {
                buttonsArray[i].titleLabel?.font = titleFont
                if i == 0 {
                    contentTotalWidth += buttonMarginMin + buttonsArray[i].ara.titleRealWidth + buttonMarginMin
                } else {
                    contentTotalWidth += buttonsArray[i].ara.titleRealWidth + buttonMarginMin
                }
            }
            setupFrame()
        }
    }
    // text 未选中颜色
    open var normalTitleColor: UIColor = UIColor.white.withAlphaComponent(0.5) {
        didSet {
            guard normalTitleColor != oldValue else { return }
            for i in 0 ..< buttonsArray.count where i != currentIndex {
                buttonsArray[i].setTitleColor(normalTitleColor, for: .normal)
            }
        }
    }
    // text 选中颜色
    open var selectedTitleColor: UIColor = UIColor.white {
        didSet {
            guard selectedTitleColor != oldValue else { return }
            buttonsArray[currentIndex].setTitleColor(selectedTitleColor, for: .normal)
        }
    }
    // lineView 样式
    open var showLineView: Bool = true {
        didSet {
            guard showLineView != oldValue else { return }
            if showLineView {
                lineView.isHidden = false
                for i in 0 ..< buttonsArray.count {
                    buttonsArray[i].bounds.size.height = bounds.size.height - lineViewHeight
                }
            } else {
                lineView.isHidden = true
                for i in 0 ..< buttonsArray.count {
                    buttonsArray[i].bounds.size.height = bounds.size.height
                }
            }
        }
    }
    // 下划线高度
    open var lineViewHeight: CGFloat = 2 {
        didSet {
            guard lineViewHeight != oldValue else { return }
            setupFrame()
        }
    }
    // 下划线颜色
    open var lineViewColor: UIColor = UIColor.yellow {
        didSet {
            guard lineViewColor != oldValue else { return }
            lineView.backgroundColor = lineViewColor
        }
    }
    // 离底部高度
    open var lineViewMarginBottom: CGFloat = 3 {
        didSet {
            guard lineViewMarginBottom != oldValue else { return }
            lineView.frame.origin.y = bounds.size.height - lineViewHeight - lineViewMarginBottom
        }
    }
    // 当前 index
    open var currentIndex: Int {
        didSet {
            guard currentIndex != oldValue else { return }
            resetTextHighlightAndLineView()
            updateScrollViewContentOffset()
            if let action = changeIndexAction {
                action(currentIndex)
            }
        }
    }
    // 排版方式
    open var tabViewAlign: TabViewAlign = .average {
        didSet {
            guard tabViewAlign != oldValue else { return }
            setupFrame()
        }
    }
    var changeIndexAction: ((_ index: Int) -> Void)?
    var buttonClickAction: ((_ index: Int, _ oldIndex: Int) -> Void)?
    
    private lazy var tabScrollView: UIScrollView = {
        let sv = UIScrollView(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        sv.isPagingEnabled = false
        sv.scrollsToTop = false
        sv.bounces = true
        return sv
    }()
    
    private lazy var lineView: UIView = {
        let lv = UIView()
        lv.backgroundColor = lineViewColor
        lv.clipsToBounds = true
        return lv
    }()
    
    public init(frame: CGRect, titlesArray: [String], initIndex: Int = 0) {
        self.titlesArray = titlesArray
        self.currentIndex = initIndex
        
        super.init(frame: frame)
        
        addSubview(tabScrollView)
        setupTitles()
        tabScrollView.addSubview(lineView)
        
        setupFrame()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    #if DEBUG
    deinit {
        print("AraSegmentedControl deinit.")
    }
    #endif
    
    private func setupTitles() {
        for i in 0 ..< titlesArray.count {
            let button = UIButton(type: .custom)
            tabScrollView.addSubview(button)
            button.tag = i
            button.titleLabel?.baselineAdjustment = .alignCenters
            button.titleLabel?.font = titleFont
            button.setTitle(titlesArray[i], for: .normal)
            button.setTitleColor(normalTitleColor, for: .normal)
            button.addTarget(self, action: #selector(onLabelTap(_:)), for: .touchUpInside)
            if i == 0 {
                contentTotalWidth += buttonMarginMin + button.ara.titleRealWidth + buttonMarginMin
            } else {
                contentTotalWidth += button.ara.titleRealWidth + buttonMarginMin
            }
            buttonsArray.append(button)
        }
    }
    
    private func setupFrame() {
        // buttons
        switch tabViewAlign {
        case .left:
            tabScrollView.contentSize = CGSize(width: contentTotalWidth, height: tabScrollView.bounds.size.height)
            buttonMarginReal = buttonMarginMin
            break
        case .average:
            if contentTotalWidth >= tabScrollView.bounds.size.width {
                tabScrollView.contentSize = CGSize(width: contentTotalWidth, height: tabScrollView.bounds.size.height)
                buttonMarginReal = buttonMarginMin
            } else {
                // 重新计算 buttonMarginMin
                tabScrollView.contentSize = CGSize(width: tabScrollView.bounds.size.width, height: bounds.size.height)
                var temp: CGFloat = tabScrollView.bounds.size.width
                for i in 0 ..< buttonsArray.count {
                    temp = temp - buttonsArray[i].ara.titleRealWidth
                }
                buttonMarginReal = temp / CGFloat((buttonsArray.count + 1))
            }
            break
        }
        
        for i in 0 ..< buttonsArray.count {
            let x: CGFloat = i == 0 ? buttonMarginReal : buttonsArray[i - 1].frame.maxX + buttonMarginReal
            let y: CGFloat = 0
            let width: CGFloat = buttonsArray[i].ara.titleRealWidth
            let height: CGFloat = bounds.size.height - lineViewHeight
            buttonsArray[i].frame = CGRect(x: x, y: y, width: width, height: height)
        }
        buttonsArray[currentIndex].setTitleColor(selectedTitleColor, for: .normal)
        
        // lineView
        let x: CGFloat = 0
        let y: CGFloat = bounds.size.height - lineViewHeight - lineViewMarginBottom
        let width: CGFloat = buttonsArray[currentIndex].ara.titleRealWidth
        let height: CGFloat = lineViewHeight
        lineView.layer.cornerRadius = lineViewHeight / 2
        lineView.frame = CGRect(x: x, y: y, width: width, height: height)
        lineView.center.x = buttonsArray[currentIndex].center.x
    }
    
    @objc private func onLabelTap(_ sender: UIButton) {
        if let action = buttonClickAction {
            action(sender.tag, currentIndex)
        }
        if sender.tag == currentIndex {
            return
        }
        currentIndex = sender.tag
    }
    
    func adjuctUIWithProgress(_ progress: CGFloat, oldIndex: Int, currentIndex: Int) {
        let oldButton = buttonsArray[oldIndex]
        let currentButton = buttonsArray[currentIndex]
        // lineView 位置 = 初始位置 + 总位移矢量 * 进度
        let xDistance = currentButton.center.x - oldButton.center.x
        lineView.center.x = oldButton.center.x + xDistance * progress
        // lineView 长度 = 初始长度 + 总长度变化矢量 * 进度
        let width = currentButton.ara.titleRealWidth - oldButton.ara.titleRealWidth
        lineView.bounds.size.width = oldButton.ara.titleRealWidth + width * progress
    }
    
    // 重置 text 高亮和 lineView 位置
    func resetTextHighlightAndLineView() {
        for i in 0 ..< buttonsArray.count {
            if i == currentIndex {
                buttonsArray[i].setTitleColor(selectedTitleColor, for: .normal)
            } else {
                buttonsArray[i].setTitleColor(normalTitleColor, for: .normal)
            }
        }
        let currentButton = buttonsArray[currentIndex]
        UIView.animate(withDuration: 0.3) {
            self.lineView.bounds.size.width = currentButton.ara.titleRealWidth
            self.lineView.center.x = currentButton.center.x
        }
    }
    
    private func updateScrollViewContentOffset() {
        guard contentTotalWidth >= tabScrollView.bounds.size.width else { return }
        let leftArea = tabScrollView.center.x
        let rightArea = tabScrollView.contentSize.width - tabScrollView.center.x
        var tabViewContentOffsetX: CGFloat
        if lineView.center.x <= leftArea {
            tabViewContentOffsetX = 0
        } else if lineView.center.x >= rightArea {
            tabViewContentOffsetX = tabScrollView.contentSize.width - tabScrollView.bounds.size.width
        } else {
            tabViewContentOffsetX = lineView.center.x - tabScrollView.center.x
        }
        UIView.animate(withDuration: 0.3) {
            self.tabScrollView.contentOffset = CGPoint(x: tabViewContentOffsetX, y: 0)
        }
    }
    
}
