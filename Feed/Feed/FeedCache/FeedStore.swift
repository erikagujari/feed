//
//  FeedStore.swift
//  Feed
//
//  Created by Erik Agujari on 21/06/2020.
//  Copyright © 2020 Erik Agujari. All rights reserved.
//
import Foundation

public enum RetrieveCacheFeedResult {
    case empty
    case found((feed: [LocalFeedImage], timestamp: Date))
    case failure(Error)
}

public protocol FeedStore {
    typealias DeletionCompletion = ((Error?) -> Void)
    typealias InsertionCompletion = ((Error?) -> Void)
    typealias RetrievalCompletion = ((RetrieveCacheFeedResult) -> Void)
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
}
