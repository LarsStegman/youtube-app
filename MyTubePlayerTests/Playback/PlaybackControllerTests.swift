//
//  PlaybackControllerTests.swift
//  MyTubePlayerTests
//
//  Created by Lars Stegman on 17/11/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation
import XCTest
import AVFoundation
@testable import MyTubePlayer

private struct TestPlayerItem: PlayableItem, Equatable {
    let uuid = UUID()

    func asPlayerItem() -> AVPlayerItem {
        let path = Bundle.init(for: PlaybackControllerTests.self)
            .path(forResource: "1080p_sample_vid", ofType: "mkv")!
        return AVPlayerItem(asset: AVAsset(url: URL.init(fileURLWithPath: path)))
    }
}

class PlaybackControllerTests: XCTestCase {

    func testEmptyInitNoCurrentItem() {
        let playbackController = PlaybackQueueController<TestPlayerItem>()
        XCTAssertNil(playbackController.currentItem)
    }

    func testNonEmptyInitNoCurrentItem() {
        let playbackController = PlaybackQueueController(items: [TestPlayerItem()])
        XCTAssertNil(playbackController.currentItem)
    }

    func testNonEmptyInitCurrentItemAfterPlay() {
        let playbackController = PlaybackQueueController(items: [TestPlayerItem()])
        playbackController.start()
        XCTAssertNotNil(playbackController.currentItem)
    }

    func testPlayFromEmptyInit() {
        let playbackController = PlaybackQueueController<TestPlayerItem>(items: [])
        XCTAssertNil(playbackController.currentItem)
        playbackController.start()
        XCTAssertNil(playbackController.currentItem)
    }

    func testInitMultipleItems() {
        let playbackController = PlaybackQueueController<TestPlayerItem>(items: [TestPlayerItem(), TestPlayerItem()])
        XCTAssertEqual(playbackController.queue.count, 2)
    }

    func testSkipPlayingItem() {
        let item1 = TestPlayerItem()
        let item2 = TestPlayerItem()
        let playbackController = PlaybackQueueController(items: [item1, item2])
        playbackController.start()

        XCTAssertNotEqual(playbackController.currentItem, item2)
        playbackController.skipForwards()
        XCTAssertEqual(playbackController.currentItem, item2)
    }

    func testSkipLastPlayingItem() {
        let item1 = TestPlayerItem()
        let playbackController = PlaybackQueueController(items: [item1])
        playbackController.start()

        XCTAssertEqual(playbackController.currentItem, item1)
        playbackController.skipForwards()
        XCTAssertEqual(playbackController.currentItem, item1)
    }

    func testPreviousFirstPlayingItem() {
        let item1 = TestPlayerItem()
        let playbackController = PlaybackQueueController(items: [item1])
        playbackController.start()

        XCTAssertEqual(playbackController.currentItem, item1)
        playbackController.skipBackwards()
        XCTAssertEqual(playbackController.currentItem, item1)
    }

    func testInsertingCausesUpdate() {
        let item1 = TestPlayerItem()
        let item2 = TestPlayerItem()
        let playbackController = PlaybackQueueController(items: [item1])

        let expectation = XCTestExpectation(description: "Object will change when a new item is added")
        let willChangeObserver = playbackController.objectWillChange.sink {
            expectation.fulfill()
        }

        playbackController.enqueue(item: item2)
        XCTAssertNotNil(willChangeObserver)
        wait(for: [expectation], timeout: 5.0)
    }
}

