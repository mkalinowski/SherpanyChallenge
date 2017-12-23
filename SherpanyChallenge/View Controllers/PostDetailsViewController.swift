//
//  PostDetailsViewController.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 12/22/17.
//  Copyright © 2017 Higher Order. All rights reserved.
//

import UIKit

class PostDetailsViewController: UIViewController, ListPostsViewControllerDelegate {
    private var titleLabel = UILabel().with {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        $0.numberOfLines = 0
    }

    private var bodyLabel = UILabel().with {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.preferredFont(forTextStyle: .body)
        $0.numberOfLines = 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(bodyLabel)

        additionalSafeAreaInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.safeAreaLayoutGuide.bottomAnchor),
            bodyLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            bodyLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)])
    }

    func listPostsViewController(_ controller: ListPostsViewController, didSelect post: Post) {
        titleLabel.text = post.title
        bodyLabel.text = post.body
    }
}
