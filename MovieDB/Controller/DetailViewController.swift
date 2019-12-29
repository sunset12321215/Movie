//
//  DetailViewController.swift
//  MovieDB
//
//  Created by CuongVX-D1 on 8/2/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet private weak var videoImageView: UIImageView!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    @IBOutlet private weak var overView: ReadMoreTextView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var scoreStar: CosmosView!
    @IBOutlet private weak var voteScoreLable: UILabel!
    @IBOutlet private weak var navigationView: UIView!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var youtubePlayerView: YTPlayerView!
    
    // MARK: - Properties
    private struct Constant {
        static let castCellHeight = 140 * Screen.ratioHeight
        static let castCellWidth = 70 * Screen.ratioWidth
        static let favoritesIconChecked = UIImage(named: "Favoritesiconchecked")
        static let favoriteStar = UIImage(named: "FavoriteStar")
    }
    var movie = Movie()
    private let realm = try? Realm()
    private let movieRepository = MovieRepositoryImpl(api: APIService.share)
    private var genres = [Genre]() {
        didSet {
            let restult = genres.filter { movie.genreIds.contains($0.id) }
            let string = restult.map { String($0.name) }
            genreLabel.text = string.joined(separator: ", ")
        }
    }
    private var casts = [Cast]() {
        didSet {
            collectionView.reloadData()
        }
    }
    private var videos = [Video]()
    
    // MARK: - Life cycle
    private func setupViews() {
        setupCollectionView()
        fetchData()
        setupNavigationView()
        configView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Setup Views
    private func setupCollectionView() {
        collectionView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.register(cellType: CastCell.self)
        }
    }
    
    //  test khi chạy video sẽ xoay màn hình -> nếu chạy trên máy thật k đc thì xoá
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.setAnimationsEnabled(false)
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIView.setAnimationsEnabled(true)
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
        
        movieRepository.getCredit(id: movie.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let castsResponse):
                guard let results = castsResponse?.casts else { return }
                self.casts = results
            case .failure(let error):
                print(error as Any)
            }
        }
        
        movieRepository.getVideos(id: movie.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let videosResponse):
                guard let results = videosResponse?.videos else { return }
                self.videos = results
            case .failure(let error):
                print(error as Any)
            }
        }
    }
    
    private func setupNavigationView() {
        navigationView.backgroundColor = .firstGradientColor
    }
    
    //  test khi chạy video sẽ xoay màn hình -> nếu chạy trên máy thật k đc thì xoá
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }
    
    private func configView() {
        videoImageView.showAnimatedGradientSkeleton()
        let urlVideo = URL(string: URLs.APIImagesOriginalPath + movie.backdropPath)
        videoImageView.sd_setImage(with: urlVideo) { (_, _, _, _) in
            self.videoImageView.hideSkeleton()
        }
        posterImageView.showAnimatedGradientSkeleton()
        let urlPoster = URL(string: URLs.APIImagesPath + movie.posterPath)
        posterImageView.sd_setImage(with: urlPoster) { (_, _, _, _) in
            self.posterImageView.hideSkeleton()
        }
        nameLabel.text = movie.title
        overView.text = movie.overview
        infoLabel.text = "\(movie.info)"
        voteScoreLable.text = String(movie.voteAverage)
        scoreStar.rating = Double(movie.voteAverage / 2)
        let getMovie = realm?.objects(Movie.self).filter("id=\(movie.id)").first
        let _ = getMovie == nil ? favoriteButton.setImage(Constant.favoriteStar, for: .normal) : favoriteButton.setImage(Constant.favoritesIconChecked, for: .normal)
    }
    
    // MARK: - Action
    @IBAction func backToPrevious(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playVideoTrainer(_ sender: Any) {
//        let trailerID = videos.first?.key ?? ""
//        youtubePlayerView.load(withVideoId: trailerID)
//        youtubePlayerView.isHidden = false
//        youtubePlayerView.playVideo()
        
        
        let url = URL(string: "https://www.youtube.com/watch?v=cX-Oqdt7gmc")
        
//        youtube
//        self.player = VGPlayer(URL: url)
    }
    
    @IBAction func closeYouTubePlayer(_ sender: Any) {
        youtubePlayerView.isHidden = true
    }
    
    @IBAction func favoriteButton(_ sender: UIButton) {
        guard let a = realm?.objects(Movie.self).filter("id=\(movie.id)").isInvalidated else {
            return
        }
        print(a);
        
        switch a {
        case false:
            movie.isFavorite = true
            try? realm?.write {
                realm?.add(self.movie)
            }
            sender.setImage(Constant.favoritesIconChecked, for: .normal)
        case true:
                try? realm?.write {
                    realm?.delete(movie)
                }
                sender.setImage(Constant.favoriteStar, for: .normal)
            
        }    
        return;
        
//        guard let getMovie = realm?.objects(Movie.self).filter("id=\(movie.id)").first else {
//            movie.isFavorite = true
//            try? realm?.write {
//                realm?.add(self.movie)
//            }
//            sender.setImage(Constant.favoritesIconChecked, for: .normal)
//            return
//        }
//
//        try? realm?.write {
//            realm?.delete(getMovie)
//        }
//        sender.setImage(Constant.favoriteStar, for: .normal)
    }
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return casts.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CastCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.setContentForCell(data: casts[indexPath.row])
        return cell
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constant.castCellWidth,
                      height: Constant.castCellHeight)
    }
}

extension DetailViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.movieDetail
}
