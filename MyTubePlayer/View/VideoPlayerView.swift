//
//  VideoPlayerView.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 19/10/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import SwiftUI
import AVKit
import Combine

struct VideoDisplayView: View {
    @EnvironmentObject var playerController: PlayerController

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                VideoPlayerView()
                    .background(Color.black)
                    .aspectRatio(16/9, contentMode: .fit)
                
                Divider()
                VStack {
                    Text(playerController.currentItem?.title ?? "Video title")
                        .font(.title)
                    }
                .padding()
                Spacer()
            }
        }
    }
}

