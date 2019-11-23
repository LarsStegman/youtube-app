//
//  Flexible.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 23/11/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import SwiftUI

extension Axis.Set {
    static let all: Axis.Set = [.horizontal, .vertical]
}

struct Flexible: ViewModifier {
    let axis: Axis.Set

    func body(content: _ViewModifier_Content<Flexible>) -> some View {
        let width: (CGFloat, CGFloat)? = self.axis.contains(.horizontal) ? (0, .infinity) : nil
        let height: (CGFloat, CGFloat)? = self.axis.contains(.vertical) ? (0, .infinity) : nil

        return content.frame(minWidth: width?.0, maxWidth: width?.1,
                             minHeight: height?.0, maxHeight: height?.1)
    }
}

extension View {
    func flexible(axis: Axis.Set) -> some View {
        return self.modifier(Flexible(axis: axis))
    }
}
