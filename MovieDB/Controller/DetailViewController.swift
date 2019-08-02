//
//  DetailViewController.swift
//  MovieDB
//
//  Created by CuongVX-D1 on 8/2/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {
    
    @IBOutlet private weak var videoImageView: UIImageView!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var ReadMoreTextView: ReadMoreTextView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private struct Constant {
        static let castCellHeight = 140 * Screen.ratioHeight
        static let castCellWidth = 70 * Screen.ratioWidth
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.register(cellType: CastCell.self)
        }
    }
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CastCell = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constant.castCellWidth,
                      height: Constant.castCellHeight)
    }
}
