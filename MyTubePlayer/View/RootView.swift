//
//  RootView.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 22/07/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import SwiftUI
import AVKit


struct RootView: View {
    @EnvironmentObject var userData: DataController

    @State var selected = -1
    var body: some View {
        HStack(spacing: 0) {
            TabView(selection: self.$selected) {
                Group {
                    Text("Your subscription feed")
                        .tabItem {
                            VStack {
                                Image(systemName: selected == 0 ? "rectangle.stack.fill" : "rectangle.stack").imageScale(.large)
                                Text("Feed")
                            }
                        }
                        .tag(0)

                    SubscriptionsOverview()
                        .tabItem {
                            VStack {
                                Image(systemName: selected == 1 ? "eye.fill" : "eye").imageScale(.large)
                                Text("Subscriptions")
                            }
                        }
                        .tag(1)

                    ProfileView()
                        .tabItem {
                            VStack {
                                Image(systemName: selected == 2 ? "person.fill" : "person").imageScale(.large)
                                Text(userData.authenticationController.user?.profile.givenName ?? "Profile")
                            }
                        }
                        .tag(2)
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
                .frame(maxWidth: 350)
                .background(Color(UIColor.systemBackground))

            Divider()

            VideoDisplayView()
                .navigationViewStyle(StackNavigationViewStyle())
                .background(Color(UIColor.systemBackground))
        }
        .edgesIgnoringSafeArea(.top)
    }
}
