//
//  Playlist.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 01/12/2018.
//  Copyright © 2018 Stegman. All rights reserved.
//

import Foundation

class Playlist: YouTubeObject {
    var channel: Channel?
    var videos: [Video]?

    override init(id: String) {
        self.channel = nil
        self.videos = nil
        super.init(id: id)
    }

    init(id: String, title: String, description: String, publicationDate: Date, thumbnail: ThumbnailDetails,
         channel: Channel, videos: [Video] = []) {
        self.channel = channel
        self.videos = videos
        super.init(id: id, title: title, description: description, publicationDate: publicationDate,
                   thumbnail: thumbnail)
    }

    init?(from: YouTubeObjectable, channel: Channel, videos: [Video]? = nil) {
        self.channel = channel
        self.videos = videos ?? []
        super.init(from: from)
    }

    enum CodingKeys: String, CodingKey {
        case channelId
        case videoIds
        case type
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let channelId = try container.decode(String?.self, forKey: .channelId) {
            self.channel = Channel(id: channelId)
        } else {
            self.channel = nil
        }

        if let videoIds = try container.decode([String]?.self, forKey: .videoIds) {
            self.videos = videoIds.map { Video(id: $0) }
        } else {
            self.videos = nil
        }

        try super.init(from: container.superDecoder())
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("\(type(of: self))".lowercased(), forKey: .type)
        try container.encode(self.channel?.id, forKey: .channelId)
        try container.encode(self.videos?.map({ $0.id }), forKey: .videoIds)
        try super.encode(to: container.superEncoder())
    }
}
