// Created by Augus on 7/18/23
// Copyright © 2023 Augus <iAugux@gmail.com>

import Foundation

// MARK: - Clamp number
public extension Comparable {
    func clamped(lower: Self) -> Self {
        return self < lower ? lower : self
    }

    func clamped(upper: Self) -> Self {
        return self > upper ? upper : self
    }

    func clamped(lower: Self, upper: Self) -> Self {
        return min(max(self, lower), upper)
    }

    func clamped(_ value1: Self, _ value2: Self) -> Self {
        return min(max(self, min(value1, value2)), max(value1, value2))
    }

    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
