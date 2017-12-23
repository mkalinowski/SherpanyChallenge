//
//  PostDetailsViewController.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 12/22/17.
//  Copyright © 2017 Higher Order. All rights reserved.
//

import UIKit

class PostDetailsViewController: UIViewController, ListPostsViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    func listPostsViewController(_ controller: ListPostsViewController, didSelect post: Post) {
        NSLog("Selected \(post.title)")
    }
}
