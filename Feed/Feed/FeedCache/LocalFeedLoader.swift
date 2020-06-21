//
//  LocalFeedLoader.swift
//  Feed
//
//  Created by Erik Agujari on 21/06/2020.
//  Copyright © 2020 Erik Agujari. All rights reserved.
//
import Foundation

public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    
    public typealias SaveResult = Error?
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func save(_ items: [FeedItem], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedFeed { [weak self] error in
            guard let self = self else { return }
            
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                self.cache(items, with: completion)
            }
        }
    }
    
    private func cache(_ items: [FeedItem], with completion: @escaping (SaveResult) -> Void) {
        store.insert(items, timestamp: self.currentDate(), completion: { [weak self] error in
            guard self != nil else { return }
            
            completion(error)
        })
    }
}

