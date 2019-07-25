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
public protocol SGTLRQueryResponse {
}

extension Never: SGTLRQueryResponse {}

/// A GTLRCollectionQueryResponse is usually a GTLRCollectionObject. This can be used to control pagination and to determine what kind of elements will be
/// returned.
public protocol SGTLRCollectionQueryResponse: SGTLRQueryResponse, Sequence where Element: GTLRObject {
    /// The page token for the next page, if there is one.
    var nextPageToken: String? { get }
    /// The page token for the previous page, if there is one.
    var prevPageToken: String? { get }

    /// The info for all pages.
    var pageInfo: GTLRYouTube_PageInfo? { get }
    var tokenPagination: GTLRYouTube_TokenPagination? { get }
}

/// A namespace for SGTLRQueries
enum SGTLRQueries {

}

// MARK: - SGTLRQuery conformance

// MARK: Channel
extension GTLRYouTubeQuery_ChannelsList: SGTLRCollectionQuery {
    typealias Response = GTLRYouTube_ChannelListResponse
}
extension GTLRYouTube_ChannelListResponse: SGTLRCollectionQueryResponse {
    public typealias Element = GTLRYouTube_Channel
}


// MARK: Subscriptions
extension GTLRYouTubeQuery_SubscriptionsList: SGTLRCollectionQuery {
    typealias Response = GTLRYouTube_SubscriptionListResponse
}
extension GTLRYouTube_SubscriptionListResponse: SGTLRCollectionQueryResponse {
    public typealias Element = GTLRYouTube_Subscription
}

extension GTLRYouTubeQuery_SubscriptionsDelete: SGTLRQuery {
    typealias Response = Never
}


// MARK: Playlist
extension GTLRYouTubeQuery_PlaylistsList: SGTLRCollectionQuery {
    typealias Response = GTLRYouTube_PlaylistListResponse
}
extension GTLRYouTube_PlaylistListResponse: SGTLRCollectionQueryResponse {
    public typealias Element = GTLRYouTube_Playlist
}

extension GTLRYouTubeQuery_PlaylistItemsList: SGTLRCollectionQuery {
    typealias Response = GTLRYouTube_PlaylistItemListResponse
}
extension GTLRYouTube_PlaylistItemListResponse: SGTLRCollectionQueryResponse {
    public typealias Element = GTLRYouTube_PlaylistItem
}


// MARK: Videos
extension GTLRYouTubeQuery_VideosList: SGTLRCollectionQuery {
    typealias Response = GTLRYouTube_VideoListResponse
}
extension GTLRYouTube_VideoListResponse: SGTLRCollectionQueryResponse {
    public typealias Element = GTLRYouTube_Video
}
