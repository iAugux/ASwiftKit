// Created by Augus on 2021/6/17
// Copyright © 2021 Augus <iAugux@gmail.com>

import Foundation

public extension Swift.Optional where Wrapped: Numeric {
    var zeroIfNil: Wrapped { return self == nil ? .zero : self! }
}

public extension Swift.Optional where Wrapped == String {
    var emptyIfNil: String { return self == nil ? "" : self! }
}
