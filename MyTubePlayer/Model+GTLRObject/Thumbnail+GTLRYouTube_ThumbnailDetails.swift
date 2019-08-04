//
//  Thumbnail+GTLRYouTube_ThumbnailDetails.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 16/11/2018.
//  Copyright © 2018 Stegman. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

fileprivate extension ThumbnailDetails.ThumbnailSize {
    func keypath() -> String {
        switch self {
        case .default: return "defaultProperty"
        default: return self.rawValue
        }
    }
}

extension ThumbnailDetails {
    init?(from: GTLRYouTube_ThumbnailDetails) {
        var thumbnails = [ThumbnailSize: Thumbnail]()
        for type in ThumbnailSize.allCases {
            let key = type.keypath()
            guard let thumb = from.value(forKey: key) as? GTLRYouTube_Thumbnail,
                let thumbnail = Thumbnail(from: thumb) else {
                continue
            }

            thumbnails[type] = thumbnail
        }

        if thumbnails.isEmpty {
            return nil
        }

        self.thumbnails = thumbnails
    }
}

extension Thumbnail {
    init?(from: GTLRYouTube_Thumbnail) {
        guard let urlStr = from.url, let url = URL(string: urlStr) else {
            return nil
        }

        self.url = url
        self.width = from.width?.intValue
        self.height = from.height?.intValue
    }
}
