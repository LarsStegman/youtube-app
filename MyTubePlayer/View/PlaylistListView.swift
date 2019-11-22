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
        if playlist.base.isLoaded {
            return AnyView(PageLoadingContainerView(loader:
                GTLRPageLoader(
                    source: PlaylistItems(playlistId: playlist.id, count: nil),
                    maxResultsPerPage: 30,
                    service: self.dataController.gtlrService)
                ) { data, controller in
                    PlaylistItemsView(items: data, itemsLoadingController: controller)
            })
        } else {
            return AnyView(Spinner(isAnimating: true, style: .medium))
        }
    }
}


struct PlaylistItemsView<PLC: PageLoadingController>: View {
    let items: [PlaylistItem]
    @ObservedObject var itemsLoadingController: PLC
    @EnvironmentObject var playbackQueueController: PlaybackQueueController

    var body: some View {
        ScrollView {
            VStack {
                ForEach(items) { plItem in
                    Button(action: {
                        self.playbackQueueController.show(item: Video(base: YTBaseStruct(id: plItem.videoId),
                                                                 channelId: plItem.channelId))
                        self.playbackQueueController.start()
                    }) {
                        FloatingThumbnailedView(item: plItem)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .scaledToFit()
                }

                LoadingStatusButton(status: itemsLoadingController.status, action: {
                    self.itemsLoadingController.loadNextPage()
                })
                .padding(.top)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
        }
    }
}

extension PlaylistItem: ThumbnailItem {
    var title: String {
        return self.base.title ?? "Loading..."
    }

    var subtitle: String {
        return self.channelTitle
    }

    var publishDate: Date? {
        return self.publicationDate
    }

    var thumbnail: ImageLoadable? {
        return self.base.thumbnails?.thumbnails[.maxres]
    }

    var caption: String? {
        return nil
    }
}

