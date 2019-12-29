//
//  PlayerViewController.swift
//  MovieDB
//
//  Created by Cuong on 3/2/20.
//  Copyright © 2020 CuongVX-D1. All rights reserved.
//

import UIKit

protocol PlayerViewControllerDelegate: class  {
    func gotoHomeController()
}

final class PlayerViewController: AVPlayerViewController {
    
    //  MARK: - Outlet
    weak var customDelegate: PlayerViewControllerDelegate?
    
    //  MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        playVideo()
        configViews()
    }

    override func viewWillDisappear(_ animated: Bool) {
        customDelegate?.gotoHomeController()
    }
    
    //  MARK: - Config Views
    private func configViews() {
        entersFullScreenWhenPlaybackBegins = true
        exitsFullScreenWhenPlaybackEnds = true
    }
    
    //  MARK: - Setup Data
    private func playVideo() {
        let introVideoPath = Media.introVideoPath()
        player = AVPlayer(url: URL(fileURLWithPath: introVideoPath))
        player!.play()
        Screen.horizontalOrientation()
    }
}
