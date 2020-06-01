//
//  FeedLoader.swift
//  Feed
//
//  Created by Erik Agujari on 27/05/2020.
//  Copyright © 2020 Erik Agujari. All rights reserved.
//

public enum LoadFeedResult<Error: Swift.Error> {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    associatedtype Error: Swift.Error
    
    func load(completion: @escaping (LoadFeedResult<Error>) -> ())
}
