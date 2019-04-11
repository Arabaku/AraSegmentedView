//
//  AraNamespace.swift
//  AraSegmentedView
//
//  Created by 刘靖禹 on 2019/4/7.
//  Copyright © 2019 Arabaku. All rights reserved.
//

import Foundation

struct AraSegmentedViewWrapper<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

protocol AraSegmentedViewCompatible {
    associatedtype CompatibleType
    var ara: CompatibleType { get }
}

extension AraSegmentedViewCompatible {
    var ara: AraSegmentedViewWrapper<Self> {
        get {
            return AraSegmentedViewWrapper(self)
        }
    }
}

