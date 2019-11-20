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


class GTLRLoader<O: YTLoadingIntialisable>: ValueLoader, ObservableObject, Combine.Subscriber {
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

    fileprivate func loaderPublisher(query: O.Q) -> AnyPublisher<O.Q.Response, Error> {
        return self.service.publisher(for: query).eraseToAnyPublisher()
    }

    private var lastLoading: AnyPublisher<O.Q.Response, LoadingError>? = nil
    func load() {
        self.subscription?.cancel()
        self.subscription = nil
        if self.status != .loading {
            self.status = .loading
            self.lastLoading = self.loaderPublisher(query: data.loadQuery)
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

///
class GTLRPageLoader<S: YTPageLoadable>: ObservableObject, Combine.Subscriber {

    typealias Input = [S.PageElement]
    typealias Failure = LoadingError

    let source: S
    @Published var data: [S.PageElement] = []
    @Published private(set) var status: LoadingStatus = .uninit

    private let maxResults: Int
    private let service: GTLRYouTubeService

    init(source: S, maxResultsPerPage: Int = 5, service: GTLRYouTubeService) {
        self.source = source
        self.maxResults = maxResultsPerPage
        self.service = service
    }

    private var loader: AnyPublisher<[S.PageElement], LoadingError>? = nil
    private var subscription: Combine.Subscription? = nil

    private func resetState() {
        self.loader = nil
        self.subscription?.cancel()
        self.subscription = nil
        self.status = .uninit
        self.data = []
    }

    func reload() {
        Swift.print("Page loader: reload")
        self.resetState()
        self.status = .loading
        self.loader = self.service.collectionPublisher(for: self.source.loadElementsQuery(maxResults: self.maxResults))
            .tryMap { (page) in
                return try page.map {
                    if let item = S.PageElement.init(from: $0) {
                        return item
                    } else {
                        throw LoadingError.decodingFailed
                    }
                }
            }
            .mapError { (err) -> LoadingError in
                return (err as? LoadingError) ?? LoadingError.loadingFailed
            }
            .eraseToAnyPublisher()

        self.loader?.subscribe(self)
    }

    func cancel() {
        self.subscription?.cancel()
        self.subscription = nil
        self.loader = nil
        self.status = .cancelled
    }

    func loadNextPageIfNeeded() {
        guard self.status == .pageFinished else {
            return
        }

        self.loadNextPage()
    }

    func loadNextPage() {
        guard let sub = self.subscription else {
            return
        }

        self.status = .loading
        sub.request(.max(1))
    }


    func receive(subscription: Combine.Subscription) {
        self.subscription = subscription
    }

    func receive(_ input: [S.PageElement]) -> Subscribers.Demand {
        self.objectWillChange.send()
        self.data.append(contentsOf: input)
        self.status = .pageFinished
        self.objectWillChange.send()
        return .none
    }

    func receive(completion: Subscribers.Completion<LoadingError>) {
        self.status = completion.loadingStatus
        self.subscription = nil
        self.loader = nil
    }
}

extension GTLRPageLoader: PageLoader {
    typealias Controller = GTLRPageLoader

    var controller: Controller {
        return self
    }

    var allLoaded: Bool {
        return self.status == .finished
    }

    func load() {
        self.reload()
    }

    typealias Element = S.PageElement

    typealias Value = [S.PageElement]

    var isLoading: Binding<Bool> {
        return Binding(get: {
            return self.status == .loading
        }, set: { (loading) in
            if loading {
                self.loadNextPageIfNeeded()
            }
        })
    }
}

