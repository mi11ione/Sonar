import Foundation
import OSLog
import StoreKit

protocol PurchasesService: Sendable {
    /// Returns true if the user has any paid entitlement (Pro, Premium, or Lifetime)
    func isSubscriber() async -> Bool
    /// Returns the active plan identifier (product ID) if subscribed, or "sonar.lifetime" if lifetime is owned
    func currentPlanIdentifier() async -> String?
    /// High-level plan mapping for gating logic
    func currentPlan() async -> PurchasesPlan
    /// Purchase a product; optionally apply a promotional offer with compact JWS (win-back).
    func purchase(productId: String, promotionalOfferID: String?, compactJWS: String?) async throws
    /// Restore purchases (synchronizes the App Store account)
    func restore() async throws
    /// Developer convenience: force-entitle all features locally
    func setDeveloperOverrideEnabled(_ enabled: Bool)
    func developerOverrideEnabled() -> Bool
}

extension PurchasesService {
    /// Convenience overload to preserve existing call sites
    func purchase(productId: String) async throws {
        try await purchase(productId: productId, promotionalOfferID: nil, compactJWS: nil)
    }
}

enum PurchasesPlan: Sendable, Equatable {
    case free
    case pro
    case premium
    case lifetime

    var isPaid: Bool { self != .free }
    var isPro: Bool { self == .pro }
    var isPremiumOrLifetime: Bool { self == .premium || self == .lifetime }
}

struct DefaultPurchasesService: PurchasesService, Sendable {
    private static let devKey = "dev.subscription.override"
    private let logger = Logger.purchase

    // MARK: - Public API

    func isSubscriber() async -> Bool {
        if developerOverrideEnabled() { return true }
        let plan = await currentPlan()
        return plan.isPaid
    }

    func currentPlanIdentifier() async -> String? {
        if developerOverrideEnabled() { return "dev.max.override" }
        // Prefer subscription product IDs; fall back to lifetime if owned
        if let subId = await activeSubscriptionProductID() { return subId }
        if await hasLifetimeEntitlement() { return "sonar.lifetime" }
        return nil
    }

    func currentPlan() async -> PurchasesPlan {
        if developerOverrideEnabled() { return .lifetime }
        if await hasLifetimeEntitlement() { return .lifetime }
        if let id = await activeSubscriptionProductID() {
            if id.contains("premium") { return .premium }
            if id.contains("pro") { return .pro }
        }
        return .free
    }

    func purchase(productId: String, promotionalOfferID: String? = nil, compactJWS: String? = nil) async throws {
        logger.log("purchase_tap plan=\(productId, privacy: .public)")
        let products = try await Product.products(for: [productId])
        guard let product = products.first else { return }
        do {
            let result: Product.PurchaseResult
            if let offerId = promotionalOfferID, let jws = compactJWS {
                // Apply promotional offer using compact JWS per StoreKit API
                // See: Product.PurchaseOption.promotionalOffer(_:compactJWS:) in framework sources
                let options = Set(Product.PurchaseOption.promotionalOffer(offerId, compactJWS: jws))
                result = try await product.purchase(options: options)
            } else {
                result = try await product.purchase()
            }
            switch result {
            case let .success(verification):
                if case let .verified(transaction) = verification {
                    await transaction.finish() // StoreKit Transaction.finish() to acknowledge delivery
                    logger.log("purchase_success plan=\(transaction.productID, privacy: .public)")
                } else {
                    logger.error("purchase_unverified plan=\(productId, privacy: .public)")
                }
            case .userCancelled:
                logger.log("purchase_cancelled plan=\(productId, privacy: .public)")
            case .pending:
                logger.log("purchase_pending plan=\(productId, privacy: .public)")
            @unknown default:
                logger.error("purchase_result_unknown plan=\(productId, privacy: .public)")
            }
        } catch {
            logger.error("purchase_error plan=\(productId, privacy: .public) error=\(String(describing: error), privacy: .public)")
            throw error
        }
    }

    func restore() async throws {
        logger.log("restore_tap")
        try await AppStore.sync()
        logger.log("restore_success")
    }

    func setDeveloperOverrideEnabled(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: Self.devKey)
    }

    func developerOverrideEnabled() -> Bool {
        UserDefaults.standard.bool(forKey: Self.devKey)
    }

    // MARK: - Helpers

    private func activeSubscriptionProductID() async -> String? {
        for await entitlement in Transaction.currentEntitlements {
            if case let .verified(transaction) = entitlement, transaction.productType == .autoRenewable {
                return transaction.productID
            }
        }
        return nil
    }

    private func hasLifetimeEntitlement() async -> Bool {
        // Treat ownership of the non-consumable as Premium scope forever
        for await entitlement in Transaction.currentEntitlements {
            if case let .verified(transaction) = entitlement, transaction.productType == .nonConsumable, transaction.productID == "sonar.lifetime" {
                return true
            }
        }
        return false
    }
}
