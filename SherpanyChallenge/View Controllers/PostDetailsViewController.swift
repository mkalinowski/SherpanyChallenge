//
//  PostDetailsViewController.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 12/22/17.
//  Copyright © 2017 Higher Order. All rights reserved.
//

import UIKit

class PostDetailsViewController: UIViewController, ListPostsViewControllerDelegate {
    private var post: Post? {
        didSet {
            title = post?.title
            bodyLabel.text = post?.body
            collectionView.reloadData()
            collectionView.setContentOffset(.zero, animated: false)

            let albums = post?.user?.sortedAlbums ?? []
            albumsDataSource = AlbumsDataSource(albums: albums)
            albumsDataSource?.delegate = self
            collectionView.dataSource = albumsDataSource
            collectionView.delegate = albumsDataSource
        }
    }

    private let bodyLabel = UILabel().with {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.preferredFont(forTextStyle: .body)
        $0.numberOfLines = 0
    }

    private lazy var collectionView =
        UICollectionView(frame: .zero,
                         collectionViewLayout: flowLayout).with {
                            $0.translatesAutoresizingMaskIntoConstraints = false
                            $0.backgroundColor = .clear
                            $0.register(PhotoCell.self)
                            $0.register(AlbumView.self,
                                        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader)
    }

    private let flowLayout: UICollectionViewFlowLayout = StickyHeaderFlowLayout().with {
        $0.itemSize = CGSize(width: 80, height: 80)
        $0.minimumLineSpacing = 0
        $0.scrollDirection = .vertical
    }

    private var albumsDataSource: AlbumsDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(bodyLabel)
        view.addSubview(collectionView)

        additionalSafeAreaInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        NSLayoutConstraint.activate([
            bodyLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bodyLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            bodyLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: bodyLabel.safeAreaLayoutGuide.bottomAnchor,
                                                constant: 10),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }

    func listPostsViewController(_ controller: ListPostsViewController, didSelect post: Post) {
        self.post = post
    }
}

extension PostDetailsViewController: AlbumsDataSourceDelegate {
    func albumsDataSource(_ albumsDataSource: AlbumsDataSource, didChange sections: IndexSet) {
        collectionView.reloadSections(sections)

        guard let expandedSection = albumsDataSource.expandedSection,
            let attributes = collectionView.layoutAttributesForSupplementaryElement(ofKind: UICollectionElementKindSectionHeader,
                                                                                    at: IndexPath(item: 0, section: expandedSection))
            else { return }

        collectionView.setContentOffset(CGPoint(x: 0, y: attributes.frame.origin.y - collectionView.contentInset.top),
                                        animated: true)
    }
}
