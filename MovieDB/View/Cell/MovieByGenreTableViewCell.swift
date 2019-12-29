//
//  MovieByGenreTableViewCell.swift
//  MovieDB
//
//  Created by Cuong on 1/8/20.
//  Copyright © 2020 CuongVX-D1. All rights reserved.
//

import UIKit

final class MovieByGenreTableViewCell: UITableViewCell, NibReusable {

    //  MARK: - Outlet
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var oveviewLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    //  MARK: - Properties
    private struct Constant {
        static let imageScale: CGFloat = 0.6
        static let animationTime = 0.3
    }
    
    //  MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configViews()
    }
    
    //  MARK: - Setup Views
    func setContentForCell(data: Movie) {
        let fullImageURL = URL(string: String(URLs.APIImagesOriginalPath) + data.posterPath)
        movieImageView.sd_setImage(with: fullImageURL) { [weak self] (_, _, _, _) in
            guard let self = self else { return }
            self.movieImageView.hideSkeleton()
        }
        movieNameLabel.text = data.title
        oveviewLabel.text = data.overview
        scoreLabel.text = String(data.voteAverage)
    }
    
    private func configViews() {
        movieImageView.showAnimatedGradientSkeleton()
        selectionStyle = .none
        scoreLabel.cornerRadius = scoreLabel.frame.width / 2
    }
    
    func animationImage() {
        UIView.animate(withDuration: Constant.animationTime, animations: {
            self.movieImageView.transform = .init(scaleX: Constant.imageScale, y: Constant.imageScale)
        }) { [weak self] (_) in
            guard let self = self else { return }
            self.movieImageView.transform = .identity
        }
    }
    
    override func prepareForReuse() {
        movieImageView.image = nil
    }
}
