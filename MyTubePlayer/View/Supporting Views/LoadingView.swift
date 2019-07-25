//
//  LoadingView.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 24/07/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import SwiftUI
import Combine
import GoogleAPIClientForREST

protocol ValueLoader: BindableObject {
    associatedtype Value

    init(_ data: Value, service: GTLRService)

    var data: Value { get set }
    func load()
}

struct LoadingView<ValueConsumer: View, ValueContainer: ValueLoader>: View {
    @ObjectBinding var container: ValueContainer
    private(set) var containedView: (Binding<ValueContainer.Value>) -> ValueConsumer

    init(_ container: ValueContainer, @ViewBuilder containedView: @escaping (Binding<ValueContainer.Value>) -> ValueConsumer) {
        self.container = container
        self.containedView = containedView
    }

    var body: some View {
        return containedView(self.$container.data)
            .onAppear {
                self.container.load()
            }
    }
}
