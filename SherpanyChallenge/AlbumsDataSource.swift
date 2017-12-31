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
    let title: String
    let body: String

    init(title: String, body: String, albums: [Album]) {
        self.albums = albums
        self.title = title
        self.body = body
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
        return albums.count + 1
    }

    public func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }

        if expandedSection != section {
            return 0
        }
        let album: Album? = albums[safe: section - 1]
        return album?.sortedPhotos?.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.section == 0 {
            let cell: BodyCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.titleLabel.preferredMaxLayoutWidth = collectionView.frame.width
            cell.bodyLabel.preferredMaxLayoutWidth = collectionView.frame.width
            cell.bodyLabel.text = body.capitalized
            cell.titleLabel.text = title.capitalized
            return cell
        }

        let cell: PhotoCell = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView,
                               viewForSupplementaryElementOfKind kind: String,
                               at indexPath: IndexPath) -> UICollectionReusableView {

        let cell: AlbumView =
            collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                            for: indexPath)
        guard indexPath.section > 0,
            let album: Album = albums[safe: indexPath.section - 1],
            let count = album.photos?.count
            else { fatalError() }

        cell.tag = indexPath.section
        cell.titleLabel.text = album.title?.capitalized
        cell.subtitleLabel.text = "\(count) photo\((count > 1) ? "s" : "")"
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(didTap(_:))))

        return cell
    }
}

extension AlbumsDataSource: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        if section == 0 {
            return .zero
        }
        return UIEdgeInsets(top: 20.0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 46) // TODO: Autolayout
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let photoCell: PhotoCell = cell as? PhotoCell,
            let album = albums[safe: indexPath.section - 1],
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

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        struct Static {
            static var sizingCell = BodyCell(frame: .zero)
        }

        if indexPath.section == 0 {
            Static.sizingCell.titleLabel.preferredMaxLayoutWidth = collectionView.frame.width
            Static.sizingCell.bodyLabel.preferredMaxLayoutWidth = collectionView.frame.width
            Static.sizingCell.bodyLabel.text = body
            Static.sizingCell.titleLabel.text = title.capitalized

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame.size.width = collectionView.frame.width
            let newAttributes = Static.sizingCell.preferredLayoutAttributesFitting(attributes)
            return newAttributes.size
        } else {
            let size = floor(collectionView.bounds.size.width / 7.0)
            // TODO: Fit equally
            return CGSize(width: size, height: size)
        }
    }
}
