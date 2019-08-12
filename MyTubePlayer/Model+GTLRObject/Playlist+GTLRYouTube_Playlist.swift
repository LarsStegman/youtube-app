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
    init?(from: GTLRYouTube_Playlist) {
        guard let channelId = from.snippet?.channelId else {
            return nil
        }

        let base = YTBaseStruct(from: from)
        let playlistItems = PlaylistItems(playlistId: base.id,
                                          count: from.contentDetails?.itemCount?.intValue ?? 0,
                                          items: [])
        self.init(base: base, channelId: channelId, playlistItems: playlistItems)
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

    var thumbnailDetails: ThumbnailDetails? {
        guard let gtlrThumbnails = self.snippet?.thumbnails else {
            return nil
        }

        return ThumbnailDetails(from: gtlrThumbnails)
    }
}
