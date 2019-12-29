//
//  String+.swift
//  MovieDB
//
//  Created by Cuong on 12/30/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import Foundation

extension String {
    public static func scoreLabelAttribute(score: Float, color: UIColor) -> NSMutableAttributedString {
        let scoreString = String(score)
        let dotIndex = scoreString.firstIndex(of: ".") ?? scoreString.endIndex
        let leftNumber = scoreString[..<dotIndex]
        let rightNumber = scoreString[dotIndex..<scoreString.endIndex]
        
        let mediumFont = UIFont.systemFont(ofSize: 20, weight: .medium)
        let smallFont = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        let firstAtribute: [NSAttributedString.Key : Any] = [.font : mediumFont, .foregroundColor : color]
        let secondAtribute: [NSAttributedString.Key : Any] = [.font : smallFont, .foregroundColor : color]
        
        let attributeStringFirst = NSMutableAttributedString.init(string: String(leftNumber))
        attributeStringFirst.addAttributes(firstAtribute,
                                           range: NSRange.init(location: 0, length: 1))
        
        let attributeStringSecond = NSMutableAttributedString.init(string: String(rightNumber))
        attributeStringSecond.addAttributes(secondAtribute,
                                            range: NSRange.init(location: 1, length: 1))
        
        attributeStringFirst.append(attributeStringSecond)
        return attributeStringFirst
    }
}
