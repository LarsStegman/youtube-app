//
//  StructLoader.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 04/08/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import GoogleAPIClientForREST


class GTLRLoader<O: YTStructLoadable>: ValueLoader, ObservableObject, Combine.Subscriber {
    typealias Input = O.Q.Response
    typealias Failure = LoadingError
    typealias Value = O

    let service: GTLRService

    @Published var data: O
    @Published var status: LoadingStatus = .uninit

    init(_ data: O, service: GTLRService) {
        self.data = data
        self.service = service
    }

    deinit {
        self.subscription?.cancel()
    }

    private var lastLoading: AnyPublisher<O.Q.Response, LoadingError>? = nil
    func load() {
        self.subscription?.cancel()
        self.subscription = nil
        if self.status != .loading, let q = data.loadQuery {
            self.status = .loading
            // TODO: Does the publisher maybe get dereferenced immediately?
            self.lastLoading = self.service.publisher(for: q)
                .mapError { err -> LoadingError in
                    return LoadingError.loadingFailed
                }
                .eraseToAnyPublisher()

            self.lastLoading?.subscribe(self)
            }
    }

    fileprivate var subscription: Combine.Subscription? = nil
    func receive(subscription: Combine.Subscription) {
        self.subscription = subscription
    }

    func receive(_ input: O.Q.Response) -> Subscribers.Demand {
        if let response = O.init(from: input) {
            self.data = response
            self.status = .finished
        } else {
            self.status = .failure(.decodingFailed)
        }

        return .none
    }

    func receive(completion: Subscribers.Completion<LoadingError>) {
        switch completion {
        case .finished:
            if case .failure(_) = self.status {
                // Do nothing
            } else {
                self.status = .finished
            }
        case .failure(let err): self.status = .failure(err)
        }

        self.subscription = nil
        self.lastLoading = nil
    }

    func cancel() {
        self.subscription?.cancel()
        self.subscription = nil
        self.lastLoading = nil
        self.status = .cancelled
    }
}

class GTLRCollectionLoader<O: YTCollectionLoadable>: GTLRLoader<O>, ContinuousValueLoader {
    private var remainingDemand: Subscribers.Demand = .max(1)
    func loadMore() {
        self.remainingDemand += 1
        self.subscription?.request(self.remainingDemand)
    }

    override func receive(_ input: O.Q.Response) -> Subscribers.Demand {
        self.objectWillChange.send()
        self.data.load(items: Array(input))
        self.remainingDemand -= 1
        return self.remainingDemand
        // TODO: Update status
    }
}
