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

        let listPostsViewController = ListPostsViewController()
        let postDetailsViewController = PostDetailsViewController()

        let splitViewControler = UISplitViewController()
        splitViewControler.viewControllers = [UINavigationController(rootViewController: listPostsViewController),
                                              postDetailsViewController]
        splitViewControler.preferredDisplayMode = .allVisible

        window.rootViewController = splitViewControler
        window.makeKeyAndVisible()

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        let networkWorker = NetworkWorker()
        networkWorker.getPosts { rawPosts in
            do {
                let rawPosts = try rawPosts()
                CoreDataService.shared.persistentContainer.performBackgroundTask { context in
                    context.importMultiple(rawPosts)

                    do {
                        try context.save()
                    } catch {
                        NSLog("Error: \(error)")
                    }
                }
            } catch {
                NSLog("Error: \(error)")
            }
        }
    }
}
