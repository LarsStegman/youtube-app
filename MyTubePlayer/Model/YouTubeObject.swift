//
//  YouTubeObject.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 01/12/2018.
//  Copyright © 2018 Stegman. All rights reserved.
//

import Foundation

class YouTubeObject: Codable {
    let id: String
    var description: String?
    var publicationDate: Date?
    var title: String?
    var thumbnail: ThumbnailDetails?
    var isLoaded = false

    init(id: String) {
        self.id = id
        self.isLoaded = false
    }

    init(id: String, title: String, description: String, publicationDate: Date, thumbnail: ThumbnailDetails) {
        self.id = id
        self.title = title
        self.description = description
        self.publicationDate = publicationDate
        self.thumbnail = thumbnail
        self.isLoaded = true
    }

    init?(from: YouTubeObjectable) {
        guard let thumbnail = ThumbnailDetails(from: from.thumbnailDetails) else {
            return nil
        }

        self.id = from.id
        self.title = from.title
        self.description = from.publicDescription
        self.publicationDate = from.publicationDate
        self.thumbnail = thumbnail
        self.isLoaded = true
    }
}

extension YouTubeObject: Equatable {
    static func ==(lhs: YouTubeObject, rhs: YouTubeObject) -> Bool {
        return lhs.id == rhs.id
    }
}
