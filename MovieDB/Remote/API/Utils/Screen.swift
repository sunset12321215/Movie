//
//  Screen.swift
//  MovieDB
//
//  Created by CuongVX-D1 on 7/24/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.

import Foundation
import UIKit

struct Screen {
    private static let bounds = UIScreen.main.bounds
    static let width = bounds.size.width
    static let height = bounds.size.height
    static let designWidth: CGFloat = 320
    static let designHeight: CGFloat = 568
    static let ratioWidth = width / designWidth
    static let ratioHeight = height / designHeight
    static let statusBarHeight = UIApplication.shared.statusBarFrame.height
    
    static func horizontalOrientation() {
        var value = UIInterfaceOrientation.landscapeRight.rawValue
        if UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight{
            value = UIInterfaceOrientation.portrait.rawValue
        }
        UIDevice.current.setValue(value, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
}
