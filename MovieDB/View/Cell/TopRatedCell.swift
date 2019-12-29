//
//  TopRatedCell.swift
//  MovieDB
//
//  Created by CuongVX-D1 on 8/1/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import UIKit

protocol TopRatedCellDelegate: class {
    func didTappedDeleteButton(cell: UICollectionViewCell, movie: Movie)
}

final class TopRatedCell: UICollectionViewCell, NibReusable {
    
    //  MARK: - Outlet
    @IBOutlet private weak var backImageView: UIImageView!
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var yearReleaseLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var ovalImageView: UIImageView!
    
    private var dbManager: DBManager!
    private var movieToRemove = Movie()
    weak var customDelegate: TopRatedCellDelegate?
    
    //  MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configCell()
    }
    
    //  MARK: - Setup Views
    func setContentForCell(data: Movie) {
        let url = URL(string: String(URLs.APIImagesOriginalPath) + data.posterPath)
        movieImageView.sd_setImage(with: url) { [weak self] (_, _, _, _) in
            guard let self = self else { return }
            self.movieImageView.hideSkeleton()
            self.backImageView.isHidden = false
        }
        yearReleaseLabel.text = data.year
        nameLabel.text = data.title
        scoreLabel.attributedText = String.scoreLabelAttribute(score: data.voteAverage, color: .white)
        movieToRemove = data
    }
    
    private func configCell() {
        deleteButton.transform = .init(translationX: -30, y: 0)
        dbManager = DBManager.shareInstance
        movieImageView.showAnimatedGradientSkeleton()
        backImageView.isHidden = true
    }
    
    func enableEditButton() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: [], animations: {
            self.deleteButton.transform = .identity
        }, completion: nil)
    }
    
    func disableDeleteButton() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            self.deleteButton.transform = .init(translationX: -30, y: 0)
        }, completion: nil)
    }
    
    func hideScoreLabel() {
        ovalImageView.isHidden = true
        scoreLabel.isHidden = true
    }
    
    override func prepareForReuse() {
        movieImageView.image = nil
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        customDelegate?.didTappedDeleteButton(cell: self, movie: movieToRemove)
    }
}
