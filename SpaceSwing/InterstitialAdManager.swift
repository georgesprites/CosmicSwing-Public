import GoogleMobileAds
import UIKit

final class InterstitialAdManager: NSObject {

    static let shared = InterstitialAdManager()

    private var interstitial: InterstitialAd?
    private var isLoading = false

    private var onDismiss: (() -> Void)?

    private let adUnitID = "ca-app-pub-3940256099942544/4411468910" // test ID

    func load() {
        guard !isLoading, interstitial == nil else { return }
        isLoading = true

        InterstitialAd.load(with: adUnitID, request: Request()) { [weak self] ad, error in
            guard let self else { return }
            self.isLoading = false

            if let error = error {
                print("Interstitial load failed:", error)
                self.interstitial = nil
                return
            }

            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
        }
    }

    /// Show interstitial and call completion after dismissal
    func show(from vc: UIViewController, completion: (() -> Void)? = nil) {
        guard let ad = interstitial else {
            load()
            completion?() // fail-safe: continue immediately
            return
        }

        self.onDismiss = completion
        ad.present(from: vc)
    }
}

extension InterstitialAdManager: FullScreenContentDelegate {

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        interstitial = nil
        onDismiss?()
        onDismiss = nil
        load() // preload next
    }

    func ad(_ ad: FullScreenPresentingAd,
            didFailToPresentFullScreenContentWithError error: Error) {
        print("Interstitial failed to present:", error)
        interstitial = nil
        onDismiss?()
        onDismiss = nil
        load()
    }
}
