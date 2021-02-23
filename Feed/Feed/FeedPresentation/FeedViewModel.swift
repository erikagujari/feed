//
//  FeedViewModel.swift
//  Feed
//
//  Created by Erik Agujari on 23/2/21.
//  Copyright © 2021 Erik Agujari. All rights reserved.
//

public struct FeedViewModel {
    public let feed: [FeedImage]
}

public protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}
