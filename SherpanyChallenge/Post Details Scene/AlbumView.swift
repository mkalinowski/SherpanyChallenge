//
//  AlbumView.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 27/12/2017.
//  Copyright © 2017 Higher Order. All rights reserved.
//

import UIKit

class AlbumView: UICollectionReusableView {
    override class var layerClass: AnyClass {
        return DefaultZPositionLayer.self // Move the view below scroll indicator
    }

    let titleLabel = UILabel()
    let subtitleLabel = UILabel()

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

        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light)).with {
            $0.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            $0.frame = bounds
        }

        addSubview(blurView)

        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel]).with {
            $0.axis = .vertical
            $0.distribution = .fillEqually
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
            $0.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            $0.frame = blurView.bounds
        }

        let imageView = UIImageView(image: #imageLiteral(resourceName: "chevron")).with {
            $0.contentMode = .center
            $0.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
            $0.frame = CGRect.zero.with {
                $0.size.width = 40
                $0.origin.x = blurView.bounds.width - 40
                $0.size.height = blurView.bounds.height
            }
        }

        blurView.contentView.addSubview(stackView)
        blurView.contentView.addSubview(imageView)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        gestureRecognizers?.forEach {
            removeGestureRecognizer($0)
        }
    }
}
