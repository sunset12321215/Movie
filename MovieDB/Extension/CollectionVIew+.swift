//
//  CollectionVIew+.swift
//  MovieDB
//
//  Created by Cuong on 3/1/20.
//  Copyright © 2020 CuongVX-D1. All rights reserved.
//

import Foundation

var audioPlayer = AVAudioPlayer()
extension UICollectionViewDelegate {
    func playSound() {
        let sound = Bundle.main.path(forResource: "tapped", ofType: "mp3")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        }
        catch {
            print(error)
        }
        audioPlayer.play()
    }
}
