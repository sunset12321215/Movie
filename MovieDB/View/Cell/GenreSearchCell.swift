//
//  GenreSearchCell.swift
//  MovieDB
//
//  Created by Cuong on 1/21/20.
//  Copyright © 2020 CuongVX-D1. All rights reserved.
//

import UIKit

final class GenreSearchCell: UICollectionViewCell, NibReusable {
    
    //  MARK: - Outlet
    @IBOutlet private weak var genreLabel: UILabel!
    
    //  MARK: - Properties
    
    override var isSelected: Bool {
        didSet {
            setupBackGroundColor()
        }
    }
    
    //  MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
    //  MARK: - Setup View
    func setupContentForCell(data: Genre) {
        genreLabel.text = data.name
    }
    
    func setupBackGroundColor() {
        switch isSelected {
        case true:
            self.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        case false:
            self.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 0.3)
        }
    }
    
    private func configView() {
        self.cornerRadius = 6
        genreLabel.textColor = .white
        self.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 0.3)
    }
    
    class func sizeForCell(data: Genre, height: CGFloat) -> CGSize {
        guard let cell = UINib(nibName: "GenreSearchCell", bundle: nil).instantiate(withOwner: self, options: nil).first as? GenreSearchCell else {
            return CGSize.zero
        }
        cell.genreLabel.text = data.name
        let cellWidth = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width
        return CGSize(width: cellWidth, height: height)
    }
}
