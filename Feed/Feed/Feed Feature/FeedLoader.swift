//
//  FeedLoader.swift
//  Feed
//
//  Created by Erik Agujari on 27/05/2020.
//  Copyright © 2020 Erik Agujari. All rights reserved.
//

public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage], Error>
    func load(completion: @escaping (Result) -> ())
}
