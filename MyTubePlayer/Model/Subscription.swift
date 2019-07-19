//
//  Subscription.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 01/12/2018.
//  Copyright © 2018 Stegman. All rights reserved.
//

import Foundation

class Subscription: YouTubeObject {
    var channel: Channel

    init(id: String, title: String, description: String, publicationDate: Date, thumbnail: ThumbnailDetails,
         channel: Channel) {
        self.channel = channel
        super.init(id: id, title: title, description: description, publicationDate: publicationDate,
                   thumbnail: thumbnail)
    }

    init?(from: YouTubeObjectable, channel: Channel) {
        self.channel = channel
        super.init(from: from)
    }

    enum CodingKeys: String, CodingKey {
        case channelId
        case type
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let channelId = try container.decode(String.self, forKey: .channelId)
        let channel = Channel(id: channelId)
        self.channel = channel
        try super.init(from: container.superDecoder())
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("\(type(of: self))".lowercased(), forKey: .type)
        try container.encode(self.channel.id, forKey: .channelId)
        try super.encode(to: container.superEncoder())
    }
}
