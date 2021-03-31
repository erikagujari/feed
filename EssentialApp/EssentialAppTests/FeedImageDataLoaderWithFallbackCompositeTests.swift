//
//  FeedImageDataLoaderWithFallbackCompositeTests.swift
//  EssentialAppTests
//
//  Created by Erik Agujari on 31/3/21.
//

import XCTest
import Feed
import EssentialApp

final class FeedImageDataLoaderWithFallbackCompositeTests: XCTestCase {
    func test_loadImageData_deliversPrimaryFeedOnPrimaryLoaderSuccess() {
        let primaryData = Data()
        let fallbackData = Data()
        let sut = makeSUT(primaryResult: .success(primaryData), fallbackResult: .success(fallbackData))
        
        expect(sut: sut, toCompleteWith: .success(primaryData))
    }
    
    func test_load_deliversFallbackFeedOnPrimaryLoaderFailure() {
        let fallbackData = Data()
        let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .success(fallbackData))
        
        expect(sut: sut, toCompleteWith: .success(fallbackData))
    }
    
    func test_load_deliversErrorOnBothPrimaryAndFallbackLoaderFailure() {
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
    
    func expect(sut: FeedImageDataLoader, toCompleteWith expectedResult: FeedImageDataLoader.Result, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for image load completion")
        _ = sut.loadImageData(from: URL(string: "http://any-url.com")!) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedData), .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData, file: file, line: line)
            case (.failure, .failure): break
            default:
                XCTFail("Expected \(expectedResult) load image result, got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
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
}
