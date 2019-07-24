//
//  TopRatedCell.swift
//  MovieDB
//
//  Created by CuongVX-D1 on 8/1/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import UIKit

final class TopRatedCell: UICollectionViewCell, NibReusable {

    @IBOutlet private weak var topImageView: UIImageView!
    @IBOutlet private weak var yearReleaseLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topImageView.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
    }
}
