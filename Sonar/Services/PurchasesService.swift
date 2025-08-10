import Foundation
import StoreKit

protocol PurchasesService: Sendable {
    func isSubscriber() async -> Bool
    func currentPlanIdentifier() async -> String?
    func purchase(productId: String) async throws
    func restore() async throws
    func setDeveloperOverrideEnabled(_ enabled: Bool)
    func developerOverrideEnabled() -> Bool
}

struct DefaultPurchasesService: PurchasesService, Sendable {
    private static let devKey = "dev.subscription.override"
    func isSubscriber() async -> Bool {
        if developerOverrideEnabled() { return true }
        for await entitlement in Transaction.currentEntitlements {
            if case let .verified(transaction) = entitlement, transaction.productType == .autoRenewable {
                return true
            }
        }
        return false
    }

    func currentPlanIdentifier() async -> String? {
        if developerOverrideEnabled() { return "dev.max.override" }
        for await entitlement in Transaction.currentEntitlements {
            if case let .verified(transaction) = entitlement, transaction.productType == .autoRenewable {
                return transaction.productID
            }
        }
        return nil
    }

    func purchase(productId: String) async throws {
        let products = try await Product.products(for: [productId])
        guard let product = products.first else { return }
        _ = try await product.purchase()
    }

    func restore() async throws {
        try await AppStore.sync()
    }

    func setDeveloperOverrideEnabled(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: Self.devKey)
    }

    func developerOverrideEnabled() -> Bool {
        UserDefaults.standard.bool(forKey: Self.devKey)
    }
}
