import StoreKit
import SwiftUI

struct PaywallView: View {
    @State private var products: [Product] = []
    @State private var isLoading: Bool = true
    @State private var showManageSheet: Bool = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.purchases) private var purchases
    @Environment(\.openURL) private var openURL

    private let productIds: [String] = [
        "sonar.pro.monthly",
        "sonar.premium.monthly",
        "sonar.premium.annual",
        "sonar.lifetime",
    ]
    private let groupID = "sonar.subscriptions"

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("paywall_title").font(.largeTitle.bold())
                    Text("paywall_subtitle")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)

                    if isLoading {
                        ProgressView()
                    } else if products.isEmpty {
                        ContentUnavailableView("no_products", systemImage: "cart")
                    } else {
                        // Use indices to avoid any Binding overload inference
                        ForEach(products.indices, id: \.self) { index in
                            let product = products[index]
                            VStack(alignment: .leading, spacing: 8) {
                                // Render promoted icon by product ID to avoid passing a Binding<Product>
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
                    }
                }
                .padding()
            }
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("close") { dismiss() } } }
            .task { await loadProducts() }
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
