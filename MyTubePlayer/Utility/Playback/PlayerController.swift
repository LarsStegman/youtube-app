//
//  PlayerController.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 18/11/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation
import SwiftUI
import AVKit
import UIKit
import Combine

/// An item that can be fed into an AVPlayer and be played
protocol PlayableItem {
    func asPlayerItem() -> AVPlayerItem
}

extension AVPlayerItem {
    func asPlayerItem() -> AVPlayerItem {
        return self
    }
}

extension URL: PlayableItem {
    func asPlayerItem() -> AVPlayerItem {
        return AVPlayerItem(url: self)
    }
}

class AVPlayerLayerUIView: UIView {
    private let videoLayer: AVPlayerLayer

    init(player: AVPlayer) {
        self.videoLayer = AVPlayerLayer(player: player)
        super.init(frame: .zero)
        self.layer.addSublayer(videoLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("PlayerLayerView does not support init(coder:)")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.videoLayer.frame = bounds
    }
}


class PlayerController: ObservableObject {

    let player: AVPlayer
    private let playerStatusObserver: AVPlayerObserver
    private var statusObserver: AnyCancellable?
    private let streamFetcher = YouTubeStreamFetcher()
    private var playbackDataFetcher: AnyCancellable?


    init(player: AVPlayer) {
        self.player = player
        self.playerStatusObserver = AVPlayerObserver(player: player)
        self.statusObserver = self.playerStatusObserver.statusPublisher.assign(to: \.playerStatus, on: self)
    }


    @Published private(set) var playerStatus = PlayerStatus.empty()
    @Published private(set) var currentItem: Video?
    @Published private(set) var error: Error?

    private var playbackData: VideoPlaybackData? {
        didSet {
            self.replacePlayerItem()
        }
    }


    func set(currentItem video: Video?) {
        self.currentItem = video
        self.playbackDataFetcher?.cancel()
        guard let videoId = video?.id else {
            return
        }

        self.playbackDataFetcher = self.streamFetcher.playbackData(videoId: videoId)
            .sink(receiveCompletion: { (completion) in
                if case .failure(let err) = completion {
                    self.error = err
                    self.playbackData = nil
                }
            }, receiveValue: { (playbackData) in
                self.error = nil
                self.playbackData = playbackData
            })
    }

    private func replacePlayerItem() {
        guard let url = self.playbackData?.streams.first?.value else {
            self.player.replaceCurrentItem(with: nil)
            return
        }

        self.player.replaceCurrentItem(with: url.asPlayerItem())
    }

    func play() {
        self.player.play()
    }

    func pause() {
        self.player.pause()
    }

    /// SPEED CONTROLS, PROGRESS ETC

}


