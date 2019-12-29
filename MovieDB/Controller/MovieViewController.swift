//
//  MovieViewController.swift
//  MovieDB
//
//  Created by CuongVX-D1 on 7/23/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import UIKit

final class MovieViewController: UIViewController {
 
    //  MARK: - Outlet
    @IBOutlet private weak var nowMovieCollectionView: UICollectionView!
    @IBOutlet private weak var topMovieCollectionView: UICollectionView!
    @IBOutlet private weak var navigationView: UIView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var searchButton: UIButton!
    
    //  MARK: - Properties
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
    private var nowMoviePageNumber = 0
    private var topMoviePageNumber = 0
    private var audioPlayer = AVAudioPlayer()
    
    //  MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animationShowLayout()
        nowMovieCollectionView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        hideLayout()
    }
    
    //  MARK: - Setup Views
    private func setupViews() {
        setupTabbarItem()
        setupNowMovieCollectionView()
        setupTopMovieCollectionView()
        fetchTopRateMovieData()
        setupNavigationView()
        setupContentView()
        fetchNowMovieData()
        hideLayout()
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
    
    private func hideLayout() {
        let titleLabelWidth = titleLabel.frame.width
        titleLabel.transform = CGAffineTransform(translationX: -titleLabelWidth, y: 0)
        let searchButtonWidth = searchButton.frame.width
        searchButton.transform = CGAffineTransform(translationX: searchButtonWidth, y: 0)
    }
    
    private func animationShowLayout() {
        UIView.animate(withDuration: 1, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            self.titleLabel.transform = .identity
            self.searchButton.transform = .identity
        }, completion: nil)
    }
    
    //  MARK: - Setup Data
    private func fetchTopRateMovieData() {
        topMoviePageNumber += 1
        movieRepository.getMovies(type: .top, page: topMoviePageNumber) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let topRatedMovieResponse):
                guard let results = topRatedMovieResponse?.movies else { return }
                if self.topRatedMovieArray.count == 6 {
                    self.topRatedMovieArray.removeAll()
                }
                self.topRatedMovieArray += results
            case .failure(let error):
                print(error as Any)
            }
        }
    }
    
    private func fetchNowMovieData() {
        nowMoviePageNumber += 1
        movieRepository.getMovies(type: .now, page: nowMoviePageNumber) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nowMovieResponse):
                guard let results = nowMovieResponse?.movies else { return }
                if self.nowsMovieArray.count == 3 {
                    self.nowsMovieArray.removeAll()
                }
                self.nowsMovieArray += results
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
    
    //  MARK: - Action
    @IBAction func searchAction(_ sender: Any) {
        let searchViewController = SearchViewController.instantiate()
        present(searchViewController, animated: true, completion: nil)
    }
}

//  MARK: - Extension
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
        
        playTappedSound()
        var movie = Movie()
        switch collectionView {
        case nowMovieCollectionView:
            movie = nowsMovieArray[indexPath.row]
        case topMovieCollectionView:
            movie = topRatedMovieArray[indexPath.row]
        default:
            return
        }
        let detailViewController = MovieDetailViewController.instantiate()
        detailViewController.movie = movie
        if collectionView == nowMovieCollectionView {
            detailViewController.isShowRibbonImage = true
        }
        present(detailViewController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        switch collectionView {
        case nowMovieCollectionView:
            if indexPath.row == nowsMovieArray.count {
                fetchNowMovieData()
            }
            let cell = collectionView.dequeueReusableCell(for: indexPath) as NowMovieCell
            cell.showAnimationRibbonImage()
        case topMovieCollectionView:
            if indexPath.row == topRatedMovieArray.count {
                fetchTopRateMovieData()
            }
        default:
            return
        }
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

extension MovieViewController {

    func playTappedSound() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Media.tappedSoundPath()))
        }
        catch {
            print(error)
        }
        audioPlayer.play()
    }
}
