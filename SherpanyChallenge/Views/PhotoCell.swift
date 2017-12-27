//
//  PhotoCell.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 27/12/2017.
//  Copyright © 2017 Higher Order. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    lazy var titleLabel: UILabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)

        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
        titleLabel.text = ""
    }
}
