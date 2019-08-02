//
//  TopRatedArrayCell.swift
//  MovieDB
//
//  Created by CuongVX-D1 on 8/1/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import UIKit

protocol TopRatedArrayCellDelegate: class {
    func passPosition(_ position: CGFloat)
    func gotoDetailViewController()
}

final class TopRatedArrayCell: UITableViewCell, NibReusable {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private struct Constant {
        static let cellHeight: CGFloat = 240 * Screen.ratioHeight
        static let cellWidth: CGFloat = 140 * Screen.ratioWidth
        static let minimumLineSpacing = 10 * Screen.ratioWidth
        static let numberOfMovieInSection = 10
        static let cellScaleFirst: CGFloat = 0.8
        static let cellScaleSecond: CGFloat = 0.9
        static let cellScaleMax: CGFloat = 1
        static let durationTime = 0.1
    }
    var topRatedArray = [Movie]() {
        didSet {
            collectionView.reloadData()
        }
    }
    weak var delegate: TopRatedArrayCellDelegate?
    
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

extension TopRatedArrayCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return Constant.numberOfMovieInSection
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TopRatedCell = collectionView.dequeueReusableCell(for: indexPath)
        if topRatedArray.count != 0 {
            cell.setContentForCell(data: topRatedArray[indexPath.row])
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TopRatedCell else { return }
        
        UIView.animate(withDuration: Constant.durationTime, animations: {
            cell.transform = .init(scaleX: Constant.cellScaleFirst,
                                   y: Constant.cellScaleFirst)
        }) { (_) in
            UIView.animate(withDuration: Constant.durationTime, animations: {
                cell.transform = .init(scaleX: Constant.cellScaleMax,
                                       y: Constant.cellScaleMax)
            }) { (_) in
                UIView.animate(withDuration: Constant.durationTime, animations: {
                    cell.transform = .init(scaleX: Constant.cellScaleSecond,
                                           y: Constant.cellScaleSecond)
                }, completion: { (_) in
                    cell.transform = .init(scaleX: Constant.cellScaleMax,
                                           y: Constant.cellScaleMax)
                    self.delegate?.gotoDetailViewController()
                })
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.x
        delegate?.passPosition(position)
    }
}

extension TopRatedArrayCell: UICollectionViewDelegateFlowLayout {
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
