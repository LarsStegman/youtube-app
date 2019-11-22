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

struct VideoPlayerView: View {
    @EnvironmentObject var playerController: PlayerController

    var body: some View {
        AVPlayerSwiftUIViewController(player: self.playerController.player)
    }
}

struct AVPlayerSwiftUIViewController: UIViewControllerRepresentable {
    let player: AVPlayer

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let avPlayerVC = AVPlayerViewController()


        return avPlayerVC
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player = self.player
    }
}

#if DEBUG
struct AVPlayerSwiftUIViewControllerPreviews: PreviewProvider {
    static var previews: some View {
        VideoPlayerView()
            .environmentObject(PlayerController(player: AVPlayer()))
    }
}
#endif
