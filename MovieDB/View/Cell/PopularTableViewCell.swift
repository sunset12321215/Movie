//
//  PopularTableViewCell.swift
//  MovieDB
//
//  Created by CuongVX-D1 on 8/1/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import UIKit

final class PopularTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    private struct Constant {
        static let cellHeight: CGFloat = 225 * Screen.ratioHeight
        static let cellWidth: CGFloat = 140 * Screen.ratioWidth
        static let minimumLineSpacing = 20 * Screen.ratioWidth
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.do {
            $0.register(cellType: TopRatedCell.self)
            $0.dataSource = self
            $0.delegate = self
        }
    }
}

extension PopularTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TopRatedCell = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }
}

extension PopularTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constant.cellWidth,
                      height: Constant.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.minimumLineSpacing
    }
}
