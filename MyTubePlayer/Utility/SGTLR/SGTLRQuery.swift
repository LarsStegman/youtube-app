//
//  SGTLRQuery.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 10/07/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

/// A GTLRQuery with its associated return type
protocol SGTLRQuery: GTLRQueryProtocol {

    /// The type of the object returned by the query.
    associatedtype Response: SGTLRQueryResponse
}

/// A collection query which allows pagination.
protocol SGTLRCollectionQuery: SGTLRQuery where Response: SGTLRCollectionQueryResponse {

    /// The page token to indicate which page of the results should be retrieved.
    var pageToken: String? { get set }
}


/// A GTLRQuery response
protocol SGTLRQueryResponse {
}

/// A GTLRCollectionQueryResponse is usually a GTLRCollectionObject. This can be used to control pagination and to determine what kind of elements will be
/// returned.
protocol SGTLRCollectionQueryResponse: SGTLRQueryResponse {
    /// The page token for the next page, if there is one.
    var nextPageToken: String? { get }
    /// The page token for the previous page, if there is one.
    var prevPageToken: String? { get }

    /// The info for all pages.
    var pageInfo: GTLRYouTube_PageInfo? { get }
    var tokenPagination: GTLRYouTube_TokenPagination? { get }

    associatedtype Element: GTLRObject
}

// MARK: - SGTLRQuery conformance
extension GTLRYouTubeQuery_ChannelsList: SGTLRCollectionQuery {
    typealias Response = GTLRYouTube_ChannelListResponse
}
extension GTLRYouTube_ChannelListResponse: SGTLRCollectionQueryResponse {
    typealias Element = GTLRYouTube_Channel
}

extension GTLRYouTubeQuery_PlaylistItemsList: SGTLRCollectionQuery {
    typealias Response = GTLRYouTube_PlaylistItemListResponse
}
extension GTLRYouTube_PlaylistItemListResponse: SGTLRCollectionQueryResponse {
    typealias Element = GTLRYouTube_PlaylistItem
}

extension GTLRYouTubeQuery_SubscriptionsList: SGTLRCollectionQuery {
    typealias Response = GTLRYouTube_SubscriptionListResponse
}
extension GTLRYouTube_SubscriptionListResponse: SGTLRCollectionQueryResponse {
    typealias Element = GTLRYouTube_Subscription
}
