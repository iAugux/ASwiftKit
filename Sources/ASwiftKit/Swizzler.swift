// Created by Augus on 2021/6/17
// Copyright © 2021 Augus <iAugux@gmail.com>

import Foundation

public enum Swizzler {
    static func swizzleMethods(for cls: AnyClass?, originalSelector: Selector, swizzledSelector: Selector) {
        guard let originalMethod = class_getInstanceMethod(cls, originalSelector),
              let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector)
        else {
            ASWarn("Can't find the selector to swizzle!")
            return
        }
        let didAddMethod = class_addMethod(cls, originalSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        if didAddMethod {
            class_replaceMethod(cls.self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}
