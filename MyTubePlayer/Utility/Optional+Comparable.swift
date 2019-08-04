//
//  Optional+Comparable.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 03/08/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation

extension Optional: Comparable where Wrapped: Comparable {
    public static func < (lhs: Optional<Wrapped>, rhs: Optional<Wrapped>) -> Bool {
        switch (lhs, rhs) {
        case (.some(let ld), .some(let rd)): return ld < rd
        case _, _: return true
        }
    }
}
