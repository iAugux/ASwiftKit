// Created by Augus on 6/11/23
// Copyright © 2023 Augus <iAugux@gmail.com>

import Foundation

public extension FileManager {
    func string(at url: URL, encoding: String.Encoding = .utf8) -> String? {
        guard let data = contents(atPath: url.path) else { return nil }
        return String(data: data, encoding: encoding)
    }
}
