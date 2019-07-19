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


protocol Refreshable {
    associatedtype StoredData: Codable

    var data: StoredData? { get }
    var refreshedDate: Date? { get }

    func refresh()
    func refreshIfNeeded()
}

struct DataQueries {
    static var subscriptions: GTLRYouTubeQuery_SubscriptionsList {
        let query = GTLRYouTubeQuery_SubscriptionsList.query(withPart: "snippet")
        query.mine = true
        query.maxResults = 50

        let parameters = GTLRServiceExecutionParameters(shouldFetchNextPages: true)
        query.executionParameters = parameters

        return query
    }
}


class PublishedRefreshableData<D: Codable, P: Publisher>: Refreshable, BindableObject where P.Output == D, P.Failure == Error {
    typealias StoredData = D

    let willChange = PassthroughSubject<Void, Never>()
    @Published private(set) var data: StoredData? {
        willSet {
            willChange.send()
        }
    }
    var refreshedDate: Date?

    let persistence: PersistenceService
    private let refreshPublisher: () -> AnyPublisher<D, Error>

    init(type: String,
         persistence: PersistenceService,
         refresh: @escaping @autoclosure () -> P) {
        self.persistence = persistence
        self.refreshPublisher = { refresh().eraseToAnyPublisher() }

        if let data = try? self.persistence.load(filename: type),
            let storedSubs = try? JSONDecoder().decode(StoredData.self, from: data) {
                self.data = storedSubs
        } else {
            self.data = nil
        }

        _ = self.$data.encode(encoder: JSONEncoder())
            .ignoreError()
            .sink { (d) in
                try? self.persistence.store(data: d, inFile: type)
        }
    }

    private var refreshing: AnyCancellable?
    func refresh() {
        self.refreshing?.cancel()
        let refresher = self.refreshPublisher()
            .ignoreError()
            .sink(receiveValue: { (d) in
                self.data = d
                self.refreshing = nil
                self.refreshedDate = Date()
            })

        self.refreshing = AnyCancellable(refresher)
    }

    func refreshIfNeeded() {
        self.refresh()
    }
}


class PersistenceService {
    let userId: String

    init(userId: String) {
        self.userId = userId
    }

    enum PersistenceError: Error {
        case cacheInaccessible
    }

    private func baseUrl() throws -> URL {
        guard let storeFile = FileManager.default.urls(for: .libraryDirectory, in: .allDomainsMask).first else {
            throw PersistenceError.cacheInaccessible
        }

        return storeFile
    }

    func store(data: Data, inFile filename: String) throws {
        let fileUrl = try self.baseUrl().appendingPathComponent(filename)
        try data.write(to: fileUrl)
    }

    func load(filename: String) throws -> Data {
        let fileUrl = try self.baseUrl().appendingPathComponent(filename)
        return try Data(contentsOf: fileUrl)
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

        self.subscriptions = PublishedRefreshableData(type: "subscriptions",
                                                      persistence: persistenceService,
                                                      refresh: gtlrService
                                                        .publisher(for: DataQueries.subscriptions)
                                                        .gtlrCollectionSequence()
                                                        .map { subs in
                                                            subs.compactMap { Subscription(from: $0) }
                                                        }.eraseToAnyPublisher())

    }

    var subscriptions: PublishedRefreshableData<[Subscription], AnyPublisher<[Subscription], Error>>
}
