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
        var usersData: Data? = nil
        var postsData: Data? = nil

        let sync = DispatchGroup()
        sync.enter()
        User.download { data in
            do {
                let data = try data()
                usersData = data
            } catch {
                NSLog("Error: \(error)")
            }
            sync.leave()
        }

        sync.enter()
        Post.download { data in
            do {
                let data = try data()
                postsData = data
            } catch {
                NSLog("Error: \(error)")
            }
            sync.leave()
        }

        sync.notify(queue: .main) {
            guard let usersData = usersData,
                let postsData = postsData
                else {
                    NSLog("Error: No data downloaded")
                    return
            }
            CoreDataService.shared.upsert(users: usersData, posts: postsData)
        }
    }
}
