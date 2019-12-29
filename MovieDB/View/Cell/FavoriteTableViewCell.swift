//
//  FavoriteTableViewCell.swift
//  MovieDB
//
//  Created by Cuong on 1/8/20.
//  Copyright © 2020 CuongVX-D1. All rights reserved.
//

import UIKit

final class FavoriteTableViewCell: UITableViewCell, NibReusable {

    //  MARK: - Outlet
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var oveviewLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    //  MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    //  MARK: - Setup Views
    func setContentForCell(data: Movie) {
        movieImageView.showAnimatedGradientSkeleton()
        let fullImageURL = URL(string: String(URLs.APIImagesOriginalPath) + data.posterPath)
        movieImageView.sd_setImage(with: fullImageURL) { (_, _, _, _) in
            self.movieImageView.hideSkeleton()
        }
        movieNameLabel.text = data.title
        oveviewLabel.text = data.overview
    }
    
    //  MARK: - Action
    @IBAction func moreButton(_ sender: Any) {
        
    }
}
