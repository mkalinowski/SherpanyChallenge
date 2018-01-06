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
        imageView.contentMode = .scaleAspectFill
        contentView.clipsToBounds = true
        contentView.addSubview(imageView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
        imageView.image = nil
        imageView.cancel()
    }
}
