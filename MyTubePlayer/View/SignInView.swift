//
//  SignInView.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 20/07/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation
import SwiftUI
import GoogleSignIn

struct SignInView: View {
    @EnvironmentObject var dataController: DataController

    var username: String? {
        dataController.authenticationController.user?.profile.givenName
    }

    var signInText: String {
        if let user = dataController.authenticationController.user?.profile.name {
            return "\(user) is signed in"
        } else {
            return "No one is signed in"
        }
    }

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(signInText)

            if !self.dataController.authenticationController.isSignedIn {
                SignInButton()
                    .style(.wide)
            }
            Spacer()
        }
    }
}

final class SignInButton: NSObject, UIViewControllerRepresentable, GIDSignInUIDelegate {
    private let vc = SignInVC()

    func makeUIViewController(context: Context) -> SignInVC {
        return self.vc
    }

    func updateUIViewController(_ uiViewController: SignInVC, context: Context) {
        uiViewController.button.colorScheme = context.environment.colorScheme.gidSignInButtonColorScheme
    }

    func style(_ style: GIDSignInButtonStyle) -> SignInButton {
        vc.button.style = style
        return self
    }
}

extension ColorScheme {
    var gidSignInButtonColorScheme: GIDSignInButtonColorScheme {
        switch self {
        case .light: return .light
        case .dark: fallthrough
        @unknown default: return .dark
        }
    }
}
