//
//  Refresh.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 24/07/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

protocol YTLoadable {
    associatedtype Q: SGTLRQuery
    var isLoaded: Bool { get }
    var loadQuery: Q? { get }

    init?(from: Q.Response)
}

extension YTLoadable where Self: YTStruct {
    var isLoaded: Bool {
        return self.base.isLoaded
    }
}

protocol YTStructLoadable: YTLoadable where Q: SGTLRCollectionQuery {
    init?(from: Q.Response.Element)
}

extension YTStructLoadable where Q: SGTLRCollectionQuery {
    init?(from: Q.Response) {
        guard let item = Array(from).first else {
            return nil
        }

        self.init(from: item)
    }
}

protocol YTCollectionLoadable: YTStructLoadable {
    func load<C: Collection>(items: C) where C.Element == Q.Response.Element
}

extension Channel: YTStructLoadable {
    var loadQuery: GTLRYouTubeQuery_ChannelsList? {
        return SGTLRQueries.completeChannel(id: self.id)
    }
}

extension Playlist: YTStructLoadable {
    var loadQuery: GTLRYouTubeQuery_PlaylistsList? {
        return SGTLRQueries.completePlaylist(id: self.id)
    }
}

//extension PlaylistItems: YTStructLoadable {
//    var isLoaded: Bool {
//        return self.items?.count == self.count
//    }
//
//    var loadQuery: GTLRYouTubeQuery_PlaylistItemsList? {
//        return SGTLRQueries.playlistItems(
//    }
//}
