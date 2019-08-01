//
//  SubscribeButton.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 24/07/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import SwiftUI

struct SubscribeButton: View {
    @Binding var isSubscribed: Bool

    var body: some View {
        return Button(action: {
            withAnimation {
                self.isSubscribed.toggle()
            }
        }) {
            HStack(spacing: 2) {
                Image(systemName: self.isSubscribed ? "checkmark.circle" : "plus")
                    .imageScale(self.isSubscribed ? .large : .medium)
                if !self.isSubscribed {
                    Text("Subscribe")
                        .font(.callout)
                        .transition(.opacity)
                        .animation(nil)
                }
            }
            .padding(5)
            .padding([.leading, .trailing], isSubscribed ? 0 : 8)
        }
        .frame(minWidth: 30, minHeight: 30)
        .foregroundColor(.white)
        .background(Color.accentColor)
        .cornerRadius(15)

    }
}

