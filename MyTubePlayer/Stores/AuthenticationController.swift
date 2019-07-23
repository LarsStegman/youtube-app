//
//  Authenticator.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 16/11/2018.
//  Copyright © 2018 Stegman. All rights reserved.
//

import Foundation

import GTMSessionFetcher // needed for fetchAuthorizer?
import GoogleAPIClientForREST
import GoogleSignIn

class AuthenticationController: NSObject, GIDSignInDelegate {
    var user: GIDGoogleUser? {
        return GIDSignIn.sharedInstance().currentUser
    }

    var isSignedIn: Bool {
        return GIDSignIn.sharedInstance().hasAuthInKeychain()
    }

    var delegate: AuthenticationControllerDelegate?

    init(delegate: AuthenticationControllerDelegate? = nil) {
        super.init()
        self.delegate = delegate
        GIDSignIn.sharedInstance().clientID = SecretsStore.getKey(for: .clientID)
        GIDSignIn.sharedInstance().scopes = SecretsStore.getKey(for: .requiredScopes)
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signInSilently()
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if user != nil {
            self.delegate?.signInNewUser()
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        self.delegate?.signOutUser()
    }
}

protocol AuthenticationControllerDelegate {
    func signInNewUser()
    func signOutUser()
}
