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

        networkWorker.getPosts { posts in
            do {
                let posts = try posts()
                NSLog("Posts: \(posts.first)")
            } catch {
                NSLog("Error: \(error)")
            }
        }

        networkWorker.getUsers { users in
            do {
                let users = try users()
                NSLog("Users: \(users.first)")
            } catch {
                NSLog("Error: \(error)")
            }
        }

        networkWorker.getAlbums { albums in
            do {
                let albums = try albums()
                NSLog("Albums: \(albums.first)")
            } catch {
                NSLog("Error: \(error)")
            }
        }

        networkWorker.getPhotos { photos in
            do {
                let photos = try photos()
                NSLog("Photos: \(photos.first)")
            } catch {
                NSLog("Error: \(error)")
            }
        }
    }
}
