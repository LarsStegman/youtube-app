//
//  GTLRObject+Iterator.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 21/11/2018.
//  Copyright © 2018 Stegman. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

extension GTLRCollectionObject: Sequence {
    public func makeIterator() -> NSFastEnumerationIterator {
        return NSFastEnumerationIterator(self)
    }
}
