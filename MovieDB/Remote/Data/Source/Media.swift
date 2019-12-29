//
//  Media.swift
//  MovieDB
//
//  Created by Cuong on 3/5/20.
//  Copyright © 2020 CuongVX-D1. All rights reserved.
//

import Foundation

struct Media {
    
    static func tappedSoundPath() -> String {
        guard let path = Bundle.main.path(forResource: "tapped", ofType:"mp3") else {
            return ""
        }
        return path
     }
    
    static func introVideoPath() -> String {
        guard let path = Bundle.main.path(forResource: "introvideo", ofType:"mp4") else {
            return ""
        }
        return path
    }
    
    static func trailerVideoPath() -> String {
        guard let path = Bundle.main.path(forResource: "trailer", ofType:"mp4") else {
            return ""
        }
        return path
    }
}
