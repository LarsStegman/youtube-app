//
//  GTLRService+Publisher.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 01/07/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation
import Combine
import GoogleAPIClientForREST

// MARK: - SGTLRServiceSubscription
extension GTLRServiceTicket: Cancellable { }

extension GTLRService {
    func publisher<Q: SGTLRQuery>(for query: Q) -> SGTLRPublisher<Q> {
        return SGTLRPublisher(query: query, service: self)
    }

    func collectionPublisher<Q: SGTLRCollectionQuery>(for query: Q) -> SGTLRCollectionPublisher<Q> {
        return SGTLRCollectionPublisher(query: query, service: self)
    }
}

class SGTLRPublisher<Q: SGTLRQuery>: CachingCancellablePublisher<Q.Response, Error> {
    let service: GTLRService
    let query: Q
    private var ticket: GTLRServiceTicket? = nil {
        didSet {
            self.cancellable = self.ticket
        }
    }

    init(query: Q, service: GTLRService) {
        self.query = query
        self.service = service
    }

    private func executeQuery() {
        self.ticket = self.service.executeQuery(self.query) {
            (ticket: GTLRServiceTicket, object: Any?, err: Error?) in
            self.gtlrDidFinish(serviceTicket: ticket, withObject: object as? Q.Response, withError: err)
        }
    }

    func gtlrDidFinish(serviceTicket ticket: GTLRServiceTicket,
                       withObject object: Q.Response?,
                       withError error: Error?) {
        guard let obj = object else {
            if let err = error {
                self.complete(.failure(err))
            } else {
                self.complete(.finished)
            }
            return
        }

        self.send(obj)
        self.complete(.finished)
        self.ticket = nil
    }

    override func receive<S>(subscriber: S) where S : Subscriber, S.Failure == Failure, S.Input == Output {
        super.receive(subscriber: subscriber)
        if self.ticket == nil {
            self.executeQuery()
        }
    }
}

// MARK: - GTLRCollectionPublisher
class SGTLRCollectionPublisher<Q: SGTLRCollectionQuery>: CachingCancellablePublisher<Q.Response, Error>, Combine.Subscriber {
    // MARK: Publisher
    let service: GTLRService

    private(set) var originalQuery: Q
    private var nextQuery: Q? = nil

    init(query: Q, service: GTLRService) {
        self.originalQuery = query
        self.nextQuery = query.copy() as? Q
        self.service = service
    }

    private func executeNextQuery() {
        guard let query = self.nextQuery else {
            return
        }

        self.nextQuery = nil
        self.execute(query)
    }

    private func execute(_ query: Q) {
        self.pageSubscription = nil
        self.service.publisher(for: query).receive(subscriber: self)
    }


    // MARK: Subscriber
    typealias Input = Q.Response
    private var pageSubscription: Combine.Subscription? = nil {
        didSet {
            self.cancellable = self.pageSubscription
        }
    }

    func receive(_ input: Q.Response) -> Subscribers.Demand {
        if let pageToken = input.nextPageToken {
            let nextQuery = self.originalQuery.copy() as! Q
            nextQuery.pageToken = pageToken
            self.nextQuery = nextQuery
        }

        self.send(input)
        return self.remainingDemand.values.max() ?? .none
    }

    func receive(completion: Combine.Subscribers.Completion<Error>) {
        self.pageSubscription = nil
        if case .finished = completion {
            if self.nextQuery == nil {
                self.complete(.finished)
            }
        } else {
            self.complete(completion)
        }
    }

    func receive(subscription: Combine.Subscription) {
        self.pageSubscription = subscription
    }
}
