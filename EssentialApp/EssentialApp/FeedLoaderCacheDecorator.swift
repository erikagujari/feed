//
//  FeedLoaderCacheDecorator.swift
//  EssentialApp
//
//  Created by Erik Agujari on 1/4/21.
//
import Feed

public class FeedLoaderCacheDecorator: FeedLoader {
    private let decoratee: FeedLoader
    private let cache: FeedCache
    
    public init(decoratee: FeedLoader, cache: FeedCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    public func load(completion: @escaping (FeedLoader.Result) -> ()) {
        decoratee.load { [weak self] result in
            completion(result.map { feed in
                self?.cache.save(feed, completion: { _ in })
                return feed
            })
        }
    }
}
