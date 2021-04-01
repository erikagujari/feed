//
//  FeedImageDataCache.swift
//  Feed
//
//  Created by Erik Agujari on 1/4/21.
//  Copyright © 2021 Erik Agujari. All rights reserved.
//
import Foundation

public protocol FeedImageDataCache {
    typealias Result = Swift.Result<Void, Swift.Error>
        
    func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}
