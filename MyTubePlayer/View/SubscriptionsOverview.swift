//
//  Subscription.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 22/07/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import SwiftUI
import Combine

struct SubscriptionsOverview: View {
    @EnvironmentObject var data: DataController

    var body: some View {
        NavigationView {
            Group {
                if data.userInteractionService != nil {
                    SubscriptionListView(subscriptions: data.userInteractionService!.subscriptions)
                } else {
                    VStack {
                        Text("😰")
                            .font(.largeTitle)
                        Text("No signed in user")
                    }
                }
            }
            .navigationBarTitle("Subscriptions")
        }
    }
}

struct SubscriptionCell: View {
    let subscription: Subscription

    private var placeholderImageName: String {
        if let startChar = subscription.title?.lowercased().split(separator: " ").first(where: {$0 != "the"})?.first {
            return "\(startChar).square"
        } else {
            return "square"
        }
    }

    var descriptionLabel: String? {
        return subscription.description == "" ? nil : subscription.description
    }

    var body: some View {
        HStack {
            Image(systemName: self.placeholderImageName)
                .imageScale(.large)
            
            VStack(alignment: .leading) {
                Text(subscription.title ?? subscription.id)
                    .font(.body)
                if descriptionLabel != nil {
                    Text(descriptionLabel!)
                        .font(.footnote)
                        .lineLimit(1)
                }
            }
        }
    }
}


struct SubscriptionListView: View {
    @ObservedObject var subscriptions: SubscriptionList
    @EnvironmentObject var dataController: DataController

    var orderedSubscriptions: [Subscription] {
        return self.subscriptions.subscriptions.sorted(by: self.sort)
    }

    @State private var sort = SortDescriptor.descending(on: \Subscription.publicationDate)
    @State private var showSortingOptions = false
    private var sortButton: some View {
        Button(action: {
            self.showSortingOptions.toggle()
        }) {
            Image(systemName: "arrow.up.arrow.down")
                .imageScale(.large)
        }
    }

    private var sortingSheet: ActionSheet {
        ActionSheet(
            title: Text("Sort on"),
            message: nil,
            buttons: [
                .default(Text("Title, descending"), action: { self.sort = .descending(on: \.title) }),
                .default(Text("Title, ascending"), action: { self.sort = .ascending(on: \.title) }),
                .default(Text("Subscription date"), action: { self.sort = .descending(on: \.publicationDate) }),
                .cancel()
        ])
    }

    @State private var showingAlert = false
    @State private var alert: Error? = nil
    @State private var deleting: Cancellable? = nil
    private func delete(subscription at: IndexSet) {
        guard let i = at.first else {
            return
        }

        self.deleting = self.subscriptions.unsubscribe(from: self.orderedSubscriptions[i])
            .sink { (completion) in
                if case .failure(let err) = completion {
                    self.alert = err
                    self.showingAlert = true
                }
                self.deleting = nil
            }
    }

    var body: some View {
        List {
            Text("\(orderedSubscriptions.count) subscriptions")
            ForEach(orderedSubscriptions, id: \.id) { sub in
                NavigationLink(
                    destination:
                    ValueLoadingContainerView(
                        loader: GTLRLoader(sub.baseChannel, service: self.dataController.gtlrService),
                        contained: { loadedChannel in
                            ChannelView(channel: loadedChannel)
                    })
                ) {
                    SubscriptionCell(subscription: sub)
                }
            }
            .onDelete(perform: delete(subscription:))
        }
        .navigationBarItems(trailing: sortButton)
        .actionSheet(isPresented: self.$showSortingOptions, content: { self.sortingSheet })
        .alert(isPresented: $showingAlert) {
            var message: Text? = nil
            if let text = self.alert?.localizedDescription {
                message = Text(text)
            }

            return Alert(title: Text("Error"),
                         message: message,
                         dismissButton: nil)
        }
    }
}
