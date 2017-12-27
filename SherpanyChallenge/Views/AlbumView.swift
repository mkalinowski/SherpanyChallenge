//
//  AlbumView.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 27/12/2017.
//  Copyright © 2017 Higher Order. All rights reserved.
//

import UIKit

class AlbumView: UICollectionReusableView {
    let titleLabel = UILabel().with {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure() {
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
}
