// Created by Augus on 2021/10/10
// Copyright © 2021 Augus <iAugux@gmail.com>

#if os(iOS)
import UIKit

public extension UIApplication {
    /// Get first current key window with sepcific states.
    /// - Parameter states: States, order matters here.
    /// - Returns: The key window, `nil` if not found.
    func currentKeyWindow(states: UIScene.ActivationState...) -> UIWindow? {
        connectedScenes
            .filter { states.contains($0.activationState) }
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .filter { $0.isKeyWindow }
            .first
    }

    var firstActivedWindowScene: UIWindowScene? {
        connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first
    }
}
#endif
