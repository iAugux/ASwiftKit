//  ASKit.swift
//  Created by Augus <iAugux@gmail.com>.
//  Copyright © 2015-2020 iAugus. All rights reserved.

#if os(macOS)
import AppKit
#elseif os(iOS) || os(watchOS)
import UIKit
#endif

// MARK: - Global variables & constants
/// Check is this a 64bit device
public let is_64_bit = MemoryLayout<Int>.size == MemoryLayout<Int64>.size

// MARK: - NSObject + Extensions
public extension NSObject {
    var className: String { String(describing: Self.self) }
}

#if os(iOS)
// MARK: - UIStoryboard、Xib Extensions
public extension UIStoryboard {
    /// Instantiates and returns the view controller with the specified identifier.
    /// Note: withIdentifier must equal to the vc Class
    func instantiateViewController<T: UIViewController>(with vc: T.Type) -> T {
        return instantiateViewController(withIdentifier: String(describing: vc.self)) as! T
    }

    static var Main: UIStoryboard { return UIStoryboard(name: "Main", bundle: nil) }
}

public extension UIView {
    /// Load view from nib. Note: Nib name must be equal to the class name.
    static func loadFromNib() -> Self { return loadFromNib(self) }
    private static func loadFromNib<T: UIView>(_ type: T.Type) -> T {
        return Bundle.main.loadNibNamed(String(describing: type), owner: nil, options: nil)![0] as! T
    }
}

// MARK: - UIScreen Extensions
public extension UIScreen {
    /// This will always return `.zero` in share extension
    static let safeAreaInsets = UIWindow().safeAreaInsets
    static var width: CGFloat { return UIScreen.main.bounds.width }
    static var height: CGFloat { return UIScreen.main.bounds.height }
}

// MARK: - CGRect Extensions
public extension CGRect {
    /// Returns a larger(or smaller if `height < 0`) height rect with same origin.
    func withExtra(width: CGFloat, height: CGFloat) -> CGRect {
        return inset(by: UIEdgeInsets(top: 0, left: 0, bottom: -height, right: -width))
    }
}

// MARK: - UITableView, UICollectionView, UITableViewCell, UICollectionViewCell, IndexPath extensions
public extension UITableView {
    var centerPoint: CGPoint { return CGPoint(x: center.x + contentOffset.x, y: center.y + contentOffset.y) }
    var centerCellIndexPath: IndexPath? { return indexPathForRow(at: centerPoint) }
    var visibleIndexPath: [IndexPath] { return visibleCells.compactMap { indexPath(for: $0) } }
    func cellForRow(at location: CGPoint) -> UITableViewCell? {
        guard let indexPath = indexPathForRow(at: location) else { return nil }
        return cellForRow(at: indexPath)
    }

    func reloadData(with animation: UITableView.RowAnimation) {
        reloadSections(IndexSet(integersIn: 0 ..< numberOfSections), with: animation)
    }

    func reloadVisibleRows(with animation: UITableView.RowAnimation = .none) {
        guard let ips = indexPathsForVisibleRows else { return }
        reloadRows(at: ips, with: animation)
    }
}

public extension UITableViewCell {
    var relatedTableView: UITableView? {
        var view = superview
        while view != nil, !(view is UITableView) { view = view?.superview }
        return view as? UITableView
    }

    func hideSeparator(_ flag: Bool = true) {
        separatorInset.right = .greatestFiniteMagnitude
    }
}

public extension UICollectionView {
    var centerPoint: CGPoint { return CGPoint(x: center.x + contentOffset.x, y: center.y + contentOffset.y) }
    var centerItemIndexPath: IndexPath? { return indexPathForItem(at: centerPoint) }
    var visibleIndexPath: [IndexPath] { return visibleCells.compactMap { indexPath(for: $0) } }
}

public extension UICollectionViewCell {
    var relatedCollectionView: UICollectionView? {
        var view = superview
        while view != nil, !(view is UICollectionView) { view = view?.superview }
        return view as? UICollectionView
    }
}

public extension IndexPath {
    // Actually there is no difference between `row` and `item`.
    func offsetBy(row: Int, section: Int = 0) -> IndexPath {
        return IndexPath(row: self.row + row, section: self.section + section)
    }

    func offsetBy(item: Int, section: Int = 0) -> IndexPath {
        return IndexPath(row: self.item + item, section: self.section + section)
    }
}

// MARK: - UITabBarController Extensions
extension UITabBarController {
    /// If the selected view controller is a navigation controller, then return the top view controller.
    var selectedTopViewController: UIViewController? {
        guard let selected = selectedViewController else { return nil }
        if let nav = selected as? UINavigationController { return nav.topViewController } else { return selected }
    }
}

// MARK: - UITabBar Extensions
public extension UITabBar {
    func frameOfItem(at index: Int) -> CGRect {
        var frames: [CGRect] = subviews.compactMap { if let v = $0 as? UIControl { return v.frame } else { return nil } }
        frames.sort { $0.origin.x < $1.origin.x }
        if frames.count > index { return frames[index] }
        return frames.last ?? .zero
    }

    func indexOfItem(at point: CGPoint) -> Int? {
        var frames: [CGRect] = subviews.compactMap { if let v = $0 as? UIControl { return v.frame } else { return nil } }
        frames.sort { $0.origin.x < $1.origin.x }
        for (index, rect) in frames.enumerated() { if rect.contains(point) { return index } }
        return nil
    }
}

// MARK: - UIDevice Extensions
public extension UIDevice {
    /// Normally, we don't need to detect iPhone X family device.
    /// Didn't use `UIApplication.shard.window` so that we can use it in app extensions.
    var hasNotch: Bool { return UIScreen.safeAreaInsets.bottom > 0 }
    var isPad: Bool { return UIDevice.current.userInterfaceIdiom == .pad }
    var isSimulator: Bool { let code = hardwareVersion; return code == "i386" || code == "x86_64" }
    var hardwareVersion: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let versionCode = String(utf8String: NSString(bytes: &systemInfo.machine, length: Int(_SYS_NAMELEN), encoding: String.Encoding.ascii.rawValue)!.utf8String!)!
        return versionCode
    }
}

public extension UIDevice {
    var isScreen3_5Inch: Bool {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        return max(w, h) == 480
    }

    var isScreen4Inch: Bool {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        return max(w, h) == 568
    }

    var isScreen4_7Inch: Bool {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        return max(w, h) == 667 && UIScreen.main.scale != 3.0
    }

    var isScreen5_5Inch: Bool {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let m = max(w, h)
        return m == 736 || (m == 667 && UIScreen.main.scale == 3.0)
    }
}

// MARK: - UIView Extensions
public extension UIView {
    convenience init(backgroundColor: UIColor?) {
        self.init()
        self.backgroundColor = backgroundColor
    }

    convenience init(wrapping subview: UIView, with insets: UIEdgeInsets = .zero) {
        self.init()
        addSubview(subview, pinningEdges: .all, withInsets: insets)
    }

    var parentViewController: UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController { return viewController }
        }
        return nil
    }

    func copiedView<T: UIView>() -> T {
        if #available(iOS 11.0, *) {
            return try! NSKeyedUnarchiver.unarchivedObject(ofClass: T.self, from: NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false))!
        } else {
            return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
        }
    }

    /// Set current view's absolute center to other view's center
    func centerTo(_ view: UIView) {
        frame.origin.x = view.bounds.midX - frame.width / 2
        frame.origin.y = view.bounds.midY - frame.height / 2
    }

    func addGestureRecognizers(_ gestures: [UIGestureRecognizer]) { gestures.forEach { addGestureRecognizer($0) } }
    func addGestureRecognizers(_ gestures: UIGestureRecognizer...) { addGestureRecognizers(gestures) }
}

public extension UIView {
    @objc var borderColor: UIColor? {
        get { return layer.borderColor?.uiColor }
        set { layer.borderColor = newValue?.cgColor }
    }

    @objc var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
}

// MARK: - UIGestureRecognizer Extensions
extension UIGestureRecognizer {
    /// Disable and re-enable again to cancel the gesture.
    func cancel() { isEnabled = false; isEnabled = true }
}

// MARK: - UIFeedbackGenerator Extensions
public enum HapticFeedbackConfig {
    public static var isEnabled = true
}

public extension UIImpactFeedbackGenerator {
    static func fire(_ style: FeedbackStyle) {
        guard HapticFeedbackConfig.isEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
}

public extension UINotificationFeedbackGenerator {
    static func fire(_ type: FeedbackType) {
        guard HapticFeedbackConfig.isEnabled else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}

public extension UISelectionFeedbackGenerator {
    static func fire() {
        guard HapticFeedbackConfig.isEnabled else { return }
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
}

// MARK: - Loop descendant views
public extension UIView {
    /// loop subviews and subviews' subviews
    ///
    /// - parameter closure: subview
    func loopDescendantViews(_ closure: (_ subView: UIView) -> Void) {
        for v in subviews {
            closure(v)
            v.loopDescendantViews(closure)
        }
    }

    /// loop subviews and subviews' subviews
    ///
    /// - parameter nameOfView:   name of subview
    /// - parameter shouldReturn: should return or not when meeting the specific subview
    /// - parameter execute:      subview
    func loopDescendantViews(_ nameOfView: String, shouldReturn: Bool = true, execute: (_ subView: UIView) -> Void) {
        for v in subviews {
            if v.className == nameOfView {
                execute(v)
                if shouldReturn { return }
            }
            v.loopDescendantViews(nameOfView, shouldReturn: shouldReturn, execute: execute)
        }
    }

    /// Get all descendant view with specific name
    ///
    /// - Parameter nameIfView: the view name
    /// - Returns: the results
    func getDescendantViews(_ nameOfView: String) -> [UIView] {
        var views: [UIView] = []
        loopDescendantViews(nameOfView, shouldReturn: false, execute: {
            views.append($0)
        })
        return views
    }
}

// MARK: - HitTest
public extension UIView {
    /// REFERENCE: http://stackoverflow.com/a/34774177/4656574
    /**
     1. We should not send touch events for hidden or transparent views, or views with userInteractionEnabled set to NO;
     2. If touch is inside self, self will be considered as potential result.
     3. Check recursively all subviews for hit. If any, return it.
     4. Else return self or nil depending on result from step 2.

     Note: 'subviews.reversed()' needed to follow view hierarchy from top most to bottom. And check for clipsToBounds to ensure not to test masked subviews.

     Usage:

     Import category in your subclassed view.
     Replace hitTest:withEvent: with this

     override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
     let uiview = super.hitTest(point, withEvent: event)
     print(uiview)
     return overlapHitTest(point, withEvent: event)
     }
     */
    /// Handle issue when you need to receive touch on top most visible view.
    /// - parameter point:       point
    /// - parameter event:       evet
    /// - parameter invisibleOn: If you want hidden view can not be hit, set `invisibleOn` to true
    ///
    /// - returns: UIView
    func overlapHitTest(_ point: CGPoint, with event: UIEvent?, invisibleOn: Bool = false) -> UIView? {
        // 1
        let invisible = (isHidden || alpha == 0) && invisibleOn
        if !isUserInteractionEnabled || invisible { return nil }
        // 2
        var hitView: UIView? = self
        if !self.point(inside: point, with: event) {
            if clipsToBounds {
                return nil
            } else {
                hitView = nil
            }
        }
        // 3
        for subview in subviews.reversed() {
            let insideSubview = convert(point, to: subview)
            if let sview = subview.overlapHitTest(insideSubview, with: event) { return sview }
        }
        return hitView
    }
}

// MARK: - UIWindow Extensions
public extension UIWindow {
    // REFERENCE: http://stackoverflow.com/a/34679549/4656574
    func replaceRootViewController(with replacementController: UIViewController, duration: TimeInterval = 0.4, completion: Closure? = nil) {
        guard let rootVC = rootViewController else { preconditionFailure("rootViewController should not be nil!") }
        let snapshotImageView = UIImageView(image: snapshot)
        self.addSubview(snapshotImageView)
        rootVC.dismiss(animated: false, completion: { [unowned self] in // dismiss all modal view controllers
            self.rootViewController = replacementController
            self.bringSubviewToFront(snapshotImageView)
            UIView.animate(withDuration: duration, animations: {
                snapshotImageView.alpha = 0
            }, completion: { _ in
                snapshotImageView.removeFromSuperview()
                completion?()
            })
        })
    }
}

// MARK: - UIView + Snapshot
public extension UIView {
    var snapshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }

    var snapshotData: Data {
#if os(iOS)
        UIGraphicsBeginImageContext(frame.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let fullScreenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(fullScreenshot!, nil, nil, nil)
        return fullScreenshot!.jpegData(compressionQuality: 0.5)!
#elseif os(OSX)
        let rep: NSBitmapImageRep = self.view.bitmapImageRepForCachingDisplayInRect(self.view.bounds)!
        self.view.cacheDisplayInRect(self.view.bounds, toBitmapImageRep: rep)
        return rep.TIFFRepresentation!
#endif
    }

    func takeSnapshot(_ frame: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: frame.origin.x * -1, y: frame.origin.y * -1)
        guard let currentContext = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: currentContext)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

// MARK: - UIView Corner Radius
public extension UIView {
    func roundCorners(_ corners: CACornerMask = .allCorners, radius: CGFloat, border: (color: UIColor, width: CGFloat)? = nil) {
        clipsToBounds = true
        if #available(iOS 11.0, *) {
            layer.cornerRadius = radius
            layer.maskedCorners = corners
            if let border {
                layer.borderColor = border.color.cgColor
                layer.borderWidth = border.width
            }
        } else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners.toRectCorner, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
            if let border {
                addBorder(mask, borderColor: border.color, borderWidth: border.width)
            }
        }
    }

    private func addBorder(_ mask: CAShapeLayer, borderColor: UIColor, borderWidth: CGFloat) {
        let borderLayer = CAShapeLayer()
        borderLayer.path = mask.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
    }
}

public extension CACornerMask {
    static var topLeft: CACornerMask { return .layerMinXMinYCorner }
    static var topRight: CACornerMask { return .layerMaxXMinYCorner }
    static var bottomLeft: CACornerMask { return .layerMinXMaxYCorner }
    static var bottomRight: CACornerMask { return .layerMaxXMaxYCorner }
    static var allCorners: CACornerMask { return [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner] }
    var toRectCorner: UIRectCorner {
        var corners = UIRectCorner()
        if contains(.topLeft) { corners.insert(.topLeft) }
        if contains(.topRight) { corners.insert(.topRight) }
        if contains(.bottomLeft) { corners.insert(.bottomLeft) }
        if contains(.bottomRight) { corners.insert(.bottomRight) }
        return corners
    }
}

// MARK: - Animations
public extension UIView {
    // MARK: - Rotation Animation
    func rotate(by angle: CGFloat, duration: TimeInterval = 0.25, target: CAAnimationDelegate? = nil) {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.duration = max(0, duration)
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = angle
        rotationAnimation.delegate = target
        rotationAnimation.timingFunction = .init(name: .linear)
        transform = transform.rotated(by: angle)
        layer.add(rotationAnimation, forKey: nil)
    }

    func reverseTransform(duration: TimeInterval) {
        UIView.animate(withDuration: duration) { self.transform = .identity }
    }

    // MARK: - Flash Animation
    func flash(duration: TimeInterval, minAlpha: CGFloat = 0, maxAlpha: CGFloat = 1, repeatCount: Float = .greatestFiniteMagnitude) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = duration
        animation.fromValue = maxAlpha
        animation.toValue = minAlpha
        animation.timingFunction = .init(name: .easeInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = repeatCount
        layer.add(animation, forKey: nil)
    }

    // MARK: - Alpha
    func hide(_ flag: Bool, duration: TimeInterval = 0.25, animated: Bool) {
        guard animated else { isHidden = flag; return }
        let alpha: CGFloat = flag ? 0 : 1
        UIView.animate(withDuration: duration, delay: 0, options: .beginFromCurrentState, animations: {
            self.alpha = alpha
        }) { _ in
            self.isHidden = flag
        }
    }

    func morphingView(duration: TimeInterval = 0.25, toAlpha alpha: CGFloat) {
        UIView.animate(withDuration: duration, delay: 0, options: .beginFromCurrentState, animations: {
            self.alpha = alpha
        }, completion: nil)
    }

    // MARK: - Shake Animation
    func startShaking(frequency: TimeInterval = 0.2, offset: CGFloat = 1.5, direction: ASDirection = .horizontal, repeatCount: Float = .greatestFiniteMagnitude) {
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.position))
        animation.duration = frequency
        animation.repeatCount = repeatCount
        animation.autoreverses = true
        switch direction {
        case .horizontal:
            animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - offset, y: center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + offset, y: center.y))
        case .vertical:
            animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x, y: center.y - offset))
            animation.toValue = NSValue(cgPoint: CGPoint(x: center.x, y: center.y + offset))
        }
        layer.add(animation, forKey: #keyPath(CALayer.position))
    }

    func stopShaking() {
        layer.removeAnimation(forKey: #keyPath(CALayer.position))
    }

    func shaking(withDuration duration: TimeInterval, frequency: TimeInterval = 0.2, offset: CGFloat = 1.5, direction: ASDirection = .horizontal, repeartCount: Float = .greatestFiniteMagnitude) {
        startShaking(frequency: frequency, offset: offset, direction: direction, repeatCount: repeartCount)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in self?.stopShaking() }
    }
}

// MARK: - UIButton Extensions
public extension UIButton {
    var image: UIImage? {
        get { return image(for: .normal) }
        set { setImage(newValue, for: .normal) }
    }

    var title: String? {
        get { return title(for: .normal) }
        set { setTitle(newValue, for: .normal) }
    }

    var titleColor: UIColor? {
        get { return titleColor(for: .normal) }
        set { setTitleColor(newValue, for: .normal) }
    }

    var attributedTitle: NSAttributedString? {
        get { return attributedTitle(for: .normal) }
        set { setAttributedTitle(newValue, for: .normal) }
    }
}
#endif

// MARK: - Reutrn bool value
public extension Numeric { var bool: Bool { return self != .zero } }
public extension Bool { init(_ numeric: some Numeric) { self.init(numeric != .zero) } }

public extension String? {
    var emptyValueIfNil: String {
        return self == nil ? "" : self!
    }
}

// MARK: - Date Extensions
public extension DateComponents {
    enum Weekday: Int, Hashable, CaseIterable {
        case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    }
}

// MARK: - - Bundle Extensions
public extension Bundle {
    var displayName: String {
        let name = object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        return name ?? (object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String) ?? ""
    }
}

#if os(iOS)
// MARK: - UIAlertController Extension
public extension UIViewController {
    func presentAlert(title: String? = nil, message: String? = nil, actionTitle: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: handler)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
#endif

// MARK: - String Extensions
public extension String {
    // MARK: - Localized Strings
    static let yes = NSLocalizedString("YES", comment: "")
    static let no = NSLocalizedString("NO", comment: "")
    static let ok = NSLocalizedString("OK", comment: "")
    static let confirm = NSLocalizedString("Confirm", comment: "")
    static let cancel = NSLocalizedString("Cancel", comment: "")
}

public extension String {
    init(_ instance: some Any) {
        self.init(describing: instance)
    }

    subscript(i: Int) -> String {
        guard i >= 0, i < count else { return "" }
        return String(self[index(startIndex, offsetBy: i)])
    }

    subscript(range: Range<Int>) -> String {
        let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) ?? endIndex
        return String(self[lowerIndex ..< (index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) ?? endIndex)])
    }

    subscript(range: ClosedRange<Int>) -> String {
        let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) ?? endIndex
        return String(self[lowerIndex ..< (index(lowerIndex, offsetBy: range.upperBound - range.lowerBound + 1, limitedBy: endIndex) ?? endIndex)])
    }

    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { sInd in
            (range(of: to, range: sInd ..< endIndex)?.lowerBound).map { eInd in
                return String(self[sInd ..< eInd])
            }
        }
    }
}

public extension String {
    /// Returns the actual url if the path is valid, otherwise returns a fake url `URL("https://")!`.
    var url: URL { return URL(string: self) ?? URL(string: "https://")! }
    /// Returns an optional url if the path is valid.
    var optionalURL: URL? { return URL(string: self) }
}

public extension String {
    var validURLs: [URL] {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else { return [] }
        let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: count))
        return matches.compactMap { $0.resultType == .link ? $0.url : nil }
    }
}

public extension String {
    func camelCaseToSnakeCase() -> String? {
        return processCamelCase(template: "$1_$2")
    }

    func camelCaseToSentenceCase() -> String? {
        return processCamelCase(template: "$1 $2")
    }

    private func processCamelCase(template: String) -> String? {
        let acronymPattern = "([A-Z]+)([A-Z][a-z]|[0-9])"
        let normalPattern = "([a-z0-9])([A-Z])"
        return self.processCamelCaseRegex(pattern: acronymPattern, template: template)?.processCamelCaseRegex(pattern: normalPattern, template: template)
    }

    private func processCamelCaseRegex(pattern: String, template: String) -> String? {
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: count)
        return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: template)
    }
}

public extension StringProtocol {
    func nsRange(of text: String) -> NSRange? { return range(of: text).map { NSRange($0, in: self) } }
}

// MARK: - URL Extensions
public extension URL {
    var lastPathComponentWithoutPathExtension: String {
        return lastPathComponent.replacingOccurrences(of: ".\(pathExtension)", with: "")
    }

    var queryPairs: [String: String] {
        var results = [String: String]()
        let pairs = query?.components(separatedBy: "&") ?? []
        for pair in pairs {
            let kv = pair.components(separatedBy: "=")
            if kv.count > 1 { results.updateValue(kv[1], forKey: kv[0]) }
        }
        return results
    }

    func append(_ queryItem: String, value: String?) -> URL {
        // create query item if value is not nil
        guard let value else { return absoluteURL }
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        // create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []
        let queryItem = URLQueryItem(name: queryItem, value: value)
        // append the new query item in the existing query items array
        queryItems.append(queryItem)
        // append updated query items array in the url component object
        urlComponents.queryItems = queryItems
        // returns the url from new url components
        return urlComponents.url!
    }

    func append(_ params: [String: String?]) -> URL {
        var url = self
        params.forEach { url = url.append($0.key, value: $0.value) }
        return url
    }

    func httpsURL() -> URL {
        guard scheme != "https" else { return self }
        let str = absoluteString.replacingOccurrences(of: "http://", with: "https://")
        return URL(string: str)!
    }
}

#if os(iOS)
// MARK: - Uniform
public extension UIEdgeInsets {
    init(uniform inset: CGFloat) { self.init(top: inset, left: inset, bottom: inset, right: inset) }
    init(uniform inset: Double) { let inset = CGFloat(inset); self.init(top: inset, left: inset, bottom: inset, right: inset) }
    init(uniform inset: Int) { let inset = CGFloat(inset); self.init(top: inset, left: inset, bottom: inset, right: inset) }
    init(horizontal: CGFloat = 0, vertical: CGFloat = 0) { self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal) }
    init(horizontal: Double = 0, vertical: Double = 0) { let h = CGFloat(horizontal); let v = CGFloat(vertical); self.init(top: v, left: h, bottom: v, right: h) }
    init(horizontal: Int = 0, vertical: Int = 0) { let h = CGFloat(horizontal); let v = CGFloat(vertical); self.init(top: v, left: h, bottom: v, right: h) }
    init(top: CGFloat) { self.init(top: top, left: 0, bottom: 0, right: 0) }
    init(left: CGFloat) { self.init(top: 0, left: left, bottom: 0, right: 0) }
    init(bottom: CGFloat) { self.init(top: 0, left: 0, bottom: bottom, right: 0) }
    init(right: CGFloat) { self.init(top: 0, left: 0, bottom: 0, right: right) }
}
#endif

public extension CGSize {
    init(uniform value: CGFloat) { self.init(width: value, height: value) }
    init(uniform value: Double) { self.init(width: value, height: value) }
    init(uniform value: Int) { self.init(width: value, height: value) }
}

// MARK: - CoreGraphics
public extension CGRect {
    init(size: CGSize) {
        self.init(origin: .zero, size: size)
    }

    init(center: CGPoint, size: CGSize) {
        let origin = CGPoint(x: center.x - size.width / 2, y: center.y - size.height / 2)
        self.init(origin: origin, size: size)
    }

    var center: CGPoint { return CGPoint(x: origin.x + width / 2, y: origin.y + height / 2) }
    var randomPoint: CGPoint {
        let x = CGFloat(arc4random_uniform(UInt32(width))) + origin.x
        let y = CGFloat(arc4random_uniform(UInt32(height))) + origin.y
        return CGPoint(x: x, y: y)
    }
}

public extension CGSize {
    func scale(_ scale: CGFloat) -> CGSize {
        return CGSize(width: width * scale, height: height * scale)
    }
}

public func CGDistance(_ p1: CGPoint, _ p2: CGPoint) -> CGFloat {
    guard p1 != p2 else { return 0 }
    return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2))
}

public func CGTriangleDistance(_ l1: CGFloat, _ l2: CGFloat) -> CGFloat {
    guard l1 != 0, l2 != 0 else { return 0 }
    return sqrt(pow(l1, 2) + pow(l2, 2))
}

public func CGPointOnLinearLine(withX x: CGFloat, _ began: CGPoint, _ ended: CGPoint) -> CGPoint {
    let k = (ended.y - began.y) / (began.x - began.x)
    let b = (began.y + ended.y - k * (began.x + ended.x)) / 2
    let y = k * x + b
    return CGPoint(x: x, y: y)
}

public func CGPointOnLinearLine(withY y: CGFloat, began: CGPoint, _ ended: CGPoint) -> CGPoint {
    let point = CGPointOnLinearLine(withX: y, began, ended)
    return CGPoint(x: point.y, y: point.x)
}

public func CGPointsOnOneLine(_ point1: CGPoint, _ point2: CGPoint, _ point3: CGPoint) -> Bool {
    let k = (point2.y - point1.y) / (point2.x - point1.x)
    let b = (point1.y + point2.y - k * (point1.x + point2.x)) / 2
    return point3.y == k * point3.x + b
}

public func CGPointsOnOneLine(_ points: CGPoint...) -> Bool { return CGPointsOnOneLine(points) }
public func CGPointsOnOneLine(_ points: [CGPoint]) -> Bool {
    guard points.count > 2 else { return true }
    guard points.count > 3 else { return CGPointsOnOneLine(points[0], points[1], points[2]) }
    for point in points[3 ..< points.count] { if !CGPointsOnOneLine(point, points[0], points[1]) { return false } }
    return true
}

public func CGPointNotIn(rects: CGRect..., point: CGPoint) -> Bool { return CGPointNotIn(rects: rects, point: point) }
public func CGPointNotIn(rects: [CGRect], point: CGPoint) -> Bool {
    for rect in rects { if rect.contains(point) { return false } }
    return true
}

public func CGPointInsideRing(point: CGPoint, center: CGPoint, firstRadius: CGFloat, secondRadius: CGFloat) -> Bool {
    let area = touchArea(point, center: center)
    let smaller = sumOfSquares(min(firstRadius, secondRadius))
    let bigger = sumOfSquares(max(firstRadius, secondRadius))
    return area >= smaller && area <= bigger
}

public func CGPointInsideCircle(point: CGPoint, center: CGPoint, radius: CGFloat) -> Bool {
    let area = touchArea(point, center: center)
    return area <= sumOfSquares(radius)
}

private func touchArea(_ point: CGPoint, center: CGPoint) -> Double {
    return sumOfSquares(point.x - center.x) + sumOfSquares(point.y - center.y)
}

private func sumOfSquares(_ x: CGFloat) -> Double { return pow(Double(x), 2) }

// MARK: - UserDefaults Extensions
public extension UserDefaults {
    func bool(forKey key: String, defaultValue: Bool) -> Bool {
        if value(forKey: key) == nil { set(defaultValue, forKey: key) }
        return bool(forKey: key)
    }

    func integer(forKey key: String, defaultValue: Int) -> Int {
        if value(forKey: key) == nil { set(defaultValue, forKey: key) }
        return integer(forKey: key)
    }

    func string(forKey key: String, defaultValue: String) -> String {
        if value(forKey: key) == nil { set(defaultValue, forKey: key) }
        return string(forKey: key) ?? defaultValue
    }

    func double(forKey key: String, defaultValue: Double) -> Double {
        if value(forKey: key) == nil { set(defaultValue, forKey: key) }
        return double(forKey: key)
    }

    func object(forKey key: String, defaultValue: AnyObject) -> Any? {
        if object(forKey: key) == nil { set(defaultValue, forKey: key) }
        return object(forKey: key)
    }

#if os(iOS)
    func color(forKey key: String) -> UIColor? {
        return given(data(forKey: key)) { data in
            if #available(iOS 11.0, *) {
                return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
            } else {
                return NSKeyedUnarchiver.unarchiveObject(with: data) as? UIColor
            }
        }
    }

    func setColor(_ color: UIColor?, forKey key: String) {
        let data: Data? = given(color) { color in
            if #available(iOS 11.0, *) {
                return try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
            } else {
                return NSKeyedArchiver.archivedData(withRootObject: color)
            }
        }
        set(data, forKey: key)
    }
#endif
}

#if os(iOS)
// MARK: - UIImageView EXtensions
public extension UIImageView {
    var renderingMode: UIImage.RenderingMode {
        get { return image?.renderingMode ?? .automatic }
        set { if let img = image { image = img.withRenderingMode(newValue) } }
    }

    func setImageWithFadeAnimation(_ image: UIImage?, duration: TimeInterval = 1.0) {
        guard let image else { return }
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = CATransitionType.fade
        layer.add(transition, forKey: nil)
        self.image = image
    }

    @IBInspectable var ignoresInvertColors: Bool {
        get { if #available(iOS 11.0, *) { return accessibilityIgnoresInvertColors } else { return false } }
        set { if #available(iOS 11.0, *) { accessibilityIgnoresInvertColors = newValue } }
    }
}

public extension UIImage {
    convenience init?(cgImage: CGImage?) {
        guard let cgImage else { return nil }
        self.init(cgImage: cgImage)
    }

    convenience init?(view: UIView?) {
        guard let view else { return nil }
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image?.cgImage)
    }

    convenience init?(frame: CGRect, color: UIColor?, isOpaque: Bool = true, scale: CGFloat = 0) {
        guard let color else { return nil }
        UIGraphicsBeginImageContextWithOptions(frame.size, isOpaque, scale)
        color.setFill()
        UIRectFill(frame)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image?.cgImage)
    }

    @available(iOS 13.0, *)
    convenience init?(systemName: String, pointSize: CGFloat, weight: UIImage.SymbolWeight = .regular) {
        self.init(systemName: systemName, withConfiguration: UIImage.SymbolConfiguration(pointSize: pointSize, weight: weight))
    }

    var originalRender: UIImage { return withRenderingMode(.alwaysOriginal) }
    var templateRender: UIImage { return withRenderingMode(.alwaysTemplate) }

    func roundedScaledToSize(_ size: CGSize) -> UIImage { return (resize(to: size) ?? self).rounded() }

    func rounded(radius: CGFloat? = nil) -> UIImage {
        let imageLayer = CALayer()
        imageLayer.frame = CGRect(origin: .zero, size: size)
        imageLayer.contents = cgImage
        imageLayer.masksToBounds = true
        let radius = radius ?? min(size.width, size.height) / 2
        imageLayer.cornerRadius = radius
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        imageLayer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedImage ?? UIImage()
    }
}

// MARK: - - UIImage + Resize
public extension UIImage {
    /// Returns scaled image, returns nil if failed.
    func resize(to size: CGSize) -> UIImage? {
        #if os(watchOS)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
        #else
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        #endif
    }

    func scaledToWidth(_ width: CGFloat) -> UIImage? {
        guard width < size.width else { return self }
        let scale = width / size.width
        let newSize = CGSize(width: width, height: size.height * scale)
        return resize(to: newSize)
    }

    func scaledToHeight(_ height: CGFloat) -> UIImage? {
        guard height < size.height else { return self }
        let scale = height / size.height
        let newSize = CGSize(width: size.width * scale, height: height)
        return resize(to: newSize)
    }
}

extension UIImage {
    public var rotatedImageByOrientation: UIImage {
        // return if the orientation is already correct
        guard imageOrientation != .up else { return self }
        let transform = calculatedAffineTransform
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        guard let cgImage = self.cgImage, let colorSpace = cgImage.colorSpace else { return self }
        let width = size.width
        let height = size.height
        guard let ctx = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: cgImage.bitmapInfo.rawValue) else { return self }
        ctx.concatenate(transform)
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: height, height: width))
        default:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        }
        // And now we just create a new UIImage from the drawing context
        if let cgImage = ctx.makeImage() {
            return UIImage(cgImage: cgImage)
        } else {
            return self
        }
    }

    private var calculatedAffineTransform: CGAffineTransform {
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform = CGAffineTransform.identity
        let width = size.width
        let height = size.height
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: width, y: height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.rotated(by: .pi / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: height)
            transform = transform.rotated(by: .pi / -2)
        default:
            break
        }
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        return transform
    }
}

public extension UIImage {
    func tintedImage(with color: UIColor) -> UIImage? {
        guard let maskImage = self.cgImage else { return nil }
        let width = self.size.width
        let height = self.size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        guard let bitmapContext = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        else { return nil }
        bitmapContext.clip(to: bounds, mask: maskImage)
        bitmapContext.setFillColor(color.cgColor)
        bitmapContext.fill(bounds)
        guard let cImage = bitmapContext.makeImage() else { return nil }
        let coloredImage = UIImage(cgImage: cImage)
        return coloredImage
    }

    /// Invert the color of the image, then return the new image
    /// REFERENCE: http://stackoverflow.com/a/38835122/4656574
    /// - parameter cgResult: whether or not to convert to cgImgae, default is false
    /// - returns: inverted image, nil if failed
    func inversedImage(cgResult: Bool = false) -> UIImage? {
        let coreImage = UIKit.CIImage(image: self)
        guard let filter = CIFilter(name: "CIColorInvert") else { return nil }
        filter.setValue(coreImage, forKey: kCIInputImageKey)
        guard let result = filter.value(forKey: kCIOutputImageKey) as? UIKit.CIImage else { return nil }
        guard cgResult else { return UIImage(ciImage: result) }
        guard let cgImage = CIContext(options: nil).createCGImage(result, from: result.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}

// MARK: - - UITextView
public extension UITextView {
    func exclude(rects: [CGRect]) {
        textContainer.exclusionPaths = rects.map { UIBezierPath(rect: $0) }
    }
}

// MARK: - Selector Extensions
public extension Selector {
    static let dismissAnimated = #selector(UIViewController.dismissAnimated)
    static let dismissWithoutAnimation = #selector(UIViewController.dismissWithoutAnimation)
    static let popViewControllerAnimated = #selector(UIViewController.popViewControllerAnimated)
    static let popViewControllerWithoutAnimation = #selector(UIViewController.popViewControllerWithoutAnimation)
}

// MARK: - - Dismiss view controller
public extension UIViewController {
    @objc func dismissAnimated() { dismiss(animated: true, completion: nil) }
    @objc func dismissWithoutAnimation() { dismiss(animated: false, completion: nil) }
    @objc func popViewControllerAnimated() { _ = navigationController?.popViewController(animated: true) }
    @objc func popViewControllerWithoutAnimation() { _ = navigationController?.popViewController(animated: false) }
    func presentViewControllerWithPushAnimation(destinationVC: UIViewController, duration: TimeInterval = 0.25) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .push
        transition.subtype = .fromRight
        transition.isRemovedOnCompletion = true
        view.window?.layer.add(transition, forKey: nil)
        present(destinationVC, animated: false, completion: nil)
    }

    func dismissViewControllerWithPopAnimation(duration: TimeInterval = 0.25) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .push
        transition.subtype = .fromLeft
        transition.isRemovedOnCompletion = true
        view.window?.layer.add(transition, forKey: nil)
        dismiss(animated: false, completion: nil)
    }

    func present(_ vc: UIViewController) {
        present(vc, animated: true, completion: nil)
    }

    func push(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }

    func show(_ vc: UIViewController) {
        show(vc, sender: nil)
    }
}

// MARK: - UIViewController Extensions
public extension UIViewController {
    /// Load view from nib. Note: File's Owner must be equal to the class name.
    static func loadFromNib() -> Self { return loadFromNib(self) }
    private static func loadFromNib<T: UIViewController>(_ type: T.Type) -> T {
        return Bundle.main.loadNibNamed(String(describing: type), owner: self, options: nil)![0] as! T
    }

    /// Check whether this view controller is presented or not.
    var isModal: Bool {
        return presentingViewController != nil || navigationController?.presentingViewController?.presentedViewController == navigationController || tabBarController?.presentingViewController is UITabBarController
    }
}

// MARK: - Top Most View Controller
/// Description: the toppest view controller of presenting view controller
/// How to use:  UIApplication.shared.keyWindow?.rootViewController?.topMostViewController
/// Where to use: There are lots of kinds of controllers (UINavigationControllers, UITabbarControllers, UIViewController)
extension UIViewController {
    @objc var topMostViewController: UIViewController? {
        // Handling Modal views
        if let presentedViewController = self.presentedViewController { return presentedViewController.topMostViewController }
        // Handling UIViewController's added as subviews to some other views.
        for view in view.subviews {
            // Key property which most of us are unaware of / rarely use.
            if let subViewController = view.next as? UIViewController { return subViewController.topMostViewController }
        }
        return self
    }
}

extension UITabBarController {
    override var topMostViewController: UIViewController? {
        return selectedViewController?.topMostViewController
    }

    var topVisibleViewController: UIViewController? {
        var top = selectedViewController
        while top?.presentedViewController != nil { top = top?.presentedViewController }
        return top
    }
}

extension UINavigationController {
    override var topMostViewController: UIViewController? {
        return visibleViewController?.topMostViewController
    }
}

// MARK: - UINavigationController Extension
public extension UINavigationController {
    func makeNavBarCompletelyTransparent() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        view.backgroundColor = UIColor.clear
        navigationBar.backgroundColor = UIColor.clear
    }

    @available(iOS, deprecated, message: "please use: `makeNavBarCompletelyTransparent`")
    func completelyTransparentBar() { makeNavBarCompletelyTransparent() }
}

// MARK: - UINavigationBar Extensions
public extension UINavigationBar {
    var lagreTitleHeight: CGFloat {
        let maxSize = subviews.filter { $0.frame.origin.y > 0 }.max { $0.frame.origin.y < $1.frame.origin.y }.map { $0.frame.size }
        return maxSize?.height ?? 0
    }

    private enum Association { static var key = 0 }
    /// Supported iOS 12
    var isBottomHairlineHidden: Bool {
        get { return objc_getAssociatedObject(self, &Association.key) as? Bool ?? false }
        set {
            objc_setAssociatedObject(self, &Association.key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            var imageView: UIImageView?
            func loop() {
                loopDescendantViews { if let iv = $0 as? UIImageView, iv.bounds.height <= 1.0 { imageView = iv; return } }
            }
            loop()
            guard imageView == nil else {
                imageView?.isHidden = newValue
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                loop()
                imageView?.isHidden = newValue
            }
        }
    }
}

// MARK: - UIScrollView Extensions
public extension UIScrollView {
    var isAtBottom: Bool { return contentOffset.y == contentSize.height - bounds.size.height }
    var isOnTop: Bool {
        if #available(iOS 11.0, *) {
            return contentOffset.y == -safeAreaInsets.top
        } else {
            return contentOffset.y == -contentInset.top
        }
    }

    @discardableResult
    func scrollToTop(animated: Bool = true) -> CGPoint {
        let topOffset: CGFloat
        if #available(iOS 11.0, *) {
            topOffset = -safeAreaInsets.top
        } else {
            topOffset = -contentInset.top
        }
        let point = CGPoint(x: 0, y: topOffset)
        setContentOffset(point, animated: animated)
        return point
    }

    @discardableResult
    func scrollToBottom(animated: Bool = true) -> CGPoint {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.height)
        setContentOffset(bottomOffset, animated: animated)
        return bottomOffset
    }

    @discardableResult
    func scrollToLeft(animated: Bool = true) -> CGPoint {
        setContentOffset(.zero, animated: animated)
        return .zero
    }

    @discardableResult
    func scrollToRight(animated: Bool = true) -> CGPoint {
        let rightOffset = CGPoint(x: contentSize.width - bounds.width, y: 0)
        setContentOffset(rightOffset, animated: animated)
        return rightOffset
    }
}

public extension UIScrollView {
    var verticalDirection: ASVerticalDirection {
        return panGestureRecognizer.translation(in: self).y < 0 ? .down : .up
    }

    var horizontalDirection: ASHorizontalDirection {
        return panGestureRecognizer.translation(in: self).x < 0 ? .right : .left
    }
}

// MARK: - PathUtilities
public enum PathUtilities {}
public extension PathUtilities {
    static var documentDirectoryPath: String { return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] }
    static var documentDirectoryURL: URL { return URL(fileURLWithPath: documentDirectoryPath, isDirectory: true) }
    static func documentURLForFile(_ named: String) -> URL { return documentDirectoryURL.appendingPathComponent(named) }
    static var libraryDirectoryPath: String { return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0] }
    static func libraryPathForFile(_ named: String) -> String { return (libraryDirectoryPath as NSString).appendingPathComponent(named) }
    static func documentPath(forResource: String, of type: String) -> URL {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let resourcePath = ((documentsDirectory as NSString).appendingPathComponent(forResource) as NSString).appendingPathExtension(type)
        return URL(fileURLWithPath: resourcePath!)
    }

    static var temporaryDirectoryPath: String { return NSTemporaryDirectory() }
    static var cacheDirectoryPath: String { return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] }
    static func cacheURLForFile(_ named: String) -> URL { return URL(fileURLWithPath: cacheDirectoryPath).appendingPathComponent(named) }
    static func cachePathForFile(_ named: String) -> String { return cacheURLForFile(named).absoluteString }
    static func appGroupDocumentPath(_ appGroupId: String) -> String? {
        guard let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupId) else { return nil }
        return url.absoluteString.replacingOccurrences(of: "file:", with: "", options: .literal, range: nil)
    }

    /// Create folder if needed
    ///
    /// - Parameter path: the folder path
    /// - Returns: returns true if created, otherwise returns false, if already exists, return nil.
    @discardableResult
    static func createFolder(atPath path: String) -> Bool? {
        guard !FileManager.default.fileExists(atPath: path) else { return nil }
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch { ASError(error.localizedDescription); return false }
    }

    /// Delete the specific file
    ///
    /// - Parameter path: file path to delete
    /// - Returns: returns true if delete successfully, otherwise returns false. If file doesn't exist, returns true.
    @discardableResult
    static func deleteFile(atPath path: String) -> Bool {
        let exists = FileManager.default.fileExists(atPath: path)
        guard exists else { return true }
        do {
            try FileManager.default.removeItem(atPath: path); return true
        } catch {
            ASError(error.localizedDescription); return false
        }
    }

    static func isDirectoryFor(_ path: String) -> Bool {
        var isDirectory: ObjCBool = false
        FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return isDirectory.boolValue
    }

    static func clearTempDirectory() {
        do {
            let paths = (try? FileManager.default.contentsOfDirectory(atPath: NSTemporaryDirectory())) ?? []
            try paths.forEach {
                let path = (NSTemporaryDirectory() as NSString).appendingPathComponent($0)
                try FileManager.default.removeItem(atPath: path)
            }
        } catch { ASError(error) }
    }

    static func fetchRootDirectoryForiCloud(completion: @escaping (URL?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let url = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            if !FileManager.default.fileExists(atPath: url.path, isDirectory: nil) {
                do { ASLog("Creating directory...")
                    try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                } catch { ASError(error) }
            }
            DispatchQueue.main.async { completion(url) }
        }
    }
}

// MARK: - Gradient
// REFERENCE: http://stackoverflow.com/a/42020700/4656574
public typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)
public enum GradientOrientation {
    case topRightBottomLeft, topLeftBottomRight, horizontal, vertical
    fileprivate var startPoint: CGPoint { return points.startPoint }
    fileprivate var endPoint: CGPoint { return points.endPoint }
    private var points: GradientPoints {
        switch self {
        case .topRightBottomLeft: return (CGPoint(x: 0.0, y: 1.0), CGPoint(x: 1.0, y: 0.0))
        case .topLeftBottomRight: return (CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0))
        case .horizontal: return (CGPoint(x: 0.0, y: 0.5), CGPoint(x: 1.0, y: 0.5))
        case .vertical: return (CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 1.0))
        }
    }
}

public extension UIView {
    @discardableResult func applyGradient(withColors colors: [UIColor], locations: [NSNumber]? = nil) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations
        layer.insertSublayer(gradient, at: 0)
        return gradient
    }

    @discardableResult func applyGradient(withColors colors: [UIColor], points: GradientPoints) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.startPoint = points.startPoint
        gradient.endPoint = points.endPoint
        layer.insertSublayer(gradient, at: 0)
        return gradient
    }

    @discardableResult func applyGradient(withColors colors: [UIColor], gradientOrientation orientation: GradientOrientation) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        layer.insertSublayer(gradient, at: 0)
        return gradient
    }

    static func gradientLayer(colors: [UIColor], gradientOrientation orientation: GradientOrientation) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = colors.map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        return gradient
    }

    static func gradientLayer(colors: [UIColor], points: GradientPoints) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = colors.map { $0.cgColor }
        gradient.startPoint = points.startPoint
        gradient.endPoint = points.endPoint
        return gradient
    }
}

public extension UIStackView {
    convenience init(axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution? = nil, alignment: UIStackView.Alignment? = nil, spacing: CGFloat? = nil, arrangedSubviews: [UIView] = []) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        given(distribution) { self.distribution = $0 }
        given(alignment) { self.alignment = $0 }
        given(spacing) { self.spacing = $0 }
    }
}

public final class ASSpacer: UIView {
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    /// Create a fixed size view, usually used in stack view.
    /// Set both width and height, so it can be used in both horizontal and vertical stack view.
    /// - Note: While using this initializer, the constraint priority is `999` not `required`.
    public init(_ dimension: CGFloat) {
        super.init(frame: .zero)
        constrainSize(to: CGSize(uniform: dimension), priority: .pseudoRequired)
    }

    /// Create a fixed horizontal size view.
    public init(horizontal dimension: CGFloat) {
        super.init(frame: .zero)
        constrainWidth(to: dimension)
    }

    /// Create a fixed vertical size view.
    public init(vertical dimension: CGFloat) {
        super.init(frame: .zero)
        constrainHeight(to: dimension)
    }
}

// MARK: - UISearchBar Extensions
public extension UISearchBar {
    /// This may be broken in the future iOS release.
    func selectAll() {
        loopDescendantViews("UISearchBarTextField", shouldReturn: false, execute: {
            // Do not use `value(forKey: "searchField") as? UITextField`, may rejected by Apple
            guard let tf = $0 as? UITextField else { return }
            guard tf.responds(to: #selector(selectAll(_:))) else { return }
            // Ensure texts can be selected
            DispatchQueue.main.async { tf.selectAll(nil) }
        })
    }

    func changeTextFieldTintColor(_ color: UIColor) {
        loopDescendantViews {
            if let tf = $0 as? UITextField { tf.tintColor = color; return }
        }
    }

    func customMode(with color: UIColor, placeholder: String?) {
        loopDescendantViews {
            if let tf = $0 as? UITextField {
                tf.tintColor = color; tf.textColor = color
                if let ph = placeholder {
                    let str = NSAttributedString(string: ph, attributes: [NSAttributedString.Key.foregroundColor: color.alpha(0.5)])
                    tf.attributedPlaceholder = str
                }
            }
        }
    }
}

// MARK: - UIRefreshControl Extensions
public extension UIRefreshControl {
    func beginRefreshingManually() {
        guard let scrollView = superview as? UIScrollView else { return }
        let offsetY = scrollView.contentOffset.y - frame.height
        scrollView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
        beginRefreshing()
    }
}

public extension UILabel {
    convenience init(text: String?, style: UIFont.TextStyle? = nil) {
        self.init()
        self.text = text
        guard let style else { return }
        font = UIFont.preferredFont(forTextStyle: style)
    }

    var isTruncated: Bool {
        guard let string = text else { return false }
        let size = string.size(maxWidth: bounds.width, font: font, ceiled: false)
        return size.height > bounds.size.height
    }
}
#endif
