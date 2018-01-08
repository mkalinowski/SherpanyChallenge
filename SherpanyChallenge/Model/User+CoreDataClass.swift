//
//  User+CoreDataClass.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 12/23/17.
//  Copyright © 2017 Higher Order. All rights reserved.
//
//

import CoreData

@objc(User)
public class User: NSManagedObject, Decodable, Downloadable {
    static var path: String {
        return "/users"
    }

    enum CodingKeys: String, CodingKey {
        case email
        case id
    }

    public required convenience init(from decoder: Decoder) throws {
        guard let contextKey = CodingUserInfoKey.context,
            let context = decoder.userInfo[contextKey] as? NSManagedObjectContext
            else {
                throw Error.noContext
        }

        self.init(entity: User.entity(), insertInto: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        email = try container.decode(String.self, forKey: .email)
        id = try container.decode(Int64.self, forKey: .id)
    }
}
