//
//  FeedItem.swift
//  Feed
//
//  Created by Erik Agujari on 27/05/2020.
//  Copyright © 2020 Erik Agujari. All rights reserved.
//
import Foundation

public struct FeedItem: Equatable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let imageUrl: URL
    
    public init(id: UUID, description: String?, location: String?, imageUrl: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.imageUrl = imageUrl
    }
}
