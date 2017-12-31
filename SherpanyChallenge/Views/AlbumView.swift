//
//  AlbumView.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 27/12/2017.
//  Copyright © 2017 Higher Order. All rights reserved.
//

import UIKit

class AlbumView: UICollectionReusableView {
    let titleLabel = UILabel()

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

        backgroundColor = UIColor.white
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel.sizeToFit()
        titleLabel.frame.origin = .zero
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        gestureRecognizers?.forEach {
            removeGestureRecognizer($0)
        }
    }
}
