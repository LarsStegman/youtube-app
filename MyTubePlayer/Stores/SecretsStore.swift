//
//  KeyStore.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 17/11/2018.
//  Copyright © 2018 Stegman. All rights reserved.
//

import Foundation

struct SecretsStore {
    enum SingleValueKey: String {
        case youtubeDataAPIv3 = "yt_data_api_v3"
        case clientID = "client_id"
    }

    enum MultiValueKey: String {
        case requiredScopes = "required_scopes"
    }

    private static func getValue<T: Decodable>(for key: String) -> T? {
        guard let keysData = Bundle.main.url(forResource: "api_keys", withExtension: "plist"),
            let keys = NSDictionary(contentsOf: keysData) else {
                fatalError("Keys file not found")
        }

        return keys[key] as? T
    }

    static func getKey(for key: SingleValueKey) -> String {
        return getValue(for: key.rawValue)!
    }

    static func getKey(for key: MultiValueKey) -> [String] {
        return getValue(for: key.rawValue)!
    }
}
