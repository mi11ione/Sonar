import OSLog
import StoreKit
import SwiftUI

struct PaywallView: View {
    @State private var products: [Product] = []
    @State private var isLoading: Bool = true
    @State private var showManageSheet: Bool = false
    @State private var showLifetimeSheet: Bool = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.purchases) private var purchases
    @Environment(\.openURL) private var openURL
    @AppStorage("paywall.preferredTerm") private var preferredTerm: String = "annual"
    private let logger = Logger.purchase

    private let productIds: [String] = [
        "sonar.pro.monthly",
        "sonar.premium.monthly",
        "sonar.premium.annual",
        "sonar.lifetime",
    ]
    private let groupID = "sonar.subscriptions"
    private let source: String

    init(source: String = "settings") {
        self.source = source
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Unlock Sonar").font(.largeTitle.bold())
                    Text(contextMessage)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)

                    termToggle

                    if isLoading {
                        ProgressView()
                    } else if products.isEmpty {
                        ContentUnavailableView("no_products", systemImage: "cart")
                    } else {
                        planGrid
                        Button("restore_purchases") { Task { try? await purchases.restore() } }
                            .buttonStyle(.plain)
                            .padding(.top, 4)
                        Divider().padding(.vertical, 8)
                        // Manage subscriptions and upgrade/downgrade affordances when already subscribed
                        SubscriptionStatusView(groupID: groupID)
                        HStack {
                            Spacer()
                            Button("manage_subscription") { showManageSheet = true }
                                .buttonStyle(.bordered)
                                .manageSubscriptionsSheet(isPresented: $showManageSheet, subscriptionGroupID: groupID)
                        }
                    }
                    Spacer()
                    VStack(spacing: 6) {
                        Button("terms_of_service") { openLegal(urlString: "https://example.com/terms") }
                            .buttonStyle(.plain)
                        Button("privacy_policy") { openLegal(urlString: "https://example.com/privacy") }
                            .buttonStyle(.plain)
                        HStack(spacing: 6) {
                            Image(systemName: "lock.shield").foregroundStyle(.secondary)
                            Text("Private. On-device processing.").foregroundStyle(.secondary)
                        }
                        Text("Cancel anytime in Settings.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
            }
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("close") { incrementCloseCounter(increment: true); dismiss() } } }
            .task { await loadProducts() }
            .onAppear {
                logger.log("paywall_shown source=\(source, privacy: .public) planDefault=\(preferredTerm, privacy: .public)")
                incrementCloseCounter(increment: false)
            }
        }
    }

    private var termToggle: some View {
        HStack {
            Picker("Billing", selection: Binding(get: {
                preferredTerm
            }, set: { newValue in
                preferredTerm = newValue
            })) {
                Text("Monthly").tag("monthly")
                Text("Annual").tag("annual")
            }
            .pickerStyle(.segmented)
            .onAppear {
                // Default returning users to Annual emphasis if unset
                if preferredTerm.isEmpty { preferredTerm = "annual" }
            }
        }
        .overlay(alignment: .bottomTrailing) {
            if preferredTerm == "annual" {
                Text("Save ~46% vs monthly").font(.caption2).foregroundStyle(.secondary)
            }
        }
    }

    @ViewBuilder private var planGrid: some View {
        let monthly = filteredProducts(term: "monthly")
        let annual = filteredProducts(term: "annual")
        let showing = preferredTerm == "monthly" ? monthly : annual

        VStack(spacing: 12) {
            ForEach(showing.indices, id: \.self) { index in
                let product = showing[index]
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(product.displayName).font(.headline)
                        Spacer()
                        if product.id.contains("premium") {
                            Text("Most Popular").font(.caption2).padding(.horizontal, 6).padding(.vertical, 2).background(Color.accentColor.opacity(0.15), in: Capsule())
                        }
                        if product.id.contains("annual") {
                            Text("Best Value").font(.caption2).padding(.horizontal, 6).padding(.vertical, 2).background(Color.green.opacity(0.15), in: Capsule())
                        }
                    }
                    ProductView(id: product.id, prefersPromotionalIcon: true) {
                        Image(systemName: "cart")
                    } placeholderIcon: {
                        Image(systemName: "cart")
                    }
                    .productViewStyle(.regular)
                    .productDescription(.visible)
                    HStack(spacing: 8) {
                        Text(product.displayPrice).bold()
                        if let info = product.subscription {
                            Text(unitLabel(info.subscriptionPeriod.unit)).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Button("buy") { Task { try? await purchases.purchase(productId: product.id) } }
                            .buttonStyle(.borderedProminent)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
            }

            if let lifetime = products.first(where: { $0.id == "sonar.lifetime" }) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Lifetime").font(.headline)
                        Spacer()
                        Text("Pay once — keep Premium forever").font(.caption).foregroundStyle(.secondary)
                    }
                    HStack {
                        Text(lifetime.displayPrice).bold()
                        Spacer()
                        Button("buy") { Task { try? await purchases.purchase(productId: lifetime.id) } }
                            .buttonStyle(.bordered)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
            if let offerJWS = UserDefaults.standard.string(forKey: "promo.offer.jws"),
               UserDefaults.standard.bool(forKey: "promo.winback.eligible"),
               let premiumMonthly = products.first(where: { $0.id == "sonar.premium.monthly" })
            {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Win-back offer: 50% off 1 month").font(.subheadline.bold())
                    Button("Redeem offer") { Task { try? await purchases.purchase(productId: premiumMonthly.id, promotionalOfferID: "winback50", compactJWS: offerJWS) } }
                        .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.yellow.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    private func loadProducts() async {
        defer { isLoading = false }
        do {
            products = try await Product.products(for: Set(productIds))
            products.sort { $0.price < $1.price }
        } catch {
            products = []
        }
    }

    private func openLegal(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        openURL(url)
    }

    private func unitLabel(_ unit: Product.SubscriptionPeriod.Unit) -> String {
        switch unit {
        case .day: return String(localized: "per_day")
        case .week: return String(localized: "per_week")
        case .month: return String(localized: "per_month")
        case .year: return String(localized: "per_year")
        @unknown default: return "unknown"
        }
    }

    private func filteredProducts(term: String) -> [Product] {
        products.filter { p in
            guard p.id != "sonar.lifetime" else { return false }
            if term == "annual" { return p.id.hasSuffix(".annual") }
            return p.id.hasSuffix(".monthly")
        }
        .sorted { lhs, rhs in
            // Order plans: Premium first
            if lhs.id.contains("premium"), !rhs.id.contains("premium") { return true }
            if rhs.id.contains("premium"), !lhs.id.contains("premium") { return false }
            return lhs.price < rhs.price
        }
    }

    private var contextMessage: String {
        let closes = UserDefaults.standard.integer(forKey: "paywall.closeCount")
        if closes >= 2 {
            return "Unlimited entries, deeper insights, and search that remembers. Save ~46% with annual."
        }
        switch source {
        case "gate":
            return "Keep unlimited entries, deeper insights, and search your history."
        case "insights":
            return "Unlock trends, weekly highlights, and smart filters."
        default:
            return "Unlimited entries, deeper insights, and search that remembers."
        }
    }

    private func incrementCloseCounter(increment: Bool) {
        let key = "paywall.closeCount"
        if increment {
            let v = UserDefaults.standard.integer(forKey: key)
            UserDefaults.standard.set(v + 1, forKey: key)
        }
    }
}

#Preview { PaywallView() }

// MARK: - Entitlement-aware upgrade/downgrade status

private struct SubscriptionStatusView: View {
    let groupID: String
    @State private var statuses: [Product.SubscriptionInfo.Status] = []
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if statuses.isEmpty {
                Text("not_subscribed").font(.footnote).foregroundStyle(.secondary)
            } else {
                ForEach(Array(statuses.enumerated()), id: \.offset) { _, status in
                    Text(label(for: status.state)).bold()
                }
                Text("change_plan_via_apple").font(.footnote).foregroundStyle(.secondary)
            }
        }
        .subscriptionStatusTask(for: groupID) { state in
            if let s = state.value { statuses = s }
        }
    }

    private func label(for state: Product.SubscriptionInfo.RenewalState) -> LocalizedStringKey {
        switch state {
        case .subscribed: "subscribed"
        case .expired: "expired"
        case .inBillingRetryPeriod: "billing_retry"
        case .inGracePeriod: "grace_period"
        case .revoked: "revoked"
        default: "unknown"
        }
    }
}
