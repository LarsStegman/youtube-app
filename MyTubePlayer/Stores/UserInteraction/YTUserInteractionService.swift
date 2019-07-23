//
//  YTUserDataStore.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 12/07/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import GoogleAPIClientForREST


/// A store for a user's YouTube data like their subscription feed, subscriptions, playlists, channel
class YTUserInteractionService {

    let gtlrService: GTLRYouTubeService
    let persistenceService: PersistenceService

    init(gtlrService: GTLRYouTubeService,
         persistenceService: PersistenceService) {
        self.gtlrService = gtlrService
        self.persistenceService = persistenceService

        self.subscriptions = SubscriptionList(service: gtlrService, immediatelyFetch: true)
    }

    var subscriptions: SubscriptionList
}

