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
        let items: [Item]
    }

    private struct Item: Decodable {
        let id: UUID
        let description: String?
        let location: String?
        let image: URL
        
        var item: FeedItem {
            return FeedItem(id: id,
                            description: description,
                            location: location,
                            imageUrl: image)
        }
    }
    private static var OK_200: Int { return 200 }
    
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedItem] {
        guard response.statusCode == OK_200
            else {
                throw RemoteFeedLoader.Error.invalidData
        }
        
        return try JSONDecoder().decode(Root.self, from: data).items.map { $0.item }
    }
}
