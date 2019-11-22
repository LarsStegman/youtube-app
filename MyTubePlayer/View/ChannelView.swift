//
//  ChannelView.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 23/07/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import SwiftUI
import GoogleAPIClientForREST

struct ChannelView: View {
    @EnvironmentObject var dataController: DataController
    let channel: Channel

    @State var selectedView = 0
    private let channelSections = ["Uploads", "Playlists", "Info"]

    var contentView: some View {
        switch self.selectedView {
        case 0:
        if let uploadsPlaylist = self.channel.uploadsPlaylistBase {
            return AnyView(
                ValueLoadingContainerView(
                    loader: GTLRLoader(uploadsPlaylist, service: self.dataController.gtlrService)) {
                        PlaylistListView(playlist: $0)
                }
            )
        } else {
            return AnyView(
                Image(systemName: "exclamationmark.circle")
            )
        }
        case 1: return AnyView(VStack {
            Text("Playlists")
                .padding([.leading, .trailing], 8)
            Spacer()
            })
        case 2: return AnyView(Text(self.channel.description ?? "Not loaded"))
        default: return AnyView(EmptyView().background(Color.gray))
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading) {
                channel.banner.map { b in
                    BannerView(banner: b)
                }

                Group {
                    ChannelNameView(channel: self.channel)

                    Picker(selection: self.$selectedView, label: Text("Channel Section")) {
                        ForEach(0..<self.channelSections.count) { i in
                            Text(self.channelSections[i])
                                .tag(i)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                    .padding([.leading, .trailing], 8)
                    .padding(.bottom, 4)
                Divider()
            }

            self.contentView
        }
        .navigationBarTitle("", displayMode: .inline)
    }
}

extension Channel {
    var uploadsPlaylistBase: Playlist? {
        if let uploads = self.uploadsId {
            return Playlist(base: YTBaseStruct(id: uploads), channelId: self.id)
        } else {
            return nil
        }
    }
}
