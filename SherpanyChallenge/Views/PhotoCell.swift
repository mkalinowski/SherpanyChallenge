//
//  PhotoCell.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 27/12/2017.
//  Copyright © 2017 Higher Order. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    lazy var imageView: RemoteImageView = RemoteImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure() {
        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
        imageView.image = nil
        imageView.cancel()
    }
}
