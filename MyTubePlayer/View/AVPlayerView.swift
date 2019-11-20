//
//  AVPlayerView.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 09/11/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import AVKit

struct AVPlayerLayerView: UIViewRepresentable {
    let player: AVPlayer
    init(player: AVPlayer) {
        self.player = player
    }

    func updateUIView(_ uiView: AVPlayerLayerUIView, context: UIViewRepresentableContext<AVPlayerLayerView>) {

    }

    func makeUIView(context: UIViewRepresentableContext<AVPlayerLayerView>) -> AVPlayerLayerUIView {
        return AVPlayerLayerUIView(player: self.player)
    }
}
