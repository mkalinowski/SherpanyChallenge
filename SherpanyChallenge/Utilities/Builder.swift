//
//  Builder.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 12/22/17.
//  Copyright © 2017 Higher Order. All rights reserved.
//

import UIKit

public protocol Builder {}
extension Builder {
    public func with(configure: (inout Self) -> Void) -> Self {
        var this = self
        configure(&this)
        return this
    }
}
extension CGRect: Builder {}
extension NSObject: Builder {}
extension URLComponents: Builder {}
extension URLRequest: Builder {}
