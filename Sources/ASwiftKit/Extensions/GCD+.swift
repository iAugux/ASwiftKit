// Created by Augus on 5/25/23
// Copyright © 2023 Augus <iAugux@gmail.com>

#if os(macOS)
import AppKit
#else
import Foundation
#endif

public func delay(in seconds: TimeInterval, execute work: @escaping @convention(block) () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: work)
}

public func runInMainQueue(force: Bool = false, execute work: @escaping @convention(block) () -> Void) {
    if force || !Thread.isMainThread {
        DispatchQueue.main.async(execute: work)
    } else {
        work()
    }
}

public func runInBackgroundQueue(qos: DispatchQoS.QoSClass = .default, execute work: @escaping @convention(block) () -> Void) {
    DispatchQueue.global(qos: qos).async(execute: work)
}
