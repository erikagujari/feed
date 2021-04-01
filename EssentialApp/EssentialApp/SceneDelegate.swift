//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Erik Agujari on 27/3/21.
//

import CoreData
import UIKit
import Feed
import FeediOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let url = URL(string: "https://static1.squarespace.com/static/5891c5b8d1758ec68ef5dbc2/t/5d1c78f21e661a0001ce7cfd/1562147059075/feed-case-study-v1-api-feed.json")!
        let session = URLSession(configuration: .ephemeral)
        let client = URLSessionHTTPClient(session: session)
        
        let remoteFeedLoader = RemoteFeedLoader(client: client, url: url)
        let remoteImageDataLoader = RemoteFeedImageDataLoader(client: client)
        
        let localStoreUrl = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("feed-store.sqlite")
        let feedStore = try! CoreDataFeedStore(localURL: localStoreUrl)
        let localFeedLoader = LocalFeedLoader(store: feedStore, currentDate: Date.init)
        let localImageDataLoader = LocalFeedImageDataLoader(store: feedStore)
        
        let feedViewController = FeedUICompose.feedComposedWith(feedLoader: FeedLoaderWithFallbackComposite(primary: FeedLoaderCacheDecorator(decoratee: remoteFeedLoader,
                                                                                                                                              cache: localFeedLoader),
                                                                                                            fallback: localFeedLoader),
                                                                imageLoader: FeedImageDataLoaderWithFallbackComposite(primary: localImageDataLoader, fallback: remoteImageDataLoader))
        
        window?.rootViewController = feedViewController
    }
}
