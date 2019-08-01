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
    }
    
    func setContentForCell(data: Movie) {
        let url = URL(string: String(URLs.APIImagesOriginalPath) + data.posterPath)
        topImageView.showAnimatedGradientSkeleton()
        self.topImageView.sd_setImage(with: url) { (_, _, _, _) in
            self.topImageView.hideSkeleton()
        }
        yearReleaseLabel.text = data.year
        nameLabel.text = data.title
    }
}
