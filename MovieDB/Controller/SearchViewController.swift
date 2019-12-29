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
    @IBOutlet private weak var emptyMovieView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    
    //  MARK: - Properties
    private struct Constant {
        static let topCellWidth = 119.47 * Screen.ratioWidth
        static let topCellHeight = 191.6 * Screen.ratioHeight
        static let scaleTime = 0.2
        static let cellScale: CGFloat = 0.2
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
            emptyMovieView.isHidden = true
        }
    }
    private var tempMovies = [Movie]()
    private var numberOfPage = 1
    private var totalPages = 0
    private var audioPlayer = AVAudioPlayer()
    private var genreSelectedIndexPath = IndexPath()
    
    //  MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationView()
        setupCollectionViews()
        fetchData()
        setupSearchField()
        hideLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animationShowLayout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        hideLayout()
    }
    
    //  MARK: - Setup View
    private func hideLayout() {
        let backButtonWidth = backButton.frame.width
        backButton.transform = CGAffineTransform(translationX: -backButtonWidth, y: 0)
        let searchFieldHeight = searchField.frame.height * 2
        searchField.transform = CGAffineTransform(translationX: 0, y: -searchFieldHeight)
        let cancelButtonWidth = cancelButton.frame.width + 10
        cancelButton.transform = CGAffineTransform(translationX: cancelButtonWidth, y: 0)
    }
    
    private func animationShowLayout() {
        UIView.animate(withDuration: 1, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            self.searchField.transform = .identity
            self.backButton.transform = .identity
            self.cancelButton.transform = .identity
        }, completion: nil)
    }
    
    private func setupNavigationView() {
         navigationView.backgroundColor = .firstGradientColor
    }
    
    private func setupCollectionViews() {
        genreCollectionView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.register(cellType: GenreSearchCell.self)
            $0.allowsMultipleSelection = false
        }
        
        searchResultCollectionView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.register(cellType: TopRatedCell.self)
            $0.register(cellType: TopRateMovieMoreCell.self)
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
        numberOfPage = 1
        movieRepository.searchMovie(text: query, page: numberOfPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let searchResponse):
                guard let results = searchResponse?.movies else { return }
                self.movies = results
                self.tempMovies = results
                self.searchResultCollectionView.reloadData()
                self.totalPages = searchResponse?.totalPages ?? 0
            case .failure(let error):
                print(error as Any)
            }
        }
    }
    
    private func loadMore() {
        numberOfPage += 1
        let query = searchField.text ?? ""
        movieRepository.searchMovie(text: query, page: numberOfPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let searchResponse):
                guard let results = searchResponse?.movies else { return }
                self.movies += results
                self.tempMovies += results
                self.emptyMovieView.isHidden = true
                self.searchResultCollectionView.reloadData()
            case .failure(let error):
                print(error as Any)
            }
        }
    }
    
    private func didSelectedGenre(genre: Genre) {
        let genreID = genre.id
        for movie in movies {
            if !movie.genreIds.contains(genreID) {
                guard let indexOfMovieToDelete = movies.firstIndex(of: movie) else { return }
                movies.remove(at: indexOfMovieToDelete)
                searchResultCollectionView.deleteItems(at: [IndexPath(item: indexOfMovieToDelete, section: 0)])
            }
        }
        if movies.count == 0 {
            emptyMovieView.isHidden = false
        }
    }
    
    //  MARK: - Action
    @IBAction func cancleAction(_ sender: Any) {
        movies.removeAll()
        emptyMovieView.isHidden = false
        let _ = textFieldShouldReturn(searchField)
        searchField.text = ""
        genreCollectionView.deselectItem(at: genreSelectedIndexPath, animated: true)
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case genreCollectionView:
            guard let cell = collectionView.cellForItem(at: indexPath) as? GenreSearchCell else { return }
            cell.shake()
        case searchResultCollectionView:
            guard let cell = collectionView.cellForItem(at: indexPath) as? TopRatedCell else { return }
            UIView.animate(withDuration: Constant.scaleTime) {
                cell.transform = .init(scaleX: Constant.cellScale, y: Constant.cellScale)
            }
            UIView.animate(withDuration: Constant.scaleTime) {
                cell.transform = .identity
            }
            playTappedSound()
            let movie = movies[indexPath.row]
            let movieDetailViewController = MovieDetailViewController.instantiate()
            movieDetailViewController.movie = movie
            present(movieDetailViewController, animated: true, completion: nil)
        default:
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard collectionView == genreCollectionView else {
            return true
        }
        if collectionView.indexPathsForSelectedItems?.contains(indexPath) != true {
            didSelectedGenre(genre: genres[indexPath.row])
            genreSelectedIndexPath = indexPath
            return true
        } else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return false
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if numberOfPage > totalPages { return }
        if indexPath.row == movies.count - 1 {
            loadMore()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let _ = textFieldShouldReturn(searchField)
    }  
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case genreCollectionView:
            return GenreSearchCell.sizeForCell(data: genres[indexPath.row], height: 2.5 / 3 * genreCollectionView.frame.height)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            self.backButton.transform = .identity
        }, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchResultCollectionView.setContentOffset(searchResultCollectionView.contentOffset, animated: false)
        let backButtonWidth = backButton.frame.width
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            self.backButton.transform = CGAffineTransform(translationX: -backButtonWidth, y: 0)
        }, completion: nil)
        genreCollectionView.deselectItem(at: genreSelectedIndexPath, animated: true)
    }
}

extension SearchViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.search
}

extension SearchViewController {
    
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
