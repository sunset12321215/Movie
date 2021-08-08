//
//  MovieDetailViewController.swift
//  MovieDB
//
//  Created by CuongVX-D1 on 8/2/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import UIKit

final class MovieDetailViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet private weak var videoImageView: UIImageView!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    @IBOutlet private weak var overView: UITextView!
    @IBOutlet private weak var contentHeight: NSLayoutConstraint!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var scoreStar: CosmosView!
    @IBOutlet private weak var voteScoreLable: UILabel!
    @IBOutlet private weak var navigationView: UIView!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var ribbonImage: UIImageView!
    
    // MARK: - Properties
    private struct Constant {
        static let castCellHeight = 140 * Screen.ratioHeight
        static let castCellWidth = 100 * Screen.ratioWidth
        static let favoritesIconChecked = UIImage(named: "Favoritesiconchecked")
        static let favoriteStar = UIImage(named: "FavoriteStar")
        static let cellScale: CGFloat = 0.6
        static let scaleTime = 0.2
    }
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
    private var dbManager: DBManager!
    var movie = Movie()
    private var audioPlayer = AVAudioPlayer()
    var isShowRibbonImage = false
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animationShowLayout()
        showRibbonImage()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        hideLayout()
        ribbonImage.alpha = 0
    }
    
    // MARK: - Setup Views
    private func showRibbonImage() {
        if isShowRibbonImage {
            UIView.animate(withDuration: 5, delay: 0.5, options: [.autoreverse, .repeat], animations: {
                self.ribbonImage.alpha = 1
            }, completion: nil)
        }
    }
    
    private func setupViews() {
        setupCollectionView()
        fetchData()
        setupNavigationView()
        hideLayout()
        configView()
    }
    
    private func setupCollectionView() {
        collectionView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.register(cellType: CastCell.self)
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
    
    private func configView() {
        videoImageView.showAnimatedGradientSkeleton()
        let urlVideo = URL(string: URLs.APIImagesOriginalPath + movie.backdropPath)
        videoImageView.sd_setImage(with: urlVideo) { [weak self] (_, _, _, _) in
            guard let self = self else { return }
            self.videoImageView.hideSkeleton()
        }
        posterImageView.showAnimatedGradientSkeleton()
        let urlPoster = URL(string: URLs.APIImagesPath + movie.posterPath)
        posterImageView.sd_setImage(with: urlPoster) { [weak self] (_, _, _, _) in
            guard let self = self else { return }
            self.posterImageView.hideSkeleton()
        }
        nameLabel.text = movie.title
        overView.text = movie.overview
        infoLabel.text = "\(movie.info)"
        voteScoreLable.text = String(movie.voteAverage)
        scoreStar.rating = Double(movie.voteAverage / 2)
        dbManager = DBManager.shareInstance
        let checkMovie = dbManager?.isMovieInDataBase(movie: movie)
        let _ = checkMovie == false ? favoriteButton.setImage(Constant.favoriteStar, for: .normal) : favoriteButton.setImage(Constant.favoritesIconChecked, for: .normal)
        ribbonImage.alpha = 0
    }
    
    private func hideLayout() {
        let titleLabelWidth = backButton.frame.width
        backButton.transform = CGAffineTransform(translationX: -titleLabelWidth, y: 0)
        let navigationHeight = navigationView.frame.height
        titleLabel.transform = CGAffineTransform(translationX: 0, y: -navigationHeight)
        let videoImageHeight = videoImageView.frame.height
        playButton.transform = CGAffineTransform(translationX: 0, y: -videoImageHeight)
        let favoriteButtonWidth = favoriteButton.frame.width
        favoriteButton.transform = CGAffineTransform(translationX: favoriteButtonWidth * 2, y: 0)
    }
    
    private func animationShowLayout() {
        UIView.animate(withDuration: 1, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            self.titleLabel.transform = .identity
            self.backButton.transform = .identity
            self.playButton.transform = .identity
            self.favoriteButton.transform = .identity
        }, completion: nil)
        let genresWidthDisplaying = Screen.width - genreLabel.frame.origin.x
        let transformX = genreLabel.frame.width - genresWidthDisplaying + 10
        if transformX < 0 { return }
        UIView.animate(withDuration: 2, delay: 0.5, options: [.repeat, .autoreverse], animations: {
            self.genreLabel.transform = .init(translationX: -transformX, y: 0)
        }, completion: nil)
    }
    
    private func setupTrailerAlertTableView() {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false,
            disableTapGesture: true
        )
        let alert = SCLAlertView(appearance: appearance)
        let controller = TrailerTableViewController.instantiate()
        controller.videos = videos
        alert.addChild(controller)
        alert.customSubview = controller.view
        let trailerViewControllerHeight = videos.count == 1 ? 200 : 345 as CGFloat
        let alertViewHeight = videos.count == 1 ? 200 : 345 as CGFloat
        alert.customSubview?.frame = CGRect(x: 0, y: 0, width: 0, height: alertViewHeight * Screen.ratioHeight)
        controller.view.snp.makeConstraints { (make) in
            make.width.equalTo(185 * Screen.ratioWidth)
            make.height.equalTo(trailerViewControllerHeight * Screen.ratioHeight)
        }
        controller.didMove(toParent: alert)
        alert.addButton("Close", backgroundColor: .firstGradientColor, textColor: .white, showTimeout: nil) {
        }
        alert.showInfo("All Trailser & Teaser", subTitle: "")
    }
    
    private func saveMovie() {
        let cloneMovie = Movie()
        cloneMovie.copy(from: movie)
        dbManager?.addFavoriteMovie(movie: cloneMovie)
        view.makeToast("Saved Your Favorite Movie")
        favoriteButton.setImage(#imageLiteral(resourceName: "Favoritesiconchecked"), for: .normal)
    }
    
    private func removeMovie() {
        guard let findMovie = dbManager?.searchMovie(id: movie.id) else { return }
        dbManager?.removeFavoriteMovie(movie: findMovie)
        view.makeToast("Remove Your Favorite Movie")
        favoriteButton.setImage(#imageLiteral(resourceName: "FavoriteStar"), for: .normal)
    }
    
    // MARK: - Action
    @IBAction func backToPrevious(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func playVideoTrainer(_ sender: Any) {
        setupTrailerAlertTableView()
    }
    
    @IBAction func favoriteButton(_ sender: UIButton) {
        if favoriteButton.currentImage == #imageLiteral(resourceName: "FavoriteStar") {
            saveMovie()
        } else {
            removeMovie()
        }
    }
}

extension MovieDetailViewController: UICollectionViewDataSource {
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

extension MovieDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CastCell else { return }
        UIView.animate(withDuration: Constant.scaleTime) {
            cell.transform = .init(scaleX: Constant.cellScale, y: Constant.cellScale)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CastCell else { return }
        
        UIView.animate(withDuration: Constant.scaleTime, animations: {
            cell.transform = .identity
            self.playTappedSound()
        }) { [weak self] (_) in
            guard let self = self else { return }
            let castID = self.casts[indexPath.row].id
            let castDetailController = CastDetailViewController.instantiate()
            castDetailController.castID = castID
            self.navigationController?.pushViewController(castDetailController, animated: true)
        }
    }
}

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constant.castCellWidth,
                      height: Constant.castCellHeight)
    }
}

extension MovieDetailViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.movieDetail
}

extension MovieDetailViewController {
    
    func playTappedSound() {
        do {
            let url = URL(fileURLWithPath: Media.tappedSoundPath())
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        }
        catch {
            print(error)
        }
        audioPlayer.play()
    }
}
