//
//  XCTestCase+MemoryLeakTracking.swift
//  FeedTests
//
//  Created by Erik Agujari on 06/06/2020.
//  Copyright © 2020 Erik Agujari. All rights reserved.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should be deallocated, potentially memory leak", file: file, line: line)
        }
    }
}
