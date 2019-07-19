//
//  YTService.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 15/11/2018.
//  Copyright © 2018 Stegman. All rights reserved.
//

import Foundation
import GTMSessionFetcher // needed for fetchAuthorizer?
import GoogleAPIClientForREST
import GoogleSignIn

extension GTLRYouTubeService {
    static var shared: GTLRYouTubeService = GTLRYouTubeService(userAuthorization: nil)

    convenience init(userAuthorization: GTMFetcherAuthorizationProtocol?) {
        self.init()

        let apiKey = SecretsStore.getKey(for: .youtubeDataAPIv3)
        self.apiKey = apiKey
        self.isRetryEnabled = true
        self.authorizer = userAuthorization
    }
}
