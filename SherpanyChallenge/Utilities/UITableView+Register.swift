//
//  UITableView+Register.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 12/22/17.
//  Copyright © 2017 Higher Order. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static var identifier: String { return String(describing: self) }
}

extension UITableView {
    func register(_ cell: UITableViewCell.Type) {
        register(cell, forCellReuseIdentifier: cell.identifier)
    }

    func dequeueReusableCell<CellClass: UITableViewCell>(for indexPath: IndexPath) -> CellClass {
        let cell = dequeueReusableCell(withIdentifier: CellClass.identifier, for: indexPath)
        return (cell as? CellClass) ?? CellClass()
    }
}
