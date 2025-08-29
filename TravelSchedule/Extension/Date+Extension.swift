//
//  Date+Extension.swift
//  TravelSchedule
//
//  Created by Алина on 26.08.2025.
//
import Foundation

extension Date {
    func toISODateString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}
