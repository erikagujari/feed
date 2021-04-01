//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by Erik Agujari on 1/4/21.
//
import Feed

class FeedLoaderStub: FeedLoader {
    private let result: FeedLoader.Result
    
    init(result: FeedLoader.Result) {
        self.result = result
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> ()) {
        completion(result)
    }
}
