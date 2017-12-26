//
//  ListPostsViewController.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 12/22/17.
//  Copyright © 2017 Higher Order. All rights reserved.
//

import CoreData
import UIKit

protocol ListPostsViewControllerDelegate: NSObjectProtocol {
    func listPostsViewController(_ controller: ListPostsViewController, didSelect post: Post)
}

class ListPostsViewController: UITableViewController {
    weak var listPostsViewControllerDelegate: ListPostsViewControllerDelegate?

    private lazy var fetchedResultsController: NSFetchedResultsController<Post>? = {
        let fetchedResultsController: NSFetchedResultsController<Post>? = persistenceService?.fetchedResultsController()
        fetchedResultsController?.delegate = self
        return fetchedResultsController
    }()

    private var persistenceService: PersistenceService?

    init(persistenceService: PersistenceService) {
        self.persistenceService = persistenceService
        super.init(style: .plain)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Challenge Accepted!"

        tableView.register(PostCell.self)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension

        do {
            try fetchedResultsController?.performFetch()
            tableView.reloadData()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
    }
}

extension ListPostsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PostCell = tableView.dequeueReusableCell(for: indexPath)
        if let post = fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = post.title
            cell.detailTextLabel?.text = post.user?.email
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] _, indexPath in
            guard let strongSelf = self,
                let postObjectID = strongSelf.fetchedResultsController?.object(at: indexPath).objectID
                else { return }

            strongSelf.persistenceService?.deleteObject(with: postObjectID)
        }

        return [delete]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let post = fetchedResultsController?.object(at: indexPath) {
            listPostsViewControllerDelegate?.listPostsViewController(self, didSelect: post)
        }
    }
}
