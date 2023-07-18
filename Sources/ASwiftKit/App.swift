// Created by Augus on 2021/6/17
// Copyright © 2021 Augus <iAugux@gmail.com>

import Foundation

public enum APP {
    public static var version: String? { return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String }
    public static var build: String? { return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String }
    public static func appStoreURL(with id: String) -> URL { return URL(string: appStorePath(with: id))! }
    public static func reviewURL(with id: String) -> URL { return URL(string: appStorePath(with: id) + "?action=write-review")! }
    public static func reviewsPageURL(with id: String) -> URL { return URL(string: "https://itunes.apple.com/app/viewContentsUserReviews?id=\(id)")! }
    private static func appStorePath(with id: String) -> String { return "https://itunes.apple.com/app/id\(id)" }
}
