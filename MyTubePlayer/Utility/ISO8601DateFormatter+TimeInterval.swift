//
//  ISO8601DateFormatter+TimeInterval.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 18/11/2018.
//  Copyright © 2018 Stegman. All rights reserved.
//

import Foundation

extension ISO8601DateFormatter {
    /// Parses an ISO8601 time interval string
    /// For example: P5DT19H6M15S represents 5 days 19 hours 6 minutes and 15 seconds.
    /// PT4M5S represents 4 minutes and 5 seconds
    /// M and S are mandatory.
    ///
    /// - Parameter from: An ISO8601 interval string.
    /// - Returns: The time interval in seconds that the string represents (if it's valid)
    func interval(from: String) -> TimeInterval? {
        let regex = try! NSRegularExpression(pattern: "P((?<d>[0-9]+)D)?T((?<h>[0-9]+)H)?((?<m>[0-9]+)M)((?<s>[0-9]+)S)")
        guard let match = regex.matches(in: from, range: NSRange(location: 0, length: from.count)).first,
            let minutesRange = Range(match.range(withName: "m"), in: from),
            let minutes = Int(from[minutesRange]),
            let secondsRange = Range(match.range(withName: "s"), in: from),
            let seconds = Int(from[secondsRange]) else {
                return nil
        }

        var interval = 0
        if let dayRange = Range(match.range(withName: "d"), in: from), let days = Int(from[dayRange]) {
            interval += days * (24 * 60 * 60)
        }

        if let hoursRange = Range(match.range(withName: "h"), in: from), let hours = Int(from[hoursRange]) {
            interval += hours * (60 * 60)
        }

        interval += minutes * 60
        interval += seconds

        return Double(interval)
    }
}
