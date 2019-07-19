//
//  Video.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 01/12/2018.
//  Copyright © 2018 Stegman. All rights reserved.
//

import Foundation

class Video: YouTubeObject {
    let duration: TimeInterval?
    var channel: Channel?

    let liveData: LiveBroadcastInformation?

    override init(id: String) {
        self.duration = nil
        self.channel = nil
        self.liveData = nil
        super.init(id: id)
    }

    init(id: String, title: String, description: String, publicationDate: Date, thumbnail: ThumbnailDetails,
         channel: Channel, duration: TimeInterval, liveData: LiveBroadcastInformation? = nil) {
        self.duration = duration
        self.channel = channel
        self.liveData = liveData
        super.init(id: id, title: title, description: description, publicationDate: publicationDate,
                   thumbnail: thumbnail)
    }

    init?(from: YouTubeObjectable, channel: Channel, duration: TimeInterval,
          liveData: LiveBroadcastInformation? = nil) {
        self.duration = duration
        self.channel = channel
        self.liveData = liveData
        super.init(from: from)
    }

    enum CodingKeys: String, CodingKey {
        case duration
        case channelId
        case liveData
        case type
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.duration = try container.decode(TimeInterval?.self, forKey: .duration)
        if let channelId = try container.decode(String?.self, forKey: .channelId) {
            self.channel = Channel(id: channelId)
        } else {
            self.channel = nil
        }

        self.liveData = try container.decode(LiveBroadcastInformation?.self, forKey: .liveData)
        try super.init(from: container.superDecoder())
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("\(type(of: self))".lowercased(), forKey: .type)
        try container.encode(self.channel?.id, forKey: .channelId)
        try container.encode(self.duration, forKey: .duration)
        try container.encode(self.liveData, forKey: .liveData)
        try super.encode(to: container.superEncoder())
    }
}

extension Video {
    var pageUrl: URL {
        return URL(string: "https://youtube.com/watch?v=\(id)")!
    }
}
