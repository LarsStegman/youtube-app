//
//  Image.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 04/08/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation

enum Resolution: Int, Hashable, Codable, CaseIterable, Comparable {
    static func < (lhs: Resolution, rhs: Resolution) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    case low
    case standard
    case high
    case extraHigh
}

enum ImageEnvironment: String, Hashable, Codable, CaseIterable {
    case mobile
    case tablet
    case website
    case tv
}

struct ChannelBanner: Codable {
    struct ImageKey: Hashable, Codable {
        let environment: ImageEnvironment
        let resolution: Resolution

        init(_ environment: ImageEnvironment, _ resolution: Resolution) {
            self.environment = environment
            self.resolution = resolution
        }
    }
    
    let images: [ImageKey: URL]
}

