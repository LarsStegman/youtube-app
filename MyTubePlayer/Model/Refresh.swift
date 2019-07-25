//
//  Refresh.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 24/07/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

protocol YouTubeObjectRefreshable {
    associatedtype Q: SGTLRQuery
    var isLoaded: Bool { get }
    var refreshQuery: Q? { get }

    func load(from: Q.Response)
}

extension YouTubeObjectRefreshable where Self: YouTubeObject,
                                            Q: SGTLRCollectionQuery, Q.Response.Element: YouTubeObjectable {
    func load(from: Q.Response) { // override this in extensions to set properties specific to objects
        guard let item = Array(from).first else {
            return
        }

        self.load(from: item)
    }
}

extension Channel: YouTubeObjectRefreshable {
    var refreshQuery: GTLRYouTubeQuery_ChannelsList? {
        return SGTLRQueries.completeChannel(id: self.id)
    }
}

extension Playlist: YouTubeObjectRefreshable {
    var refreshQuery: GTLRYouTubeQuery_PlaylistsList? {
        return SGTLRQueries.completePlaylist(id: self.id)
    }
}

extension Video: YouTubeObjectRefreshable {
    var refreshQuery: GTLRYouTubeQuery_VideosList? {
        return SGTLRQueries.completeVideo(id: self.id)
    }
}
