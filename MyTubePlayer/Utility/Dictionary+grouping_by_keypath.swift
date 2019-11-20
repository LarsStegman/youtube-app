//
//  Dictionary+grouping_by_keypath.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 24/10/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation

extension Dictionary {
    init<S: Sequence, U: Hashable>(grouping: S, byKeypath keyPath: KeyPath<S.Element, U>) {
        self = Dictionary(grouping: grouping, by: { (e: S.Element) -> U in
            e[keyPath: keyPath]
        })
    }
}
