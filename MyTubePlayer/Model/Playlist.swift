//
//  Playlist.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 01/12/2018.
//  Copyright © 2018 Stegman. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

@dynamicMemberLookup
struct Playlist: YTStruct, Codable {
    let base: YTBaseStruct
    let channelId: String
    var count: Int

    init(base: YTBaseStruct, channelId: String, count: Int = 0) {
        self.base = base
        self.channelId = channelId
        self.count = count
    }

    subscript<T>(dynamicMember keyPath: KeyPath<YTBaseStruct, T>) -> T {
        get {
            base[keyPath: keyPath]
        }
    }
}

struct PlaylistItems: Codable {
    let playlistId: String
    let count: Int?
}

@dynamicMemberLookup
struct PlaylistItem: YTStruct, Codable {
    let base: YTBaseStruct
    let channelId: String
    let channelTitle: String
    let playlistId: String

    var position: Int
    let videoId: String

    init(base: YTBaseStruct, channelId: String, channelTitle: String,
         playlistId: String, position: Int, videoId: String) {
        self.base = base
        self.channelId = channelId
        self.channelTitle = channelTitle
        self.playlistId = playlistId
        
        self.position = position
        self.videoId = videoId
    }

    subscript<T>(dynamicMember keyPath: KeyPath<YTBaseStruct, T>) -> T {
        get {
            base[keyPath: keyPath]
        }
    }
}
