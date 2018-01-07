//
//  UITableViewVontroller+NSFetchedResultsController.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 26/12/2017.
//  Copyright © 2017 Higher Order. All rights reserved.
//

import CoreData
import UIKit

extension UITableViewController: NSFetchedResultsControllerDelegate {
    private enum AssociatedKeys {
        static var selectedCell = "selectedCell"
    }

    private var selectedIndexPath: IndexPath? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.selectedCell) as? IndexPath
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.selectedCell,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.refreshControl?.beginRefreshing()
        selectedIndexPath = tableView.indexPathForSelectedRow
        tableView.beginUpdates()
    }

    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        tableView.refreshControl?.endRefreshing()

        if let selectedIndexPath = selectedIndexPath {
            tableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: .none)
        }
    }

    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                           didChange sectionInfo: NSFetchedResultsSectionInfo,
                           atSectionIndex sectionIndex: Int,
                           for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            return
        }
    }

    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                           didChange anObject: Any,
                           at indexPath: IndexPath?,
                           for type: NSFetchedResultsChangeType,
                           newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath
                else { break }

            if let oldSelectedIndexPath = selectedIndexPath,
                newIndexPath.section == oldSelectedIndexPath.section,
                newIndexPath <= oldSelectedIndexPath {

                selectedIndexPath?.row = oldSelectedIndexPath.row + 1
            }

            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath
                else { break }

            if indexPath == selectedIndexPath {
                selectedIndexPath = nil
            } else if let oldSelectedIndexPath = selectedIndexPath,
                indexPath.section == oldSelectedIndexPath.section,
                indexPath < oldSelectedIndexPath {

                selectedIndexPath?.row = oldSelectedIndexPath.row - 1
            }

            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath
                else { break }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath
                else { break }

            if indexPath == selectedIndexPath {
                selectedIndexPath = newIndexPath
            }
            tableView.reloadRows(at: [indexPath, newIndexPath], with: .automatic)
        }
    }
}
