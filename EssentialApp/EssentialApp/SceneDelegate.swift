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
    
    private lazy var httpClient: HTTPClient = {
        return URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var store: FeedStore & FeedImageDataStore = {
        return try! CoreDataFeedStore(localURL: NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("feed-store.sqlite"))
    }()
    
    private lazy var localFeedLoader = {
        return LocalFeedLoader(store: store, currentDate: Date.init)
    }()
    
    convenience init(httpClient: HTTPClient, store: FeedStore & FeedImageDataStore) {
        self.init()
        self.httpClient = httpClient
        self.store = store
    }
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        configureWindow()
    }
    
    func configureWindow() {
        let remoteURL = URL(string: "https://static1.squarespace.com/static/5891c5b8d1758ec68ef5dbc2/t/5db4155a4fbade21d17ecd28/1572083034355/essential_app_feed.json")!
        let remoteFeedLoader = RemoteFeedLoader(client: httpClient, url: remoteURL)
        let remoteImageLoader = RemoteFeedImageDataLoader(client: httpClient)
        let localImageLoader = LocalFeedImageDataLoader(store: store)
        
        window?.rootViewController = UINavigationController(rootViewController: FeedUICompose.feedComposedWith(feedLoader: FeedLoaderWithFallbackComposite(primary: FeedLoaderCacheDecorator(decoratee: remoteFeedLoader,
                                                                                                                                                                                             cache: localFeedLoader),
                                                                                                                                                           fallback: localFeedLoader),
                                                                                                               imageLoader: FeedImageDataLoaderWithFallbackComposite(primary: localImageLoader,
                                                                                                                                                                     fallback: FeedImageDataLoaderDecorator(decoratee: remoteImageLoader,
                                                                                                                                                                                                            cache: localImageLoader))))
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        localFeedLoader.validateCache(completion: { _ in })
    }
}
