//
//  CoreDataFeedStore.swift
//  FeedStoreChallenge
//
//  Created by Erik Agujari on 03/10/2020.
//  Copyright © 2020 Essential Developer. All rights reserved.
//
import CoreData

public class CoreDataFeedStore {
    let context: NSManagedObjectContext
    
    public init(localURL: URL) throws {
        let bundle = Bundle(for: CoreDataFeedStore.self)
        let container = try CoreDataFeedStore.managedContainer(forLocalURL: localURL, bundle: bundle)
        context = container.newBackgroundContext()
    }
    
    func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
    
    func save(context: NSManagedObjectContext, errorCompletion: InsertionCompletion) {
        do {
            try context.save()
            errorCompletion(.success(()))
        } catch {
            errorCompletion(.failure(error))
        }
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
}

private extension CoreDataFeedStore {    
    enum CoreDataError: Error {
        case loadError
    }
    
    static func managedObjectModel(fileName: String, bundle: Bundle) throws -> NSManagedObjectModel {
        guard let url = bundle.url(forResource: fileName, withExtension: "momd"),
              let managedObjectModel = NSManagedObjectModel(contentsOf: url)
        else { throw CoreDataError.loadError }
        return managedObjectModel
    }
    
    static func container(bundle: Bundle) throws -> NSPersistentContainer {
        let fileName = "CoreDataFeed"
        return NSPersistentContainer(name: fileName, managedObjectModel: try CoreDataFeedStore.managedObjectModel(fileName: fileName, bundle: bundle))
    }
    
    static func managedContainer(forLocalURL URL: URL, bundle: Bundle) throws -> NSPersistentContainer {
        let container = try CoreDataFeedStore.container(bundle: bundle)
        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: URL)]
        var persistentError: Error?
        
        container.loadPersistentStores { (_, error) in
            persistentError = error
        }
        guard persistentError == nil else { throw CoreDataError.loadError }
        return container
    }
}
