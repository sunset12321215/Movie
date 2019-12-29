//
//  MovieByGenreViewController.swift
//  MovieDB
//
//  Created by Cuong on 1/17/20.
//  Copyright © 2020 CuongVX-D1. All rights reserved.
//

import UIKit

final class MovieByGenreViewController: UIViewController {
    
    //  MARK: - Outlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var genreMovieLabel: UILabel!
    
    //  MARK: - Properties
    private struct Constants {
        static let cellHeight = 218 * Screen.ratioHeight
    }
    var idCategories = 0 {
        didSet {
            getMoviesByID(id: idCategories)
        }
    }
    var genreName = "" 
    private var movies = Array(repeating: Movie(), count: 3) {
        didSet {
            tableView.reloadData()
        }
    }
    private let movieRepository = MovieRepositoryImpl(api: APIService.share)

    //  MARK: - Setup Views
    private func setupTableView() {
        tableView.do {
            $0.register(cellType: FavoriteTableViewCell.self)
            $0.dataSource = self
            $0.delegate = self
            $0.rowHeight = Constants.cellHeight
        }
    }
    
    private func setupNavigationView() {
        navigationView.backgroundColor = .firstGradientColor
    }
    
    private func getMoviesByID(id: Int){
        movieRepository.getMoviesByID(id: id, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movieResponse):
                guard let results = movieResponse?.movies else { return }
                self.movies = results
            case .failure(let error):
                print(error as Any)
            }
        }
    }

    //  MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationView()
        genreMovieLabel.text = genreName
    }
}

//  MARK: - Extension
extension MovieByGenreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FavoriteTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setContentForCell(data: movies[indexPath.row])
        return cell
    }
}

extension MovieByGenreViewController: UITableViewDelegate {
    
}

extension MovieByGenreViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.movieByGenre
}
