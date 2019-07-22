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
    @IBOutlet private weak var getStartedButton: UIButton!
    
    //  MARK: - Variable & Constants
    private let arrayWalkThough = [
        WalkThough(imageString: "WalkthroughA", title: "Get the first\nMovie & TV\ninfomation"),
        WalkThough(imageString: "WalkthroughB", title: "Know the movie\nis not worth\nWatching"),
        WalkThough(imageString: "WalkthroughC", title: "Real-time\nupdates movie\nTrailer"),
        ]
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
        getStartedButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupPageControl()
    }
    
    //  MARK: - Setup View
    private func setupPageControl() {
        pageControl.updateDots()
        pageControl.numberOfPages = arrayWalkThough.count
    }
    
    //  MARK: - Action
    @IBAction func NextAction(_ sender: UIButton) {
        pageControl.currentPage = pageControl.currentPage + 1
        pageControl.updateDots()
        collectionView.scrollToItem(at: IndexPath(item: pageControl.currentPage, section: 0), at: .right, animated: true)
        if pageControl.currentPage == 2 {
            getStartedButton.isHidden = false
        }
    }
    
    @IBAction func getStartedAction(_ sender: Any) {
        //  MARK: - ToDo
    }
}

extension WalkThroughViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return arrayWalkThough.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WalkThoughCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.setContentForCell(data: arrayWalkThough[indexPath.row])
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
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let position = targetContentOffset.pointee.x / Constant.widthScreen
        pageControl.currentPage = Int(position)
        pageControl.updateDots()
        if position == 2 {
            getStartedButton.isHidden = false
        } else {
            getStartedButton.isHidden = true
        }
    }
}
