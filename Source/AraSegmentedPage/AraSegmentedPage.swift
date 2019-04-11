//
//  AraSegmentedView.swift
//  AraSegmentedView
//
//  Created by 刘靖禹 on 2019/4/7.
//  Copyright © 2019 Arabaku. All rights reserved.
//

import UIKit

open class AraSegmentedView: UIView {
    
    open weak var delegate: AraSegmentedViewDelegate?
    
    private let segmentedControl: AraSegmentedControl
    private let childVCsArray: [UIViewController]
    
    private var beginOffSetX = CGFloat()
    private var isTap = false // 如果是点击 label，不响应滚动代理
    
    lazy var containerCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = self.bounds.size
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.gray
        collectionView.isPrefetchingEnabled = false
        collectionView.scrollsToTop = false
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()

    public init(frame: CGRect, segmentedControl: AraSegmentedControl, childVCsArray: [UIViewController]) {
        self.childVCsArray = childVCsArray
        self.segmentedControl = segmentedControl
        super.init(frame: frame)
        
        addSubview(containerCollectionView)
        containerCollectionView.scrollToItem(at: IndexPath(item: segmentedControl.currentIndex, section: 0), at: .centeredHorizontally, animated: false)
        
        segmentedControl.buttonClickAction = { [weak self] (index, oldIndex) in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.araSegmentedView(strongSelf, didClickIndex: index, oldIndex: oldIndex)
        }
        segmentedControl.changeIndexAction = { [weak self] (index) in
            guard let strongSelf = self else { return }
            strongSelf.isTap = true
            strongSelf.containerCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
            strongSelf.delegate?.araSegmentedView(strongSelf, didMoveToIndex: index)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    #if DEBUG
    deinit {
        print("AraSegmentedView deinit.")
    }
    #endif
    
}

// MARK: - UICollectionView 代理
extension AraSegmentedView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCsArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        let vc = childVCsArray[indexPath.item]
        vc.view.frame = bounds
        cell.contentView.addSubview(vc.view)
        return cell
    }
    
}

// MARK: - 滚动代理
extension AraSegmentedView {
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        segmentedControl.isUserInteractionEnabled = true
        let index = Int(floor(scrollView.contentOffset.x / bounds.size.width))
        segmentedControl.currentIndex = index
    }
    
    // 防止滑动到了边界而被迫终止时不调用 scrollViewDidEndDecelerating
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            segmentedControl.isUserInteractionEnabled = true
            let index = Int(floor(scrollView.contentOffset.x / bounds.size.width))
            segmentedControl.currentIndex = index
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isTap = false
        segmentedControl.isUserInteractionEnabled = false
        beginOffSetX = scrollView.contentOffset.x
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.araSegmentedViewIsMoving(self)
        
        guard !isTap else { return }
    
        let offSetX = scrollView.contentOffset.x
        let temp = offSetX / bounds.width
        
        var progress = temp - floor(temp)
        var oldIndex: Int
        var currentIndex: Int
        
        if offSetX - beginOffSetX >= 0 { // 左拖，右移
            oldIndex = Int(floor(offSetX / bounds.size.width))
            currentIndex = oldIndex + 1
            if currentIndex >= childVCsArray.count {
                currentIndex = oldIndex - 1
            }
            if offSetX - beginOffSetX == scrollView.bounds.size.width { // 滚动完成
                progress = 1.0
                currentIndex = oldIndex
            }
        } else { // 右拖，左移
            currentIndex = Int(floor(offSetX / bounds.size.width))
            oldIndex = currentIndex + 1
            progress = 1.0 - progress
        }
        delegate?.araSegmentedView(self, isDraggingFromIndex: oldIndex, toIndex: currentIndex, progress: Float(progress))
        segmentedControl.adjuctUIWithProgress(progress, oldIndex: oldIndex, currentIndex: currentIndex)
    }
    
}

