//
//  CategoryViewController.swift
//  MovieDB
//
//  Created by CuongVX-D1 on 7/23/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import UIKit

final class CategoryViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var navigationView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var searchButton: UIButton!
    
    // MARK: - Properties
    private struct Constant {
        static let categoryCellHeight: CGFloat = 200 * Screen.ratioHeight
        static let cellScaleFirst: CGFloat = 0.8
        static let cellScaleSecond: CGFloat = 0.9
        static let durationTime = 0.1
    }
    private let movieRepository = MovieRepositoryImpl(api: APIService.share)
    private var genres = [Genre]() {
        didSet {
            tableView.reloadData()
        }
    }
    private var movies = [Movie]()
    var audioPlayer = AVAudioPlayer()
    
    private func setupViews() {
        setupTabbarItem()
        setupTableView()
        fetchData()
        setupNavigationView()
    }
    
    //  MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        hideLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animationShowLayout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        hideLayout()
    }
    
    private func setupNavigationView() {
        navigationView.backgroundColor = .firstGradientColor
    }
    
    private func setupTableView() {
        tableView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.register(cellType: CategoryCell.self)
        }
    }
    
    private func setupTabbarItem() {
        tabBarItem.selectedImage = UIImage(named: "CategoriesSelectedImage")?.withRenderingMode(.alwaysOriginal)
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
    
    //  MARK: - Action
    @IBAction func searchAction(_ sender: Any) {
        let searchViewController = SearchViewController.instantiate()
        navigationController?.pushViewController(searchViewController, animated: true)
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CategoryCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setContentForCell(data: genres[indexPath.row])
        return cell
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.categoryCellHeight
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryCell else { return }
        UIView.animate(withDuration: Constant.durationTime, animations: {
            cell.transform = .init(scaleX: Constant.cellScaleFirst,
                                   y: Constant.cellScaleFirst)
        }) { (_) in
            cell.transform = .identity
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryCell else { return }
        UIView.animate(withDuration: Constant.durationTime, animations: {
            cell.transform = .init(scaleX: Constant.cellScaleSecond,
                                   y: Constant.cellScaleSecond)
        }) { (_) in
            UIView.animate(withDuration: Constant.durationTime, animations: {
                cell.transform = .identity
                self.playTappedSound()
            }, completion: { [weak self] (_) in
                guard let self = self else { return }
                let genre = self.genres[indexPath.row]
                let movieByGenreVC = MovieByGenreViewController.instantiate()
                movieByGenreVC.genre = genre
                self.navigationController?.pushViewController(movieByGenreVC, animated: true)
            })
        }
    }
}

extension CategoryViewController {
    
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
