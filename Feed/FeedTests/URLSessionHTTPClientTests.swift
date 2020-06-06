//
//  URLSessionHTTPClientTests.swift
//  FeedTests
//
//  Created by Erik Agujari on 01/06/2020.
//  Copyright © 2020 Erik Agujari. All rights reserved.
//

import XCTest
import Feed

class URLSessionHTTPClient {
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (HTTPClientResponse) -> Void) {
        session.dataTask(with: url, completionHandler: { _, _, error in
            if let error = error {
                completion(.failure(error))
            }
        }).resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    
    func test_getFromUrl_failsOnRequestError() {
        URLProtocolStub.startInterceptingRequests()
        let url = URL(string: "http://any-url.com")!
        let error = NSError(domain: "Any error", code: 0, userInfo: nil)
        URLProtocolStub.stub(data: nil, response: nil, error: error)
        
        let sut = URLSessionHTTPClient()
        let exp = expectation(description: "Wait for completion")
        
        sut.get(from: url, completion: { result in
            switch result {
            case let .failure(receivedErorr as NSError):
                XCTAssertEqual(receivedErorr, error)
            default:
                XCTFail("Expected failure with error \(error), got result \(result) instead")
            }
            exp.fulfill()
        })
        
        wait(for: [exp], timeout: 1.0)
        URLProtocolStub.stopInterceptingRequests()
    }
    
    //MARK - Helpers
    private class URLProtocolStub: URLProtocol {
        private static var stub: Stub?
        
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }
        
        static func stub(data: Data?, response: URLResponse?, error: Error?) {
            stub = Stub(data: data,
                              response: response,
                              error: error)
        }
        
        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            if let data = URLProtocolStub.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            if let response = URLProtocolStub.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            if let error = URLProtocolStub.stub?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {
            
        }
    }
}
