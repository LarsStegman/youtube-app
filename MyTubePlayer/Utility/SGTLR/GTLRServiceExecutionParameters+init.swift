//
//  GTLRServiceExecutionParameters+init.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 14/07/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

extension GTLRServiceExecutionParameters {
    convenience init(shouldFetchNextPages: Bool = false) {
        self.init()
        self.shouldFetchNextPages = NSNumber(booleanLiteral: shouldFetchNextPages)
    }
}
