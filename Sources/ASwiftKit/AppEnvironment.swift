// Created by Augus on 7/30/23
// Copyright © 2023 Augus <iAugux@gmail.com>

import Foundation

public enum AppEnvironment: String {
    case development, production, sandbox
    public var isRelease: Bool { return self == .production }
    public var isDebug: Bool { return self == .development }
    public static var current: AppEnvironment {
#if DEBUG
        return .development
#else
        if Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt" { return .sandbox }
        return .production
#endif
    }
}

public extension AppEnvironment {
    @inline(__always)
    static let isRunningForPreviews: Bool = {
#if DEBUG
        // https://stackoverflow.com/a/61741858/4656574
        let key = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] ?? ""
        return Int(key) ?? 0 > 0
#else
        return false
#endif
    }()

    static let hardwareVersion: String = {
#if DEBUG
        // prevent Xcode Preivews from crashing
        return AppEnvironment.isRunningForPreviews ? "**Xcode Preivew**" : "**Debug Mode**"
#else
        var systemInfo = utsname()
        uname(&systemInfo)
        let versionCode = String(utf8String: NSString(bytes: &systemInfo.machine, length: Int(_SYS_NAMELEN), encoding: String.Encoding.ascii.rawValue)!.utf8String!)!
        return versionCode
#endif
    }()
}
