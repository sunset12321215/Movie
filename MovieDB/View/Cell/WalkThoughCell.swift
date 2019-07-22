//
//  WalkThoughCell.swift
//  MovieDB
//
//  Created by CuongVX-D1 on 7/22/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import UIKit

final class WalkThoughCell: UICollectionViewCell, Reusable {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setContentForCell(data: WalkThough) {
        imageView.image = UIImage(named: data.imageString)
        titleLabel.text = data.title
    }
}
