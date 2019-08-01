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
    static let designWidth: CGFloat = 375
    static let designHeight: CGFloat = 900
    static let ratioWidth = width / designWidth
    static let ratioHeight = height / designHeight
    static let statusBarHeight = UIApplication.shared.statusBarFrame.height
}
