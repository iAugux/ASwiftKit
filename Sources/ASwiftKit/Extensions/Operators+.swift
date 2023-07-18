// Created by Augus on 7/18/23
// Copyright © 2023 Augus <iAugux@gmail.com>

import Foundation

/// "augus" == ("augus", "n") is true
public func == (lhs: String?, rhs: (String, String)) -> Bool {
    return lhs == rhs.0 || lhs == rhs.1
}

/// "augus" ~= ("Augus", "n") is true
public func ~= (lhs: String?, rhs: (String, String)) -> Bool {
    return lhs ~= rhs.0 || lhs ~= rhs.1
}

/// "augus" ~= "Augus" is true
public func ~= (lhs: String?, rhs: String?) -> Bool {
    guard lhs != rhs else { return true }
    return lhs?.lowercased() == rhs?.lowercased()
}

/// "123" == 123 is true
public func == (lhs: String, rhs: Int) -> Bool {
    return Int(lhs) == rhs
}

/// 123 == "123" is true
public func == (lhs: Int, rhs: String) -> Bool {
    return lhs == Int(rhs)
}

/// 1 ~= [2, 3, 1] is true
public func ~= <T: Comparable>(lhs: T?, rhs: [T]) -> Bool {
    return lhs != nil ? rhs.contains(lhs!) : false
}

/// Dictionary operator
public func += <K, V>(lhs: inout [K: V], rhs: [K: V]) {
    for (k, v) in rhs {
        lhs[k] = v
    }
}

/// Dictionary operator
public func + <K, V>(_ lhs: [K: V], _ rhs: [K: V]) -> [K: V] {
    var temp = lhs
    temp += rhs
    return temp
}

public func * (_ size: CGSize, _ ratio: CGFloat) -> CGSize {
    return CGSize(width: size.width * ratio, height: size.height * ratio)
}

public func / (_ size: CGSize, _ ratio: CGFloat) -> CGSize {
    return size * (1 / ratio)
}

public func + (_ lhs: CGSize, _ rhs: CGSize) -> CGSize {
    return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
}

postfix operator °
protocol IntegerInitializable: ExpressibleByIntegerLiteral { init(_: Int) }
extension Int: IntegerInitializable {
    public static postfix func ° (lhs: Int) -> CGFloat {
        return CGFloat(lhs) * .pi / 180
    }

    public static postfix func ° (lhs: Int) -> Double {
        return Double(lhs) * .pi / 180
    }
}
