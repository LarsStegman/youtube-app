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

class GTLRObjectLoader<O: YouTubeObjectRefreshable>: ValueLoader, BindableObject {
    typealias Value = O

    let willChange = PassthroughSubject<Void, Never>()
    let service: GTLRService

    var data: O {
        willSet {
            willChange.send()
        }
    }

    required init(_ data: O, service: GTLRService) {
        self.data = data
        self.service = service
    }

    private var loader: Cancellable? = nil
    func load() {
        if !data.isLoaded, let q = data.refreshQuery {
            self.loader = self.service.publisher(for: q)
                .ignoreError()
                .sink {
                    self.willChange.send()
                    self.data.load(from: $0)
                    self.loader = nil
                }
        }
    }
}
