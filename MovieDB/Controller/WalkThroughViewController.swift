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
    @IBOutlet private weak var nextButton: UIButton!
    
    //  MARK: - Variable & Constants
    private let arrayWalkThough = [
        WalkThough(imageString: "WalkthroughA", title: "Get the first\nMovie & TV\ninfomation", image: "NextButtonImage"),
        WalkThough(imageString: "WalkthroughB", title: "Know the movie\nis not worth\nWatching", image: "NextButtonImage"),
        WalkThough(imageString: "WalkthroughC", title: "Real-time\nupdates movie\nTrailer", image: "GetStartedImageButton"),
        ]
    private struct Constant {
        static let widthScreen = UIScreen.main.bounds.width
        static let heightScreen = UIScreen.main.bounds.height
        static let minimumLineSpacing: CGFloat = 0
    }
    private let playerController = PlayerViewController()
    
    //  MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupViews()
        playerController.customDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupPageControl()
    }
    
    //  MARK: - Setup Views
    private func setupViews() {
        let buttonImage = UIImage(named: "NextButtonImage")?.withRenderingMode(.alwaysOriginal)
        nextButton.setImage(buttonImage, for: .normal)
        navigationController?.isNavigationBarHidden = true
        
    }
    
    private func setupPageControl() {
        pageControl.updateDots()
        pageControl.numberOfPages = arrayWalkThough.count
    }
    
    private func setupCollectionView() {
        collectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: WalkThoughCell.self)
        }
    }
    
    //  MARK: - Action
    @IBAction func NextAction(_ sender: UIButton) {
        pageControl.currentPage = pageControl.currentPage + 1
        pageControl.updateDots()
        collectionView.scrollToItem(at: IndexPath(item: pageControl.currentPage,
                                                  section: 0),
                                    at: .right,
                                    animated: true)
        if pageControl.currentPage == 2 {
            getStartedButton.isHidden = false
            nextButton.isHidden = true
        }
    }
    
    @IBAction func getStartedAction(_ sender: Any) {
        present(playerController, animated: true, completion: nil)
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
        let position = Int(targetContentOffset.pointee.x / Constant.widthScreen)
        pageControl.currentPage = Int(position)
        pageControl.updateDots()
        let imageString = arrayWalkThough[position].image
        let buttonImage = UIImage(named: imageString)?.withRenderingMode(.alwaysOriginal)
        nextButton.setImage(buttonImage, for: .normal)
        nextButton.isHidden = position != 2 ? false : true
        getStartedButton.isHidden = position != 2 ? true : false
    }
}

extension WalkThroughViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.walkThrough
}

extension WalkThroughViewController: PlayerViewControllerDelegate {
    func gotoHomeController() {
        let homeController = HomeController.instantiate()
        navigationController?.pushViewController(homeController, animated: true)
    }
}
