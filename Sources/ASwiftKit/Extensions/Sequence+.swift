// Created by Augus on 7/18/23
// Copyright © 2023 Augus <iAugux@gmail.com>

import Foundation

extension Array {
    public func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }

    /// Splits the receiving array into multiple arrays
    ///
    /// - Parameter subCollectionCount: The number of output arrays the receiver should be divided into
    /// - Returns: An array containing `subCollectionCount` arrays. These arrays will be filled round robin style from the receiving array.
    /// So if the receiver was `[0, 1, 2, 3, 4, 5, 6]` the output would be `[[0, 3, 6], [1, 4], [2, 5]]`. If the reviever is empty the output
    /// Will still be `subCollectionCount` arrays, they just all will be empty. This way it's always safe to subscript into the output.
    /// https://stackoverflow.com/a/54636086/4656574
    private func split(subCollectionCount: Int) -> [[Element]] {
        precondition(subCollectionCount > 1, "Can't split the array unless you ask for > 1")
        var output: [[Element]] = []
        (0 ..< subCollectionCount).forEach { outputIndex in
            let indexesToKeep = stride(from: outputIndex, to: count, by: subCollectionCount)
            let subCollection = enumerated().filter { indexesToKeep.contains($0.offset) }.map { $0.element }
            output.append(subCollection)
        }
        precondition(output.count == subCollectionCount)
        return output
    }
}

public extension MutableCollection {
    /// REFERENCE: https://stackoverflow.com/a/24029847
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            // Change `Int` in the next line to `IndexDistance` in < Swift 4.1
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

public extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

public extension Collection {
    subscript(ifPresent index: Index) -> Element? {
        return (index >= startIndex && index < endIndex) ? self[index] : nil
    }
}

public extension Collection where Element: Numeric {
    var sum: Element { return reduce(0, +) }
}

public extension Collection where Element: BinaryInteger {
    /// Returns `0` if it's empty
    var average: Double { return isEmpty ? 0 : Double(sum) / Double(count) }
}

public extension Collection where Element: BinaryFloatingPoint {
    /// Returns `0` if it's empty
    var average: Element { return isEmpty ? 0 : sum / Element(count) }
}

public extension Array {
    func find(_ includedElement: (Element) -> Bool) -> Int? {
        for (idx, element) in enumerated() {
            if includedElement(element) {
                return idx
            }
        }
        return nil
    }

    @available(iOS, deprecated, message: "prefer: 'array[ifPresent: index]'")
    /// Find the element at the specific index
    /// No need to use this to find the first element, just use `aArray.first`
    func object(_ atIndex: Int) -> Element? {
        guard atIndex >= startIndex, atIndex < endIndex else { return nil }
        return self[atIndex]
    }

    mutating func append(newElements: [Element]) {
        self = (self + newElements)
    }
}

public extension Sequence where Element: Equatable {
    var originalOrderUnique: [Element] {
        reduce([]) { $0.contains($1) ? $0 : $0 + [$1] }
    }

    func originalOrderUnique(where compare: (Element, Element) -> Bool) -> [Element] {
        reduce([]) { element0, element1 in
            element0.contains { compare(element1, $0) } ? element0 : element0 + [element1]
        }
    }
}

public extension Sequence where Iterator.Element: Hashable {
    var unique: [Iterator.Element] {
        return Array(Set(self))
    }
}

public extension Sequence {
    // REFERENCE: https://stackoverflow.com/questions/31220002/how-to-group-by-the-elements-of-an-array-in-swift
    @available(swift, deprecated: 4.0, message: "Please use 'Dictionary(grouping:, by:)'")
    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U: [Iterator.Element]] {
        var categories: [U: [Iterator.Element]] = [:]
        for element in self {
            let key = key(element)
            if case nil = categories[key]?.append(element) { categories[key] = [element] }
        }
        return categories
    }
}

public extension Array where Element: Equatable {
    /// Move an item to a specific index, if the index doesn't exist, will do nothing.
    ///
    /// - Parameters:
    ///   - item: The item needs to move.
    ///   - newIndex: The destination index.
    mutating func move(item: Element, to newIndex: Index) {
        guard let index = firstIndex(of: item) else { return }
        move(at: index, to: newIndex)
    }

    /// Bring the specific item to the first index, if the item doesn't exist, will do nothing.
    ///
    /// - Parameter item: The item needs to move.
    mutating func bringToFront(item: Element) {
        move(item: item, to: 0)
    }

    /// Send the specific item to the last index, if the item doesn't exist, will do nothing.
    ///
    /// - Parameter item: The item needs to move.
    mutating func sendToBack(item: Element) {
        move(item: item, to: endIndex - 1)
    }
}

public extension Array {
    /// - Note: You'll need to guarantee the indexes are exist, that means index should not be out of range.
    mutating func move(at index: Index, to newIndex: Index) {
        insert(remove(at: index), at: newIndex)
    }
}

public extension Repeated {
    func toArray() -> [Element] {
        Array(self)
    }
}

public extension RangeReplaceableCollection where Element: Equatable {
    mutating func toggleElement(_ element: Element) {
        if let index = self.firstIndex(of: element) {
            // Element exists, remove it
            remove(at: index)
        } else {
            // Element doesn't exist, add it
            append(element)
        }
    }
}
