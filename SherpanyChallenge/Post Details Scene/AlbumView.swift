//
//  AlbumView.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 27/12/2017.
//  Copyright © 2017 Higher Order. All rights reserved.
//

import UIKit

final class AlbumView: UICollectionReusableView {
    override class var layerClass: AnyClass {
        return DefaultZPositionLayer.self // Move the view below scroll indicator
    }

    let titleLabel = UILabel().with {
        $0.font = UIFont
            .preferredFont(forTextStyle: .body)
            .fontDescriptor
            .withSymbolicTraits(.traitBold).map({
                UIFont(descriptor: $0, size: 0.0) // keep original size
            })
    }

    let subtitleLabel = UILabel().with {
        $0.textColor = UIColor.gray
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
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light)).with {
            $0.frame = bounds
            $0.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }

        addSubview(blurView)

        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel]).with {
            $0.axis = .vertical
            $0.distribution = .fillEqually
            $0.frame = blurView.bounds.with {
                $0.origin.x = 20
                $0.size.width = $0.size.width - 60
            }
            $0.autoresizingMask = [.flexibleHeight, .flexibleWidth]
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
