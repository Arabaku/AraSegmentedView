//
//  MainViewController.swift
//  AraSegmentedView
//
//  Created by Arabaku@126.com on 04/10/2019.
//  Copyright (c) 2019 Arabaku@126.com. All rights reserved.
//

import UIKit
import AraSegmentedView

class MainViewController: UIViewController {
    
    lazy var segmentedControl: AraSegmentedControl = {
        let sv = AraSegmentedControl(
            frame: CGRect(x: 0, y: 0, width: 250, height: 40),
            titlesArray: ["热点","好友动态","视频","搞笑","NBA","同城资讯"],
            //titlesArray: ["热点","好友动态","视频"],
            initIndex: 1
        )
        sv.backgroundColor = UIColor.black
        sv.titleNormalColor = UIColor.white.withAlphaComponent(0.5)
        sv.titleSelectedColor = UIColor.white
        sv.titleMarginMin = 15
        sv.lineViewHeight = 2
        sv.showLineView = true
        sv.tabViewAlign = .average
        sv.titleFont = UIFont.systemFont(ofSize: 15)
        sv.lineViewMarginBottom = 3
        return sv
    }()
    
    lazy var segmentedContentView: AraSegmentedView = {
        let contentView = AraSegmentedView(
            frame: CGRect(x: 0, y: topHeight(), width: self.view.bounds.width, height: self.view.bounds.height - topHeight() - bottomHeight()),
            segmentedControl: segmentedControl,
            //childVCsArray: [ChildViewController1(), ChildViewController2(), ChildViewController3()]
            childVCsArray: [ChildViewController1(), ChildViewController2(), ChildViewController3(), ChildViewController1(), ChildViewController2(), ChildViewController3()]
        )
        contentView.delegate = self
        return contentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = segmentedControl
        segmentedControl.center = navigationItem.titleView!.center
        view.addSubview(segmentedContentView)
    }
    
    func topHeight() -> CGFloat {
        return self.navigationController!.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.size.height
    }
    
    func bottomHeight() -> CGFloat {
        return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? CGFloat.zero
    }
    
    deinit {
        print("MainViewController deinit.")
    }
    
}

extension MainViewController: AraSegmentedViewDelegate {
    
    func araSegmentedView(_ araSegmentedView: AraSegmentedView, didClickIndex index: Int, oldIndex: Int) {
        print("点击了index：\(index)，上一个index：\(oldIndex)")
    }
    
    func araSegmentedView(_ araSegmentedView: AraSegmentedView, didMoveToIndex index: Int) {
        print("已经移动到：\(index)")
    }
    
    func araSegmentedView(_ araSegmentedView: AraSegmentedView, isDraggingFromIndex fromIndex: Int, toIndex: Int, progress: Float) {
        print("从：\(fromIndex), 拖动到：\(toIndex), 进度：\(progress)")
    }
    
    func araSegmentedViewIsMoving(_ araSegmentedView: AraSegmentedView) {
        
    }
    
}

