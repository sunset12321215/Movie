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
        static let cellScaleFirst: CGFloat = 0.8
        static let cellScaleSecond: CGFloat = 0.9
        static let cellScaleMax: CGFloat = 1
        static let durationTime = 0.1
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
            $0.register(cellType: TopRatedArrayCell.self)
            $0.register(UINib(nibName: "TopRatedArrayCell", bundle: nil),
                        forCellReuseIdentifier: "TopRatedArrayCell")
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
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? NowCell else { return }
        
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
                    guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController else {return}
                    self.present(detailVC, animated: true, completion: nil)
                })
            }
        }
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
        let cell: TopRatedArrayCell = tableView.dequeueReusableCell(for: indexPath)
        cell.delegate = self
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

extension MovieViewController: TopRatedArrayCellDelegate {
    func gotoDetailViewController() {
        guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController else {return}
        self.present(detailVC, animated: true, completion: nil)
    }
    
    func passPosition(_ position: CGFloat) {
        guard let topRatedArrayCellOne = topTableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? TopRatedArrayCell else { return }
        topRatedArrayCellOne.collectionView.contentOffset.x = position
        
        guard let topRatedArrayCellTwo = topTableView.cellForRow(at: IndexPath(item: 1, section: 0)) as? TopRatedArrayCell else { return }
        topRatedArrayCellTwo.collectionView.contentOffset.x = position
    }
}
