//
//  Photo+CoreDataClass.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 12/23/17.
//  Copyright © 2017 Higher Order. All rights reserved.
//
//

import CoreData
import Foundation

@objc(Photo)
public class Photo: NSManagedObject, Decodable, Downloadable {
    static var path: String {
        return "/photos"
    }

    enum CodingKeys: String, CodingKey {
        case albumId
        case id
        case title
        case url
        case thumbnailUrl
    }

    public required convenience init(from decoder: Decoder) throws {
        guard let contextKey = CodingUserInfoKey.context,
            let context = decoder.userInfo[contextKey] as? NSManagedObjectContext
            else {
                throw Error.noContext
        }

        self.init(entity: Photo.entity(), insertInto: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        id = try container.decode(Int64.self, forKey: .id)

        url = try container.decode(URL.self, forKey: .url)
        thumbnailUrl = try container.decode(URL.self, forKey: .thumbnailUrl)

        let albumId = try container.decode(Int64.self, forKey: .albumId)
        let fetchRequest: NSFetchRequest<Album> = Album.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == \(albumId)")
        album = (try context.fetch(fetchRequest)).first
    }
}
