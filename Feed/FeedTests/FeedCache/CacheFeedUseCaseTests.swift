//
//  CacheFeedUseCaseTests.swift
//  FeedTests
//
//  Created by Erik Agujari on 20/06/2020.
//  Copyright © 2020 Erik Agujari. All rights reserved.
//

import XCTest

class LocalFeedStore {
    init(store: FeedStore) {
        
    }
}

class FeedStore {
    var deleteCachedFeedCallCount = 0
}

class CacheFeedUseCaseTests: XCTestCase {
    func test_init_doesNotDeleteCacheUponCreation() {
        let store = FeedStore()
        _ = LocalFeedStore(store: store)
        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }
}
