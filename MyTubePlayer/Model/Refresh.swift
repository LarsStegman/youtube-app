//
//  Refresh.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 24/07/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST


// MARK: - SingleElement
protocol YTLoadingIntialisable {
    associatedtype Q: SGTLRQuery
    var isLoaded: Bool { get }
    var loadQuery: Q { get }

    init?(from: Q.Response)
}

extension YTLoadingIntialisable where Self: YTStruct {
    var isLoaded: Bool {
        return self.base.isLoaded
    }
}

protocol YTCollectionElementInitialisable: YTLoadingIntialisable where Q: SGTLRCollectionQuery {
    init?(from: Q.Response.Element)
}

extension YTCollectionElementInitialisable {
    init?(from: Q.Response) {
        guard let item = Array(from).first else {
            return nil
        }

        self.init(from: item)
    }
}

extension Channel: YTCollectionElementInitialisable {
    var loadQuery: GTLRYouTubeQuery_ChannelsList {
        return SGTLRQueries.completeChannel(id: self.id)
    }
}

extension Playlist: YTCollectionElementInitialisable {
    var loadQuery: GTLRYouTubeQuery_PlaylistsList {
        return SGTLRQueries.completePlaylist(id: self.id)
    }
}

extension PlaylistItem: YTCollectionElementInitialisable {
    var loadQuery: GTLRYouTubeQuery_PlaylistItemsList {
        return SGTLRQueries.completePlaylistItem(id: self.id)
    }
}

// MARK: - Pages
protocol YTPageLoadable {
    associatedtype Q: SGTLRCollectionQuery
    associatedtype PageElement: YTCollectionElementInitialisable where PageElement.Q.Response.Element == Q.Response.Element

    /// A query that results in multiple results that are pageable
    func loadElementsQuery(maxResults: Int) -> Q
}


extension PlaylistItems: YTPageLoadable {
    typealias PageElement = PlaylistItem

    func loadElementsQuery(maxResults: Int) -> GTLRYouTubeQuery_PlaylistItemsList {
        return SGTLRQueries.playlistItems(playlistId: self.playlistId, maxResults: maxResults)
    }
}
