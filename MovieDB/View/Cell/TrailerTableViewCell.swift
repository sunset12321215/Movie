//
//  TrailerTableViewCell.swift
//  MovieDB
//
//  Created by Cuong on 1/26/20.
//  Copyright © 2020 CuongVX-D1. All rights reserved.
//

import UIKit

final class TrailerTableViewCell: UITableViewCell, NibReusable {

    //  MARK: - Outlet
    @IBOutlet private weak var trailerImageView: UIImageView!
    @IBOutlet private weak var trailerNameLavel: UILabel!
    @IBOutlet private weak var trailerInfoLabel: UILabel!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    //  MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configViews()
    }
    
    //  MARK: - Setup data
    func setupContent(from data: Video) {
        trailerNameLavel.text = data.name
        trailerInfoLabel.text = data.type + ": " + String(data.size) + "p"
        let urlImage = "https://img.youtube.com/vi/\(data.key)/0.jpg"
        guard let url = URL(string: urlImage) else { return }
        trailerImageView.sd_setImage(with: url) { [weak self] (_, _, _, _) in
            guard let self = self else { return }
            self.activityIndicatorView.isHidden = true
        }
    }
    
    //  MARK: - Config Views
    private func configViews() {
        self.selectionStyle = .none
    }
}
