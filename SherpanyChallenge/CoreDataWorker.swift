//
//  CoreDataWorker.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 12/22/17.
//  Copyright © 2017 Higher Order. All rights reserved.
//

import CoreData
import Foundation
import UIKit

final class CoreDataService {
    static let shared = CoreDataService() // TODO: Inject
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
}

extension NSManagedObjectContext {
    // TODO: Generic
    func importMultiple(_ rawPosts: [RawPost]) {
        // Note: Potential optimisation - fetch all Entities sorted by id,
        // sort all json objects by id and merge them manually with two iterators,
        // deciding `online` whether to update or insert

        mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        rawPosts
            .map {
                let post = Post(context: self)
                post.body = $0.body
                post.id = Int64($0.id)
                post.title = $0.title
                return post
            }
            .forEach {
                insert($0)
        }
    }
}
