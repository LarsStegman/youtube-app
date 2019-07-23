//
//  Subscription.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 22/07/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import SwiftUI

struct SubscriptionsOverview: View {
    @EnvironmentObject var data: DataController

    var body: some View {
        let subview: AnyView
        if let userService = data.userInteractionService {
            subview = AnyView(SubscriptionListView(subscriptions: userService.subscriptions))
        } else {
            subview = AnyView(VStack {
                Text("😰")
                    .font(.largeTitle)
                Text("No signed in user")
            })
        }

        return NavigationView {
            subview
                .navigationBarTitle("Subscriptions")
        }
    }
}

struct SubscriptionCell: View {
    let subscription: Subscription

    private var placeholderImageName: String {
        if let startChar = subscription.title?.lowercased().first {
            return "\(startChar).square"
        } else {
            return "square"
        }
    }

    var body: some View {
        HStack {
            Image(systemName: self.placeholderImageName)
                .imageScale(.large)
            
            VStack(alignment: .leading) {
                Text(subscription.title ?? subscription.id)
                    .font(.body)
                Text(subscription.description ?? "No description")
                    .font(.footnote)
            }
            Spacer()
        }
    }
}

extension Optional: Comparable where Wrapped: Comparable {
    public static func < (lhs: Optional<Wrapped>, rhs: Optional<Wrapped>) -> Bool {
        switch (lhs, rhs) {
        case (.some(let ld), .some(let rd)): return ld < rd
        case _, _: return true
        }
    }
}



struct SubscriptionListView: View {
    @ObjectBinding var subscriptions: SubscriptionList

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

    @State private var showingAlert = false
    @State private var alert: Error? = nil
    private func delete(subscription at: IndexSet) {
        guard let i = at.first else {
            return
        }

        self.subscriptions.unsubscribe(from: self.orderedSubscriptions[i])
            .sink { (completion) in
                if case .failure(let err) = completion {
                    self.alert = err
                    self.showingAlert = true
                }
            }
    }

    var body: some View {
        List {
            Text("\(orderedSubscriptions.count) subscriptions")
            ForEach(orderedSubscriptions, id: \.id) {
                SubscriptionCell(subscription: $0)
            }
            .onDelete(perform: delete(subscription:))
        }
        .navigationBarItems(trailing: sortButton)
        .actionSheet(isPresented: self.$showSortingOptions) {
            ActionSheet(
                title: Text("Sort on"),
                message: nil,
                buttons: [
                    .default(Text("Title, descending"), onTrigger: { self.sort = .descending(on: \.title) }),
                    .default(Text("Title, ascending"), onTrigger: { self.sort = .ascending(on: \.title) }),
                    .default(Text("Subscription date"),  onTrigger: { self.sort = .descending(on: \.publicationDate) }),
            ])
        }
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
