//
//  TrailerTableViewController.swift
//  MovieDB
//
//  Created by Cuong on 1/26/20.
//  Copyright © 2020 CuongVX-D1. All rights reserved.
//

import UIKit

final class TrailerTableViewController: UIViewController {
    
    //  MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    
    //  MARK: - Properties
    var videos = [Video]()
    private var player: YTSwiftyPlayer!
    private struct Constant {
        static let rowHeight = 200 * Screen.ratioHeight
    }
    private let playerViewController = UIViewController()
    var audioPlayer = AVAudioPlayer()
    
    //  MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: TrailerTableViewCell.self)
        tableView.rowHeight = Constant.rowHeight
    }
}

//  MARK: - Extention
extension TrailerTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TrailerTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setupContent(from: videos[indexPath.row])
        return cell
    }
}

extension TrailerTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playTappedSound()
        let video = videos[indexPath.row]
        player = YTSwiftyPlayer(
            frame: CGRect(x: 0, y: 0,
                          width: 0, height: Constant.rowHeight),
            playerVars: [.videoID(video.key)]
        )
        player.setPlaybackQuality(.hd1080)
        player.autoplay = true
        player.delegate = self
        playerViewController.view = player
        player.loadPlayer()
        Screen.horizontalOrientation()
        present(playerViewController, animated: true, completion: nil)
    }
}

extension TrailerTableViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.trailer
}

extension TrailerTableViewController: YTSwiftyPlayerDelegate {
    func player(_ player: YTSwiftyPlayer, didChangeState state: YTSwiftyPlayerState) {
        if state == .ended || state == .paused {
            playerViewController.dismiss(animated: true, completion: nil)
        }
    }
}

extension TrailerTableViewController {
    
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
