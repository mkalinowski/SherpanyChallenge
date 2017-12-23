//
//  Entities.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 12/22/17.
//  Copyright © 2017 Higher Order. All rights reserved.
//

import CoreData
import Foundation

// TODO: Remove after conversion to MOCs
struct RawAlbum: Codable {
    let userId: Int
    let id: Int
    let title: String
}

struct RawPhoto: Codable {
    let albumId: Int
    let id: Int
    let title: String
    let url: URL
    let thumbnailUrl: URL
}
