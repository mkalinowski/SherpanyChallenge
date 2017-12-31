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

    private lazy var fetchedResultsController: NSFetchedResultsController<Post>? =
        self.persistenceService?.fetchedResultsController()?.with {
            $0.delegate = self
    }

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

        let blurredImageView = BlurredImageView()
        tableView.backgroundView = blurredImageView
        tableView.separatorEffect = UIVibrancyEffect(blurEffect: blurredImageView.effect)

        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1453115046, green: 0.5773126483, blue: 0.9095440507, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        tableView.register(PostCell.self)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension

        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .white

        if let refreshControl = refreshControl {
            refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        }

        do {
            tableView.setContentOffset(CGPoint(x: 0, y: -(refreshControl?.frame.size.height ?? 0)),
                                       animated: true)
            try fetchedResultsController?.performFetch()
            tableView.refreshControl?.beginRefreshing()
            tableView.reloadData()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
    }

    @objc private func refresh(_ sender: UIRefreshControl) {
        do {
            try fetchedResultsController?.performFetch()
            tableView.refreshControl?.beginRefreshing()
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
            cell.textLabel?.text = post.title?.capitalized
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
