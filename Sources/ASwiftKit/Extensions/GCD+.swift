// Created by Augus on 5/25/23
// Copyright © 2023 Augus <iAugux@gmail.com>

#if os(macOS)
import AppKit
#elseif os(iOS) || os(watchOS)
import Foundation
#endif

public func delay(in seconds: TimeInterval, execute work: @escaping @convention(block) () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: work)
}

public func runInMainQueue(execute work: @escaping @convention(block) () -> Void) {
    if Thread.isMainThread {
            work()
    } else {
        DispatchQueue.main.async(execute: work)
    }
}
