//
//  CoreDataFeedStore+FeedImageDataLoader.swift
//  Feed
//
//  Created by Erik Agujari on 27/2/21.
//  Copyright © 2021 Erik Agujari. All rights reserved.
//
import Foundation

extension CoreDataFeedStore: FeedImageDataStore {
    public func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {
        perform { context in
            completion(Result {
                let image = try? CoreDataFeedImage.first(with: url, in: context)
                
                image?.data = data
                try? context.save()
            })
        }
    }
    
    public func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
        perform { context in
            completion(Result {
                try CoreDataFeedImage.first(with: url, in: context)?.data
            })
        }
    }
}
