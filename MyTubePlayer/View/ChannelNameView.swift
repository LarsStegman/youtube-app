//
//  ChannelNameView.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 24/07/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import SwiftUI

struct ChannelNameView: View {
    @EnvironmentObject var dataController: DataController
    var channel: Channel

    @State var isSubscribed = false

    var image: ImageLoadable {
        return channel.thumbnails?.thumbnails[.high]?.url ?? Image(systemName: "exclamationmark.circle")
    }

    var body: some View {
        HStack(alignment: .center) {
            AvatarView(image: image)
                .frame(width: 60, height: 60)

            VStack(alignment: .leading, spacing: 4) {
                Text(self.channel.title ?? "Loading...")
                    .font(.largeTitle)

                if dataController.authenticationController.isSignedIn {
                    SubscribeButton(isSubscribed: self.$isSubscribed)
                }
            }
        }
    }
}
