//
//  AlbumsDataSource.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 12/28/17.
//  Copyright © 2017 Higher Order. All rights reserved.
//

import UIKit

protocol AlbumsDataSourceDelegate: class {
    func albumsDataSource(_ albumsDataSource: AlbumsDataSource, didChange sections: IndexSet)
}

class AlbumsDataSource: NSObject {

    weak var delegate: AlbumsDataSourceDelegate?

    private(set) var expandedSection: Int?

    typealias ConfigureCell = (_ item: UICollectionViewCell, _ indexPath: IndexPath) -> Void // TODO

    let albums: [Album]

    init?(albums: [Album]) {
        self.albums = albums
        super.init()
    }

    @objc func didTap(_ sender: UITapGestureRecognizer) {
        guard let albumView = sender.view as? AlbumView
            else { return }
        let section = albumView.tag

        if expandedSection == section {
            expandedSection = nil
            delegate?.albumsDataSource(self, didChange: IndexSet(integer: section))
        } else {
            var sections = IndexSet(integer: section)
            _ = expandedSection.map {
                sections.insert($0)
            }
            expandedSection = section

            delegate?.albumsDataSource(self, didChange: sections)
        }
    }
}

extension AlbumsDataSource: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return albums.count
    }

    public func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
        if expandedSection != section {
            return 0
        }
        let album: Album? = albums[safe: section]
        return album?.sortedPhotos?.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCell = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView,
                               viewForSupplementaryElementOfKind kind: String,
                               at indexPath: IndexPath) -> UICollectionReusableView {
        let cell: AlbumView =
            collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                            for: indexPath)

        if let album: Album = albums[safe: indexPath.section] {

            var title = album.title

            if let count = album.photos?.count {
                title?.append(" (\(count) photos)") // TODO: plural
            }

            cell.tag = indexPath.section
            cell.titleLabel.text = title
        }

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        cell.addGestureRecognizer(tapGestureRecognizer)

        return cell
    }
}

extension AlbumsDataSource: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30) // TODO: Autolayout
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let photoCell: PhotoCell = cell as? PhotoCell,
            let album = albums[safe: indexPath.section],
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
}
