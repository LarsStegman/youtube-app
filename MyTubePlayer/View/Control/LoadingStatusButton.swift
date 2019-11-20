//
//  LoadingStatusButton.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 08/09/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import SwiftUI

struct LoadingStatusButton: View {
    let status: LoadingStatus
    let action: () -> Void

    var body: some View {
        switch status {
        case .uninit: fallthrough
        case .pageFinished: return AnyView(Button(action: self.action) {
            Text("Load more")
        })
        case .loading: return AnyView(Spinner(isAnimating: true, style: .large))
        default: return AnyView(EmptyView())
        }
    }
}

struct LoadingStatusButton_Previews: PreviewProvider {
    static var previews: some View {
        LoadingStatusButton(status: .loading, action: {})
    }
}
