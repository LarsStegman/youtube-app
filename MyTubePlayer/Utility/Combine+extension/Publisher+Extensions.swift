//
//  Publisher+firstElement.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 12/07/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation
import Combine

extension Publisher where Output: Collection {
    func firstElement() -> Publishers.Map<Self, Output.Element?> {
        return self.map { $0.first }
    }
}

extension Publisher {
    func ignoreError() -> Publishers.Catch<Self, Empty<Self.Output, Never>> {
        return self.catch { _ in
            Empty(completeImmediately: true)
        }
    }
}

extension Publisher where Output == Never {
    func sink(receiveCompletion: @escaping (Subscribers.Completion<Self.Failure>) -> Void) -> AnyCancellable {
        self.sink(receiveCompletion: receiveCompletion, receiveValue: {_ in })
    }
}
