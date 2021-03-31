//
//  XCTestCase+Helpers.swift
//  EssentialAppTests
//
//  Created by Erik Agujari on 31/3/21.
//

import XCTest

extension XCTestCase {
    func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0, userInfo: nil)
    }
}
