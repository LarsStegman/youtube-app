//
//  Thumbnail.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 01/12/2018.
//  Copyright © 2018 Stegman. All rights reserved.
//

import Foundation

struct Thumbnail {
    let url: URL
    let width: Int?
    let height: Int?
}

extension Thumbnail: Codable { }
