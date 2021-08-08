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
                                                          frame: CGRect(x: 0, y: 0, width: 30 * Screen.ratioWidth, height: 30 * Screen.ratioHeight),
                                                          colors: mixColors)
}

enum GradientOrientation {
    case topToBottom
    case leftToRight
    
    func getPoints() -> [CGPoint] {
        switch self {
        case .topToBottom:
            return [CGPoint(x: 0, y: 1),
                    CGPoint(x: 0,y: 0)]
        case .leftToRight:
            return [CGPoint(x: 0, y: 0),
                    CGPoint(x: 1, y: 0)]
        }
    }
}

extension UIView {
    
    var colorOne: CGColor {
        return #colorLiteral(red: 0.9764705882, green: 0.6235294118, blue: 0, alpha: 1).cgColor
    }
    
    var colorTwo: CGColor {
        return #colorLiteral(red: 0.8588235294, green: 0.1882352941, blue: 0.4117647059, alpha: 1).cgColor
    }
    
    func setGradientColor(orientation: GradientOrientation) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorOne, colorTwo]
        let arrayPoint = orientation.getPoints()
        gradientLayer.startPoint = arrayPoint[0]
        gradientLayer.endPoint = arrayPoint[1]
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at:0)
    }
}
