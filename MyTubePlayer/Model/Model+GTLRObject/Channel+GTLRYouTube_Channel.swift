//
//  Channel+GTLRYouTube_Channel.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 20/11/2018.
//  Copyright © 2018 Stegman. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

extension GTLRYouTube_Channel: YouTubeObjectable {
    var title: String {
        return self.snippet!.title!
    }

    var publicationDate: Date {
        return self.snippet!.publishedAt!.date
    }

    var publicDescription: String {
        return self.snippet!.descriptionProperty!
    }

    var id: String {
        return self.identifier!
    }

    var thumbnailDetails: GTLRYouTube_ThumbnailDetails {
        return self.snippet!.thumbnails!
    }
}
