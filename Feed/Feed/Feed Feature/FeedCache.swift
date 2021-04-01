//
//  FeedCache.swift
//  Feed
//
//  Created by Erik Agujari on 1/4/21.
//  Copyright © 2021 Erik Agujari. All rights reserved.
//

public protocol FeedCache {
    typealias SaveResult = Result<Void, Error>
    
    func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void)
}
