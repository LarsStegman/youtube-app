//
//  PlaybackController.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 08/11/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation
import AVKit
import UIKit
import Combine

/// A queue controller that allows the control for a playback queue. The current item is fed into an AVPlayer which displays, the item.
/// It maintains a playable container
class PlaybackQueueController: ObservableObject {
    let playerController: PlayerController
    @Published private(set) var queue: [Video] = [] {
        didSet {
            self.updateState()
        }
    }

    var autoPlay: Bool

    var currentItem: Video? {
        if let idx = self.currentIndex {
            return self.queue[idx]
        } else {
            return nil
        }
    }
    var currentIndex: Int? {
        if case .displaying(let currentIndex) = self.state {
            return currentIndex
        } else {
            return nil
        }
    }

    private var statusObserver: AnyCancellable!
    init(playerController: PlayerController, autoPlay: Bool = true, items: [Video] = []) {
        self.playerController = playerController
        self.autoPlay = autoPlay
        self.replaceQueue(with: items)
        self.statusObserver = self.playerController.$playerStatus.sink(receiveValue: self.observe(playerStatus:))
        self.updateState()
    }

    deinit {
        self.statusObserver.cancel()
    }


    // MARK: - Player status processing
    private func observe(playerStatus status: PlayerStatus) {
        if status.isAtEnd && self.autoPlay {
            self.skipForwards()
        }
    }

    
    // MARK: - Playback state transitioning

    private enum PlaybackQueueState: Equatable {
        case uninit
        case ready
        case displaying(current: Int)
    }

    // If playback is moved beyond or in front of the queue length, playback is stopped.
    private var state: PlaybackQueueState = .uninit {
        didSet {
            self.transition(from: oldValue)
        }
        willSet {
            self.objectWillChange.send()
        }
    }

    private func updateState() {
        if self.queue.isEmpty {
            self.state = .uninit
        } else {
            if case .uninit = self.state {
                self.state = .ready
            }
        }
    }

    private func transition(from oldState: PlaybackQueueState) {
        switch (oldState, self.state) {
        case (_, .ready):
            if self.queue.isEmpty {
                self.state = .uninit
            }

            self.playerController.set(currentItem: nil)
        case (_, .uninit):
            self.playerController.set(currentItem: nil)
        case (_, .displaying(let new)):
            self.playerController.set(currentItem: self.queue[new])
        }
    }


    // MARK: - Item control

    var canSkipForwards: Bool {
        if let currentIdx = self.currentIndex {
            return currentIdx < self.queue.count - 1
        } else {
            return false
        }
    }

    /// Moves to the next item if an item is playing and available
    func skipForwards() {
        if self.canSkipForwards, let currentIdx = self.currentIndex {
            self.state = .displaying(current: currentIdx + 1)
        }
    }

    var canSkipBackwards: Bool {
        if let currentIdx = self.currentIndex {
            return currentIdx > 0
        } else {
            return false
        }
    }

    /// Moves to the previous item if it available
    func skipBackwards() {
        if self.canSkipBackwards, let currentIdx = self.currentIndex {
            self.state = .displaying(current: currentIdx - 1)
        }
    }

    func start() {
        switch self.state {
        case .uninit: break
        case .ready:
            self.state = .displaying(current: 0)
        case .displaying(current: _):
            break
        }
    }

    /// Stops playback
    func stop() {
        self.state = .ready
    }

    /// Appends an item to the end of the playback queue
    /// - Parameter item: The item to enqueue
    func enqueue(item: Video) {
        self.queue.append(item)
    }

    /// Enqueues an item after the currently playing item
    /// - Parameter item: The item to enqueue
    func enqueueNext(item: Video) {
        switch self.state {
        case .uninit, .ready:
            self.queue.insert(item, at: 0)
        case .displaying(let currentIdx):
            self.queue.insert(item, at: currentIdx + 1)
        }
    }

    func show(item: Video) {
        switch self.state {
        case .uninit, .ready:
            self.queue.insert(item, at: 0)
        case .displaying(let currentIdx):
            self.queue.insert(item, at: currentIdx)
            self.state = .displaying(current: currentIdx)
        }
    }

    /// Replaces all items in the queue and optionally immediately starts playing the first item
    /// - Parameters:
    ///   - with: The items to play
    func replaceQueue(with: [Video]) {
        self.state = .uninit
        self.queue = with
    }
}
