//
//  PostCell.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 12/22/17.
//  Copyright © 2017 Higher Order. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        configure()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure() {
        textLabel?.font = UIFont
            .preferredFont(forTextStyle: .headline)
            .fontDescriptor
            .withSymbolicTraits(.traitBold).map({
                UIFont(descriptor: $0, size: 0.0) // keep original size
            })

        textLabel?.textColor = UIColor(named: "sherpanyBlue")
        textLabel?.highlightedTextColor = .white

        detailTextLabel?.font = .preferredFont(forTextStyle: .footnote)
        detailTextLabel?.textColor = UIColor(named: "sherpanyBlue")?.withAlphaComponent(0.5)
        detailTextLabel?.highlightedTextColor = UIColor.white.withAlphaComponent(0.5)

        let bgColorView = UIView()

        bgColorView.backgroundColor = UIColor(named: "sherpanyGreen")
        selectedBackgroundView = bgColorView
    }
}
