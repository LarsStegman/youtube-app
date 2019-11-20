//
//  SortDescriptor.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 04/12/2018.
//  Copyright © 2018 Stegman. All rights reserved.
//

import Foundation

enum SortDescriptor<T> {
    indirect case multiple([SortDescriptor<T>])
    case singular((T, T) -> ComparisonResult, Bool)

    func compare(_ lhs: T,_ rhs: T) -> ComparisonResult {
        switch self {
        case let .multiple(descriptors):
            for d in descriptors {
                switch d.compare(lhs, rhs) {
                case .orderedSame: continue
                case let r: return r
                }
            }

            return .orderedSame
        case let .singular(c, shouldOrderAscending):
            let r = c(lhs, rhs)
            return shouldOrderAscending ? r : r.inverted()
        }
    }

    func inverted() -> SortDescriptor<T> {
        switch self {
        case let .multiple(r): return .multiple(r.reversed())
        case let .singular(r, orderAscending): return .singular(r, !orderAscending)
        }
    }

    mutating func invert() {
        self = self.inverted()
    }
}

extension SortDescriptor {
    static func ascending<K: Comparable>(on keyPath: KeyPath<T, K>) -> SortDescriptor<T> {
        return .singular({ (lhs, rhs) in
            return lhs[keyPath: keyPath].compare(to: rhs[keyPath: keyPath])
        }, true)
    }

    static func descending<K: Comparable>(on keyPath: KeyPath<T, K>) -> SortDescriptor<T> {
        return SortDescriptor<T>.ascending(on: keyPath).inverted()
    }
}

extension SortDescriptor {
    func orderedAscending(_ lhs: T, _ rhs: T) -> Bool {
        return compare(lhs, rhs) == .orderedAscending
    }
}

extension Comparable {
    func compare(to: Self) -> ComparisonResult {
        if self < to {
            return .orderedAscending
        } else if self == to {
            return .orderedSame
        } else {
            return .orderedDescending
        }
    }
}

extension ComparisonResult {
    func inverted() -> ComparisonResult {
        switch self {
        case .orderedAscending: return .orderedDescending
        case .orderedDescending: return .orderedAscending
        default: return self
        }
    }
}

extension Sequence {
    func sorted(by descriptor: SortDescriptor<Self.Element>) -> [Self.Element] {
        return self.sorted(by: descriptor.orderedAscending)
    }
}
