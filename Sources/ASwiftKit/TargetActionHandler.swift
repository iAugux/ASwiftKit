// Created by Augus on 2021/6/17
// Copyright © 2021 Augus <iAugux@gmail.com>

#if os(iOS)
import UIKit

public extension Selector {
    /// Selectors can be used as unique `void *` keys, this gets that key.
    var key: UnsafeRawPointer { return unsafeBitCast(self, to: UnsafeRawPointer.self) }
}

public extension NSObject {
    func getAssociatedValue(for key: UnsafeRawPointer) -> Any? {
        return objc_getAssociatedObject(self, key)
    }

    func setAssociatedValue(_ value: Any?, forKey key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

public class TargetActionHandler: NSObject {
    private let action: Closure
    fileprivate var removeAction: Closure?
    fileprivate init(_ action: @escaping () -> Void) { self.action = action }
    @objc fileprivate func invoke() { action() }
    public func remove() { removeAction?() }
}

public extension UIGestureRecognizer {
    @discardableResult
    func addHandler(_ handler: @escaping Closure) -> TargetActionHandler {
        let target = TargetActionHandler(handler)
        target.removeAction = { [weak self, unowned target] in self?.removeTarget(target, action: nil) }
        addTarget(target, action: #selector(TargetActionHandler.invoke))
        setAssociatedValue(target, forKey: unsafeBitCast(target, to: UnsafeRawPointer.self)) // Retain for lifetime of receiver
        return target
    }

    convenience init<T: UIGestureRecognizer>(handler: @escaping Handler<T>) {
        self.init()
        self.addHandler {
            handler(self as! T)
        }
    }
}

public extension UIControl {
    @discardableResult
    func addHandler(for events: UIControl.Event, handler: @escaping Closure) -> TargetActionHandler {
        let target = TargetActionHandler(handler)
        target.removeAction = { [weak self, unowned target] in self?.removeTarget(target, action: nil, for: .allEvents) }
        addTarget(target, action: #selector(TargetActionHandler.invoke), for: events)
        setAssociatedValue(target, forKey: unsafeBitCast(target, to: UnsafeRawPointer.self)) // Retain for lifetime of receiver
        return target
    }
}

public extension UIButton {
    @discardableResult
    func addTapHandler(_ handler: @escaping Closure) -> TargetActionHandler {
        return addHandler(for: .touchUpInside, handler: handler)
    }
}

public extension UIBarButtonItem {
    convenience init(title: String, style: UIBarButtonItem.Style = .plain, handler: @escaping Closure) {
        let target = TargetActionHandler(handler)
        self.init(title: title, style: style, target: target, action: #selector(TargetActionHandler.invoke))
        setAssociatedValue(target, forKey: unsafeBitCast(target, to: UnsafeRawPointer.self)) // Retain for lifetime of receiver
    }

    convenience init(image: UIImage?, style: UIBarButtonItem.Style = .plain, handler: @escaping Closure) {
        let target = TargetActionHandler(handler)
        self.init(image: image, style: style, target: target, action: #selector(TargetActionHandler.invoke))
        setAssociatedValue(target, forKey: unsafeBitCast(target, to: UnsafeRawPointer.self)) // Retain for lifetime of receiver
    }

    convenience init(barButtonSystemItem systemItem: UIBarButtonItem.SystemItem, handler: @escaping Closure) {
        let target = TargetActionHandler(handler)
        self.init(barButtonSystemItem: systemItem, target: target, action: #selector(TargetActionHandler.invoke))
        setAssociatedValue(target, forKey: unsafeBitCast(target, to: UnsafePointer.self))
    }
}
#endif
