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
            self.isSubscribed.toggle()
        }) {
            if self.isSubscribed {
                Image(systemName: "checkmark.circle")
            } else {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                    Text("Subscribe")
                        .font(.callout)
                }
                .padding(5)
            }
        }
        .foregroundColor(.white)
        .background(Color.accentColor)
        .cornerRadius(20)
    }
}

