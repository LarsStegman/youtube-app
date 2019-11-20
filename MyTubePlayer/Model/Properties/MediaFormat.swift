//
//  VideoPlaybackData.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 11/11/2018.
//  Copyright © 2018 Stegman. All rights reserved.
//

import Foundation

protocol MediaFormat: Codable, CustomStringConvertible, Identifiable, Hashable {
    var id: Int { get }
    var container: String { get }
    var codec: String { get }

    var note: String? { get }
}

extension MediaFormat {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}


struct AudioFormat: MediaFormat {
    var description: String {
        return "\(id) Audio: \(container) - \(codec)"
    }

    let id: Int
    let container: String

    let codec: String
    let note: String?

    enum CodingKeys: String, CodingKey {
        case id
        case container = "ext"

        case codec = "acodec"
        case note = "format_note"
    }
}


struct VideoFormat: MediaFormat {
    var description: String {
        return "\(id) Video: \(container) - \(codec) - \(resolution)"
    }

    let id: Int
    let container: String
    let resolution: Resolution

    let codec: String
    let note: String?

    struct Resolution: Codable, CustomStringConvertible {
        let height: Int
        let width: Int?
        let fps: Int?

        var description: String {
            return "\(height)p\(fps != nil ? String(fps!) : "")"
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case container = "ext"

        case codec = "vcodec"
        case note = "format_note"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.container = try container.decode(String.self, forKey: .container)
        self.codec = try container.decode(String.self, forKey: .codec)
        self.note = try container.decodeIfPresent(String.self, forKey: .note)
        self.resolution = try Resolution(from: decoder)
    }
}


/// A data structure which stores stream urls for youtube videos
struct VideoPlaybackData {
    let videoId: String
    let streams: [VideoFormat: URL]
}

extension VideoPlaybackData: Codable {}


