//
//  UIScrollView+Wheely.swift
//  Wheely Cool App
//
//  Created by Guilherme Politta on 10/10/18.
//  Copyright © 2018 Guilherme Politta. All rights reserved.
//

import UIKit

extension UIScrollView {
    func getNormalizedScrollPosition(_ max: CGFloat) -> CGFloat {
        let scrollPosition: CGFloat = adjustedContentInset.top + contentOffset.y
        return (1.0 - (scrollPosition / max)).clamp()
    }
}

fileprivate extension FloatingPoint {
    func clamp(min: Self = 0, max: Self = 1) -> Self {
        if self < min {
            return min
        }
        if self > max {
            return max
        }
        return self
    }
}
