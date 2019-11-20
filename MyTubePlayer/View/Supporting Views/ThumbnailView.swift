//
//  ThumbnailView.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 14/09/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import SwiftUI
import Combine

protocol ThumbnailViewable {
    var thumbnail: Thumbnail? { get }
    var caption: String? { get }
}

struct ThumbnailView: View {
    let item: ThumbnailViewable
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            item.thumbnail.map { t in
                ImageLoadingView(image: t)
            }

            item.caption.map { caption in
                Group {
                    Text(caption)
                        .foregroundColor(Color.white)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                }
                .background(Color.black.opacity(0.8))
                .cornerRadius(8)
                .padding(6)
            }
        }
    }
}

extension Thumbnail: ImageLoadable {
    func loadImage() -> AnyPublisher<Image, LoadingError> {
        self.url.loadImage()
    }

    func equals(_ other: ImageLoadable) -> Bool {
        self.url.equals(other)
    }
}


//struct ThumbnailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ThumbnailView()
//    }
//}
