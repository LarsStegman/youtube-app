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
    let channelId: String
    let playlistItems: PlaylistItems

    init(base: YTBaseStruct, channelId: String, playlistItems: PlaylistItems) {
        self.base = base
        self.channelId = channelId
        self.playlistItems = playlistItems
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
    var items: [PlaylistItem]?
}

@dynamicMemberLookup
struct PlaylistItem: YTStruct, Codable {
    let base: YTBaseStruct
    let channelId: String
    let channelTitle: String
    let playlistId: String

    let position: Int
    let videoId: String

    subscript<T>(dynamicMember keyPath: KeyPath<YTBaseStruct, T>) -> T {
        get {
            base[keyPath: keyPath]
        }
    }
}
