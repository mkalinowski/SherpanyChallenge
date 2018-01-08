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
        let listPostsViewController =
            ListPostsViewController(persistenceService: persistenceService)
        listPostsViewController.listPostsViewControllerDelegate = postDetailsViewController

        let splitViewControler = UISplitViewController()
        splitViewControler.viewControllers =
            [UINavigationController(rootViewController: listPostsViewController),
             postDetailsViewController]
        splitViewControler.minimumPrimaryColumnWidth = 342
        splitViewControler.maximumPrimaryColumnWidth = 342
        splitViewControler.preferredDisplayMode = .allVisible

        window.rootViewController = splitViewControler
        window.makeKeyAndVisible()

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        persistenceService.sync()
    }
}
