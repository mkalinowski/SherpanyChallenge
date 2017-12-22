//
//  ListPostsViewController.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 12/22/17.
//  Copyright © 2017 Higher Order. All rights reserved.
//

import CoreData
import UIKit

class ListPostsViewController: UITableViewController {
    private var controller: NSFetchedResultsController<Post>?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Challenge Accepted!"

        tableView.register(PostCell.self)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension

        controller = CoreDataService.shared.fetchedResultsController()
        controller?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            do {
                try self.controller?.performFetch()
                self.tableView.reloadData()
            } catch {
                fatalError("Failed to fetch entities: \(error)")
            }
        }
    }
}

extension ListPostsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return controller?.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller?.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PostCell = tableView.dequeueReusableCell(for: indexPath)
        if let post = controller?.object(at: indexPath) {
            cell.textLabel?.text = post.title
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = "foo bar baz"
        }
        return cell
    }
}

extension ListPostsViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
