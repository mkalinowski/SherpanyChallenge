//
//  SyncWorker.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 08/01/2018.
//  Copyright © 2018 Higher Order. All rights reserved.
//

import UIKit

struct NetworkActivityIndicator {
    private static var count = 0

    private init () {
    }

    static func show() {
        DispatchQueue.main.async {
            // swiftlint:disable:next empty_count
            if NetworkActivityIndicator.count == 0 {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            NetworkActivityIndicator.count += 1
        }
    }

    static func hide() {
        DispatchQueue.main.async {
            NetworkActivityIndicator.count -= 1
            // swiftlint:disable:next empty_count
            if NetworkActivityIndicator.count == 0 {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
}
