//
//  FavoriteViewController.swift
//  MovieDB
//
//  Created by Cuong on 1/7/20.
//  Copyright © 2020 CuongVX-D1. All rights reserved.
//

import UIKit

final class FavoriteViewController: UIViewController {

    //MARK: - Outlet
    @IBOutlet private weak var favotiteCollectionView: UICollectionView!
    @IBOutlet private weak var navigationView: UIView!
    
    //MARK: - Properties
    private struct Constant {
        
    }

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    //MARK: - Setup Views
    private func setupViews() {
        setupTabbarItem()
        setupCollectionView()
        setupNavigationView()
    }
    
    private func setupCollectionView() {
        favotiteCollectionView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.register(cellType: TopRatedCell.self)
        }
    }
    
    private func setupTabbarItem() {
        tabBarItem.selectedImage = UIImage(named: "FavoriteSlectedImage")?.withRenderingMode(.alwaysOriginal)
    }
    
    private func setupNavigationView() {
        navigationView.backgroundColor = .firstGradientColor
    }
}

extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TopRatedCell = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = (collectionView.frame.width - 10) / 2
        let h = w * 191.6 / 119.47
        return CGSize(width: w, height: h)
    }
}
