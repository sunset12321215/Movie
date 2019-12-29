//
//  HomeController.swift
//  MovieDB
//
//  Created by Cuong on 1/6/20.
//  Copyright © 2020 CuongVX-D1. All rights reserved.
//

import UIKit

final class HomeController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbarItem()
        configViews()
    }

    private func configViews() {
        let walkThoughtScreen = WalkThroughViewController.instantiate()
        present(walkThoughtScreen, animated: false, completion: nil)
    }
    
    private func setupTabbarItem() { UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.secondGradientColor], for: .selected)
    }
}
