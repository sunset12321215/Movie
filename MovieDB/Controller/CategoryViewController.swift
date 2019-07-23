//
//  CategoryViewController.swift
//  MovieDB
//
//  Created by CuongVX-D1 on 7/23/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import UIKit

final class CategoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbarItem()
    }
    
    private func setupTabbarItem() {
        self.title = "CATEGORY"
        self.tabBarItem.image = UIImage(named: "Categories")
        self.tabBarItem.selectedImage = UIImage(named: "CategoriesSelected")?.withRenderingMode(.alwaysOriginal)
    }
}
