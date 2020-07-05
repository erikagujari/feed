//
//  LocalFeedImage.swift
//  Feed
//
//  Created by Erik Agujari on 21/06/2020.
//  Copyright © 2020 Erik Agujari. All rights reserved.
//

import Foundation

public struct LocalFeedImage: Equatable, Codable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let url: URL
    
    public init(id: UUID, description: String?, location: String?, url: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.url = url
    }
}
