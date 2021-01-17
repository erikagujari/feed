//
//  XCTestCase+FailableRetrieveFeedStoreSpecs.swift
//  FeedTests
//
//  Created by Erik Agujari on 17/01/2021.
//  Copyright © 2021 Erik Agujari. All rights reserved.
//
import XCTest
import Feed

extension FailableRetrieveFeedStoreSpecs where Self: XCTestCase {
    func assertThatRetrieveDeliversFailureOnRetrievalError(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: .failure(anyNSError()))
    }
    
    func assertThatRetrieveHasNoSideEffectsOnFailure(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieveTwice: .failure(anyNSError()))
    }
}
