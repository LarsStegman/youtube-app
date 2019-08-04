//
//  Base.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 03/08/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation

protocol YTStruct: Hashable, Identifiable {
    var base: YTBaseStruct { get }
}

extension YTStruct {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.base.id == rhs.base.id && lhs.base.isLoaded == rhs.base.isLoaded
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.base.id)
        hasher.combine(self.base.isLoaded)
    }

    var id: String {
        return self.base.id
    }
}

struct YTBaseStruct: Codable {
    let id: String
    var title: String?
    var publicationDate: Date?
    var description: String?
    var thumbnails: ThumbnailDetails?

    var isLoaded: Bool {
        return self.title != nil &&
               self.publicationDate != nil &&
               self.description != nil &&
               self.thumbnails != nil
    }

    init(id: String, title: String? = nil, publicationDate: Date? = nil,
         description: String? = nil,
         thumbnails: ThumbnailDetails? = nil) {
        self.id = id
        self.title = title
        self.publicationDate = publicationDate
        self.description = description
        self.thumbnails = thumbnails
    }
}


