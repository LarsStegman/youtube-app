//
//  BannerImage.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 24/07/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import SwiftUI

struct BannerImage: View {
    var body: some View {
        Image("ba_avatar")
            .resizable()
            .aspectRatio(contentMode: ContentMode.fill)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 2))
    }
}

#if DEBUG
struct BannerImage_Previews: PreviewProvider {
    static var previews: some View {
        BannerImage()
    }
}
#endif
