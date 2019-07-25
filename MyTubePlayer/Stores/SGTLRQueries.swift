//
//  SGTLRQueries.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 24/07/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

extension SGTLRQueries {
    static func completeChannel(id: String) -> GTLRYouTubeQuery_ChannelsList {
        let query = GTLRYouTubeQuery_ChannelsList.query(withPart: "snippet,contentDetails,brandingSettings")
        query.identifier = id
        query.maxResults = 1
        return query
    }

    static func completeVideo(id: String) -> GTLRYouTubeQuery_VideosList {
        let q = GTLRYouTubeQuery_VideosList.query(withPart: "snippet,contentDetails,liveStreamingDetails")
        q.identifier = id
        q.maxResults = 1
        return q
    }

    static func completePlaylist(id: String) -> GTLRYouTubeQuery_PlaylistsList {
        let q = GTLRYouTubeQuery_PlaylistsList.query(withPart: "snippet,contentDetails")
        q.identifier = id
        q.maxResults = 1
        return q
    }

    static func completeSubscription(id: String) -> GTLRYouTubeQuery_SubscriptionsList {
        let q = GTLRYouTubeQuery_SubscriptionsList.query(withPart: "snippet")
        q.identifier = id
        q.maxResults = 1
        return q
    }
}
