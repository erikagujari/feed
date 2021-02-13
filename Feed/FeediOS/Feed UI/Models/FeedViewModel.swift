//
//  FeedViewModel.swift
//  FeediOS
//
//  Created by Erik Agujari on 13/2/21.
//  Copyright © 2021 Erik Agujari. All rights reserved.
//
import Feed

final class FeedViewModel {
    private let feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    var onChange: ((FeedViewModel) -> Void)?
    var onFeedLoad: (([FeedImage]) -> Void)?
    
    private(set) var isLoading: Bool = false {
        didSet {
            onChange?(self)
        }
    }
    
    func loadFeed() {
        isLoading = true
        feedLoader.load(completion: { [weak self] result in
            if let feed = try? result.get() {
                self?.onFeedLoad?(feed)
            }
            self?.isLoading = false
        })
    }
}

