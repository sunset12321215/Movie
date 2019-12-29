//
//  SearchViewController.swift
//  MovieDB
//
//  Created by Cuong on 1/21/20.
//  Copyright © 2020 CuongVX-D1. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {
    
    //  MARK: - Outlet
    @IBOutlet private weak var navigationView: UIView!
    @IBOutlet private weak var searchField: UITextField!
    @IBOutlet private weak var genreCollectionView: UICollectionView!
    @IBOutlet private weak var searchResultCollectionView: UICollectionView!
    
    //  MARK: - Properties
    private struct Constant {
        static let topCellWidth = 119.47 * Screen.ratioWidth
        static let topCellHeight = 191.6 * Screen.ratioHeight
    }
    private let movieRepository = MovieRepositoryImpl(api: APIService.share)
    private var genres = [Genre]() {
        didSet {
            genreCollectionView.reloadData()
        }
    }
    private var genreIDChecked = Set<Int>() {
        didSet {
            print(genreIDChecked)
        }
    }
    private var timer = Timer()
    private var movies = [Movie]() {
        didSet {
            searchResultCollectionView.reloadData()
        }
    }
    
    //  MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationView()
        setupCollectionViews()
        fetchData()
        setupSearchField()
    }
    
    //  MARK: - Setup View
    private func setupNavigationView() {
        navigationView.backgroundColor = .firstGradientColor
    }
    
    private func setupCollectionViews() {
        genreCollectionView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.register(cellType: GenreSearchCell.self)
        }
        
        searchResultCollectionView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.register(cellType: TopRatedCell.self)
        }
    }
    
    private func setupSearchField() {
        searchField.do {
            $0.delegate = self
            $0.leftViewMode = .always
            $0.leftView = UIImageView(image: UIImage(named: "IconSearch"))
            $0.placeholder = "Search your movie..."
            $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        }
    }
    
    private func fetchData() {
        movieRepository.getGenreList { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let genreResponse):
                guard let results = genreResponse?.genres else { return }
                self.genres = results.filter { $0.name != "" }
            case .failure(let error):
                print(error as Any)
            }
        }
    }
    
    private func searchMovie(query: String) {
        movieRepository.searchMovie(text: query, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let searchResponse):
                guard let results = searchResponse?.movies else { return }
                self.movies = results
            case .failure(let error):
                print(error as Any)
            }
        }
    }
    
    //  MARK: - Action
    @IBAction func cancleAction(_ sender: Any) {
        movies.removeAll()
        //  TODO: - Set all genre cell to defaul status
    }
}

//  MARK: - Extension
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case genreCollectionView:
            return genres.count
        case searchResultCollectionView:
            return movies.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case genreCollectionView:
            let cell: GenreSearchCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.setupContentForCell(data: genres[indexPath.row])
            return cell
        case searchResultCollectionView:
            let cell: TopRatedCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.setContentForCell(data: movies[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
}

extension SearchViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        switch collectionView {
//        case genreCollectionView:
//            guard let cell = collectionView.cellForItem(at: indexPath) as? GenreSearchCell else { return }
//            cell.isHighligh = !cell.isHighligh
//            let genreIDSlected = genres[indexPath.row].id
//            if (cell.isHighligh == true) {
//                genreIDChecked.insert(genreIDSlected)
//            } else {
//                genreIDChecked.remove(genreIDSlected)
//            }
//        default:
//            return
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        switch collectionView {
        case genreCollectionView:
            guard let cell = collectionView.cellForItem(at: indexPath) as? GenreSearchCell else { return }
            cell.shake()
            cell.isHighligh = !cell.isHighligh
        default:
            return
        }
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case genreCollectionView:
            return CGSize(width: 100, height: 2.5 / 3 * genreCollectionView.frame.height)
        case searchResultCollectionView:
            return CGSize(width: Constant.topCellWidth, height: Constant.topCellHeight)
        default:
            return CGSize.zero
        }
    }
}

//  MARK: - Search Field Delegate
extension SearchViewController: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { timer in
                guard let query = self.searchField.text else { return }
                self.searchMovie(query: query)
        })
    }
}
