//
//  CoreDataFeedStore.swift
//  FeedStoreChallenge
//
//  Created by Erik Agujari on 03/10/2020.
//  Copyright © 2020 Essential Developer. All rights reserved.
//
import CoreData

public class CoreDataFeedStore {
    private static let modelName = "CoreDataFeed"
    private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataFeedStore.self))
    private let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }
    
    public init(localURL: URL) throws {        
        guard let model = CoreDataFeedStore.model else {
            throw StoreError.modelNotFound
        }

        do {
            container = try NSPersistentContainer.load(name: CoreDataFeedStore.modelName, model: model, url: localURL)
            context = container.newBackgroundContext()
        } catch {
            throw StoreError.failedToLoadPersistentContainer(error)
        }
    }
    
    func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
    
    private func cleanUpReferencesToPersistentStores() {
        context.performAndWait {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }
    
    deinit {
        cleanUpReferencesToPersistentStores()
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

extension NSPersistentContainer {
    static func load(name: String, model: NSManagedObjectModel, url: URL) throws -> NSPersistentContainer {
        let description = NSPersistentStoreDescription(url: url)
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        container.persistentStoreDescriptions = [description]

        var loadError: Swift.Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { throw $0 }

        return container
    }
}

extension NSManagedObjectModel {
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        return bundle
            .url(forResource: name, withExtension: "momd")
            .flatMap { NSManagedObjectModel(contentsOf: $0) }
    }
}
