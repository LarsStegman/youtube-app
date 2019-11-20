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
        self.init(base: base, channelId: channelId, count: from.contentDetails?.itemCount?.intValue ?? 0)
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

extension PlaylistItem {
    init?(from: GTLRYouTube_PlaylistItem) {
        guard let channelId = from.snippet?.channelId,
            let channelTitle = from.snippet?.channelTitle,
            let playlistId = from.snippet?.playlistId,
            let position = from.snippet?.position?.intValue,
            let videoId = from.snippet?.resourceId?.videoId else {
                return nil
        }

        let base = YTBaseStruct(from: from)

        self.init(base: base, channelId: channelId, channelTitle: channelTitle,
                  playlistId: playlistId, position: position, videoId: videoId)
    }
}

extension GTLRYouTube_PlaylistItem: YouTubeObjectable {
    var id: String {
        return self.identifier!
    }

    var title: String {
        self.snippet!.title!
    }

    var publicationDate: Date {
        self.snippet!.publishedAt!.date
    }

    var publicDescription: String {
        self.snippet!.descriptionProperty!
    }

    var thumbnailDetails: ThumbnailDetails? {
        guard let gtlrThumbnails = self.snippet?.thumbnails else {
            return nil
        }

        return ThumbnailDetails(from: gtlrThumbnails)
    }
}

