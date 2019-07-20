//
//  ProfileView.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 20/07/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var dataController: DataController

    var username: String? {
        self.dataController.authenticationController.user?.profile.givenName
    }

    var body: some View {
        NavigationView {
            List {
                if !self.dataController.authenticationController.isSignedIn {
                    SignInView()
                } else {
                    Text("Subscriptions")
                }
            }
            .navigationBarTitle(self.username ?? "Profile")
        }
    }
}

