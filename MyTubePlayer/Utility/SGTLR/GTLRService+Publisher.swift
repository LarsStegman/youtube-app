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

class SGTLRServiceSubscription: Combine.Subscription, Hashable {
    fileprivate var cancellable: Cancellable
    let request: ((Subscribers.Demand) -> Void)?

    init(cancellable: Cancellable, request: ((Subscribers.Demand) -> Void)? = nil) {
        self.cancellable = cancellable
        self.request = request
    }

    func request(_ demand: Subscribers.Demand) {
        self.request?(demand)
    }

    func cancel() {
        self.cancellable.cancel()
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.combineIdentifier)
    }

    static func == (lhs: SGTLRServiceSubscription, rhs: SGTLRServiceSubscription) -> Bool {
        return lhs.combineIdentifier == rhs.combineIdentifier
    }
}

extension GTLRService {
    func publisher<Q: SGTLRQuery>(for query: Q) -> SGTLRPublisher<Q> {
        return SGTLRPublisher(query: query, service: self)
    }

    func collectionPublisher<Q: SGTLRCollectionQuery>(for query: Q) -> SGTLRCollectionPublisher<Q> {
        return SGTLRCollectionPublisher(query: query, service: self)
    }
}

class SGTLRPublisher<Q: SGTLRQuery>: Combine.Publisher {
    typealias Output = Q.Response
    typealias Failure = Error

    let service: GTLRService
    let query: Q
    private var ticket: GTLRServiceTicket? = nil

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
                self.subscriber?.receive(completion: .failure(err))
            } else {
                // FIXME: Send a custom error if both the object and the error are nil. This shouldn't happen
            }
            return
        }

        _ = self.subscriber?.receive(obj)
        self.subscriber?.receive(completion: .finished)
        self.ticket = nil
    }

    private var subscriber: AnySubscriber<Output, Failure>? = nil
    func receive<S>(subscriber: S)
        where S : Subscriber, SGTLRPublisher.Failure == S.Failure, SGTLRPublisher.Output == S.Input {
            self.executeQuery()
            guard let ticket = self.ticket else {
                return
            }

            self.subscriber = AnySubscriber(subscriber)
            subscriber.receive(subscription: SGTLRServiceSubscription(cancellable: ticket))
    }
}

// MARK: - GTLRCollectionPublisher
class SGTLRCollectionPublisher<Q: SGTLRCollectionQuery>: Combine.Publisher, Combine.Subscriber {
    typealias Input = Q.Response
    typealias Output = Q.Response
    typealias Failure = Error

    private(set) var originalQuery: Q
    let service: GTLRService

    private var nextQuery: Q? = nil
    private var pageSubscription: Combine.Subscription? = nil {
        didSet {
            if let sub = self.pageSubscription {
                self.subscriberSubscription?.cancellable = sub
            }
        }
    }

    var subscriber: AnySubscriber<Output, Failure>? = nil
    var subscriberSubscription: SGTLRServiceSubscription? = nil

    init(query: Q, service: GTLRService) {
        self.originalQuery = query
        self.nextQuery = query.copy() as? Q
        self.service = service
    }

    private(set) var remainingDemand: Subscribers.Demand = .none {
        didSet {
            if self.remainingDemand > .none {
                if !cache.isEmpty {
                    self.remainingDemand = self.subscriber?.receive(cache.removeFirst()) ?? .none
                } else {
                    self.executeNextQuery()
                }
            }
        }
    }

    private var cache = [Q.Response]()
    func receive(_ input: Q.Response) -> Subscribers.Demand {
        Swift.print("\(self) Received input: \(input)")
        if let pageToken = input.nextPageToken {
            let nextQuery = self.originalQuery.copy() as! Q
            nextQuery.pageToken = pageToken
            self.nextQuery = nextQuery
        }

        if self.remainingDemand > .none {
            self.remainingDemand = self.subscriber?.receive(input) ?? .none
        } else {
            cache.append(input)
        }

        Swift.print("\(self) new demand: \(self.remainingDemand)")
        return self.remainingDemand
    }

    func receive(completion: Combine.Subscribers.Completion<Error>) {
        Swift.print("\(self) Received completion: \(completion)")
        self.pageSubscription = nil
        if case .finished = completion {
            if self.nextQuery == nil {
                self.subscriber?.receive(completion: .finished)
                self.subscriber = nil
                self.subscriberSubscription = nil
            }
        } else {
            self.subscriber?.receive(completion: completion)
        }
    }

    func receive<S>(subscriber: S) where S : Subscriber,
        SGTLRCollectionPublisher.Failure == S.Failure, SGTLRCollectionPublisher.Output == S.Input {
            self.executeNextQuery()
            guard let pageSubscription = self.pageSubscription else {
                return
            }

            let subscriberSubscription = SGTLRServiceSubscription(cancellable: pageSubscription) { [weak self] in
                self?.remainingDemand = $0
            }
            self.subscriber = AnySubscriber(subscriber)
            self.subscriberSubscription = subscriberSubscription
            subscriber.receive(subscription: subscriberSubscription)
    }

    func receive(subscription: Combine.Subscription) {
        self.pageSubscription = subscription
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
}
