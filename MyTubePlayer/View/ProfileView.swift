//
//  ProfileView.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 20/07/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import SwiftUI
import GoogleSignIn

struct ProfileView: View {
    @EnvironmentObject var dataController: DataController

    var username: String? {
        self.dataController.authenticationController.user?.profile.givenName
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if !self.dataController.authenticationController.isSignedIn {
                    SignInView()
                }
            }
            .navigationBarItems(trailing: HStack {
                if self.dataController.authenticationController.isSignedIn {
                    Button(action: {
                        GIDSignIn.sharedInstance().signOut()
                    }) {
                        Text("Sign out")
                    }
                }
            })
            .padding(8)
            .navigationBarTitle(self.username ?? "Profile")
        }
    }
}

