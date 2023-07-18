// Created by Augus on 6/3/23
// Copyright © 2023 Augus <iAugux@gmail.com>

#if os(iOS)
import UIKit

public extension UINavigationController {
    var previousViewController: UIViewController? {
        viewControllers[ifPresent: viewControllers.count - 2]
    }
}
#endif
