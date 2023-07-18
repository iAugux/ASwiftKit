// Created by Augus on 7/18/23
// Copyright © 2023 Augus <iAugux@gmail.com>

import Foundation

public protocol Arithmetic: Comparable {
    var int: Int { get }
    var double: Double { get }
    var cgFloat: CGFloat { get }
    init(_ x: Int)
    init(_ x: Double)
    init(_ x: Float)
    init(_ x: CGFloat)
    static prefix func - (x: Self) -> Self
    static func + (lhs: Self, rhs: Self) -> Self
    static func * (lhs: Self, rhs: Self) -> Self
    static func - (lhs: Self, rhs: Self) -> Self
    static func / (lhs: Self, rhs: Self) -> Self
    static func += (lhs: inout Self, rhs: Self)
    static func -= (lhs: inout Self, rhs: Self)
    static func *= (lhs: inout Self, rhs: Self)
    static func /= (lhs: inout Self, rhs: Self)
}

extension Int: Arithmetic {
    @available(*, deprecated, message: "unnecessary")
    public var int: Int { return self } // `Int()` is unnecessary here, but just for convenience
    public var double: Double { return Double(self) }
    public var cgFloat: CGFloat { return CGFloat(self) }
}

extension Int8: Arithmetic {
    public var int: Int { return Int(self) }
    public var double: Double { return Double(self) }
    public var cgFloat: CGFloat { return CGFloat(self) }
}

extension Int16: Arithmetic {
    public var int: Int { return Int(self) }
    public var double: Double { return Double(self) }
    public var cgFloat: CGFloat { return CGFloat(self) }
}

extension Int32: Arithmetic {
    public var int: Int { return Int(self) }
    public var double: Double { return Double(self) }
    public var cgFloat: CGFloat { return CGFloat(self) }
}

extension Int64: Arithmetic {
    public var int: Int { return Int(self) }
    public var double: Double { return Double(self) }
    public var cgFloat: CGFloat { return CGFloat(self) }
}

extension Float: Arithmetic {
    public var int: Int { return Int(self) }
    public var double: Double { return Double(self) }
    public var cgFloat: CGFloat { return CGFloat(self) }
}

extension Double: Arithmetic {
    public var int: Int { return Int(self) }
    @available(*, deprecated, message: "unnecessary")
    public var double: Double { return self } // `Double()` is unnecessary here, but just for convenience
    public var cgFloat: CGFloat { return CGFloat(self) }
}

extension CGFloat: Arithmetic {
    public var int: Int { return Int(self) }
    public var double: Double { return Double(self) }
    @available(*, deprecated, message: "unnecessary")
    public var cgFloat: CGFloat { return self } // `CGFloat()` is unnecessary here, but just for convenience
}

public func plus<T: Arithmetic>(_ a: T, _ b: T) -> T { return a + b }
public func minus<T: Arithmetic>(_ a: T, _ b: T) -> T { return a - b }
public func multiply<T: Arithmetic>(_ a: T, _ b: T) -> T { return a * b }
public func divide<T: Arithmetic>(_ a: T, _ b: T) -> T { return a / b }

public extension Double {
    func floatingPointValueToInt() -> Int? { return isFinite ? Int(self) : nil }
}

public extension Double {
    func trimmed(decimals count: Int? = nil) -> String {
        if let count {
            return String(format: "%.\(count)f", self)
        } else {
            return truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
        }
    }
}

public extension Float {
    func trimmed(decimals count: Int? = nil) -> String {
        if let count {
            return String(format: "%.\(count)f", self)
        } else {
            return truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
        }
    }
}
