//
//  CompactPlayablesList.swift
//  
//
//  Created by Lars Stegman on 19/11/2019.
//

import SwiftUI





struct CompactPlayablesList: View {

    var body: some View {
        List {
            ForEach(0..<5) { i in
                HStack {
                    Text("\(i)")
                }


                ForEach(0..<i) { j in
                    HStack {
                        Text("\(j)")
                    }
                    .padding(.leading, 32)
                }
            }
        }
    }
}


struct CompactPlayablesList_Previews: PreviewProvider {
    static var previews: some View {
        CompactPlayablesList()
    }
}

