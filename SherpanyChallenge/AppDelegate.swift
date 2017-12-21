//
//  AppDelegate.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 12/22/17.
//  Copyright © 2017 Higher Order. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window
            else { return false }

        let splitViewControler = UISplitViewController()
        splitViewControler.preferredDisplayMode = .allVisible
        let listPostsViewController = ListPostsViewController()
        let postDetailsViewController = PostDetailsViewController()
        splitViewControler.viewControllers = [UINavigationController(rootViewController: listPostsViewController),
                                              postDetailsViewController]

        window.rootViewController = splitViewControler
        window.makeKeyAndVisible()

        return true
    }
}
