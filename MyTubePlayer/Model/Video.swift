//
//  Video.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 01/12/2018.
//  Copyright © 2018 Stegman. All rights reserved.
//

import Foundation

@dynamicMemberLookup
struct Video: YTStruct, Codable {
    let base: YTBaseStruct
    let channelId: String
    let duration: TimeInterval?
    let liveData: LiveBroadcastInformation?

    init(base: YTBaseStruct, channelId: String, duration: TimeInterval? = nil,
         liveData: LiveBroadcastInformation? = nil) {
        self.base = base
        self.channelId = channelId
        self.duration = duration
        self.liveData = liveData
    }

    subscript<T>(dynamicMember keyPath: KeyPath<YTBaseStruct, T>) -> T {
        get {
            base[keyPath: keyPath]
        }
    }
}

extension Video {
    var pageUrl: URL {
        return URL(string: "https://youtube.com/watch?v=\(self.id)")!
    }
}
