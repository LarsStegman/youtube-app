//
//  BasePublisher.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 23/07/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation
import Combine


class BaseSubscription<Value, Failure: Error>: Combine.Subscription, Hashable, Equatable {
    let subscriber: AnySubscriber<Value, Failure>
    let _cancel: ((BaseSubscription) -> Void)?
    let request: ((Subscribers.Demand) -> Void)?

    init<S: Subscriber>(subscriber: S,
                        cancel: ((BaseSubscription) -> Void)? = nil,
                        request: ((Subscribers.Demand) -> Void)? = nil)
        where S.Input == Value, S.Failure == Failure {
            self.subscriber = AnySubscriber(subscriber)
            self._cancel = cancel
            self.request = request
    }

    convenience init<S: Subscriber>(subscriber: S, publisher: CachingCancellablePublisher<S.Input, S.Failure>)
        where S.Input == Value, S.Failure == Failure {
        self.init(subscriber: subscriber, cancel: publisher.cancel, request: { demand in
            publisher.request(subscriber, demand)
        })
    }

    func request(_ demand: Subscribers.Demand) {
        self.request?(demand)
    }

    func cancel() {
        self._cancel?(self)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.combineIdentifier)
    }

    static func == (lhs: BaseSubscription, rhs: BaseSubscription) -> Bool {
        return lhs.combineIdentifier == rhs.combineIdentifier
    }
}


class CachingCancellablePublisher<R, E: Error>: Publisher {
    typealias Output = R
    typealias Failure = E

    // MARK: Subscriber management
    private(set) var subscriptions = [BaseSubscription<R, E>]()

    func receive<S: Subscriber>(subscriber: S) where S.Failure == Failure, S.Input == Output {
        let subscription = createSubscription(for: subscriber)

        self.cache[subscriber.combineIdentifier] = []
        self.subscriptions.append(subscription)
        subscriber.receive(subscription: subscription)
    }

    func request<S: Subscriber>(_ subscriber: S, _ demand: Subscribers.Demand)
        where S.Input == Output, S.Failure == Failure {
            self.remainingDemand[subscriber.combineIdentifier] = demand
            self.flushCache()
    }

    func createSubscription<S: Subscriber>(for subscriber: S) -> BaseSubscription<R, E>
        where S.Input == Output, S.Failure == Failure {
            return BaseSubscription(subscriber: subscriber, publisher: self)
    }


    var cancellable: Cancellable? = nil
    fileprivate func cancel(subscription sub: BaseSubscription<R, E>) {
        if let idx = self.subscriptions.firstIndex(of: sub) {
            self.subscriptions.remove(at: idx)
        }

        if self.subscriptions.isEmpty {
            self.cancellable?.cancel()
        }
    }

    // MARK: Value management
    private(set) var remainingDemand = [CombineIdentifier: Subscribers.Demand]()
    private(set) var cache = [CombineIdentifier: [R]]()

    func send(value: R) {
        for s in self.subscriptions {
            self.cache[s.subscriber.combineIdentifier]?.append(value)
        }

        self.flushCache()
    }

    func send(completion: Subscribers.Completion<E>) {
        for s in self.subscriptions {
            s.subscriber.receive(completion: completion)
        }
    }

    private func flushCache() {
        for s in self.subscriptions {
            let id = s.subscriber.combineIdentifier
            var subCache = self.cache[id] ?? []

            var remaining = self.remainingDemand[id] ?? .unlimited
            while remaining > .none, !subCache.isEmpty {
                let v = subCache.removeFirst()
                remaining = s.subscriber.receive(v)
            }

            self.remainingDemand[id] = remaining
            self.cache[id] = subCache
        }
    }
}
