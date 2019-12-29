//
//  Date+.swift
//  Movie

import Foundation

extension Date {
    static func fromString(dateInput: String) -> Date  {
        let dateFormatterInput = DateFormatter()
        dateFormatterInput.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatterInput.date(from: dateInput) else { return Date() }
        return date
    }
    
    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
    
    static func second(from referenceDate: Date) -> Int {
        return Int(Date().timeIntervalSince(referenceDate).rounded())
    }
}
