// Copyright © 2017-2020 iAugus. All rights reserved.

import StoreKit
import ASwiftKit
import ASwiftUIKit

public enum AppStore {
    public static func requestReview(shortestTime: UInt32 = 50, longestTime: UInt32 = 500) {
        #if !DEBUG
        // Do nothing
        #else
            let shortestTime: UInt32 = shortestTime
            let longestTime: UInt32 = longestTime

        let timeInterval = (shortestTime...longestTime).randomElement()!
        delay(in: Double(timeInterval)) {
            guard let windowScene = UIApplication.shared.firstActivedWindowScene else { return }
            SKStoreReviewController.requestReview(in: windowScene)
        }
        #endif
    }
}
