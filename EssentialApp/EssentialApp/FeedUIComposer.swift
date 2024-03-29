//
//  FeedUIComposer.swift
//  FeediOS
//
//  Created by Erik Agujari on 13/2/21.
//  Copyright © 2021 Erik Agujari. All rights reserved.
//
import Feed
import UIKit
import FeediOS
import Combine

public final class FeedUICompose {
    private init() {}
    
    public static func feedComposedWith(feedLoader: @escaping () -> FeedLoader.Publisher, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) -> FeedViewController {
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: feedLoader().dispatchOnMainQueue)
        
        let feedController = FeedViewController.makeWith(delegate: presentationAdapter, title: FeedPresenter.title)
        let feedPresenter = FeedPresenter(errorView: WeakRefVirtualProxy(feedController),
                                          loadingView: WeakRefVirtualProxy(feedController),
                                          feedView: FeedViewAdapter(controller: feedController,
                                                                    imageLoader: { imageLoader($0).dispatchOnMainQueue() }))
        presentationAdapter.presenter = feedPresenter
        return feedController
    }
}

private extension FeedViewController {
    static func makeWith(delegate: FeedViewControllerDelegate, title: String) -> FeedViewController {
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! FeedViewController
        feedController.delegate = delegate
        feedController.title = FeedPresenter.title
        return feedController
    }
}
