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
    let subtitleLabel = UILabel()
    let imageView = UIImageView(image: #imageLiteral(resourceName: "chevron"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure() {
        titleLabel.font = UIFont
            .preferredFont(forTextStyle: .body)
            .fontDescriptor
            .withSymbolicTraits(.traitBold).map({
                UIFont(descriptor: $0, size: 0.0) // keep original size
            })

        subtitleLabel.textColor = UIColor.gray

        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)

        let darkBlur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: darkBlur)
        addSubview(blurView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center

        blurView.contentView.addSubview(stackView)
        blurView.contentView.addSubview(imageView)
        blurView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: blurView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: blurView.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: blurView.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: imageView.leftAnchor),

            imageView.bottomAnchor.constraint(equalTo: blurView.bottomAnchor),
            imageView.topAnchor.constraint(equalTo: blurView.topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.rightAnchor.constraint(equalTo: blurView.rightAnchor),
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blurView.leftAnchor.constraint(equalTo: leftAnchor),
            blurView.rightAnchor.constraint(equalTo: rightAnchor)])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        gestureRecognizers?.forEach {
            removeGestureRecognizer($0)
        }
    }
}
