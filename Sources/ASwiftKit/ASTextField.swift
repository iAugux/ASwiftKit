// Created by Augus on 2021/6/17
// Copyright © 2021 Augus <iAugux@gmail.com>

#if os(iOS)
import UIKit

/// An UITextField with custom insets.
open class ASTextField: UITextField {
    public var insets: UIEdgeInsets = .zero { didSet { setNeedsDisplay() } }
    public convenience init(insets: UIEdgeInsets, textAlignment: NSTextAlignment = .left) {
        self.init()
        self.textAlignment = textAlignment
        self.insets = insets
    }

    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds).inset(by: insets)
    }

    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: bounds).inset(by: insets)
    }
}
#endif
