//
//  PersistenceService.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 12/22/17.
//  Copyright © 2017 Higher Order. All rights reserved.
//

import CoreData
import Foundation
import UIKit

extension NSManagedObject {
    enum Error: Swift.Error {
        case noContext
    }
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}

final class PersistenceService {
    var errorHandler: (Error) -> Void = { NSLog("CoreData error \($0)") }

    lazy var persistentContainer: NSPersistentContainer = {
        let group = DispatchGroup()
        group.enter()

        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { [weak self] storeDescription, error in
            if let error = error {
                self?.errorHandler(error)
            }
            group.leave()
        }
        group.wait()

        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    func fetchedResultsController<Entity: NSManagedObject>(sortDescriptor: String = "id") -> NSFetchedResultsController<Entity>? {
        let context = persistentContainer.viewContext
        guard let entityName = Entity.entity().name
            else { return nil }

        let fetchRequest = NSFetchRequest<Entity>(entityName: entityName)
        if Entity.entity().propertiesByName[sortDescriptor] != nil {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: sortDescriptor, ascending: true)]
        }

        let fetchedResultsController =
            NSFetchedResultsController(fetchRequest: fetchRequest,
                                       managedObjectContext: context,
                                       sectionNameKeyPath: nil,
                                       cacheName: nil)
        return fetchedResultsController
    }

    func upsert(users: Data, posts: Data) {
        persistentContainer.performBackgroundTask { context in
            context.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump

            guard let contextKey = CodingUserInfoKey.context
                else { return }

            let decoder = JSONDecoder()
            decoder.userInfo[contextKey] = context

            do {
                let importedUsers = try decoder.decode([User].self, from: users)
                let importedPosts = try decoder.decode([Post].self, from: posts)

                NSLog("Imported users: \(importedUsers.count)")
                NSLog("Imported posts: \(importedPosts.count)")

                try context.save()
            } catch {
                NSLog("Error: \(error)")
            }
        }
    }

    func deleteObject(with objectID: NSManagedObjectID) {
        persistentContainer.performBackgroundTask { context in
            context.delete(context.object(with: objectID))
            do {
                try context.save()
            } catch {
                NSLog("\(error)")
            }
        }
    }
}
