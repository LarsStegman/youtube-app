//
//  Dictionary+init_key.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 24/10/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation

extension Dictionary {
    init<S: Sequence>(values: S, valueKey keyPath: KeyPath<S.Element, Key>) where Value == S.Element {
        self = Dictionary(uniqueKeysWithValues: values.map({ e in (e[keyPath: keyPath], e) }))
    }
}
