//
//  FavoriteViewController.swift
//  MovieDB
//
//  Created by Cuong on 1/7/20.
//  Copyright © 2020 CuongVX-D1. All rights reserved.
//

import UIKit

final class FavoriteViewController: UIViewController {

    //MARK: - Outlet
    @IBOutlet private weak var favotiteCollectionView: UICollectionView!
    @IBOutlet private weak var navigationView: UIView!
    @IBOutlet private weak var noMovieFoundView: UIView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var editModeButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    
    //MARK: - Properties
    private struct Constant {
        static let topCellWidth = 119.47 * Screen.ratioWidth
        static let topCellHeight = 191.6 * Screen.ratioHeight
        static let scaleTime = 0.2
        static let cellScale: CGFloat = 0.2
    }
    private var dbManager: DBManager!
    private var listMovie = [Movie]() {
        didSet {
            noMovieFoundView.isHidden = listMovie.count == 0 ? false : true
        }
    }
    private var cellState = TopRatedCellType.none {
        didSet {
            favotiteCollectionView.reloadData()
        }
    }

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configViews()
        hideLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        listMovie = dbManager.getData()
        favotiteCollectionView.reloadData()
        animationShowLayout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if cellState == .edit {
            editButtonAction(editModeButton)
        }
        hideLayout()
    }

    //MARK: - Setup Views
    private func configViews() {
        dbManager = DBManager.shareInstance
        editModeButton.do {
            $0.borderColor = .white
            $0.borderWidth = 1
            $0.cornerRadius = 10
        }
    }
    
    //MARK: - Setup Views
    private func setupViews() {
        setupTabbarItem()
        setupCollectionView()
        setupNavigationView()
    }
    
    private func setupCollectionView() {
        favotiteCollectionView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.register(cellType: TopRatedCell.self)
        }
    }
    
    private func setupTabbarItem() {
        tabBarItem.selectedImage = UIImage(named: "FavoriteSelectedImage")?.withRenderingMode(.alwaysOriginal)
    }
    
    private func setupNavigationView() {
        navigationView.backgroundColor = .firstGradientColor
    }
    
    private func hideLayout() {
        let titleLabelWidth = titleLabel.frame.width
        titleLabel.transform = CGAffineTransform(translationX: -titleLabelWidth, y: 0)
        let stackViewWidth = stackView.frame.width
        stackView.transform = CGAffineTransform(translationX: stackViewWidth, y: 0)
    }
    
    private func animationShowLayout() {
        UIView.animate(withDuration: 1, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            self.titleLabel.transform = .identity
            self.stackView.transform = .identity
        }, completion: nil)
    }
    
    private func showAlertDelete(cell: UICollectionViewCell, movie: Movie) {
        let alertController = UIAlertController(title: "Confirm Delete Favorite Movie", message: "Do you want to delete this movie: \(movie.title)?", preferredStyle: .actionSheet)
        let actionYes = UIAlertAction(title: "Yes", style: .destructive) { [weak self] (_) in
            guard let self = self else { return }
            self.deleteMovie(movie: movie)
        }
        let actionNo = UIAlertAction(title: "No", style: .default) { (_) in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: [], animations: {
                cell.transform = .identity
            }, completion: nil)
        }
        alertController.addAction(actionYes)
        alertController.addAction(actionNo)
        present(alertController, animated: true, completion: nil)
    }
    
    private func deleteMovie(movie: Movie) {
        dbManager.removeFavoriteMovie(movie: movie)
        guard let indexOfMovie = listMovie.firstIndex(of: movie) else { return }
        listMovie.remove(at: indexOfMovie)
        favotiteCollectionView.deleteItems(at: [IndexPath(row: indexOfMovie, section: 0)])
        if listMovie.count == 0 {
            editButtonAction(editModeButton)
        }
    }
    
    //  MARK: - Action
    @IBAction func editButtonAction(_ sender: UIButton) {
        if cellState == .none {
            cellState = .edit
            sender.setTitle("DONE", for: .normal)
            let searchButtonWidth = searchButton.frame.width
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
                self.stackView.transform = CGAffineTransform(translationX: searchButtonWidth, y: 0)
            }, completion: nil)
        } else {
            cellState = .none
            sender.setTitle("EDIT MODE", for: .normal)
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
                self.stackView.transform = .identity
            }, completion: nil)
        }
    }
    
    @IBAction func searchAction(_ sender: Any) {
        let searchViewController = SearchViewController.instantiate()
        present(searchViewController, animated: true, completion: nil)
    }
}

extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listMovie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {                                                                                                                                                                                                                 
        let cell: TopRatedCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.customDelegate = self
        cell.setContentForCell(data: listMovie[indexPath.row])
        if cellState == .edit {
            cell.enableEditButton()
        } else {
            cell.disableDeleteButton()
        }
        return cell
    }
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constant.topCellWidth, height: Constant.topCellHeight)
    }
}

extension FavoriteViewController: TopRatedCellDelegate {
    func didTappedDeleteButton(cell: UICollectionViewCell, movie: Movie) {
        UIView.animate(withDuration: 0.2, animations: {
            cell.transform = .init(scaleX: 1.2, y: 1.2)
        }) { (_) in
            UIView.animate(withDuration: 0.2, animations: {
                cell.transform = .init(scaleX: 0.2, y: 0.2)
            }) { [weak self] (_) in
                guard let self = self else { return }
                self.showAlertDelete(cell: cell, movie: movie)
            }
        }
    }
}
