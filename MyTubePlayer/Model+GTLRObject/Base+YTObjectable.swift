//
//  Base+YTObjectable.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 04/08/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation

extension YTBaseStruct {
    init(from : YouTubeObjectable) {
        self.init(id: from.id,
                  title: from.title,
                  publicationDate: from.publicationDate,
                  description: from.publicDescription,
                  thumbnails: from.thumbnailDetails)
    }
}
