//
//  MovieViewController.swift
//  MovieDB
//
//  Created by CuongVX-D1 on 7/23/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import UIKit

final class MovieViewController: UIViewController {
 
    @IBOutlet private weak var nowMovieCollectionView: UICollectionView!
    @IBOutlet private weak var topMovieCollectionView: UICollectionView!
    @IBOutlet private weak var navigationView: UIView!
    @IBOutlet private weak var contentView: UIView!
    
    private struct Constant {
        static let nowCellHeight = 218 * Screen.ratioHeight
        static let nowCellWidth = 119.47 * Screen.ratioWidth
        static let topCellHeight = 191.6 * Screen.ratioHeight
        static let cellScale: CGFloat = 0.6
        static let cellScaleMax: CGFloat = 1
        static let durationTime = 0.2
        static let contentViewWidth = 320 * Screen.ratioWidth
        static let contentViewHeight = 700 * Screen.ratioHeight
    }
    private let movieRepository = MovieRepositoryImpl(api: APIService.share)
    private var nowsMovieArray = Array(repeating: Movie(), count: 3) {
        didSet {
            nowMovieCollectionView.reloadData()
        }
    }
    private var topRatedMovieArray = Array(repeating: Movie(), count: 6) {
        didSet {
            topMovieCollectionView.reloadData()
        }
    }
    
    private func setupViews() {
        setupTabbarItem()
        setupNowMovieCollectionView()
        setupTopMovieCollectionView()
        fetchData()
        setupNavigationView()
        setupContentView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupContentView() {
        let contentViewX = contentView.frame.origin.x
        let contentViewY = contentView.frame.origin.y
        contentView.frame = CGRect(x: contentViewX,
                                   y: contentViewY,
                                   width: Constant.contentViewWidth,
                                   height: Constant.contentViewHeight)
    }
    
    private func setupNavigationView() {
        navigationView.backgroundColor = .firstGradientColor
    }
    
    private func fetchData() {
        movieRepository.getMovies(type: .upcoming, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nowMovieResponse):
                guard let results = nowMovieResponse?.movies else { return }
                self.nowsMovieArray = results
            case .failure(let error):
                print(error as Any)
            }
        }
        
        movieRepository.getMovies(type: .top, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let topRatedMovieResponse):
                guard let results = topRatedMovieResponse?.movies else { return }
                self.topRatedMovieArray = results
            case .failure(let error):
                print(error as Any)
            }
        }
    }
    
    private func setupNowMovieCollectionView() {
        nowMovieCollectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: NowMovieCell.self)
            $0.register(cellType: NowMovieMoreCell.self)
        }
    }
    
    private func setupTopMovieCollectionView() {
        topMovieCollectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: TopRatedCell.self)
            $0.register(cellType: TopRateMovieMoreCell.self)
        }
    }
    
    private func setupTabbarItem() {
        tabBarItem.selectedImage = UIImage(named: "MovieSlectedImage")?.withRenderingMode(.alwaysOriginal)
    }
}

extension MovieViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case nowMovieCollectionView:
            return nowsMovieArray.count + 1
        case topMovieCollectionView:
            return topRatedMovieArray.count + 1
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case nowMovieCollectionView:
            if indexPath.row == nowsMovieArray.count {
                let cell: NowMovieMoreCell = collectionView.dequeueReusableCell(for: indexPath)
                return cell
            } else {
                let cell: NowMovieCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.setContentForCell(data: nowsMovieArray[indexPath.row])
                return cell
            }
        case topMovieCollectionView:
            if indexPath.row == topRatedMovieArray.count {
                let cell: TopRateMovieMoreCell = collectionView.dequeueReusableCell(for: indexPath)
                return cell
            } else {
                let cell: TopRatedCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.setContentForCell(data: topRatedMovieArray[indexPath.row])
                return cell
            }
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if(indexPath.row == nowsMovieArray.count) {
            return
        }
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        UIView.animate(withDuration: Constant.durationTime) {
            cell.transform = .init(scaleX: Constant.cellScale, y: Constant.cellScale)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if(indexPath.row == nowsMovieArray.count) {
            return
        }
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        UIView.animate(withDuration: Constant.durationTime) {
            cell.transform = .identity
        }
        
        var movie = Movie()
        switch collectionView {
        case nowMovieCollectionView:
            movie = nowsMovieArray[indexPath.row]
        case topMovieCollectionView:
            movie = topRatedMovieArray[indexPath.row]
        default:
            return
        }
        let detailViewController = DetailViewController.instantiate()
        detailViewController.movie = movie
        present(detailViewController, animated: true, completion: nil)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
}

extension MovieViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case nowMovieCollectionView:
            return CGSize(width: Constant.nowCellWidth,
                          height: Constant.nowCellHeight)
        case topMovieCollectionView:
            return CGSize(width: Constant.nowCellWidth,
                          height: Constant.topCellHeight)
        default:
            return CGSize.zero
        }
    }
}
