//
//  NSMutableAttributedString+Highlight.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 01/01/2018.
//  Copyright © 2018 Higher Order. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {
    func highlight(phrase: String, with color: UIColor) {
        guard let regex = try? NSRegularExpression(pattern: phrase,
                                                   options: [.ignoreMetacharacters])
            else { return }

        regex.enumerateMatches(in: string,
                               options: [],
                               range: NSRange(location: 0, length: length)) { (match, flags, _) in
                                guard let match = match
                                    else { return }

                                let attributedText = NSMutableAttributedString(string: phrase)
                                attributedText.addAttribute(.foregroundColor,
                                                            value: color,
                                                            range: NSRange(location: 0, length: attributedText.length))
                                replaceCharacters(in: match.range, with: attributedText)
        }
    }
}
