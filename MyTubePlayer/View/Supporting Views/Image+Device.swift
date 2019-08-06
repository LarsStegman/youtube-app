//
//  Image+Device.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 04/08/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation
import SwiftUI

extension ImageEnvironment {
    static func environment(for idiom: UIUserInterfaceIdiom) -> ImageEnvironment {
        switch idiom {
        case .phone: return .mobile
        case .pad: return .tablet
        case .tv: return .tv
        default: return .website
        }
    }
}

extension ChannelBanner {
    func image(for device: UIUserInterfaceIdiom, resolution: Resolution) -> URL? {
        let correspondingEnv = ImageEnvironment.environment(for: device)
        for res in Resolution.allCases {
            if let imgUrl = self.images[ImageKey(correspondingEnv, res)] {
                if res >= resolution {
                    return imgUrl
                }
            }
        }

        return nil
    }
}
