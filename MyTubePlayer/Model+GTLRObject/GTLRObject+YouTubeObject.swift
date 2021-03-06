//
//  GTLRObject+YouTubeObject.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 20/11/2018.
//  Copyright © 2018 Stegman. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

protocol YouTubeObjectable {
    var id: String { get }
    var title: String { get }
    var publicationDate: Date { get }
    var publicDescription: String { get }

    var thumbnailDetails: ThumbnailDetails? { get }
}

