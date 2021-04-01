//
//  FeedImageDataLoaderDecorator.swift
//  EssentialApp
//
//  Created by Erik Agujari on 1/4/21.
//
import Foundation
import Feed

public final class FeedImageDataLoaderDecorator: FeedImageDataLoader {
    private let decoratee: FeedImageDataLoader
    private let cache: FeedImageDataCache
    
    public init(decoratee: FeedImageDataLoader, cache: FeedImageDataCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        return decoratee.loadImageData(from: url, completion: { [weak self] result in
            if let imageData = try? result.get() {
                self?.cache.save(imageData, for: url, completion: { _ in })
            }
            completion(result)
        })
    }
}
