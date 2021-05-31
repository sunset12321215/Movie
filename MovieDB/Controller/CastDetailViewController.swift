//
//  CastDetailViewController.swift
//  MovieDB
//
//  Created by Cuong on 1/29/20.
//  Copyright © 2020 CuongVX-D1. All rights reserved.
//

import UIKit

final class CastDetailViewController: UIViewController {
    
    //  MARK: - Outlet
    @IBOutlet private weak var castImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var bioLabel: UILabel!
    @IBOutlet private weak var movieCollectionView: UICollectionView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var searchButton: UIButton!
    
    //  MARK: - Properties
    private struct Constant {
        private static let cellWidth = 119.47
        private static let cellHeight = 191.6
        static let raitoWidthHeight = CGFloat(cellWidth / cellHeight)  * Screen.ratioWidth
        static let scaleTime = 0.5
        static let cellScale: CGFloat = 0.6
    }
    var castID = Int(){
        didSet{
            fetchCastData()
        }
    }
    private var castResponse = CastResponse() {
        didSet {
            setupData()
        }
    }
    private var movies = Array(repeating: Movie(), count: 6) {
        didSet {
            movieCollectionView.reloadData()
        }
    }
    private let castRepository = CastRepositoryImpl(api: APIService.share)
    private var audioPlayer = AVAudioPlayer()
    
    //  MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        fetchData()
        configViews()
        hideLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animationShowLayout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        hideLayout()
    }
    
    //  MARK: - Config Views
    private func configViews() {
        let halfWidth = castImage.frame.width / 8
        castImage.cornerRadius = halfWidth
        bioLabel.isUserInteractionEnabled = true
        bioLabel.numberOfLines = 4
        movieCollectionView.do {
            $0.register(cellType: TopRatedCell.self)
            $0.dataSource = self
            $0.delegate = self
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
    
    //  MARK: - Setup Data
    private func fetchData() {
        castRepository.getMovies(id: castID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let moviesResponse):
                guard let results = moviesResponse?.movies else { return }
                self.movies = results
            case .failure(let error):
                print(error as Any)
            }
        }
    }
    
    private  func fetchCastData() {
        castRepository.getCast(id: castID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let castsResponse):
                self.castResponse = castsResponse ?? CastResponse()
            case .failure(let error):
                print(error as Any)
            }
        }
    }
    
    private func setupData() {
        guard let urlImage = URL(string: String(URLs.APIImagesOriginalPath) + castResponse.profilePath) else { return }
        castImage.sd_setImage(with: urlImage) { [weak self] (_, _, _, _) in
            guard let self = self else { return }
            self.castImage.hideSkeleton()
        }
        nameLabel.text = castResponse.name
        bioLabel.text = castResponse.biography
    }
    
    //  MARK: - Action
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

//  MARK: - extension
extension CastDetailViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.castDetail
}

extension CastDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TopRatedCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.setContentForCell(data: movies[indexPath.row])
        cell.hideScoreLabel()
        return cell
    }
}

extension CastDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewHeight = collectionView.frame.height
        return CGSize(width: collectionViewHeight / 2 * Constant.raitoWidthHeight,
                      height: collectionViewHeight / 2 - 10)
    }
}

extension CastDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TopRatedCell else { return }
        UIView.animate(withDuration: Constant.scaleTime) {
            cell.transform = .init(scaleX: Constant.cellScale, y: Constant.cellScale)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TopRatedCell else { return }
        UIView.animate(withDuration: Constant.scaleTime, animations: {
            cell.transform = .identity
            UIView.animate(withDuration: Constant.scaleTime, animations: {
                let movieDetailController = MovieDetailViewController.instantiate()
                movieDetailController.movie = self.movies[indexPath.row]
                self.present(movieDetailController, animated: true, completion: nil)
            })
        })
    }
}

extension CastDetailViewController {
    
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
