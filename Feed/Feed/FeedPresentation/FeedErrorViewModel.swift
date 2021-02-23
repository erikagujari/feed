//
//  FeedErrorViewModel.swift
//  Feed
//
//  Created by Erik Agujari on 23/2/21.
//  Copyright © 2021 Erik Agujari. All rights reserved.
//

public struct FeedErrorViewModel {
    public let message: String?
    
    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}

public protocol FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel)
}
