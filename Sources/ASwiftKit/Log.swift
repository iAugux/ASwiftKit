// Created by Augus on 2021/6/17
// Copyright © 2021 Augus <iAugux@gmail.com>

import Foundation

#if DEBUG
public func ASLog(_ message: Any?, filename: NSString = #file, function: String = #function, line: Int = #line) {
    NSLog("[\(filename.lastPathComponent):\(line)] \(function) - \(String(describing: message))")
}

public func ASWarn(_ message: Any?, filename: NSString = #file, function: String = #function, line: Int = #line) {
    NSLog("[\(filename.lastPathComponent):\(line)] \(function) - ⚠️ Warning: \(String(describing: message))")
}

public func ASError(_ message: Any?, filename: NSString = #file, function: String = #function, line: Int = #line) {
    NSLog("[\(filename.lastPathComponent):\(line)] \(function) - ❌ Error: \(String(describing: message))")
}

public func ASPrint(_ any: Any?) { print(any ?? "nil") }
public func ASPrint(_ any: Any?, prefix: String = "", suffix: String = "") { print(prefix + String(describing: any) + suffix) }
#else
public func ASLog(_ message: Any?, filename: NSString = #file, function: String = #function, line: Int = #line) {}
public func ASWarn(_ message: Any?, filename: NSString = #file, function: String = #function, line: Int = #line) {}
public func ASError(_ message: Any?, filename: NSString = #file, function: String = #function, line: Int = #line) {}
public func ASPrint(_ any: Any?) {}
public func ASPrint(_ any: Any?, prefix: String = "", suffix: String = "") {}
#endif
