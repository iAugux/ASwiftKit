// Created by Augus on 9/7/23
// Copyright © 2023 Augus <iAugux@gmail.com>

import Foundation

public enum Convention {}

public extension Convention {
    static func hexString(_ hex: UInt) -> String {
        String(format: "%06X", hex)
    }
}
