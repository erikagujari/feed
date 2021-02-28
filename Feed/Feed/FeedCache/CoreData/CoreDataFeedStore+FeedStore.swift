//
//  CoreDataFeedStore+FeedStore.swift
//  Feed
//
//  Created by Erik Agujari on 27/2/21.
//  Copyright © 2021 Erik Agujari. All rights reserved.
//

import CoreData

extension CoreDataFeedStore: FeedStore {
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        perform { [weak self] context in
            guard let self = self else { return }
            do {
                let fetch = try context.fetch(CoreDataFeed.fetchRequest()) as [NSManagedObject]
                fetch.forEach { feed in
                    context.delete(feed)
                }
                self.save(context: context, errorCompletion: completion)
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        deleteCachedFeed { [weak self] deletionResult in
            guard let self = self else { return }
            switch deletionResult {
            case let .failure(error):
                completion(.failure(error))
            case .success:
                let coreDataFeed = CoreDataFeed(context: self.context)
                let coreDataFeedImages = feed.map { CoreDataFeedImageMapper.fromLocalFeedImage($0, feed: coreDataFeed, context: self.context)}
                
                coreDataFeed.images = NSOrderedSet(array: coreDataFeedImages)
                coreDataFeed.timestamp = timestamp
                
                self.save(context: self.context, errorCompletion: completion)
            }
        }
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        perform { context in
            do {
                guard let fetch = try context.fetch(CoreDataFeed.fetchRequest()) as? [CoreDataFeed],
                      let coreDataFeed = fetch.first,
                      let imageSet = coreDataFeed.images.array as? [CoreDataFeedImage]
                else {
                    completion(.success(.none))
                    return
                }
                let timestamp = coreDataFeed.timestamp
                completion(.success(.some((feed: imageSet.map { CoreDataFeedImageMapper.toLocalFeedImage($0) }, timestamp: timestamp))))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
}
