//
//  FeedUIComposer.swift
//  FeediOS
//
//  Created by Erik Agujari on 13/2/21.
//  Copyright © 2021 Erik Agujari. All rights reserved.
//
import Feed

public final class FeedUICompose {
    private init() {}
    
    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let viewModel = FeedViewModel(feedLoader: feedLoader)
        let refreshController = FeedRefreshViewController(viewModel: viewModel)
        let feedController = FeedViewController(refreshController: refreshController)
        viewModel.onFeedLoad = adaptFeedToCellControllers(forwardingTo: feedController, loader: imageLoader)
        return feedController
    }
    
    private static func adaptFeedToCellControllers(forwardingTo controller: FeedViewController, loader: FeedImageDataLoader) -> ([FeedImage]) -> Void {
        return { [weak controller] feed in
            controller?.tableModel = feed.map { model in
                FeedImageCellController(model: model, imageLoader: loader)
            }
        }
    }
}
