//
//  XCTestCase+TrackForMemoryLeaks.swift
//  EssentialAppTests
//
//  Created by Erik Agujari on 31/3/21.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should be deallocated, potentially memory leak", file: file, line: line)
        }
    }
}
