//
//  PostDetailsViewController.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 12/22/17.
//  Copyright © 2017 Higher Order. All rights reserved.
//

import UIKit

final class PostDetailsViewController: UIViewController, ListPostsViewControllerDelegate {
    private var post: Post? {
        didSet {
            collectionView.backgroundView?.isHidden = (post != nil)
            postDetailsDataSource = post.map {
                PostDetailsDataSource(title: $0.title ?? "",
                                 body: $0.body ?? "",
                                 albums: ($0.user?.albums?.array as? [Album]) ?? [])
            }
            postDetailsDataSource?.delegate = self
            collectionView.dataSource = postDetailsDataSource
            collectionView.delegate = postDetailsDataSource
            collectionView.reloadData()
            collectionView.setContentOffset(.zero, animated: false)
        }
    }

    private lazy var collectionView =
        UICollectionView(frame: .zero,
                         collectionViewLayout: flowLayout).with {
                            $0.backgroundColor = .clear
                            $0.backgroundView = UILabel().with {
                                $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                                $0.font = UIFont.preferredFont(forTextStyle: .title1)
                                $0.text = "No Post Selected"
                                $0.textAlignment = .center
                                $0.textColor = .lightGray
                            }
                            $0.translatesAutoresizingMaskIntoConstraints = false
                            $0.register(BodyCell.self)
                            $0.register(PhotoCell.self)
                            $0.register(AlbumView.self,
                                        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader)
    }

    private let flowLayout: UICollectionViewFlowLayout = PostDetailsCollectionViewLayout().with {
        $0.estimatedItemSize = CGSize(width: 100, height: 100)
        $0.scrollDirection = .vertical
        $0.minimumInteritemSpacing = 0
        $0.minimumLineSpacing = 0
        $0.sectionHeadersPinToVisibleBounds = true
    }

    private var postDetailsDataSource: PostDetailsDataSource?

    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            self.collectionView.collectionViewLayout.invalidateLayout()
        })
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.collectionView.collectionViewLayout.invalidateLayout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }

    func listPostsViewController(_ controller: ListPostsViewController, didSelect post: Post?) {
        self.post = post
    }
}

extension PostDetailsViewController: PostDetailsDataSourceDelegate {
    func postDetailsDataSource(_ postDetailsDataSource: PostDetailsDataSource, didChange sections: IndexSet) {
        collectionView.reloadSections(sections)

        guard let expandedSection = postDetailsDataSource.expandedSection,
            let attributes = collectionView.layoutAttributesForSupplementaryElement(
                ofKind: UICollectionElementKindSectionHeader,
                at: IndexPath(item: 0, section: expandedSection))
            else { return }

        let section = CGPoint(x: 0, y: attributes.frame.origin.y - collectionView.contentInset.top)
        collectionView.setContentOffset(section, animated: true)
    }
}
