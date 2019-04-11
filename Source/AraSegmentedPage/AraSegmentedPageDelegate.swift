//
//  AraSegmentedViewDelegate.swift
//  AraSegmentedView
//
//  Created by 刘靖禹 on 2019/4/8.
//  Copyright © 2019 Arabaku. All rights reserved.
//

import Foundation

public protocol AraSegmentedViewDelegate: class {
    func araSegmentedViewDidClickIndex(_ index: Int, oldIndx: Int)
    func araSegmentedViewDidMoveToIndex(_ index: Int)
    func araSegmentedViewIsDragging(fromIndex: Int, toIndex: Int, progress: Float)
}

public extension AraSegmentedViewDelegate {
    func araSegmentedViewDidClickIndex(_ index: Int, oldIndx: Int) {}
    func araSegmentedViewDidMoveToIndex(_ index: Int) {}
    func araSegmentedViewIsDragging(fromIndex: Int, toIndex: Int, progress: Float) {}
}

