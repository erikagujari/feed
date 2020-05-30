//
//  RemoteFeedLoaderTests.swift
//  FeedTests
//
//  Created by Erik Agujari on 29/05/2020.
//  Copyright © 2020 Erik Agujari. All rights reserved.
//

import XCTest
@testable import Feed

class RemoteFeedLoaderTests: XCTestCase {
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
               toCompleteWith: .failure(.connectivity),
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
                   toCompleteWith: .failure(.invalidData),
                   when: {
                    client.complete(withStatusCode: code.element, at: code.offset)
            })
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponse() {
        let (sut, client) = makeSUT()
        expect(sut,
               toCompleteWith: .failure(.invalidData),
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
                    let emptyJSONList = Data("{\"items\": [] }".utf8)
                    client.complete(withStatusCode: 200, data: emptyJSONList)
        })
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        let item1 = FeedItem(id: UUID(),
                             description: nil,
                             location: nil,
                             imageUrl: URL(string: "https://a-image.url")!)
        let item1JSONItem = [ "id": item1.id.uuidString,
                              "image": item1.imageUrl.absoluteString
        ]
        
        let item2 = FeedItem(id: UUID(),
                             description: "a description",
                             location: "a location",
                             imageUrl: URL(string: "https://another-image.url")!)
        let item2JSONItem = ["id": item2.id.uuidString,
                             "description": item2.description,
                             "location": item2.location,
                             "image": item2.imageUrl.absoluteString
        ]
        
        let itemsJSON = ["items": [item1JSONItem, item2JSONItem]]
        expect(sut,
               toCompleteWith: .success([item1, item2]),
               when: {
                let json = try! JSONSerialization.data(withJSONObject: itemsJSON)
                client.complete(withStatusCode: 200, data: json)
        })
    }
    
    //MARK:  Helpers
    private func makeSUT(url: URL = URL(string: "httos://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client, url: url)
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteFeedLoader, toCompleteWith result: RemoteFeedLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        var capturedResults = [RemoteFeedLoader.Result]()
        sut.load { capturedResults.append($0) }
        action()
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClientResponse) -> Void)]()
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClientResponse) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index],
                                           statusCode: code,
                                           httpVersion: nil,
                                           headerFields: nil)!
            messages[index].completion(.success(data, response))
        }
    }
}
