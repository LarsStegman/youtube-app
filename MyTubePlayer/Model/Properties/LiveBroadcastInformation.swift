//
//  LiveBroadcastInformation.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 01/12/2018.
//  Copyright © 2018 Stegman. All rights reserved.
//

import Foundation

struct LiveBroadcastInformation {
    let scheduledStartTime: Date
    let scheduledEndTime: Date?

    let actualStartTime: Date?
    let actualEndTime: Date?
}

extension LiveBroadcastInformation: Codable { }
