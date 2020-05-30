//
//  RemoteFeedLoader.swift
//  Feed
//
//  Created by Erik Agujari on 30/05/2020.
//  Copyright © 2020 Erik Agujari. All rights reserved.
//
import Foundation

public enum HTTPClientResponse {
    case success(HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResponse) -> Void)
}

public final class RemoteFeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping(Error) -> Void) {
        client.get(from: url, completion: { result in
            switch result {
            case .success:
                completion(.invalidData)
            case .failure:
                completion(.connectivity)
            }
        })
    }
}
