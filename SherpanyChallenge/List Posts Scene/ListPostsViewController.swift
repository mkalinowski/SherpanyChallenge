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
    func listPostsViewController(_ controller: ListPostsViewController, didSelect post: Post?)
}

class ListPostsViewController: UITableViewController {
    weak var listPostsViewControllerDelegate: ListPostsViewControllerDelegate?
    lazy var searchController: UISearchController = UISearchController(searchResultsController: nil).with {
        $0.dimsBackgroundDuringPresentation = false
        $0.hidesNavigationBarDuringPresentation = false
        $0.searchBar.barStyle = .black
        $0.searchBar.placeholder = "Search Posts"
        $0.searchBar.searchBarStyle = .minimal
        $0.searchBar.tintColor = #colorLiteral(red: 0.1453115046, green: 0.5773126483, blue: 0.9095440507, alpha: 1)
        $0.searchResultsUpdater = self
    }

    private var searchPhrase: String? {
        didSet {
            if searchPhrase == "" {
                searchPhrase = nil
            }

            fetchedResultsController?.fetchRequest.predicate = searchPhrase.map {
                NSPredicate(format: "title CONTAINS[cd] %@", $0)
            }
            try? fetchedResultsController?.performFetch()
            tableView.reloadData()
        }
    }
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

    private func setupTableView() {
        let blurredImageView = BlurredImageView()
        tableView.backgroundView = blurredImageView
        tableView.estimatedRowHeight = 80
        tableView.register(PostCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorEffect = UIVibrancyEffect(blurEffect: blurredImageView.effect)
        tableView.tableHeaderView = searchController.searchBar
        tableView.scrollIndicatorInsets = UIEdgeInsets.zero.with {
            $0.top = searchController.searchBar.frame.height
        }
        tableView.indicatorStyle = .white
    }

    private func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar
            else { return }
        navigationBar.backgroundColor = #colorLiteral(red: 0.1453115046, green: 0.5773126483, blue: 0.9095440507, alpha: 1)
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black
        ]
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.addSubview(UIVisualEffectView(effect: UIBlurEffect(style: .extraLight)).with {
            $0.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
            $0.frame = navigationBar.bounds.with {
                $0.size.height += 20
                $0.origin.y -= 20
            }
            $0.layer.zPosition = -1 // Move effect below title
        })

        searchController.searchBar.backgroundColor = #colorLiteral(red: 0.1453115046, green: 0.5773126483, blue: 0.9095440507, alpha: 1)
        searchController.searchBar.isTranslucent = true
        searchController.searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: UIBarMetrics.default)
        searchController.searchBar.tintColor = #colorLiteral(red: 0.1453115046, green: 0.5773126483, blue: 0.9095440507, alpha: 1)
        searchController.searchBar.addSubview(UIVisualEffectView(effect: UIBlurEffect(style: .extraLight)).with {
            $0.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
            $0.frame = searchController.searchBar.bounds
            $0.layer.zPosition = -1 // Move effect below title
        })
    }

    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .white

        if let refreshControl = refreshControl {
            refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Challenge Accepted!"

        setupTableView()
        setupNavigationBar()
        setupRefreshControl()

        do {
            try fetchedResultsController?.performFetch()
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
            let title = NSMutableAttributedString(string: post.title?.capitalized ?? "")
            if let searchPhrase = searchPhrase {
                title.highlight(phrase: searchPhrase, with: .red)
            }

            cell.textLabel?.attributedText = title
            cell.detailTextLabel?.text = post.user?.email
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        listPostsViewControllerDelegate?.listPostsViewController(self, didSelect: nil)

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

extension ListPostsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchPhrase = searchController.searchBar.text
    }
}
