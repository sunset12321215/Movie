//
//  TopRatedCell.swift
//  MovieDB
//
//  Created by CuongVX-D1 on 8/1/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import UIKit

final class TopRatedCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet private weak var backImageView: UIImageView!
    @IBOutlet private weak var topImageView: UIImageView!
    @IBOutlet private weak var yearReleaseLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var scoreView: UIView!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configCell()
    }
    
    func setContentForCell(data: Movie) {
        topImageView.showAnimatedGradientSkeleton()
        let url = URL(string: String(URLs.APIImagesOriginalPath) + data.posterPath)
        yearReleaseLabel.text = data.year
        nameLabel.text = data.title
        scoreLabel.attributedText = String.scoreLabelAttribute(score: data.voteAverage, color: .white)
        backImageView.sd_setImage(with: url)
        topImageView.sd_setImage(with: url) { (_, _, _, _) in
            self.topImageView.hideSkeleton()
        }
    }
    
    private func configCell() {
        scoreView.do {
            $0.backgroundColor = .secondGradientColor
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = scoreView.frame.height / 2
        }
    }
}
