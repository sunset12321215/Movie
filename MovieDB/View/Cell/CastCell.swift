//
//  CastCell.swift
//  MovieDB
//
//  Created by CuongVX-D1 on 8/2/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import UIKit

final class CastCell: UICollectionViewCell, NibReusable {

    @IBOutlet private weak var castImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var jobLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
