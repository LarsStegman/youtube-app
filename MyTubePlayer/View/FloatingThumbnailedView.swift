//
//  FloatingThumbnailedView.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 14/09/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import SwiftUI

protocol ThumbnailItem: ThumbnailViewable {
    var title: String { get }
    var subtitle: String { get }
    var publishDate: Date? { get }
}


let formatter: DateFormatter = {
    let f = DateFormatter()
    f.doesRelativeDateFormatting = true
    f.dateStyle = .short
    return f
}()

struct FloatingThumbnailedView: View {
    let item: ThumbnailItem

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ThumbnailView(item: item)
                .scaledToFill()

            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.headline)
                    .lineLimit(2)
                HStack {
                    Text(item.subtitle)
                        .font(.subheadline)
                    Spacer()

                    item.publishDate.map { d in
                        Text("\(d, formatter: formatter)")
                            .font(.caption)
                    }
                }
            }
            .padding()
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

//struct FloatingThumbnailedView_Previews: PreviewProvider {
//    static var previews: some View {
//        FloatingThumbnailedView()
//    }
//}
