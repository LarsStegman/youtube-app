//
//  ThumbnailDetails.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 01/12/2018.
//  Copyright © 2018 Stegman. All rights reserved.
//

import Foundation

struct ThumbnailDetails {
    enum ThumbnailSize: String, CaseIterable, Codable {
        case `default`
        case medium
        case high
        case standard
        case maxres
    }

    let thumbnails: [ThumbnailSize: Thumbnail]
}

extension ThumbnailDetails: Codable {}
