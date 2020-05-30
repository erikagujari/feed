//
//  FeedItem.swift
//  Feed
//
//  Created by Erik Agujari on 27/05/2020.
//  Copyright © 2020 Erik Agujari. All rights reserved.
//
import Foundation

public struct FeedItem: Equatable {
    let uuid: UUID
    let description: String?
    let location: String?
    let imageUrl: String
}
