// Created by Augus on 2021/6/17
// Copyright © 2021 Augus <iAugux@gmail.com>

#if os(iOS)
import SwiftUI
import UIKit

public extension UIColor {
    convenience init(hex: UInt, alpha: CGFloat = 1) {
        let red = CGFloat((hex >> 16) & 0xFF) / 255
        let green = CGFloat((hex >> 8) & 0xFF) / 255
        let blue = CGFloat((hex >> 0) & 0xFF) / 255
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        let formatted = hex.replacingOccurrences(of: ["0x", "#"], with: "")
        guard let hex = Int(formatted, radix: 16) else { return nil }
        let red = CGFloat(CGFloat((hex & 0xFF0000) >> 16) / 255.0)
        let green = CGFloat(CGFloat((hex & 0x00FF00) >> 8) / 255.0)
        let blue = CGFloat(CGFloat((hex & 0x0000FF) >> 0) / 255.0)
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    func toHex() -> UInt {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb = Int(r * 255) << 16 | Int(g * 255) << 8 | Int(b * 255) << 0
        return UInt(max(0, rgb))
    }

    func toHexString(uppercased: Bool = false) -> String {
        let rgb = toHex()
        let result = String(format: "#%06x", rgb)
        return uppercased ? result.uppercased() : result
    }

    var alpha: CGFloat {
        var h = CGFloat(0)
        var s = CGFloat(0)
        var b = CGFloat(0)
        var a = CGFloat(0)
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return a
    }

    var components: UnsafePointer<CGFloat> { return cgColor.__unsafeComponents! }
    var cRed: CGFloat { return components[0] }
    var cGreen: CGFloat { return components[1] }
    var cBlue: CGFloat { return components[2] }
    func alpha(_ alpha: CGFloat) -> UIColor { return withAlphaComponent(alpha) }
    /// Compare two colors
    ///
    /// - Parameters:
    ///   - color: color to be compared
    ///   - tolerance: tolerance (0.0 ~ 1.0)
    /// - Returns: result
    func isEqual(to color: UIColor, withTolerance tolerance: CGFloat = 0.0) -> Bool {
        var r1: CGFloat = 0
        var g1: CGFloat = 0
        var b1: CGFloat = 0
        var a1: CGFloat = 0
        var r2: CGFloat = 0
        var g2: CGFloat = 0
        var b2: CGFloat = 0
        var a2: CGFloat = 0
        getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        return abs(r1 - r2) <= tolerance && abs(g1 - g2) <= tolerance && abs(b1 - b2) <= tolerance && abs(a1 - a2) <= tolerance
    }

    static var random: UIColor {
        let randomRed = CGFloat(drand48())
        let randomGreen = CGFloat(drand48())
        let randomBlue = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }

    func darker(_ scale: CGFloat) -> UIColor {
        var h = CGFloat(0)
        var s = CGFloat(0)
        var b = CGFloat(0)
        var a = CGFloat(0)
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: b * scale, alpha: a)
    }

    func lighter(_ scale: CGFloat) -> UIColor {
        var h = CGFloat(0)
        var s = CGFloat(0)
        var b = CGFloat(0)
        var a = CGFloat(0)
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s * scale, brightness: b, alpha: a)
    }

    func whiter(_ scale: CGFloat) -> UIColor {
        return UIColor(red: cRed * scale, green: cGreen * scale, blue: cBlue, alpha: 1.0)
    }
}

public extension CGColor {
    var uiColor: UIColor { return UIColor(cgColor: self) }
}

@available(iOS 14.0, *)
public extension Color {
    func toHex() -> UInt {
        UIColor(self).toHex()
    }
}

#endif
