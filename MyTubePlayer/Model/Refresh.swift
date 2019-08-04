//
//  Refresh.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 24/07/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

protocol YTRefreshable: YTStruct {
    associatedtype Q: SGTLRQuery
    var isLoaded: Bool { get }
    var refreshQuery: Q? { get }

    init?(from: Q.Response)
}

extension YTRefreshable {
    var isLoaded: Bool {
        return self.base.isLoaded
    }
}

protocol YTStructRefreshable: YTRefreshable where Q: SGTLRCollectionQuery {
    init?(from: Q.Response.Element)
}

extension YTStructRefreshable where Q: SGTLRCollectionQuery {
    init?(from: Q.Response) {
        guard let item = Array(from).first else {
            return nil
        }

        self.init(from: item)
    }
}

extension Channel: YTStructRefreshable {
    var refreshQuery: GTLRYouTubeQuery_ChannelsList? {
        return SGTLRQueries.completeChannel(id: self.id)
    }
}


//extension Playlist: YouTubeObjectRefreshable {
//    var refreshQuery: GTLRYouTubeQuery_PlaylistsList? {
//        return SGTLRQueries.completePlaylist(id: self.id)
//    }
//}
//
//extension Video: YouTubeObjectRefreshable {
//    var refreshQuery: GTLRYouTubeQuery_VideosList? {
//        return SGTLRQueries.completeVideo(id: self.id)
//    }
//}
