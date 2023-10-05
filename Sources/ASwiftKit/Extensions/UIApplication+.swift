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

extension UIViewController {
    public static var current: UIViewController {
        var scenes = UIApplication.shared.connectedScenes.filter { $0.activationState == .foregroundActive }
        if scenes.isEmpty {
            // If it's called just after app launched, there may be no active scenes at all.
            scenes = UIApplication.shared.connectedScenes.filter { $0.activationState == .foregroundInactive }
        }
        guard let scene = (scenes.compactMap { $0 as? UIWindowScene }).first else {
            return UIViewController()
        }
        guard let vc = scene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            return UIViewController()
        }
        return vc.findBestViewController()
    }

    private func findBestViewController() -> UIViewController {
        if let vc = presentedViewController {
            // returns presented view controller
            return vc
        } else if let vc = self as? UISplitViewController {
            // returns right hand side
            return vc.viewControllers.last ?? vc
        } else if let vc = self as? UINavigationController {
            // returns top view controller
            return vc.topViewController ?? vc
        } else if let vc = self as? UITabBarController {
            // returns visible view
            return vc.selectedViewController ?? vc
        } else {
            return self
        }
    }
}
#endif
