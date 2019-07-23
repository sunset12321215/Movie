//
//  Util.swift
//  Movie
//
//  Created by pham.xuan.tien on 1/7/19.
//  Copyright © 2019 Framgia. All rights reserved.
//

import Foundation
import UIKit

struct Util {
    static func minutesToHoursMinutes (minutes: Int) -> String {
        let hours = minutes / 60
        let minutes = minutes % 60
        return ("\(hours) h \(minutes) min")
    }
}
