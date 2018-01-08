//
//  Photo+CoreDataProperties.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 12/23/17.
//  Copyright © 2017 Higher Order. All rights reserved.
//
//

import CoreData

extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var url: URL?
    @NSManaged public var thumbnailUrl: URL?
    @NSManaged public var album: Album?

}
