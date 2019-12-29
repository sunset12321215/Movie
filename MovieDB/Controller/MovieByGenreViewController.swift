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
    @IBOutlet private weak var navigationView: UIView!
    @IBOutlet private weak var genreMovieLabel: UILabel!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    
    //  MARK: - Properties
    private struct Constants {
        static let cellHeight = 218 * Screen.ratioHeight
    }
    var genre = Genre()
    private var movies = Array(repeating: Movie(), count: 3) {
        didSet {
            tableView.reloadData()
        }
    }
    private let movieRepository = MovieRepositoryImpl(api: APIService.share)
    private var moviePage = 0
    private var audioPlayer = AVAudioPlayer()

    //  MARK: - Setup Views
    private func setupTableView() {
        tableView.do {
            $0.register(cellType: MovieByGenreTableViewCell.self)
            $0.dataSource = self
            $0.delegate = self
            $0.rowHeight = Constants.cellHeight
        }
    }
    
    private func setupNavigationView() {
        navigationView.backgroundColor = .firstGradientColor
    }
    
    private func fetchDataMovies() {
        moviePage += 1
        movieRepository.getMoviesByID(id: genre.id, page: moviePage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movieResponse):
                guard let results = movieResponse?.movies else { return }
                if self.movies.count == 3 {
                    self.movies.removeAll()
                }
                self.movies += results
            case .failure(let error):
                print(error as Any)
            }
        }
    }
    
    private func hideLayout() {
        let backButtonWidth = backButton.frame.width
        backButton.transform = CGAffineTransform(translationX: -backButtonWidth, y: 0)
        let titleLabelHeight = titleLabel.frame.height * 2
        titleLabel.transform = CGAffineTransform(translationX: 0, y: -titleLabelHeight)
        let searchButtonWidth = searchButton.frame.width
        searchButton.transform = CGAffineTransform(translationX: searchButtonWidth, y: 0)
    }
    
    private func animationShowLayout() {
        UIView.animate(withDuration: 1, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            self.titleLabel.transform = .identity
            self.backButton.transform = .identity
            self.searchButton.transform = .identity
        }, completion: nil)
    }

    //  MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationView()
        genreMovieLabel.text = genre.name
        fetchDataMovies()
        hideLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animationShowLayout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        hideLayout()
    }
    
    //  MARK: - Action
    @IBAction func backToPreveous(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        let searchViewController = SearchViewController.instantiate()
        present(searchViewController, animated: true, completion: nil)
    }
}

//  MARK: - Extension
extension MovieByGenreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieByGenreTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setContentForCell(data: movies[indexPath.row])
        return cell
    }
}

extension MovieByGenreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        if movies.count == indexPath.row + 1 {
            fetchDataMovies()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? MovieByGenreTableViewCell else {
            return
        }
        cell.animationImage()
        playTappedSound()
        let getmovie = movies[indexPath.row]
        let movieDetailViewController = MovieDetailViewController.instantiate()
        movieDetailViewController.movie = getmovie
        present(movieDetailViewController, animated: true, completion: nil)
    }
}

extension MovieByGenreViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.movieByGenre
}

extension MovieByGenreViewController {
    
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
