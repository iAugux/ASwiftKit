// Created by Augus on 2021/6/17
// Copyright © 2021 Augus <iAugux@gmail.com>

#if os(iOS)
import UIKit

/// An UILabel with custom insets.
public class ASLabel: UILabel {
    public var insets: UIEdgeInsets = .zero { didSet { setNeedsDisplay() } }
    public convenience init(padding: UIEdgeInsets) {
        self.init()
        self.insets = padding
    }

    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }

    public override var intrinsicContentSize: CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + insets.left + insets.right
        let heigth = superContentSize.height + insets.top + insets.bottom
        return CGSize(width: width, height: heigth)
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let width = superSizeThatFits.width + insets.left + insets.right
        let heigth = superSizeThatFits.height + insets.top + insets.bottom
        return CGSize(width: width, height: heigth)
    }
}
#endif
