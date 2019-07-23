//
//  Util.swift
//  Movie

import Foundation
import UIKit

struct Util {
    static func minutesToHoursMinutes (minutes: Int) -> String {
        let hours = minutes / 60
        let minutes = minutes % 60
        return ("\(hours) h \(minutes) min")
    }
}
