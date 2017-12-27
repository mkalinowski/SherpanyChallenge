//
//  UICollectionView+Register.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 27/12/2017.
//  Copyright © 2017 Higher Order. All rights reserved.
//

import UIKit

extension UICollectionReusableView {
    static var identifier: String { return String(describing: self) }
}

extension UICollectionView {
    func register(_ cell: UICollectionViewCell.Type) {
        register(cell, forCellWithReuseIdentifier: cell.identifier)
    }

    func dequeueReusableCell<CellClass: UICollectionViewCell>(for indexPath: IndexPath) -> CellClass {
        let cell = dequeueReusableCell(withReuseIdentifier: CellClass.identifier, for: indexPath)
        return (cell as? CellClass) ?? CellClass()
    }

    func register(_ cell: UICollectionReusableView.Type,
                  forSupplementaryViewOfKind elementKind: String) {
        register(cell,
                 forSupplementaryViewOfKind: elementKind,
                 withReuseIdentifier: cell.identifier)
    }

    func dequeueReusableSupplementaryView<ViewClass: UICollectionReusableView>(ofKind elementKind: String,
                                                                               for indexPath: IndexPath) -> ViewClass {
        let view = dequeueReusableSupplementaryView(ofKind: elementKind,
                                                    withReuseIdentifier: ViewClass.identifier,
                                                    for: indexPath)
        return (view as? ViewClass) ?? ViewClass()
    }
}
