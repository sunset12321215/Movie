//
//  CustomPageControl.swift
//  MovieDB
//
//  Created by CuongVX-D1 on 7/22/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import UIKit

final class CustomImagePageControl: UIPageControl {
    
    //  MARK: - Outlet
    private let activeImage = UIImage(named: "WhiteDot")!
    private let inactiveImage = UIImage(named: "GrayDot")!
    
    //  MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        pageIndicatorTintColor = UIColor.clear
        currentPageIndicatorTintColor = UIColor.clear
        clipsToBounds = false
    }
    
    //  MARK: - Update View
    func updateDots() {
        var i = 0
        for view in self.subviews {
            if let imageView = imageForSubview(view) {
                if i == currentPage {
                    imageView.image = activeImage
                } else {
                    imageView.image = inactiveImage
                }
                i = i + 1
            } else {
                var dotImage = inactiveImage
                if i == currentPage {
                    dotImage = activeImage
                }
                view.clipsToBounds = false
                view.addSubview(UIImageView(image:dotImage))
                i = i + 1
            }
        }
    }
    
    fileprivate func imageForSubview(_ view: UIView) -> UIImageView? {
        var dot: UIImageView?
        
        if let dotImageView = view as? UIImageView {
            dot = dotImageView
        } else {
            for foundView in view.subviews {
                if let imageView = foundView as? UIImageView {
                    dot = imageView
                    break
                }
            }
        }
        return dot
    }
}
