//
//  PlaylistListView.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 06/08/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import SwiftUI

struct PlaylistListView: View {
    @EnvironmentObject var dataController: DataController
    let playlist: Playlist

    var body: some View {
        List {
            Text(playlist.title ?? playlist.id)
//            ValueLoadingContainerView(GTLRLoader(playlist.playlistItems, service: dataController.gtlrService),
//                                      contained: { playlistItems in
//                ForEach(playlistItems.items ?? []) { playlistItem in
//                    Text(playlistItem.title ?? playlistItem.id)
//                }
//            })
        }
    }
}
