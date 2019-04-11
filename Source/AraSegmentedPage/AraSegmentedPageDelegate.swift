//
//  AraSegmentedViewDelegate.swift
//  AraSegmentedView
//
//  Created by 刘靖禹 on 2019/4/8.
//  Copyright © 2019 Arabaku. All rights reserved.
//

import Foundation

public protocol AraSegmentedViewDelegate: class {
    func araSegmentedView(_ araSegmentedView: AraSegmentedView, didClickIndex index: Int, oldIndex: Int)
    func araSegmentedView(_ araSegmentedView: AraSegmentedView, didMoveToIndex index: Int)
    func araSegmentedView(_ araSegmentedView: AraSegmentedView, isDraggingFromIndex fromIndex: Int, toIndex: Int, progress: Float)
    func araSegmentedViewIsMoving(_ araSegmentedView: AraSegmentedView)
}

public extension AraSegmentedViewDelegate {
    func araSegmentedView(_ araSegmentedView: AraSegmentedView, didClickIndex index: Int, oldIndex: Int) {}
    func araSegmentedView(_ araSegmentedView: AraSegmentedView, didMoveToIndex index: Int) {}
    func araSegmentedView(_ araSegmentedView: AraSegmentedView, isDraggingFromIndex fromIndex: Int, toIndex: Int, progress: Float) {}
    func araSegmentedViewIsMoving(_ araSegmentedView: AraSegmentedView) {}
}

