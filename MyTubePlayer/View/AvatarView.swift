//
//  BannerImage.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 24/07/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import SwiftUI

struct AvatarView: View {
    let image: ImageLoadable

    var body: some View {
        ImageLoadingView(image: image)
            .scaledToFit()
            .clipShape(Circle())
            .overlay(Circle().stroke(Color(UIColor.separator), lineWidth: 1))
    }
}

#if DEBUG
struct BannerImage_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView(image: URL(string: "https://yt3.ggpht.com/a/AGF-l78ONljmN82qL3T_tqYvkmSvrVXso-3OmgD0og=s176-c-k-c0xffffffff-no-rj-mo")!)
    }
}
#endif
