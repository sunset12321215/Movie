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
    var isHighligh = false {
        didSet {
            setupBackGroundColor()
        }
    }
    
    //  MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        self.backgroundColor = nil
//    }
    
    //  MARK: - Setup View
    func setupContentForCell(data: Genre) {
        genreLabel.text = data.name
        setupBackGroundColor()
    }
    
    func setupBackGroundColor() {
        switch isHighligh {
        case true:
            self.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        case false:
            self.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 0.3)
        }
    }
    
    private func configView() {
        self.cornerRadius = 6
        genreLabel.textColor = .white
    }
}
