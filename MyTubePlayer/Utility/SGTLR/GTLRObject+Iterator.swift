//
//  GTLRObject+Iterator.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 21/11/2018.
//  Copyright © 2018 Stegman. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST
import Combine


extension SGTLRCollectionQueryResponse where Self: GTLRCollectionObject {
    public func makeIterator() -> GTLRCollectionObjectIterator<Self.Element> {
        return GTLRCollectionObjectIterator<Self.Element>(self)
    }
}


extension GTLRCollectionObject {
    var count: Int {
        return (self.json?["items"] as? NSArray)?.count ?? 0
    }
}


extension Combine.Publisher where Output: SGTLRCollectionQueryResponse {
    func gtlrCollectionSequence() -> Publishers.Map<Self, Array<Output.Element>> {
        return self.map { Array($0) }
    }
}


public struct GTLRCollectionObjectIterator<E>: IteratorProtocol {
    private var index: UInt = 0
    public let object: GTLRCollectionObject

    public init(_ object: GTLRCollectionObject) {
        self.object = object
    }

    public mutating func next() -> E? {
        // FIXME: I don't want to go into the json to find the length
        guard self.object.count > self.index else {
            return nil
        }

        let result = self.object[index] as? E
        index += 1
        return result
    }
}


