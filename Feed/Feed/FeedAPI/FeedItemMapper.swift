//
//  FeedItemMapper.swift
//  Feed
//
//  Created by Erik Agujari on 31/05/2020.
//  Copyright © 2020 Erik Agujari. All rights reserved.
//
import Foundation

final class FeedItemMapper {
    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.isOK,
            let root = try? JSONDecoder().decode(Root.self, from: data)
            else {
                throw RemoteFeedLoader.Error.invalidData
        }
        
        return root.items
    }
}
