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

    var body: some View {
        ScrollView {
            VStack {
                ForEach(items) { plItem in
                    FloatingThumbnailedView(item: plItem)
                        .scaledToFit()
                }

                HStack {
                    Spacer()
                    LoadingStatusButton(status: itemsLoadingController.status, action: {
                        self.itemsLoadingController.loadNextPage()
                    })
                        .foregroundColor(Color.accentColor)
                    Spacer()
                }
            }
            .padding(.horizontal)
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

    var thumbnail: Thumbnail? {
        return self.base.thumbnails?.thumbnails[.maxres]
    }

    var caption: String? {
        return nil
    }
}

