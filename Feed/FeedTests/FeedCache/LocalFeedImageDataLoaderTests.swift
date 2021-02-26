//
//  LocalFeedImageDataLoaderTests.swift
//  FeedTests
//
//  Created by Erik Agujari on 26/2/21.
//  Copyright © 2021 Erik Agujari. All rights reserved.
//

import XCTest
import Feed

final class LocalFeedImageDataLoader {
    init(store: Any) {
        
    }
}

final class LocalFeedImageDataLoaderTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_ ,store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
        
    //MARK: - Helpers
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedImageDataLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedImageDataLoader(store: store)
        trackForMemoryLeaks(instance: store)
        trackForMemoryLeaks(instance: sut)
        return (sut, store)
    }
}
