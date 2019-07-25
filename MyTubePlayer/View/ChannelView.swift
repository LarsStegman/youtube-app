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
    @Binding var channel: Channel

    var body: some View {
        VStack(alignment: .leading) {
            Image("ba_banner")
                .resizable()
                .scaledToFit()
                .frame(height: 70)
                .clipped()
                .listRowInsets(EdgeInsets())
            
            ChannelNameView(channel: self.channel)
                .padding([.leading, .trailing], 16)
            Divider()
                .padding(.bottom, -8)
            List(Array(Range(1...50)), id: \.self) {
                Text("\($0)")
            }
        }
    }
}
