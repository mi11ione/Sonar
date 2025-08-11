import StoreKit
import SwiftUI

struct PaywallView: View {
    @State private var products: [Product] = []
    @State private var isLoading: Bool = true
    @Environment(\.dismiss) private var dismiss
    @Environment(\.purchases) private var purchases
    @Environment(\.openURL) private var openURL

    private let productIds: [String] = [
        "sonar.pro.monthly",
        "sonar.premium.monthly",
        "sonar.max.monthly",
        "sonar.premium.annual",
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Unlock Sonar").font(.largeTitle.bold())
                    Text("Unlimited entries, custom styles, and insights.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)

                    if isLoading {
                        ProgressView()
                    } else if products.isEmpty {
                        ContentUnavailableView("No products", systemImage: "cart")
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
                                    Button("Buy") { Task { try? await purchases.purchase(productId: product.id) } }
                                        .buttonStyle(.borderedProminent)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                        }
                        Button("Restore Purchases") { Task { try? await purchases.restore() } }
                            .buttonStyle(.plain)
                            .padding(.top, 4)
                    }
                    Spacer()
                    VStack(spacing: 6) {
                        Button("Terms of Service") { openLegal(urlString: "https://example.com/terms") }
                            .buttonStyle(.plain)
                        Button("Privacy Policy") { openLegal(urlString: "https://example.com/privacy") }
                            .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Close") { dismiss() } } }
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
        case .day: return "/day"
        case .week: return "/week"
        case .month: return "/month"
        case .year: return "/year"
        @unknown default: return ""
        }
    }
}

#Preview { PaywallView() }
