//
//  ThumbnailListLayout.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 22/11/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import SwiftUI

struct ThumbnailItemImpl: ThumbnailItem {
    var title: String

    var subtitle: String

    var publishDate: Date?

    var thumbnail: ImageLoadable?

    var caption: String?
}

struct ThumbnailListLayout: View {
    let items = [
        ThumbnailItemImpl(
            title: "Test title",
            subtitle: "The subtitle",
            publishDate: Date(timeIntervalSinceNow: -60 * 60 * 24 - 1),
            thumbnail: Image("mm"),
            caption: nil),
        ThumbnailItemImpl(
            title: "Test 2",
            subtitle: "Subtitle 2",
            publishDate: Date(timeIntervalSinceNow: -60 * 60 * 24 * 4 - 1),
            thumbnail: nil,
            caption: nil)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                ForEach(0..<2) { i in
                    VStack(alignment: .leading, spacing: 0) {
                        Image(systemName: "xmark.rectangle")
                            .imageScale(.large)
                            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: .infinity)
                            .aspectRatio(16/9, contentMode: .fit)

                        Divider()

                        VStack {
                            Text("Hi")
                        }
                        .padding()
                    }
                    .scaledToFill()

                    FloatingThumbnailedView(item: self.items[i])
                }
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .shadow(radius: 10)
            }
            .padding()
        }
        .frame(width: 400, height: 900)
        .background(Color(.systemBackground))
    }
}

struct ThumbnailListLayout_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(ColorScheme.allCases, id: \.self) {
                ThumbnailListLayout()
                    .previewLayout(.sizeThatFits)
                    .environment(\.colorScheme, $0)
            }
        }
//            .previewDevice("iPhone 6s")
    }
}
