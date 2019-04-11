//
//  UIButton+Extension.swift
//  AraSegmentedView
//
//  Created by 刘靖禹 on 2019/4/9.
//  Copyright © 2019 Arabaku. All rights reserved.
//

import UIKit

extension UIButton: AraSegmentedViewCompatible {}
extension AraSegmentedViewWrapper where Base == UIButton {
    
    var titleRealSize: CGSize {
        if let label = base.titleLabel, let text = label.text, let font = label.font {
            return text.size(withAttributes: [NSAttributedString.Key.font : font])
        }
        return CGSize.zero
    }
    
    var titleRealWidth: CGFloat {
        return ceil(titleRealSize.width) + 1
    }
    
}

