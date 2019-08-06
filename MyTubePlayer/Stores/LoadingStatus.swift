//
//  LoadingStatus.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 05/08/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation

enum LoadingError: Error, Equatable {
    case decodingFailed
    case loadingFailed
}


enum LoadingStatus: Equatable {
    case uninit
    case loading
    case cancelled
    case finished
    case failure(LoadingError)
}
