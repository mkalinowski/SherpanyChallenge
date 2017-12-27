//
//  Album+CoreDataClass.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 12/23/17.
//  Copyright © 2017 Higher Order. All rights reserved.
//
//

import CoreData
import Foundation

@objc(Album)
public class Album: NSManagedObject, Decodable, Downloadable {
    static var path: String {
        return "/albums"
    }

    enum CodingKeys: String, CodingKey {
        case title
        case id
        case userId
    }

    public required convenience init(from decoder: Decoder) throws {
        guard let contextKey = CodingUserInfoKey.context,
            let context = decoder.userInfo[contextKey] as? NSManagedObjectContext
            else {
                throw Error.noContext
        }

        self.init(entity: Album.entity(), insertInto: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        id = try container.decode(Int64.self, forKey: .id)

        let userId = try container.decode(Int64.self, forKey: .userId)

        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == \(userId)")
        user = (try context.fetch(fetchRequest)).first
    }

    public var sortedPhotos: [Photo]? {
        // TODO: Not optimal
        return (photos as? Set<Photo>)?.sorted()
    }
}

extension Album: Comparable {
    public static func < (lhs: Album, rhs: Album) -> Bool {
        return lhs.id < rhs.id
    }
}
