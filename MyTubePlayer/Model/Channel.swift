//
//  Channel.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 01/12/2018.
//  Copyright © 2018 Stegman. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

@dynamicMemberLookup
struct Channel: YTStruct, Codable {
    let base: YTBaseStruct
    let uploadsId: String?
    let banner: ChannelBanner?

    init(base: YTBaseStruct, uploadsId: String? = nil, banner: ChannelBanner? = nil) {
        self.base = base
        self.uploadsId = uploadsId
        self.banner = banner
    }

    subscript<T>(dynamicMember keyPath: KeyPath<YTBaseStruct, T>) -> T {
        get {
            base[keyPath: keyPath]
        }
    }
}

extension Channel: CustomDebugStringConvertible {
    var debugDescription: String {
        return "Channel \(self.id), title: \(self.title)"
    }
}
