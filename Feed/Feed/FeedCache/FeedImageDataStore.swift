//
//  FeedImageDataStore.swift
//  Feed
//
//  Created by Erik Agujari on 26/2/21.
//  Copyright © 2021 Erik Agujari. All rights reserved.
//
import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>
    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
