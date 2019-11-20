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

protocol ValueLoader: Combine.ObservableObject, Cancellable {
    associatedtype Value

    var data: Value { get }

    func load()
}

struct ValueLoadingContainerView<ValueConsumer: View, ValueContainer: ValueLoader>: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var valueLoader: ValueContainer
    let containedView: (ValueContainer.Value) -> ValueConsumer
    
    init(loader: ValueContainer,
         @ViewBuilder contained: @escaping (ValueContainer.Value) -> ValueConsumer) {
        self.valueLoader = loader
        self.containedView = contained
    }

    var body: some View {
        containedView(valueLoader.data)
            .onAppear(perform: valueLoader.load)
            .onDisappear(perform: valueLoader.cancel)
    }
}

protocol PageLoader: ValueLoader, PageLoadingController where Value == [Element] {
    associatedtype Element
    associatedtype Controller: PageLoadingController

    var controller: Controller { get }
}

protocol PageLoadingController: ObservableObject {
    func loadNextPage()
    func reload()

    var allLoaded: Bool { get }

    var isLoading: Binding<Bool> { get }
    var status: LoadingStatus { get }
}

struct PageLoadingContainerView<ValueConsumer: View, PageContainer: PageLoader>: View {
    /// A view that can display the page data.
    /// - Parameters:
    ///     - data: the data to display
    ///     - nextPage: A closure that allows the view to load the next page
    typealias PageViewBuilder = (_ data: [PageContainer.Element], _ controller: PageContainer.Controller) -> ValueConsumer

    @EnvironmentObject var dataController: DataController
    @ObservedObject var pageLoader: PageContainer
    let containedView: PageViewBuilder

    init(loader: PageContainer, @ViewBuilder contained: @escaping PageViewBuilder) {
        self.pageLoader = loader
        self.containedView = contained
    }

    var body: some View {
        containedView(self.pageLoader.data, self.pageLoader.controller)
            .onAppear(perform: pageLoader.load)
            .onDisappear(perform: pageLoader.cancel)
    }
}
