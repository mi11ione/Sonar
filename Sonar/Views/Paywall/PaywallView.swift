import SwiftUI
import StoreKit

struct PaywallView: View {
    @State private var products: [Product] = []
    @State private var isLoading: Bool = true
    @Environment(\.dismiss) private var dismiss
    @Environment(\.purchases) private var purchases

    private let productIds: [String] = [
        "sonar.pro.monthly",
        "sonar.premium.monthly",
        "sonar.max.monthly",
        "sonar.premium.annual"
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Unlock Sonar")
                    .font(.largeTitle.bold())
                Text("Unlimited entries, custom styles, and insights.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                if isLoading {
                    ProgressView()
                } else if products.isEmpty {
                    ContentUnavailableView("No products", systemImage: "cart")
                } else {
                    ForEach(products, id: \.id) { product in
                        Button {
                            Task { _ = try? await product.purchase() }
                        } label: {
                            VStack(alignment: .leading) {
                                Text(product.displayName).font(.headline)
                                Text(product.displayPrice).font(.subheadline).foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    Button("Restore Purchases") { Task { try? await purchases.restore() } }
                        .buttonStyle(.plain)
                        .padding(.top, 4)
                }
                Spacer()
            }
            .padding()
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
}

#Preview { PaywallView() }


