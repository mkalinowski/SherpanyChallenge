//
//  Post+CoreDataClass.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 12/23/17.
//  Copyright © 2017 Higher Order. All rights reserved.
//
//

import CoreData
import Foundation

@objc(Post)
public class Post: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case body
        case id
        case title
        case userId
    }

    public required convenience init(from decoder: Decoder) throws {
        guard let contextKey = CodingUserInfoKey.context,
            let context = decoder.userInfo[contextKey] as? NSManagedObjectContext
            else {
                throw Error.noContext
        }

        self.init(entity: Post.entity(), insertInto: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        body = try container.decode(String.self, forKey: .body)
        id = try container.decode(Int64.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        let userId = try container.decode(Int64.self, forKey: .userId)

        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == \(userId)")
        let users = try context.fetch(fetchRequest)
        self.user = users.first
    }
}

extension Post: Downloadable {
    static var path: String {
        return "/posts"
    }
}
