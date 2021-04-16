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
    let localStoreURL = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("feed-store.sqlite")
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        configureWindow()
    }
    
    func makeRemoteClient() -> HTTPClient {
        return URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }
    
    func configureWindow() {
        let remoteURL = URL(string: "https://static1.squarespace.com/static/5891c5b8d1758ec68ef5dbc2/t/5db4155a4fbade21d17ecd28/1572083034355/essential_app_feed.json")!
        let remoteClient = makeRemoteClient()
        let remoteFeedLoader = RemoteFeedLoader(client: remoteClient, url: remoteURL)
        let remoteImageLoader = RemoteFeedImageDataLoader(client: remoteClient)
        
        let localStore = try! CoreDataFeedStore(localURL: localStoreURL)
        let localFeedLoader = LocalFeedLoader(store: localStore, currentDate: Date.init)
        let localImageLoader = LocalFeedImageDataLoader(store: localStore)
        
        window?.rootViewController = UINavigationController(rootViewController: FeedUICompose.feedComposedWith(feedLoader: FeedLoaderWithFallbackComposite(primary: FeedLoaderCacheDecorator(decoratee: remoteFeedLoader,
                                                                                                                                                                                             cache: localFeedLoader),
                                                                                                                                                           fallback: localFeedLoader),
                                                                                                               imageLoader: FeedImageDataLoaderWithFallbackComposite(primary: localImageLoader,
                                                                                                                                                                     fallback: FeedImageDataLoaderDecorator(decoratee: remoteImageLoader,
                                                                                                                                                                                                            cache: localImageLoader))))
    }
}
