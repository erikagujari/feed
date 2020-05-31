//
//  HTTPClient.swift
//  Feed
//
//  Created by Erik Agujari on 31/05/2020.
//  Copyright © 2020 Erik Agujari. All rights reserved.
//

import Foundation

public enum HTTPClientResponse {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResponse) -> Void)
}
