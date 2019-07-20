//
//  YTUserDataStore.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 12/07/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import GoogleAPIClientForREST

extension SGTLRQueries {
    static var subscriptions: GTLRYouTubeQuery_SubscriptionsList {
        let query = GTLRYouTubeQuery_SubscriptionsList.query(withPart: "snippet")
        query.mine = true
        query.maxResults = 50

        let parameters = GTLRServiceExecutionParameters(shouldFetchNextPages: true)
        query.executionParameters = parameters

        return query
    }
}

/// A store for a user's YouTube data like their subscription feed, subscriptions, playlists, channel
class YTUserInteractionService {

    let gtlrService: GTLRYouTubeService
    let persistenceService: PersistenceService

    init(gtlrService: GTLRYouTubeService,
         persistenceService: PersistenceService) {
        self.gtlrService = gtlrService
        self.persistenceService = persistenceService

        self.subscriptions = SubscriptionList(service: gtlrService)
    }

    var subscriptions: SubscriptionList
}

class SubscriptionList: BindableObject {
    let willChange = PassthroughSubject<Void, Never>()
    enum RefreshStatus {
        case uninitialised
        case finished
        case refreshing
        case failed(Error)
    }

    var subscriptions = [Subscription]()
    var status: RefreshStatus = .uninitialised {
        willSet {
            self.willChange.send()
        }
    }

    private let service: GTLRYouTubeService
    init(service: GTLRYouTubeService) {
        self.service = service
        self.refresh()
    }

    private var refresher: AnyCancellable? = nil
    func refresh() {
        self.refresher?.cancel()
        self.status = .refreshing

        self.refresher = self.service.publisher(for: SGTLRQueries.subscriptions)
            .gtlrCollectionSequence()
            .map { gtlrSubs in
                gtlrSubs.compactMap { Subscription(from: $0) }
            }.sink(
                receiveCompletion: { (completion) in
                self.refresher = nil
                switch completion {
                case .finished: self.status = .finished
                case .failure(let err): self.status = .failed(err)
                }
            }, receiveValue: { (subs) in
                self.subscriptions = subs
            })
    }
}
