//
//  HomeController.swift
//  MovieDB
//
//  Created by Cuong on 1/6/20.
//  Copyright © 2020 CuongVX-D1. All rights reserved.
//

import UIKit

final class HomeController: UITabBarController {
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Views
    private func setupView() {
        navigationController?.navigationBar.isHidden = true
        UITabBarItem.appearance()
            .setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.secondGradientColor], for: .selected)
    }
}

extension HomeController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
