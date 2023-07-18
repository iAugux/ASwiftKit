// Created by Augus on 2021/6/17
// Copyright © 2021 Augus <iAugux@gmail.com>

import Foundation

/// Call something but don't do anything to it. like `let _ = something`
@inline(never) // prevents the passed argument from being optimized away by the compiler
public func touch(_ any: Any?) {}

/// Returns `f(x)` if `x` is non-`nil`; otherwise returns `nil`
@discardableResult public func given<T, U>(_ x: T?, _ f: (T) -> U?) -> U? { return x != nil ? f(x!) : nil }
@discardableResult public func given<T, U, V>(_ x: T?, _ y: U?, _ f: (T, U) -> V?) -> V? { return (x != nil && y != nil) ? f(x!, y!) : nil }

/// Initializes and configures a given NSObject.
/// This utility method can be used to cut down boilerplate code.
public func create<T: NSObject>(constructing construct: (T) -> Void) -> T {
    let obj = T()
    construct(obj)
    return obj
}

/// Helper to do something like: `let foo: T = SomeOptionalT ?? preconditionFailure()`
public func preconditionFailure<T>(_ message: @autoclosure () -> String = String(), file: StaticString = #file, line: UInt = #line) -> T {
    Swift.preconditionFailure(message(), file: file, line: line)
}

public func abstract(function: String = #function, file: StaticString = #file, line: UInt = #line) -> Never {
    Swift.preconditionFailure("Abstract method not implemented", file: file, line: line)
}
