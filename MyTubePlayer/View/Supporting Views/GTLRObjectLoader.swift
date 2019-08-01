//
//  GTLRObjectLoader.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 24/07/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import SwiftUI
import Combine
import GoogleAPIClientForREST

class GTLRObjectLoader<O: YouTubeObjectRefreshable>: ValueLoader, Combine.ObservableObject {
    typealias Value = O

    let objectWillChange = PassthroughSubject<Void, Never>()
    let service: GTLRService

    @Published var data: O

    init(_ data: O, service: GTLRService) {
        self.data = data
        self.service = service
    }

    private var loader: Cancellable? = nil
    func load() {
        self.loader?.cancel()
        self.loader = nil
        if !data.isLoaded, let q = data.refreshQuery {
            self.loader = self.service.publisher(for: q)
                .ignoreError()
                .sink(receiveCompletion: { _ in
                    self.loader = nil
                }, receiveValue: {
                    self.objectWillChange.send()
                    self.data.load(from: $0)
                })
            }
    }
}
