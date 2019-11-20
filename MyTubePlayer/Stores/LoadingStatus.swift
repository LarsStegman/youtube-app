//
//  LoadingStatus.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 05/08/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation
import Combine

enum LoadingError: Error, Equatable {
    case decodingFailed
    case loadingFailed
}


enum LoadingStatus: Equatable {
    case uninit
    case loading
    case cancelled
    case pageFinished
    case finished
    case failure(LoadingError)
}

extension Subscribers.Completion where Failure == LoadingError {
    var loadingStatus: LoadingStatus {
        switch self {
        case .finished: return .finished
        case .failure(let err): return .failure(err)
        }
    }
}
