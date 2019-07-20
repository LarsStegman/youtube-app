//
//  ContentView.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 19/07/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        SignInView()
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
