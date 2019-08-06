//
//  Spinner.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 05/08/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

struct Spinner: UIViewRepresentable {
    @Binding var isAnimating: Bool

    let hidesWhenStopped: Bool = true
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<Spinner>) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: self.style)
        view.hidesWhenStopped = self.hidesWhenStopped
        return view
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Spinner>) {
        if self.isAnimating {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}

