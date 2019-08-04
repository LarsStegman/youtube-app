//
//  UserSubscriptionList.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 23/07/2019.
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

    static func unsubscribe(_ id: String) -> GTLRYouTubeQuery_SubscriptionsDelete {
        return GTLRYouTubeQuery_SubscriptionsDelete.query(withIdentifier: id)
    }
}


class SubscriptionList: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    enum RefreshStatus {
        case uninitialised
        case finished
        case refreshing
        case failed(Error)
    }

    var subscriptions = [Subscription]() {
        willSet {
            self.objectWillChange.send()
        }
    }
    var status: RefreshStatus = .uninitialised {
        willSet {
            self.objectWillChange.send()
        }
    }

    private let service: GTLRYouTubeService
    init(service: GTLRYouTubeService, immediatelyFetch: Bool = true) {
        self.service = service
        if immediatelyFetch {
            _ = self.refresh()
        }
    }

    private var refresher: AnyCancellable? = nil
    func refresh() -> AnyCancellable {
        self.refresher?.cancel()
        self.status = .refreshing

        let refresher = self.service.publisher(for: SGTLRQueries.subscriptions)
            .gtlrCollectionSequence()
            .map { gtlrSubs in
                return gtlrSubs.compactMap { Subscription(from: $0) }
            }
            .sink(
                receiveCompletion: { (completion) in
                self.refresher = nil
                switch completion {
                case .finished: self.status = .finished
                case .failure(let err): self.status = .failed(err)
                }
            }, receiveValue: { (subs) in
                self.subscriptions = subs
            })

        self.refresher = refresher
        return refresher
    }

    var deleteSubscription: Cancellable? = nil
    func unsubscribe(from subscription: Subscription) -> AnyPublisher<Never, Error> {
        let unsubscribing = self.service.publisher(for: SGTLRQueries.unsubscribe(subscription.id))
        self.deleteSubscription = unsubscribing.sink(
            receiveCompletion: { (completion) in
                if case .finished = completion, let idx = self.subscriptions.firstIndex(of: subscription) {
                    self.subscriptions.remove(at: idx)
                }
                self.deleteSubscription = nil
        })
        
        return unsubscribing.eraseToAnyPublisher()
    }
}
