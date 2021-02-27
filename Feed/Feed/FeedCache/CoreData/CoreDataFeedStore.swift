//
//  CoreDataFeedStore.swift
//  FeedStoreChallenge
//
//  Created by Erik Agujari on 03/10/2020.
//  Copyright © 2020 Essential Developer. All rights reserved.
//
import CoreData

public struct CoreDataFeedStore: FeedStore {
    private let context: NSManagedObjectContext
    
    public init(localURL: URL) throws {
        let container = try CoreDataFeedStore.managedContainer(forLocalURL: localURL)
        context = container.newBackgroundContext()
    }
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        context.perform {
            do {
                let fetch = try context.fetch(CoreDataFeed.fetchRequest()) as [NSManagedObject]
                fetch.forEach { feed in
                    context.delete(feed)
                }
                save(context: context, errorCompletion: completion)
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        deleteCachedFeed { deletionResult in
            switch deletionResult {
            case let .failure(error):
                completion(.failure(error))
            case .success:
                let coreDataFeed = CoreDataFeed(context: context)
                let coreDataFeedImages = feed.map { CoreDataFeedImageMapper.fromLocalFeedImage($0, feed: coreDataFeed, context: context)}
                
                coreDataFeed.images = NSOrderedSet(array: coreDataFeedImages)
                coreDataFeed.timestamp = timestamp
                
                save(context: context, errorCompletion: completion)
            }
        }
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        context.perform {
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

private extension CoreDataFeedStore {    
    enum CoreDataError: Error {
        case loadError
    }
    
    struct CoreDataFeedImageMapper {
        static func toLocalFeedImage(_ coreDataFeedImage: CoreDataFeedImage) -> LocalFeedImage {
            return LocalFeedImage(id: coreDataFeedImage.id,
                                  description: coreDataFeedImage.imageDescription,
                                  location: coreDataFeedImage.location,
                                  url: coreDataFeedImage.url)
        }
        
        static func fromLocalFeedImage(_ localFeedImage: LocalFeedImage, feed: CoreDataFeed, context: NSManagedObjectContext) -> CoreDataFeedImage {
            return CoreDataFeedImage(id: localFeedImage.id,
                                     imageDescription: localFeedImage.description,
                                     location: localFeedImage.location,
                                     url: localFeedImage.url,
                                     feed: feed,
                                     context: context)
        }
    }
    
    func save(context: NSManagedObjectContext, errorCompletion: InsertionCompletion) {
        do {
            try context.save()
            errorCompletion(.success(()))
        } catch {
            errorCompletion(.failure(error))
        }
    }
    
    static func managedObjectModel(fileName: String) throws -> NSManagedObjectModel {
        guard let url = Bundle(for: CoreDataFeed.self).url(forResource: fileName, withExtension: "momd"),
              let managedObjectModel = NSManagedObjectModel(contentsOf: url)
        else { throw CoreDataError.loadError }
        return managedObjectModel
    }
    
    static func container() throws -> NSPersistentContainer {
        let fileName = "CoreDataFeed"
        return NSPersistentContainer(name: fileName, managedObjectModel: try CoreDataFeedStore.managedObjectModel(fileName: fileName))
    }
    
    static func managedContainer(forLocalURL URL: URL) throws -> NSPersistentContainer {
        let container = try CoreDataFeedStore.container()
        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: URL)]
        var persistentError: Error?
        
        container.loadPersistentStores { (_, error) in
            persistentError = error
        }
        guard persistentError == nil else { throw CoreDataError.loadError }
        return container
    }
}
