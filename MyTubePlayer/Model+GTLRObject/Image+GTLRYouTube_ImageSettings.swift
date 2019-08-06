//
//  Image+GTLRYouTube_ImageSettings.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 04/08/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

extension ChannelBanner {
    init?(from: GTLRYouTube_ImageSettings) {
        self.images = [
            ImageKey(.website, .standard): from.bannerImageUrl == nil ? nil : URL(string: from.bannerImageUrl!),
            ImageKey(.mobile, .high): from.bannerMobileHdImageUrl == nil ? nil: URL(string: from.bannerMobileHdImageUrl!),
            ImageKey(.tablet, .high): from.bannerTabletHdImageUrl == nil ? nil: URL(string: from.bannerTabletHdImageUrl!),
        ].compactMapValues({ $0 })
        if self.images.isEmpty {
            return nil
        }
    }
}
