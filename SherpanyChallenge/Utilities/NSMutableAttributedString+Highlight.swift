//
//  NSMutableAttributedString+Highlight.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 01/01/2018.
//  Copyright © 2018 Higher Order. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    func highlight(phrase: String, with color: UIColor) {
        guard let regex = try? NSRegularExpression(pattern: phrase,
                                                   options: [.caseInsensitive,
                                                             .ignoreMetacharacters])
            else { return }

        regex.enumerateMatches(in: string,
                               options: [],
                               range: NSRange(location: 0, length: length)) { (match, flags, _) in
                                guard let match = match
                                    else { return }

                                addAttribute(.foregroundColor,
                                             value: color,
                                             range: match.range)
        }
    }
}
