//
//  AVPlayerView.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 28/10/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation
import AVKit
import Combine


struct PlayerStatus {
    let timeControlStatus: AVPlayer.TimeControlStatus
    let loadingStatus: AVPlayer.Status

    // Time
    let duration: TimeInterval?
    let progress: Double?
    let playbackRate: Double
    let isPlaying: Bool

    // Audio
    let isMuted: Bool
    let volume: Double

    init(timeControlStatus: AVPlayer.TimeControlStatus, loadingStatus: AVPlayer.Status, duration: TimeInterval?,
         progress: Double?, playbackRate: Double, isPlaying: Bool, isMuted: Bool, volume: Double) {
        self.timeControlStatus = timeControlStatus
        self.loadingStatus = loadingStatus
        self.duration = duration
        self.progress = progress
        self.playbackRate = playbackRate
        self.isPlaying = isPlaying
        self.isMuted = isMuted
        self.volume = volume
    }

    static func empty() -> PlayerStatus {
        return PlayerStatus(
            timeControlStatus: .paused,
            loadingStatus: .unknown,
            duration: nil,
            progress: nil,
            playbackRate: 1,
            isPlaying: false,
            isMuted: true,
            volume: 0
        )
    }

    init(from player: AVPlayer) {
        let duration = player.currentItem?.duration.seconds
        var progress: Double? = nil
        if let d = duration {
            progress = player.currentTime().seconds / d
        }

        self = PlayerStatus(
            timeControlStatus: player.timeControlStatus,
            loadingStatus: player.status,
            duration: duration,
            progress: progress,
            playbackRate: Double(player.rate),
            isPlaying: player.timeControlStatus == .playing,
            isMuted: player.isMuted,
            volume: Double(player.volume)
        )
    }
}

extension PlayerStatus {
    var isAtEnd: Bool {
        return (self.progress ?? 0.0) >= 1.0
    }
}


class AVPlayerObserver {
    private var observers = [AnyCancellable]()
    let player: AVPlayer
    private let statusSubject = PassthroughSubject<PlayerStatus, Never>()
    var statusPublisher: AnyPublisher<PlayerStatus, Never> {
        return statusSubject.eraseToAnyPublisher()
    }

    init(player: AVPlayer) {
        self.player = player
        self.updateStatus()

        self.observeKVOProperty(\.status)
        self.observeKVOProperty(\.timeControlStatus)
        self.observeKVOProperty(\.currentItem)
        self.observeKVOProperty(\.allowsExternalPlayback)
        self.observeKVOProperty(\.isExternalPlaybackActive)
        self.observeKVOProperty(\.isMuted)
        self.observeKVOProperty(\.rate)
        self.observeKVOProperty(\.reasonForWaitingToPlay)
        self.player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: nil) {
            _ in
            self.updateStatus()
        }
    }

    deinit {
        self.player.removeTimeObserver(self)
    }

    private func observeKVOProperty<T: Equatable>(_ playerKP: KeyPath<AVPlayer, T>) {
        let pub = self.player.publisher(for: playerKP).sink { _ in
            self.updateStatus()
        }

        self.observers.append(pub)
    }

    private func updateStatus() {
        self.statusSubject.send(PlayerStatus(from: self.player))
    }
}
