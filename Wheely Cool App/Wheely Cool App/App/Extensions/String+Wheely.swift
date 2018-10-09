//
//  String+Wheely.swift
//  Wheely Cool App
//
//  Created by Guilherme Politta on 10/10/18.
//  Copyright © 2018 Guilherme Politta. All rights reserved.
//

import UIKit

extension String {
    func withLineHeight(_ lineHeight: CGFloat,
                        textAlignment: NSTextAlignment = .natural,
                        lineBreakMode: NSLineBreakMode = .byTruncatingTail) -> NSMutableAttributedString {
        let string: NSMutableAttributedString = NSMutableAttributedString(string: self)
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineBreakMode = lineBreakMode
        string.addAttribute(.paragraphStyle, value: paragraphStyle)
        return string
    }
}
