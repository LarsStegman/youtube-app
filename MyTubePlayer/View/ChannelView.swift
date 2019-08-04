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

    @State var selectedView = 0
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Image("ba_banner")
                    .resizable()
                    .scaledToFit()

                Group {
                    ChannelNameView(channel: self.channel)

                    Picker(selection: self.$selectedView, label: Text("Channel Section")) {
                        Text("Uploads")
                            .tag(0)
                        Text("Playlists")
                            .tag(1)
                        Text("Info")
                            .tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                    .padding([.leading, .trailing], 8)
                    .padding(.bottom, 4)
                Divider()
            }

            if selectedView == 0 {
                List(Array(Range(1...50)), id: \.self) {
                    Text("\($0)")
                }
            } else if selectedView == 1 {
                Text("Playlists")
                    .padding([.leading, .trailing], 8)
                Spacer()
            }

        }
        .navigationBarTitle("", displayMode: .inline)


//        .navigationBarHidden(true)
    }
}
