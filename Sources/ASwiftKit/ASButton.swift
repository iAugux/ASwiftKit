// Created by Augus on 2021/6/17
// Copyright © 2021 Augus <iAugux@gmail.com>

#if os(iOS)
import UIKit

/// A UIButton with custom clickable area.
public class ASButton: UIButton {
    public var clickableArea: CGSize = .zero
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard clickableArea.width > .zero else { return super.hitTest(point, with: event) }
        let minimalWidth = clickableArea.width, minimalHeight = clickableArea.height
        let buttonWidth = frame.width, buttonHeight = frame.height
        let widthToAdd = (minimalWidth - buttonWidth > 0) ? minimalWidth - buttonWidth : 0
        let heightToAdd = (minimalHeight - buttonHeight > 0) ? minimalWidth - buttonHeight : 0
        let largerFrame = CGRect(x: -widthToAdd / 2, y: -heightToAdd / 2, width: buttonWidth + widthToAdd, height: buttonHeight + heightToAdd)
        return largerFrame.contains(point) ? self : nil
    }
}
#endif
