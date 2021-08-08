//
//  CategoryCell.swift
//  MovieDB
//
//  Created by CuongVX-D1 on 7/24/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import UIKit

final class CategoryCell: UITableViewCell, NibReusable {

    // MARK: - Outlet
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var avatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    // MARK: - Views
    private func setupView() {
        selectionStyle = .none
    }
    
    // MARK: - Data
    func setContentForCell(data: Genre) {
        nameLabel.text = data.name
        avatar.image = UIImage(named: data.name)
    }
}
