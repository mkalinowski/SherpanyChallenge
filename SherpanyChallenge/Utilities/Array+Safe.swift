//
//  Array+Safe.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 27/12/2017.
//  Copyright © 2017 Higher Order. All rights reserved.
//

import Foundation

extension Array {
    public subscript(safe position: Index) -> Element? {
        // Thanks Mike Ash
        return (0..<count ~= position) ? self[position] : nil
    }
}
