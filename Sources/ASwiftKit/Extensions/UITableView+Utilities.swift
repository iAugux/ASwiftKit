// Created by Augus on 2021/6/17
// Copyright © 2021 Augus <iAugux@gmail.com>

#if os(iOS)
import UIKit

public extension UITableView {
    /// Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table.
    /// Note: withIdentifier must be equal to the Cell Class.
    func dequeueReusableCell<T: UITableViewCell>(with cell: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: cell.self), for: indexPath) as! T
    }

    /// Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table.
    /// Note: withIdentifier must be equal to the Cell Class.
    func dequeueReusableCell<T: UITableViewCell>(with cell: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: cell.self)) as! T
    }

    /// Returns a reusable header or footer view located by its identifier.
    /// Note: withIdentifier must be equal to the View Class.
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(with view: T.Type) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: String(describing: view.self)) as! T
    }

    /// Registers a nib object containing a cell with the table view under a specified identifier.
    /// Nib name must be equal to the Cell Class, and the forCellReuseIdentifier must equal to Cell Class as well.
    func registerNib(_ cellClass: Swift.AnyClass) {
        let id = String(describing: cellClass.self)
        let nib = UINib(nibName: id, bundle: nil)
        register(nib, forCellReuseIdentifier: id)
    }

    /// Registers a class for use in creating new table cells.
    /// Note: forCellReuseIdentifier must equal to the Cell Class.
    func register(_ cellClass: Swift.AnyClass) {
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass.self))
    }

    /// Registers a class for use in creating new table header or footer views.
    /// Note: forHeaderFooterViewReuseIdentifier must equal to the UITableViewHeaderFooterView Class.
    func registerHeaderFooterViewClass(_ headerFooterViewClass: Swift.AnyClass) {
        register(headerFooterViewClass, forHeaderFooterViewReuseIdentifier: String(describing: headerFooterViewClass.self))
    }

    /// Registers a nib object containing a header or footer with the table view under a specified identifier.
    /// Nib name must be equal to the UITableViewHeaderFooterView Class, and the forHeaderFooterViewReuseIdentifier must equal to UITableViewHeaderFooterView Class as well.
    func registerHeaderFooterViewNib(_ headerFooterViewClass: Swift.AnyClass) {
        let id = String(describing: headerFooterViewClass.self)
        let nib = UINib(nibName: id, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: id)
    }
}
#endif
