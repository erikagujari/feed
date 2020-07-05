//
//  FeedCacheTestsHelpers.swift
//  FeedTests
//
//  Created by Erik Agujari on 23/06/2020.
//  Copyright © 2020 Erik Agujari. All rights reserved.
//
import Foundation
import Feed

func uniqueImage() -> FeedImage {
    return FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())
}

func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let feed = [uniqueImage(), uniqueImage()]
    let localItems = feed.map { LocalFeedImage(id: $0.id,
                                               description: $0.description,
                                               location: $0.location,
                                               url: $0.url)}
    return (feed, localItems)
}

extension Date {
    func minusFeedCacheMaxAge() -> Date {
        return adding(days: -7)
    }
    func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
