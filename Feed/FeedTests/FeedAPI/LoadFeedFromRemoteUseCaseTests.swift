//
//  LoadFeedFromRemoteUseCaseTests.swift
//  FeedTests
//
//  Created by Erik Agujari on 29/05/2020.
//  Copyright © 2020 Erik Agujari. All rights reserved.
//

import XCTest
@testable import Feed

class LoadFeedFromRemoteUseCaseTests: XCTestCase {
    func test_init() {
        let client = HTTPClientSpy()
        let (_, _) = makeSUT()
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "httos://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "httos://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        XCTAssertEqual(client.requestedURLs.count, 2)
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        expect(sut,
               toCompleteWith: failure(.connectivity),
               when: {
                let clientError = NSError(domain: "Test",
                                          code: 0,
                                          userInfo: nil)
                client.complete(with: clientError)
        })
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        let samples = [199, 201, 300, 400, 500]
        samples.enumerated().forEach { code in
            expect(sut,
                   toCompleteWith: failure(.invalidData),
                   when: {
                    client.complete(withStatusCode: code.element,
                                    data: makeItemsJson([]),
                                    at: code.offset)
            })
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponse() {
        let (sut, client) = makeSUT()
        expect(sut,
               toCompleteWith: failure(.invalidData),
               when: {
                let invalidJSON = Data()
                client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        expect(sut,
               toCompleteWith: .success([]),
               when: {
                    let emptyJSONList = makeItemsJson([])
                    client.complete(withStatusCode: 200, data: emptyJSONList)
        })
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        let item1 = makeItem(id: UUID(),
                             description: nil,
                             location: nil,
                             imageUrl: URL(string: "https://a-image.url")!)
        
        let item2 = makeItem(id: UUID(),
                             description: "a description",
                             location: "a location",
                             imageUrl: URL(string: "https://another-image.url")!)
        expect(sut,
               toCompleteWith: .success([item1.model, item2.model]),
               when: {
                let itemsJSON = [item1.json, item2.json]
                client.complete(withStatusCode: 200, data: makeItemsJson(itemsJSON))
        })
    }
    
    func test_load_doesNotDeliverResultAfterSUTHasBeenDeallocated() {
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteFeedLoader? = RemoteFeedLoader(client: client, url: url)
        var capturedResults = [RemoteFeedLoader.Result]()
        
        sut?.load { capturedResults.append($0) }
        sut = nil
        
        client.complete(withStatusCode: 200, data: makeItemsJson([]))
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    //MARK:  Helpers
    private func makeSUT(url: URL = URL(string: "httos://a-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client, url: url)
        trackForMemoryLeaks(instance: client, file: file, line: line)
        trackForMemoryLeaks(instance: sut, file: file, line: line)
        return (sut, client)
    }
    
    private func makeItem(id: UUID, description: String? = nil, location: String? = nil, imageUrl: URL) -> (model: FeedImage, json: [String: Any]) {
        let item = FeedImage(id: id,
                            description: description,
                            location: location,
                            url: imageUrl)
        
        let json = ["id": item.id.uuidString,
                    "description": item.description,
                    "location": item.location,
                    "image": item.url.absoluteString]
            .compactMapValues { $0 }
        
        return (item, json)
    }
    
    private func makeItemsJson(_ items: [[String: Any]]) -> Data {
        let itemsJSON = ["items": items]
        return try! JSONSerialization.data(withJSONObject: itemsJSON)
    }
    
    private func failure(_ error: RemoteFeedLoader.Error) -> RemoteFeedLoader.Result {
        return .failure(error)
    }
    
    private func expect(_ sut: RemoteFeedLoader, toCompleteWith expectedResult: RemoteFeedLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError), .failure(expectedError)):
                XCTAssertEqual(receivedError as! RemoteFeedLoader.Error, expectedError as! RemoteFeedLoader.Error, file: file, line: line)
            default:
                XCTFail("Expected result: \(expectedResult) got receivedResult: \(receivedResult)", file: file, line: line)
            }
        }
        
        action()
        
        exp.fulfill()
        wait(for: [exp], timeout: 1.0)
    }
}
