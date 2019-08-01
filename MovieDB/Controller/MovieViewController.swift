//
//  MovieViewController.swift
//  MovieDB
//
//  Created by CuongVX-D1 on 7/23/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import UIKit

final class MovieViewController: UIViewController {
 
    @IBOutlet private weak var nowCollectionView: UICollectionView!
    @IBOutlet private weak var topTableView: UITableView!
    
    private struct Constant {
        static let nowCellHeight = 256 * Screen.ratioHeight
        static let nowCellWidth = 140 * Screen.ratioWidth
        static let topCellHeight = 225 * Screen.ratioHeight
        static let TopTableViewRow = 2
    }
    private let movieRepository = MovieRepositoryImpl(api: APIService.share)
    private var nowsArray = [Movie]() {
        didSet {
            nowCollectionView.reloadData()
        }
    }
    private var topRatedArray = [Movie]() {
        didSet {
            topTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbarItem()
        setupNowCollectionView()
        setupTopTableView()
        fetchData()
    }
    
    private func fetchData() {
        movieRepository.getMovies(type: .upcoming, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nowMovieResponse):
                guard let results = nowMovieResponse?.movies else { return }
                self.nowsArray = results
            case .failure(let error):
                print(error as Any)
            }
        }
        
        movieRepository.getMovies(type: .top, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let topRatedMovieResponse):
                guard let results = topRatedMovieResponse?.movies else { return }
                self.topRatedArray = results
            case .failure(let error):
                print(error as Any)
            }
        }
    }
    
    private func setupNowCollectionView() {
        nowCollectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: NowCell.self)
        }
    }
    
    private func setupTopTableView() {
        topTableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: PopularTableViewCell.self)
        }
    }
    
    private func setupTabbarItem() {
        self.title = "MOVIE"
        self.tabBarItem.image = UIImage(named: "Movie")
        self.tabBarItem.selectedImage = UIImage(named: "MovieSlected")?.withRenderingMode(.alwaysOriginal)
    }
}

extension MovieViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return nowsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NowCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.setContentForCell(data: nowsArray[indexPath.row])
        return cell
    }
}

extension MovieViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constant.nowCellWidth,
                      height: Constant.nowCellHeight)
    }
}

extension MovieViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return Constant.TopTableViewRow
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PopularTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        if topRatedArray.count != 0 {
            switch indexPath.row {
            case 0:
                cell.topRatedArray = Array(topRatedArray[0..<10])
            case 1:
                cell.topRatedArray = Array(topRatedArray[10..<20])
            default:
                return UITableViewCell()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.topCellHeight
    }
}
