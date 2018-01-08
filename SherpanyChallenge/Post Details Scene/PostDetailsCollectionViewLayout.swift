//
//  PostDetailsCollectionViewLayout.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 05/01/2018.
//  Copyright © 2018 Higher Order. All rights reserved.
//

import UIKit

/// Cells in the first section are stretched horizontally to fit collection view's width
class PostDetailsCollectionViewLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes

        guard let collectionView = collectionView,
            indexPath.section == 0 else {
                return attributes
        }

        return attributes?.with {
            $0.bounds.size.width = collectionView.bounds.width
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return super.layoutAttributesForElements(in: rect)?.flatMap { attributes in
            (attributes.representedElementCategory == .cell)
                ? layoutAttributesForItem(at: attributes.indexPath)
                : attributes
        }
    }
}
