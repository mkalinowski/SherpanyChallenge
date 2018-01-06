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
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        textLabel?.font = UIFont
            .preferredFont(forTextStyle: .headline)
            .fontDescriptor
            .withSymbolicTraits(.traitBold).map({
                UIFont(descriptor: $0, size: 0.0) // keep original size
            })

        textLabel?.numberOfLines = 0
        textLabel?.textColor = #colorLiteral(red: 0.8566937447, green: 0.9248988032, blue: 0.9750056863, alpha: 1)
        textLabel?.highlightedTextColor = .white

        detailTextLabel?.font = .preferredFont(forTextStyle: .footnote)
        detailTextLabel?.textColor = #colorLiteral(red: 0.8566937447, green: 0.9248988032, blue: 0.9750056863, alpha: 1).withAlphaComponent(0.5)
        detailTextLabel?.textColor = #colorLiteral(red: 0.8566937447, green: 0.9248988032, blue: 0.9750056863, alpha: 1)
        detailTextLabel?.highlightedTextColor = UIColor.white.withAlphaComponent(0.5)

        let bgColorView = UIView()

        bgColorView.backgroundColor = #colorLiteral(red: 0.1453115046, green: 0.5773126483, blue: 0.9095440507, alpha: 1)
        selectedBackgroundView = bgColorView
    }
}
