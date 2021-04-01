//
//  FeedImageDataLoaderDecoratorTests.swift
//  EssentialAppTests
//
//  Created by Erik Agujari on 1/4/21.
//

import XCTest
import Feed
import EssentialApp

final class FeedImageDataLoaderDecoratorTests: XCTestCase, FeedImageDataLoaderTestCase {
    func test_loadImageData_deliversImageDataOnLoaderSuccess() {
        let imageData = Data()
        let sut = makeSUT(loaderResult: .success(imageData))
        
        expect(sut: sut, toCompleteWith: .success(imageData))
    }
    
    func test_loadImageData_deliversErrorOnLoaderFailure() {
        let sut = makeSUT(loaderResult: .failure(anyNSError()))
        
        expect(sut: sut, toCompleteWith: .failure(anyNSError()))
    }
    
    func test_loadImageData_cachesLoadedImageDataOnLoaderSuccess() {
        let cache = CacheSpy()
        let imageData = Data()
        let sut = makeSUT(loaderResult: .success(imageData), cache: cache)
        
        _ = sut.loadImageData(from: anyURL(), completion: { _ in })
        
        XCTAssertEqual(cache.messages, [.save(imageData)], "Expected to cache loaded feed on success")
    }
    
    func test_loadImageData_doesNotCacheOnLoaderFailure() {
        let cache = CacheSpy()
        let sut = makeSUT(loaderResult: .failure(anyNSError()), cache: cache)
        
        _ = sut.loadImageData(from: anyURL(), completion: { _ in })
        
        XCTAssertEqual(cache.messages, [], "Expected not to cache feed on load error")
    }
}

private extension FeedImageDataLoaderDecoratorTests {
    func makeSUT(loaderResult: FeedImageDataLoader.Result, cache: CacheSpy = .init(), file: StaticString = #file, line: UInt = #line) -> FeedImageDataLoader {
        let loader = ImageDataLoaderStub(result: loaderResult)
        let sut = FeedImageDataLoaderDecorator(decoratee: loader, cache: cache)
        trackForMemoryLeaks(instance: loader)
        trackForMemoryLeaks(instance: sut)
        return sut
    }
    
    class CacheSpy: FeedImageDataCache {
        private(set) var messages = [Message]()
        
        enum Message: Equatable {
            case save(Data)
        }
        
        func save(_ data: Data, for url: URL, completion: @escaping (FeedImageDataCache.Result) -> Void) {
            messages.append(.save(data))
        }
    }
    
    func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
}
