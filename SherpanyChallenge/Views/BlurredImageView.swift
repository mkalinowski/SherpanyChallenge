//
//  BlurredImageView.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 31/12/2017.
//  Copyright © 2017 Higher Order. All rights reserved.
//

import UIKit

class BlurredImageView: UIView {
    let effect = UIBlurEffect(style: .dark)

    private lazy var blurView = UIVisualEffectView(effect: self.effect).with {
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    private lazy var imageView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "kindle-background-galaxy")).with {
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        $0.contentMode = .scaleAspectFill
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    convenience required init?(coder aDecoder: NSCoder) {
        self.init(frame: .zero)
        configure()
    }

    private func configure() {
        addSubview(imageView)
        addSubview(blurView)
    }
}
