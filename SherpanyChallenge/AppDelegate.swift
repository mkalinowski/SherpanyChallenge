//
//  AppDelegate.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 12/22/17.
//  Copyright © 2017 Higher Order. All rights reserved.
//

import CoreData
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var persistenceService = PersistenceService()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window
            else { return false }

        let postDetailsViewController = PostDetailsViewController()
        let listPostsViewController = ListPostsViewController(persistenceService: persistenceService)
        listPostsViewController.listPostsViewControllerDelegate = postDetailsViewController

        let splitViewControler = UISplitViewController()
        splitViewControler.viewControllers = [UINavigationController(rootViewController: listPostsViewController),
                                              UINavigationController(rootViewController: postDetailsViewController)]
        splitViewControler.preferredDisplayMode = .allVisible

        window.rootViewController = splitViewControler
        window.makeKeyAndVisible()

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        var results: [String: Data] = [:]
        let types: [Downloadable.Type] = [User.self, Post.self, Album.self, Photo.self]

        let sync = DispatchGroup()
        for type in types {
            sync.enter()
            type.download { data in
                do {
                    let data = try data()
                    results[String(describing: type)] = data
                } catch {
                    NSLog("Error: \(error)")
                }
                sync.leave()
            }
        }

        sync.notify(queue: .main) {
            guard let users = results[String(describing: User.self)],
                let posts = results[String(describing: Post.self)],
                let albums = results[String(describing: Album.self)],
                let photos = results[String(describing: Photo.self)]
                else {
                    NSLog("Error: No data downloaded")
                    return
            }
            self.persistenceService.upsert(users: users, posts: posts, albums: albums, photos: photos)
        }
    }
}
