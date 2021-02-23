//
//  FeedPresenterTests.swift
//  FeedTests
//
//  Created by Erik Agujari on 23/2/21.
//  Copyright © 2021 Erik Agujari. All rights reserved.
//

import XCTest

final class FeedPresenter {
    init(view: Any) {
        
    }
}

class FeedPresenterTests: XCTestCase {
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
        let sut = ViewSpy()
        let presenter = FeedPresenter(view: sut)
        trackForMemoryLeaks(instance: sut)
        trackForMemoryLeaks(instance: presenter)
        return (sut, presenter)
    }
    
    private class ViewSpy {
        let messages = [Any]()
    }
}
