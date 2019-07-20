//
//  PersistentService.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 19/07/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//
import Foundation

class PersistenceService {
    let userId: String

    init(userId: String) {
        self.userId = userId
    }

    enum PersistenceError: Error {
        case cacheInaccessible
    }

    private func baseUrl() throws -> URL {
        guard let storeFile = FileManager.default.urls(for: .libraryDirectory, in: .allDomainsMask).first else {
            throw PersistenceError.cacheInaccessible
        }

        return storeFile
    }

    func store(data: Data, inFile filename: String) throws {
        let fileUrl = try self.baseUrl().appendingPathComponent(filename)
        try data.write(to: fileUrl)
    }

    func load(filename: String) throws -> Data {
        let fileUrl = try self.baseUrl().appendingPathComponent(filename)
        return try Data(contentsOf: fileUrl)
    }
}
