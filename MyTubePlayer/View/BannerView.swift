//
//  Banner.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 26/07/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import SwiftUI

struct BannerView: View {
    // FIXME: Change to URL
    let banner: ChannelBanner

    var image: ImageLoadable? {
        banner.image(for: UIDevice.current.userInterfaceIdiom, resolution: .high)
    }

    var body: some View {
        if self.image != nil {
            return AnyView(ImageLoadingView(image: self.image!)
                .clipped()
                .scaledToFit())
        } else {
            return AnyView(EmptyView())
        }
    }
}

