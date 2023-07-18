// Created by Augus on 2021/6/17
// Copyright © 2021 Augus <iAugux@gmail.com>

#if os(macOS)
import AppKit
#elseif os(iOS) || os(watchOS)
import UIKit
#endif

public extension String {
    init?(number: Int, zero: String?, singular: String, pluralFormat: String) {
        switch number {
        case 0: if let zero { self.init(zero) } else { return nil }
        case 1: self.init(singular)
        default: self.init(pluralFormat)
        }
    }
}

public extension String {
    /// Get a formatted string based on the number passed.
    /// - parameter format: `NSLocalizedString` containing one `%@` for where the conditionalized numbered string goes, e.g. `NSLocalizedString(@"You Have %@", nil)`, or simply `"%@"` (the default) without `NSLocalizedString` if there're no other words to be localized.
    /// - parameter number: The number you want to conditionalize on.
    /// - parameter zero: `NSLocalizedString` containing no placeholders (optional), e.g. `NSLocalizedString(@"No Friend", nil)`.
    /// - parameter singular: `NSLocalizedString` containing no placeholders, `e.g. NSLocalizedString(@"One Friend", nil)`.
    /// - parameter pluralFormat: `NSLocalizedString` containing one `%@` for where the conditionalized number goes, e.g. `NSLocalizedString(@"%@ Friends", nil)`.
    init(format: String = "%@", number: Decimal, zero: String? = nil, singular: String, pluralFormat: String) {
        let numberString: String
        if number == 0, let zero {
            numberString = zero
        } else if abs(number) == 1 {
            numberString = singular
        } else {
            numberString = String(format: pluralFormat, number as NSNumber)
        }
        self = String(format: format, numberString)
    }

    init(format: String = "%@", number: Int, zero: String? = nil, singular: String, pluralFormat: String) {
        self.init(format: format, number: Decimal(number), zero: zero, singular: singular, pluralFormat: pluralFormat)
    }
}

public extension String {
    func trimmed() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var trimmedNilIfEmpty: String? {
        let t = trimmed()
        return t.isEmpty ? nil : t
    }

    mutating func replaceOccurrences(with dictionary: [String: String]) {
        self = self.replacingOccurrences(with: dictionary)
    }

    func replacingOccurrences(of: [String], with: String) -> String {
        var str = self
        of.forEach { str = str.replacingOccurrences(of: $0, with: with) }
        return str
    }

    func replacingOccurrences(with dictionary: [String: String]) -> String {
        var string = self
        dictionary.forEach {
            string = string.replacingOccurrences(of: $0.key, with: $0.value)
        }
        return string
    }

    var boolValue: Bool {
        NSString(string: self).boolValue
    }

    var encodeURLComponent: String {
        self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
    }

    var decodeURLComponent: String {
        self.components(separatedBy: "+").joined(separator: " ").removingPercentEncoding ?? self
    }

    var isValidEmail: Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: self)
    }
}

#if os(iOS)
public extension String {
    func size(maxWidth: CGFloat = .greatestFiniteMagnitude, maxHeight: CGFloat = .greatestFiniteMagnitude, font: UIFont, ceiled: Bool = false) -> CGSize {
        return size(maxWidth: maxWidth, maxHeight: maxHeight, attributes: [NSAttributedString.Key.font: font], ceiled: ceiled)
    }

    func size(maxWidth: CGFloat = .greatestFiniteMagnitude, maxHeight: CGFloat = .greatestFiniteMagnitude, attributes: [NSAttributedString.Key: Any], ceiled: Bool = false) -> CGSize {
        let size = (self as NSString).boundingRect(with: CGSize(width: maxWidth, height: maxHeight), options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size
        return ceiled ? ceil(size) : size
    }
}

public extension NSAttributedString {
    func size(maxWidth: CGFloat = .greatestFiniteMagnitude, maxHeight: CGFloat = .greatestFiniteMagnitude, ceiled: Bool = false) -> CGSize {
        let size = boundingRect(with: CGSize(width: maxWidth, height: maxHeight), options: .usesLineFragmentOrigin, context: nil).size
        return ceiled ? ceil(size) : size
    }
}
#endif

public extension NSAttributedString {
    func trimmedNewlines() -> NSAttributedString {
        var att = self
        while att.string.first == "\n" { att = att.attributedSubstring(from: NSRange(location: 1, length: att.string.count - 1)) }
        while att.string.last == "\n" { att = att.attributedSubstring(from: NSRange(location: 0, length: att.string.count - 1)) }
        return att
    }
}

public extension NSAttributedString {
    convenience init(htmlString: String) throws {
        guard let data = htmlString.data(using: .utf8) else {
            throw NSError(domain: "com.iAugus.error", code: 0, userInfo: nil)
        }
        try self.init(htmlData: data)
    }

    convenience init(htmlData: Data) throws {
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue]
        try self.init(data: htmlData, options: options, documentAttributes: nil)
    }
}

private func ceil(_ size: CGSize) -> CGSize {
    return CGSize(width: ceil(size.width), height: ceil(size.height))
}
