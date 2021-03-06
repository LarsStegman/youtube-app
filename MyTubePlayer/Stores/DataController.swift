//
//  CurrentUserController.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 21/11/2018.
//  Copyright © 2018 Stegman. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST
import GoogleSignIn
import GTMSessionFetcher

import Combine


class DataController: AuthenticationControllerDelegate, ObservableObject {
    private(set) var authenticationController: AuthenticationController
    @Published private(set) var userInteractionService: YTUserInteractionService? = nil

    init() {
        self.authenticationController = AuthenticationController()
        self.authenticationController.delegate = self
        self.authenticationController.setupSignIn()
    }

    var gtlrService: GTLRYouTubeService {
        return self.userInteractionService?.gtlrService ?? GTLRYouTubeService.shared
    }

    private func setup(user: GIDGoogleUser) {
        let userAuthorizer = user.authentication.fetcherAuthorizer()
        let userGtlrService = GTLRYouTubeService(userAuthorization: userAuthorizer)
        let persistence = PersistenceService(userId: user.userID)
        self.userInteractionService = YTUserInteractionService(gtlrService: userGtlrService,
                                                               persistenceService: persistence)
    }

    func signInNewUser() {
        guard let user = authenticationController.user else {
            self.signOutUser()
            return
        }

        self.setup(user: user)
    }

    func signOutUser() {
        self.userInteractionService = nil
    }
}
