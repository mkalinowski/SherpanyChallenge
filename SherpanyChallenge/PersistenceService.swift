//
//  PersistenceService.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 12/22/17.
//  Copyright © 2017 Higher Order. All rights reserved.
//

import CoreData
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
    lazy var persistentContainer: NSPersistentContainer =
        NSPersistentContainer(name: "Model").with {
            let group = DispatchGroup()
            group.enter()

            $0.loadPersistentStores { [weak self] _, error in
                if let error = error {
                    log(error.localizedDescription, type: .error)
                }
                group.leave()
            }
            group.wait()

            $0.viewContext.automaticallyMergesChangesFromParent = true
    }

    func fetchedResultsController<Entity: NSManagedObject>(
        sortDescriptor: String = "id",
        predicate: NSPredicate? = nil) -> NSFetchedResultsController<Entity>? {

        let context = persistentContainer.viewContext
        guard let entityName = Entity.entity().name
            else { return nil }

        let fetchRequest = NSFetchRequest<Entity>(entityName: entityName)
        if Entity.entity().propertiesByName[sortDescriptor] != nil {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: sortDescriptor, ascending: true)]
        }

        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }

        let fetchedResultsController =
            NSFetchedResultsController(fetchRequest: fetchRequest,
                                       managedObjectContext: context,
                                       sectionNameKeyPath: nil,
                                       cacheName: nil)
        return fetchedResultsController
    }

    func upsert(users: Data, posts: Data, albums: Data, photos: Data) {
        persistentContainer.performBackgroundTask { context in
            context.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump

            guard let contextKey = CodingUserInfoKey.context
                else { return }

            let decoder = JSONDecoder()
            decoder.userInfo[contextKey] = context

            do {
                let importedUsers = try decoder.decode([User].self, from: users)
                let importedPosts = try decoder.decode([Post].self, from: posts)
                let importedAlbums = try decoder.decode([Album].self, from: albums)
                let importedPhotos = try decoder.decode([Photo].self, from: photos)

                log("Imported users: \(importedUsers.count)", type: .info)
                log("Imported posts: \(importedPosts.count)", type: .info)
                log("Imported albums: \(importedAlbums.count)", type: .info)
                log("Imported photos: \(importedPhotos.count)", type: .info)

                try context.save()
            } catch {
                log(error.localizedDescription, type: .error)
            }
        }
    }

    func deleteObject(with objectID: NSManagedObjectID) {
        persistentContainer.performBackgroundTask { context in
            context.delete(context.object(with: objectID))
            do {
                try context.save()
            } catch {
                log(error.localizedDescription, type: .error)
            }
        }
    }
}
