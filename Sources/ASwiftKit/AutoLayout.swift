// Created by Augus on 2021/6/17
// Copyright © 2021 Augus <iAugux@gmail.com>

#if os(iOS)
import UIKit

public extension UIView {
    var safeTopAnchor: NSLayoutYAxisAnchor { safeAreaLayoutGuide.topAnchor }
    var safeBottomAnchor: NSLayoutYAxisAnchor { safeAreaLayoutGuide.bottomAnchor }
    var safeLeadingAnchor: NSLayoutXAxisAnchor { safeAreaLayoutGuide.leadingAnchor }
    var safeTrailingAnchor: NSLayoutXAxisAnchor { safeAreaLayoutGuide.trailingAnchor }
    var safeLeftAnchor: NSLayoutXAxisAnchor { safeAreaLayoutGuide.leftAnchor }
    var safeRightAnchor: NSLayoutXAxisAnchor { safeAreaLayoutGuide.rightAnchor }
}

public extension NSLayoutConstraint {
    @discardableResult func with(priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}

public extension UILayoutPriority {
    static var pseudoRequired: UILayoutPriority { return UILayoutPriority(rawValue: 999) }
    static var lowCompressionResistance: UILayoutPriority { return UILayoutPriority(rawValue: 740) }
    static var defaultCompressionResistance: UILayoutPriority { return UILayoutPriority(rawValue: 750) }
    static var highCompressionResistance: UILayoutPriority { return UILayoutPriority(rawValue: 760) }
    static var medium: UILayoutPriority { return UILayoutPriority(rawValue: 500) }
    static var lowHuggingPriority: UILayoutPriority { return UILayoutPriority(rawValue: 240) }
    static var defaultHuggingPriority: UILayoutPriority { return UILayoutPriority(rawValue: 250) }
    static var highHuggingPriority: UILayoutPriority { return UILayoutPriority(rawValue: 260) }
}

public extension UIView {
    func addSubview(_ subview: UIView, pinningEdges edges: UIRectEdge, withInsets insets: UIEdgeInsets = .zero) {
        addSubview(subview)
        subview.pinEdges(edges, to: self, withInsets: insets, useSafeArea: false)
    }

    func addSubview(_ subview: UIView, pinningEdgesToSafeArea edges: UIRectEdge, withInsets insets: UIEdgeInsets = .zero) {
        addSubview(subview)
        subview.pinEdges(edges, to: self, withInsets: insets, useSafeArea: true)
    }

    func insertSubview(_ subview: UIView, at index: Int, pinningEdges edges: UIRectEdge, withInsets insets: UIEdgeInsets = .zero) {
        insertSubview(subview, at: index)
        subview.pinEdges(edges, to: self, withInsets: insets, useSafeArea: false)
    }

    func insertSubview(_ subview: UIView, at index: Int, pinningEdgesToSafeArea edges: UIRectEdge, withInsets insets: UIEdgeInsets = .zero) {
        insertSubview(subview, at: index)
        subview.pinEdges(edges, to: self, withInsets: insets, useSafeArea: true)
    }

    func insertSubview(_ subview: UIView, aboveSubview siblingSubview: UIView, pinningEdges edges: UIRectEdge, withInsets insets: UIEdgeInsets = .zero) {
        insertSubview(subview, aboveSubview: siblingSubview)
        subview.pinEdges(edges, to: self, withInsets: insets, useSafeArea: false)
    }

    func insertSubview(_ subview: UIView, aboveSubview siblingSubview: UIView, pinningEdgesToSafeArea edges: UIRectEdge, withInsets insets: UIEdgeInsets = .zero) {
        insertSubview(subview, aboveSubview: siblingSubview)
        subview.pinEdges(edges, to: self, withInsets: insets, useSafeArea: true)
    }

    func insertSubview(_ subview: UIView, belowSubview siblingSubview: UIView, pinningEdges edges: UIRectEdge, withInsets insets: UIEdgeInsets = .zero) {
        insertSubview(subview, belowSubview: siblingSubview)
        subview.pinEdges(edges, to: self, withInsets: insets, useSafeArea: false)
    }

    func insertSubview(_ subview: UIView, belowSubview siblingSubview: UIView, pinningEdgesToSafeArea edges: UIRectEdge, withInsets insets: UIEdgeInsets = .zero) {
        insertSubview(subview, belowSubview: siblingSubview)
        subview.pinEdges(edges, to: self, withInsets: insets, useSafeArea: true)
    }

    /// - Returns: [.left, .top, .right, .bottom]
    @discardableResult
    func pinEdges(_ edges: UIRectEdge = .all, to view: UIView, withInsets insets: UIEdgeInsets = .zero, useSafeArea: Bool = false) -> [NSLayoutConstraint] {
        guard edges != [] else { preconditionFailure() }
        translatesAutoresizingMaskIntoConstraints = false
        func nonSafeAreaCondition() -> [NSLayoutConstraint] {
            var constraints: [NSLayoutConstraint] = []
            if edges.contains(.left) { constraints.append(leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left)) }
            if edges.contains(.top) { constraints.append(topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top)) }
            if edges.contains(.right) { constraints.append(trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right)) }
            if edges.contains(.bottom) { constraints.append(bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom)) }
            NSLayoutConstraint.activate(constraints)
            return constraints
        }
        guard useSafeArea else { return nonSafeAreaCondition() }
        if #available(iOS 11.0, *) {
            var constraints: [NSLayoutConstraint] = []
            if edges.contains(.left) { constraints.append(leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: insets.left)) }
            if edges.contains(.top) { constraints.append(topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: insets.top)) }
            if edges.contains(.right) { constraints.append(trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -insets.right)) }
            if edges.contains(.bottom) { constraints.append(bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -insets.bottom)) }
            NSLayoutConstraint.activate(constraints)
            return constraints
        } else {
            return nonSafeAreaCondition()
        }
    }

    func addSubview(_ subview: UIView, constrainedToCenterWithOffset offset: CGPoint) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        let constraints: [NSLayoutConstraint] = [
            subview.centerXAnchor.constraint(equalTo: centerXAnchor, constant: offset.x),
            subview.centerYAnchor.constraint(equalTo: centerYAnchor, constant: offset.y),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

public extension UIView {
    @discardableResult func constrainSize(to size: CGSize, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        let constraints = [widthAnchor.constraint(equalToConstant: size.width).with(priority: priority), heightAnchor.constraint(equalToConstant: size.height).with(priority: priority)]
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    @discardableResult func constrainWidth(to width: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = widthAnchor.constraint(equalToConstant: width).with(priority: priority)
        constraint.isActive = true
        return constraint
    }

    @discardableResult func constrainHeight(to height: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = heightAnchor.constraint(equalToConstant: height).with(priority: priority)
        constraint.isActive = true
        return constraint
    }
}
#endif
