//
//  MovieViewController.swift
//  MovieDB
//
//  Created by CuongVX-D1 on 7/23/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import UIKit

final class MovieViewController: UIViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbarItem()
    }
    
    private func setupTabbarItem() {
        self.title = "MOVIE"
        self.tabBarItem.image = UIImage(named: "Movie")
        self.tabBarItem.selectedImage = UIImage(named: "MovieSlected")?.withRenderingMode(.alwaysOriginal)
    }
}
