//
//  RootView.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 22/07/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var userData: DataController

    @State var selected = 1
    var body: some View {
        TabbedView(selection: self.$selected) {
            Text("Your subscription feed")
                .tabItem {
                    VStack {
                        Image(systemName: "rectangle.stack").imageScale(.large)
                        Text("Feed")
                    }
                }
                .tag(0)

            SubscriptionsOverview()
                .tabItem {
                    VStack {
                        Image(systemName: "eye").imageScale(.large)
                        Text("Subscriptions")
                    }
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    VStack {
                        Image(systemName: "person").imageScale(.large)
                        Text(userData.authenticationController.user?.profile.givenName ?? "Profile")
                    }
                }
                .tag(2)
        }
    }
}
