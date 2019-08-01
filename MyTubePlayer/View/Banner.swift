//
//  Banner.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 26/07/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import SwiftUI

struct Banner: View {
    // FIXME: Change to URL
    var imageName: String

    var body: some View {
        Image(imageName)
            .resizable()
            .clipped()
            .scaledToFill()
    }
}

