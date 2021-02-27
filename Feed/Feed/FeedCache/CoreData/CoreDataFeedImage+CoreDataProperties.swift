//
//  CoreDataFeedImage+CoreDataProperties.swift
//  FeedStoreChallenge
//
//  Created by Erik Agujari on 14/12/2020.
//  Copyright © 2020 Essential Developer. All rights reserved.
//
//

import Foundation
import CoreData


extension CoreDataFeedImage {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataFeedImage> {
        return NSFetchRequest<CoreDataFeedImage>(entityName: "CoreDataFeedImage")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var imageDescription: String?
    @NSManaged public var location: String?
    @NSManaged public var url: URL
    @NSManaged public var feed: CoreDataFeed?
    @NSManaged public var data: Data?
    
    public convenience init(id: UUID, imageDescription: String?, location: String?, url: URL, feed: CoreDataFeed?, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = id
        self.imageDescription = imageDescription
        self.location = location
        self.url = url
        self.feed = feed
    }
}

extension CoreDataFeedImage : Identifiable {
    
}

extension CoreDataFeedImage {
    static func first(with url: URL, in context: NSManagedObjectContext) throws -> CoreDataFeedImage? {
        let request = NSFetchRequest<CoreDataFeedImage>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(CoreDataFeedImage.url), url])
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
}
