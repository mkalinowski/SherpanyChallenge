//
//  PostDetailsViewController.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 12/22/17.
//  Copyright © 2017 Higher Order. All rights reserved.
//

import UIKit

// TODO Scroll body with photos
class PostDetailsViewController: UIViewController, ListPostsViewControllerDelegate {
    private var post: Post? {
        didSet {
            titleLabel.text = post?.title
            bodyLabel.text = post?.body
            collectionView.reloadData()
            collectionView.setContentOffset(.zero, animated: false)
        }
    }

    private let titleLabel = UILabel().with {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        $0.numberOfLines = 0
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
                            $0.dataSource = self
                            $0.delegate = self
    }

    private let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout().with {
        $0.estimatedItemSize = CGSize(width: 80, height: 80)
        $0.minimumLineSpacing = 0
        $0.scrollDirection = .vertical
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(bodyLabel)
        view.addSubview(collectionView)

        additionalSafeAreaInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.safeAreaLayoutGuide.bottomAnchor),
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

extension PostDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30) // TODO: Autolayout
    }
}

extension PostDetailsViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return post?.user?.sortedAlbums?.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
        let album: Album? = post?.user?.sortedAlbums?[safe: section]
        return album?.sortedPhotos?.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCell = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let photoCell: PhotoCell = cell as? PhotoCell,
            let album = post?.user?.sortedAlbums?[safe: indexPath.section],
            let photo = album.sortedPhotos?[safe: indexPath.item],
            let thumbnailUrl = photo.thumbnailUrl
            else { return }
        photoCell.imageView.download(thumbnailUrl)
    }

    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let photoCell: PhotoCell = cell as? PhotoCell
            else { return }
        photoCell.imageView.cancel()
    }

    public func collectionView(_ collectionView: UICollectionView,
                               viewForSupplementaryElementOfKind kind: String,
                               at indexPath: IndexPath) -> UICollectionReusableView {
        let cell: AlbumView =
            collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                            for: indexPath)

        if let album: Album = post?.user?.sortedAlbums?[safe: indexPath.section] {
            cell.titleLabel.text = album.title
        }

        return cell
    }
}
