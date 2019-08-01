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
    let channel: Channel

    init(channel: Channel) {
        self.channel = channel
        print("Channel view init: \(channel)")
    }

    @State var selectedView = 0
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Banner(imageName: "ba_banner")
                    .frame(maxHeight: 50)
                Group {
                    ChannelNameView(channel: self.channel)
                    Divider()
                    Picker(selection: self.$selectedView, label: Text("Thingy")) {
                        Text("Uploads")
                            .tag(0)
                        Text("Playlists")
                            .tag(1)

                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                    .padding([.leading, .trailing, .top], 8)
            }

            if selectedView == 0 {
                List(Array(Range(1...50)), id: \.self) {
                    Text("\($0)")
                }
            } else {
                Text("Playlists")
                    .padding([.leading, .trailing], 8)
                Spacer()
            }
        }

//        .navigationBarHidden(true)
    }
}
