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
    var isLoaded: Bool {
        return self.description != nil &&
            self.publicationDate != nil &&
            self.title != nil &&
            self.thumbnail != nil
    }

    init(id: String) {
        self.id = id
    }

    init(id: String, title: String, description: String, publicationDate: Date, thumbnail: ThumbnailDetails) {
        self.id = id
        self.title = title
        self.description = description
        self.publicationDate = publicationDate
        self.thumbnail = thumbnail
    }

    init?(from: YouTubeObjectable) {
        self.id = from.id
        self.load(from: from)
        if !self.isLoaded {
            return nil
        }
    }

    func load(from: YouTubeObjectable) {
        guard let thumbnail = ThumbnailDetails(from: from.thumbnailDetails) else {
            return
        }

        self.title = from.title
        self.description = from.publicDescription
        self.publicationDate = from.publicationDate
        self.thumbnail = thumbnail
    }
}

extension YouTubeObject: Equatable, Hashable {
    static func ==(lhs: YouTubeObject, rhs: YouTubeObject) -> Bool {
        return lhs.id == rhs.id && lhs.isLoaded == rhs.isLoaded
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.isLoaded)
    }
}
