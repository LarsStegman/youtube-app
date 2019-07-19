//
//  Playlist+GTLRYouTube_Playlist.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 28/11/2018.
//  Copyright © 2018 Stegman. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

extension Playlist {
    convenience init?(from: GTLRYouTube_Playlist) {
        guard let channelId = from.snippet?.channelId else {
            return nil
        }

        let channel = Channel(id: channelId)
        self.init(from: from, channel: channel)
    }
}

extension GTLRYouTube_Playlist: YouTubeObjectable {
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

    var thumbnailDetails: GTLRYouTube_ThumbnailDetails {
        return self.snippet!.thumbnails!
    }
}
