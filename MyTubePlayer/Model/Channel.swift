//
//  Channel.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 01/12/2018.
//  Copyright © 2018 Stegman. All rights reserved.
//

import Foundation

class Channel: YouTubeObject {
    var uploads: Playlist? {
        didSet {
            uploads?.channel = self
        }
    }
    var playlists: [Playlist]? {
        didSet {
            playlists?.forEach({ $0.channel = self })
        }
    }

    override init(id: String) {
        self.uploads = nil
        self.playlists = nil
        super.init(id: id)
    }

    convenience init(id: String, title: String) {
        self.init(id: id)
        self.title = title
    }

    init(id: String, title: String, description: String, publicationDate: Date, thumbnail: ThumbnailDetails,
         uploads: Playlist?, playlists: [Playlist]? = []) {
        self.uploads = uploads
        self.playlists = playlists
        super.init(id: id, title: title, description: description, publicationDate: publicationDate,
                   thumbnail: thumbnail)
    }

    init?(from: YouTubeObjectable, uploads: Playlist? = nil, playlists: [Playlist]? = nil) {
        self.uploads = uploads
        self.playlists = playlists
        super.init(from: from)
    }

    enum CodingKeys: String, CodingKey {
        case uploadListId
        case playlistIds
        case type
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let uploadId = try container.decode(String?.self, forKey: .uploadListId) {
            self.uploads = Playlist(id: uploadId)
        } else {
            self.uploads = nil
        }

        if let playlistIds = try container.decode([String]?.self, forKey: .playlistIds) {
            self.playlists = playlistIds.map({ Playlist(id: $0) })
        } else {
            self.playlists = nil
        }

        try super.init(from: container.superDecoder())
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("\(type(of: self))".lowercased(), forKey: .type)
        try container.encode(uploads?.id, forKey: .uploadListId)
        try container.encode(playlists?.map({ $0.id }), forKey: .playlistIds)
        try super.encode(to: container.superEncoder())
    }
}

extension Channel: CustomDebugStringConvertible {
    var debugDescription: String {
        return "Channel \(self.id), title: \(self.title), isLoaded: \(self.isLoaded)"
    }
}
