//
//  URLSessionHTTPClientTests.swift
//  FeedTests
//
//  Created by Erik Agujari on 01/06/2020.
//  Copyright © 2020 Erik Agujari. All rights reserved.
//

import XCTest
import Feed

protocol HTTPSession {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionTask
}

protocol HTTPSessionTask {
    func resume()
}

class URLSessionHTTPClient {
    let session: HTTPSession
    
    init(session: HTTPSession) {
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
    func test_getFromUrlResumesSessionDataTaskWithURL() {
        let url = URL(string: "http://any-url.com")!
        let session = HTTPSessionSpy()
        let task = URLSessionDataTaskSpy()
        session.stub(url: url, task: task)
        let sut = URLSessionHTTPClient(session: session)
        sut.get(from: url, completion: { _ in })
        XCTAssertEqual(task.resumeCallCount, 1)
    }
    
    func test_getFromUrl_failsOnRequestError() {
        let url = URL(string: "http://any-url.com")!
        let session = HTTPSessionSpy()
        let error = NSError(domain: "Any error", code: 0, userInfo: nil)
        session.stub(url: url, error: error)
        
        let sut = URLSessionHTTPClient(session: session)
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
    }
    
    //MARK - Helpers
    private class HTTPSessionSpy: HTTPSession {
        private var stubs = [URL: Stub]()
        
        private struct Stub {
            let task: HTTPSessionTask
            let error: Error?
        }
        func stub(url: URL, task: HTTPSessionTask = FakeURLSessionDataTask(), error: Error? = nil) {
            stubs[url] = Stub(task: task, error: error)
        }
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionTask {
            guard let stub = stubs[url]
                else {
                    fatalError("Coudln't find stub for \(url)")
            }
            completionHandler(nil, nil, stub.error)
            return stub.task
        }
    }
    
    private class FakeURLSessionDataTask: HTTPSessionTask {
        func resume() {
            
        }
    }
    private class URLSessionDataTaskSpy: HTTPSessionTask {
        var resumeCallCount = 0
        func resume() {
            resumeCallCount += 1
        }
    }
}
