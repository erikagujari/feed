//
//  FeedImageDataLoaderWithFallbackCompositeTests.swift
//  EssentialAppTests
//
//  Created by Erik Agujari on 31/3/21.
//

import XCTest
import Feed
import EssentialApp

final class FeedImageDataLoaderWithFallbackCompositeTests: XCTestCase, FeedImageDataLoaderTestCase {
    func test_loadImageData_deliversPrimaryImageDataOnPrimaryLoaderSuccess() {
        let primaryData = Data()
        let fallbackData = Data()
        let sut = makeSUT(primaryResult: .success(primaryData), fallbackResult: .success(fallbackData))
        
        expect(sut: sut, toCompleteWith: .success(primaryData))
    }
    
    func test_loadImageData_deliversFallbackImageDataOnPrimaryLoaderFailure() {
        let fallbackData = Data()
        let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .success(fallbackData))
        
        expect(sut: sut, toCompleteWith: .success(fallbackData))
    }
    
    func test_loadImageData_deliversErrorOnBothPrimaryAndFallbackLoaderFailure() {
        let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .failure(anyNSError()))
        
        expect(sut: sut, toCompleteWith: .failure(anyNSError()))
    }
}

private extension FeedImageDataLoaderWithFallbackCompositeTests {
    func makeSUT(primaryResult: FeedImageDataLoader.Result, fallbackResult: FeedImageDataLoader.Result, file: StaticString = #filePath, line: UInt = #line) -> FeedImageDataLoader {
        let primaryFeedImageDataLoader = ImageDataLoaderStub(result: primaryResult)
        let fallbackFeedImageDataLoader = ImageDataLoaderStub(result: fallbackResult)
        let sut = FeedImageDataLoaderWithFallbackComposite(primary: primaryFeedImageDataLoader, fallback: fallbackFeedImageDataLoader)
        trackForMemoryLeaks(instance: primaryFeedImageDataLoader)
        trackForMemoryLeaks(instance: fallbackFeedImageDataLoader)
        trackForMemoryLeaks(instance: sut)
        
        return sut
    }
}
