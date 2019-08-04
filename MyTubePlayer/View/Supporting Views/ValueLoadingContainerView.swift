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

protocol ValueLoader: Combine.ObservableObject {
    associatedtype Value

    var data: Value { get set }
    func load()
}

struct ValueLoadingContainerView<ValueConsumer: View, ValueContainer: ValueLoader>: View {
    @ObservedObject var valueLoader: ValueContainer
    let containedView: (ValueContainer.Value) -> ValueConsumer
    
    init(_ loader: ValueContainer,
         @ViewBuilder contained: @escaping (ValueContainer.Value) -> ValueConsumer) {
        self.valueLoader = loader
        self.containedView = contained
    }

    var body: some View {
        containedView(valueLoader.data)
            .onAppear(perform: load)
    }

    private func load() {
        self.valueLoader.load()
    }
}


