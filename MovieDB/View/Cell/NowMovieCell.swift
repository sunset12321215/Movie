//
//  NowMovieCell.swift
//  MovieDB
//
//  Created by CuongVX-D1 on 7/23/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import UIKit

final class  NowMovieCell: UICollectionViewCell, NibReusable {

    //  MARK: - Outlet
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var hidenImageView: UIImageView!
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var ribbonImage: UIImageView!
    
    //  MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        showAnimationRibbonImage()
        configViews()
    }
    
    //  MARK: - Setup Views
    func setContentForCell(data: Movie) {
        movieNameLabel.text = data.title
        let fullImageURL = URL(string: String(URLs.APIImagesOriginalPath) + data.posterPath)
        movieImageView.sd_setImage(with: fullImageURL) { [weak self] (_, _, _, _) in
            guard let self = self else { return }
            self.movieImageView.hideSkeleton()
            self.hidenImageView.isHidden = false
        }
    }
    
    private func configViews() {
        movieImageView.showAnimatedGradientSkeleton()
        hidenImageView.isHidden = true
    }
    
    func showAnimationRibbonImage() {
        ribbonImage.alpha = 0
        UIView.animate(withDuration: 5, delay: 0.5, options: [.autoreverse, .repeat], animations: {
            self.ribbonImage.alpha = 1
        }, completion: nil)
    }

    override func prepareForReuse() {
        movieImageView.image = nil
    }
}
