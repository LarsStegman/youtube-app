//
//  Channel+GTLRYouTube_Channel.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 20/11/2018.
//  Copyright © 2018 Stegman. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

extension Channel {
    init?(from: GTLRYouTube_Channel) {
        self.base = YTBaseStruct(from: from)
        self.uploadsId = from.contentDetails?.relatedPlaylists?.uploads
    }
}

extension GTLRYouTube_Channel: YouTubeObjectable {
    var thumbnailDetails: ThumbnailDetails? {
        if let thumb = self.snippet?.thumbnails {
            return ThumbnailDetails(from: thumb)
        } else {
            return nil
        }
    }

    var title: String {
        return self.snippet!.title!
    }

    var publicationDate: Date {
        return self.snippet!.publishedAt!.date
    }

    var publicDescription: String {
        return self.snippet!.descriptionProperty!
    }

    var id: String {
        return self.identifier!
    }
}
