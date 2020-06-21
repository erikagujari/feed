//
//  FeedItemMapper.swift
//  Feed
//
//  Created by Erik Agujari on 31/05/2020.
//  Copyright © 2020 Erik Agujari. All rights reserved.
//
import Foundation

struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}

final class FeedItemMapper {
    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }

    private static var OK_200: Int { return 200 }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.statusCode == OK_200,
            let root = try? JSONDecoder().decode(Root.self, from: data)
            else {
                throw RemoteFeedLoader.Error.invalidData
        }
        
        return root.items
    }
}
