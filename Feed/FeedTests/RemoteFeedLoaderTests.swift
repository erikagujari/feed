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
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "httos://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        XCTAssertEqual(client.requestedURL, url)
    }
    
    //MARK:  Helpers
    private func makeSUT(url: URL = URL(string: "httos://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client, url: url)
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?
        
        func get(from url: URL) {
            requestedURL = url
        }
    }
}
