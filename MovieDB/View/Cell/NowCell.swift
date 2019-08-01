//
//  NowCell.swift
//  MovieDB
//
//  Created by CuongVX-D1 on 7/23/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import UIKit

final class NowCell: UICollectionViewCell, NibReusable {

    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var movieNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
