//
//  Playlist.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 01/12/2018.
//  Copyright © 2018 Stegman. All rights reserved.
//

import Foundation

@dynamicMemberLookup
struct Playlist: YTStruct, Codable {
    let base: YTBaseStruct
    var channelId: String
//    var videos: [Video]?

    init(base: YTBaseStruct, channelId: String) {
        self.base = base
        self.channelId = channelId
    }

    subscript<T>(dynamicMember keyPath: KeyPath<YTBaseStruct, T>) -> T {
        get {
            base[keyPath: keyPath]
        }
    }
}
