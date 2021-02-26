//
//  HTTPClient.swift
//  Feed
//
//  Created by Erik Agujari on 31/05/2020.
//  Copyright © 2020 Erik Agujari. All rights reserved.
//

import Foundation

public protocol HTTPClientTask {
    func cancel()
}

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(from url: URL, completion: @escaping (Result) -> Void)
}
