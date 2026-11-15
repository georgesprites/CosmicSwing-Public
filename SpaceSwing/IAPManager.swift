import StoreKit

@MainActor
final class IAPManager: ObservableObject {
    static let shared = IAPManager()

    private let removeAdsID = "01"

    @Published private(set) var removeAdsProduct: Product?
    @Published private(set) var adsRemoved: Bool = Entitlements.adsRemoved

    func loadProducts() async {
        do {
            let products = try await Product.products(for: [removeAdsID])
            self.removeAdsProduct = products.first
        } catch {
            print("IAP loadProducts error:", error)
        }
    }

    func refreshEntitlements() async {
        // Check current entitlements (covers restore + reinstall)
        var hasRemoveAds = false
        for await result in Transaction.currentEntitlements {
            if case .verified(let t) = result, t.productID == removeAdsID {
                hasRemoveAds = true
                break
            }
        }
        adsRemoved = hasRemoveAds
        Entitlements.adsRemoved = hasRemoveAds
    }

    func buyRemoveAds() async {
        guard let product = removeAdsProduct else { return }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    await transaction.finish()
                    await refreshEntitlements()
                }
            case .userCancelled, .pending:
                break
            @unknown default:
                break
            }
        } catch {
            print("IAP purchase error:", error)
        }
    }

    func restorePurchases() async {
        // StoreKit 2: refreshEntitlements usually covers it,
        // but "Sync" is nice for a user-facing Restore button.
        do {
            try await AppStore.sync()
            await refreshEntitlements()
        } catch {
            print("IAP restore error:", error)
        }
    }
}

enum Entitlements {
    static let adsRemovedKey = "adsRemoved"
    static var adsRemoved: Bool {
        get { UserDefaults.standard.bool(forKey: adsRemovedKey) }
        set { UserDefaults.standard.set(newValue, forKey: adsRemovedKey) }
    }
}
