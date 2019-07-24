//
//  CategoryViewController.swift
//  MovieDB
//
//  Created by CuongVX-D1 on 7/23/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import UIKit

final class CategoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private struct Constant {
        static let categoryCellHeight: CGFloat = 200 * Screen.ratioHeight
        static let cellScaleFirst: CGFloat = 0.8
        static let cellScaleSecond: CGFloat = 0.9
        static let cellScaleMax: CGFloat = 1
        static let durationTime = 0.1
    }
    private let movieRepository = MovieRepositoryImpl(api: APIService.share)
    private var genres = [Genre]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbarItem()
        setupTableView()
        fetchData()
    }
    
    private func setupTableView() {
        tableView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.register(UINib(nibName: "CategoryCell", bundle: nil),
                        forCellReuseIdentifier: "CategoryCell")
        }
    }
    
    private func setupTabbarItem() {
        self.title = "CATEGORY"
        self.tabBarItem.image = UIImage(named: "Categories")
        self.tabBarItem.selectedImage = UIImage(named: "CategoriesSelected")?.withRenderingMode(.alwaysOriginal)
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
}

extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CategoryCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setContentForCell(data: genres[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.categoryCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryCell else { return }
        
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
                })
            }
        }
    }
}
