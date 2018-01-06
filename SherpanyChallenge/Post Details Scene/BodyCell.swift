//
//  BodyCell.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 12/28/17.
//  Copyright © 2017 Higher Order. All rights reserved.
//

import UIKit

open class AutoLayoutCollectionViewCell: UICollectionViewCell {
    override open func preferredLayoutAttributesFitting(
        _ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutAttributes.bounds.size.height =
            systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        return layoutAttributes
    }
}

class BodyCell: AutoLayoutCollectionViewCell {
    override func preferredLayoutAttributesFitting(
        _ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {

        let autoLayoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        let autoLayoutSize =
            contentView.systemLayoutSizeFitting(targetSize,
                                                withHorizontalFittingPriority: .required,
                                                verticalFittingPriority: .defaultLow)
        let autoLayoutFrame = CGRect(origin: autoLayoutAttributes.frame.origin,
                                     size: autoLayoutSize)
        autoLayoutAttributes.frame = autoLayoutFrame
        return autoLayoutAttributes
    }

    lazy var titleLabel = UILabel().with {
        $0.font = UIFont.preferredFont(forTextStyle: .largeTitle)
            .fontDescriptor
            .withSymbolicTraits(.traitBold).map({
                UIFont(descriptor: $0, size: 0.0) // keep original size
            })

        $0.numberOfLines = 0
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    lazy var bodyLabel = UILabel().with {
        $0.font = UIFont.preferredFont(forTextStyle: .title3)
        $0.numberOfLines = 0
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
        $0.textColor = .darkGray
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
        contentView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 50, right: 20)
        let stackView = UIStackView(arrangedSubviews: [titleLabel, bodyLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 30

        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            contentView.layoutMarginsGuide.topAnchor.constraint(equalTo: stackView.topAnchor),
            contentView.layoutMarginsGuide.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            contentView.readableContentGuide.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            contentView.readableContentGuide.rightAnchor.constraint(equalTo: stackView.rightAnchor)])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
        bodyLabel.text = nil
        titleLabel.text = nil
    }
}
