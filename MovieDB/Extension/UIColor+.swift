//
//  UIColor+.swift
//  MovieDB
//
//  Created by Cuong on 12/30/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import Foundation
import ChameleonFramework

extension UIColor {
    private static var mixColors: [UIColor] {
        guard let firstColor = HexColor("F99F00"),
            let secondColor = HexColor("DB3069") else {
                return []
        }
        return [firstColor, secondColor]
    }
    public static let firstGradientColor = GradientColor(.leftToRight,
                                                         frame: CGRect(x: 0, y: 0, width: Screen.width, height: 5),
                                                         colors: mixColors)
    public static let secondGradientColor = GradientColor(.topToBottom,
                                                          frame: CGRect(x: 0, y: 0, width: 30, height: 30),
                                                          colors: mixColors)
}
