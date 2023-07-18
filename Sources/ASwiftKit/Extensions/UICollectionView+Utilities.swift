// Created by Augus on 2021/6/17
// Copyright © 2021 Augus <iAugux@gmail.com>

#if os(iOS)
import UIKit

public extension UICollectionView {
    /// Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table.
    /// Note: withIdentifier must be equal to the Cell Class.
    func dequeueReusableCell<T: UICollectionViewCell>(with cell: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: String(describing: cell.self), for: indexPath) as! T
    }

    /// Registers a nib object containing a cell with the table view under a specified identifier.
    /// Nib name must be equal to the Cell Class, and the forCellReuseIdentifier must equal to Cell Class as well.
    func registerNib(_ cellClass: Swift.AnyClass) {
        let id = String(describing: cellClass.self)
        let nib = UINib(nibName: id, bundle: nil)
        register(nib, forCellWithReuseIdentifier: id)
    }

    /// Registers a class for use in creating new table cells.
    /// Note: forCellReuseIdentifier must equal to the Cell Class.
    func register(_ cellClass: Swift.AnyClass) {
        register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass.self))
    }

    func registerHeader(_ headerClass: Swift.AnyClass) {
        register(headerClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: headerClass.self))
    }

    func registerFooter(_ footerClass: Swift.AnyClass) {
        register(footerClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: footerClass.self))
    }

    func registerHeaderViewNib(_ header: Swift.AnyClass) {
        let id = String(describing: header.self)
        let nib = UINib(nibName: id, bundle: nil)
        register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: id)
    }

    func registerFooterViewNib(_ footer: Swift.AnyClass) {
        let id = String(describing: footer.self)
        let nib = UINib(nibName: id, bundle: nil)
        register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: id)
    }

    func dequeueReusableHeader<T: UIView>(with view: T.Type, for indexPath: IndexPath) -> T {
        let id = String(describing: view.self)
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: id, for: indexPath) as! T
    }

    func dequeueReusableFooter<T: UIView>(with view: T.Type, for indexPath: IndexPath) -> T {
        let id = String(describing: view.self)
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: id, for: indexPath) as! T
    }
}
#endif
