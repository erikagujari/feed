//
//  XCTestCase+Helpers.swift
//  EssentialAppTests
//
//  Created by Erik Agujari on 31/3/21.
//

import Feed
import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0, userInfo: nil)
}

func uniqueFeed() -> [FeedImage] {
    return [FeedImage(id: UUID(), description: "any", location: "any", url: URL(string: "http://any-url.com")!)]
}
