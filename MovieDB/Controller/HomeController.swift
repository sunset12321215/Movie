//
//  HomeController.swift
//  MovieDB
//
//  Created by Cuong on 1/6/20.
//  Copyright © 2020 CuongVX-D1. All rights reserved.
//

import UIKit

class cat: Object {
    var id = 0
    var name = ""
}

final class HomeController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbarItem()
        
        var realm = try? Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
    }
    
    private func setupTabbarItem()  { UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.secondGradientColor], for: .selected)
    }
}
