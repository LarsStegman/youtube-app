//
//  Video+GTLRYouTube_Video.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 18/11/2018.
//  Copyright © 2018 Stegman. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

let dateFormatter = ISO8601DateFormatter()

extension Video {
    init?(from: GTLRYouTube_Video) {
        guard let dS = from.contentDetails?.duration,
            let d = dateFormatter.interval(from: dS),
            let channelId = from.snippet?.channelId else {
            return nil
        }

        var liveData: LiveBroadcastInformation? = nil
        if let live = from.liveStreamingDetails {
            liveData = LiveBroadcastInformation(from: live)
        }

        let base = YTBaseStruct(from: from)
        self.init(base: base, channelId: channelId, duration: d, liveData: liveData)
    }
}

extension LiveBroadcastInformation {
    init?(from: GTLRYouTube_VideoLiveStreamingDetails) {
        guard let startTime = from.scheduledStartTime else {
            return nil
        }

        self.scheduledStartTime = startTime.date
        self.scheduledEndTime = from.scheduledEndTime?.date
        self.actualStartTime = from.actualStartTime?.date
        self.actualEndTime = from.actualEndTime?.date
    }
}

extension GTLRYouTube_Video: YouTubeObjectable {
    var id: String {
        return self.identifier!
    }

    var thumbnailDetails: ThumbnailDetails? {
        guard let gtlrThumbnails = self.snippet?.thumbnails else {
            return nil
        }

        return ThumbnailDetails(from: gtlrThumbnails)
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
}
