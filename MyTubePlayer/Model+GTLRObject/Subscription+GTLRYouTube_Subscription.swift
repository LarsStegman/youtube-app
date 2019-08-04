//
//  Subscription+GTLRYouTube_Subscription.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 21/11/2018.
//  Copyright © 2018 Stegman. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

extension Subscription {
    init?(from: GTLRYouTube_Subscription) {
        guard let channelId = from.snippet?.resourceId?.channelId else {
            return nil
        }

        self.base = YTBaseStruct(from: from)
        self.channelId = channelId
    }
}

extension GTLRYouTube_Subscription: YouTubeObjectable {
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

    var thumbnailDetails: ThumbnailDetails? {
        guard let gtlrThumbnails = self.snippet?.thumbnails else {
            return nil
        }

        return ThumbnailDetails(from: gtlrThumbnails)
    }
}
