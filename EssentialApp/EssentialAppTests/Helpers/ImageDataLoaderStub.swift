//
//  ImageDataLoaderStub.swift
//  EssentialAppTests
//
//  Created by Erik Agujari on 1/4/21.
//
import Feed
import Foundation

class ImageDataLoaderStub: FeedImageDataLoader {
    private let result: FeedImageDataLoader.Result
    
    init(result: FeedImageDataLoader.Result) {
        self.result = result
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        completion(result)
        return ImageDataLoaderTaskStub()
    }
}

class ImageDataLoaderTaskStub: FeedImageDataLoaderTask {
    func cancel() {
        
    }
}
