//
//  FeedLoadingViewModel.swift
//  Feed
//
//  Created by Erik Agujari on 23/2/21.
//  Copyright © 2021 Erik Agujari. All rights reserved.
//

public struct FeedLoadingViewModel {
    public let isLoading: Bool
}

public protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}
