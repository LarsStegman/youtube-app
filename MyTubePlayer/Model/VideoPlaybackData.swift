//
//  VideoPlaybackData.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 11/11/2018.
//  Copyright © 2018 Stegman. All rights reserved.
//

import Foundation

enum YTVideoQualityMP4: Int, Codable, CaseIterable {
    case SD144p = 160
    case HD720p = 22
    case HD1080p = 96
}

struct VideoPlaybackData {
    let streams: [YTVideoQualityMP4: URL]
}

extension VideoPlaybackData: Codable {}
