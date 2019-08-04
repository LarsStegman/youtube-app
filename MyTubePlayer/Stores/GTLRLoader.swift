//
//  StructLoader.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 04/08/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import GoogleAPIClientForREST


class GTLRLoader<O: YTStructRefreshable>: ValueLoader, ObservableObject {
    typealias Value = O
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
                }, receiveValue: { loadedValue in
                    if let d = O.init(from: loadedValue) {
                        self.data = d
                    }
                })
            }
    }
}
