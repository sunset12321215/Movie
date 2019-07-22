//
//  WalkThroughViewController.swift
//  MovieDB
//
//  Created by CuongVX-D1 on 7/22/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import UIKit

final class WalkThroughViewController: UIViewController {

    //  MARK: - Outlet
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageControl: CustomImagePageControl!
    
    //  MARK: - Variable & Constants
    private let arrayImage = ["WalkthroughA", "WalkthroughB", "WalkthroughC"]
    private struct Constant {
        static let identifier = "WalkThoughCell"
        static let widthScreen = UIScreen.main.bounds.width
        static let heightScreen = UIScreen.main.bounds.height
        static let minimumLineSpacing: CGFloat = 0
    }
    
    //  MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(UINib(nibName: "WalkThoughCell", bundle: nil),
                        forCellWithReuseIdentifier: "WalkThoughCell")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupPageControl()
    }
    
    //  MARK: - Setup View
    private func setupPageControl() {
        pageControl.updateDots()
    }
}

extension WalkThroughViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return arrayImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WalkThoughCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.setContentForCell(data: arrayImage[indexPath.row])
        return cell
    }
}

extension WalkThroughViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constant.widthScreen,
                      height: Constant.heightScreen)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.minimumLineSpacing
    }
}
