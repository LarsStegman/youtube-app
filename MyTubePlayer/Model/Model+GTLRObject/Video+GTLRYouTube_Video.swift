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
    convenience init?(from: GTLRYouTube_Video) {
        guard let dS = from.contentDetails?.duration,
            let d = dateFormatter.interval(from: dS) else {
            return nil
        }

        let channel = Channel(id: from.snippet!.channelId!, title: from.snippet!.channelTitle!)

        var liveData: LiveBroadcastInformation? = nil
        if let live = from.liveStreamingDetails {
            liveData = LiveBroadcastInformation(from: live)
        }

        self.init(from: from, channel: channel, duration: d, liveData: liveData)
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

    var thumbnailDetails: GTLRYouTube_ThumbnailDetails {
        return self.snippet!.thumbnails!
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
