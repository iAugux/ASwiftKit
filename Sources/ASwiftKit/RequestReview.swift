// Copyright © 2017-2020 iAugus. All rights reserved.

#if os(iOS)
import StoreKit

public enum AppStore {
    public static func requestReview(shortestTime: UInt32 = 50, longestTime: UInt32 = 500) {
#if DEBUG
        // Do nothing
#else
        assert(shortestTime < longestTime)
        let timeInterval = (shortestTime...longestTime).randomElement()!
        delay(in: Double(timeInterval)) {
            if #available(iOS 14.0, *) {
                guard let windowScene = UIApplication.shared.firstActivedWindowScene else { return }
                SKStoreReviewController.requestReview(in: windowScene)
            } else {
                SKStoreReviewController.requestReview()
            }
        }
#endif
    }
}
#endif
