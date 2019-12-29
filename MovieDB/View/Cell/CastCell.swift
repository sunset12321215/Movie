//
//  CastCell.swift
//  MovieDB
//
//  Created by CuongVX-D1 on 8/2/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import UIKit

final class CastCell: UICollectionViewCell, NibReusable {
    
    //  MARK: - Outlet
    @IBOutlet private weak var castImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    //  MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //  MARK: - Setup Views
    func setContentForCell(data: Cast) {
        let urlAvatar = URL(string: URLs.APIImagesOriginalPath + data.profilePath)
        nameLabel.text = data.name
        castImageView.sd_setImage(with: urlAvatar) { [weak self] (_, _, _, _) in
            guard let self = self else { return }
            self.castImageView.hideSkeleton()
        }
    }
    
    override func prepareForReuse() {
        castImageView.showAnimatedGradientSkeleton()
    }
}
