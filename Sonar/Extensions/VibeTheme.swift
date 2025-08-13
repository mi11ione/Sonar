import SwiftUI

enum VibeTheme {
    static let cornerRadius: CGFloat = 14
    static let smallCornerRadius: CGFloat = 10
    static let sectionSpacing: CGFloat = 16
    static let cardPadding: CGFloat = 12
    static let strokeOpacity: Double = 0.10
    static let chipBackgroundOpacity: Double = 0.14
}

struct VibeCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(VibeTheme.cardPadding)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: VibeTheme.cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: VibeTheme.cornerRadius, style: .continuous)
                    .strokeBorder(.primary.opacity(VibeTheme.strokeOpacity), lineWidth: 1)
            )
    }
}

struct VibeBackground: View {
    @Environment(\.colorScheme) private var scheme
    var body: some View {
        ZStack {
            Color(.systemBackground)
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.accentColor.opacity(0.08),
                    .clear,
                ]),
                center: .topLeading,
                startRadius: 0,
                endRadius: 600
            )
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.04),
                    .clear,
                ]),
                center: .bottomTrailing,
                startRadius: 0,
                endRadius: 700
            )
        }
    }
}

extension View {
    func vibeCard() -> some View { modifier(VibeCardModifier()) }

    func vibeTag(tint: Color = .accentColor) -> some View {
        font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(tint.opacity(VibeTheme.chipBackgroundOpacity), in: Capsule())
            .foregroundStyle(tint)
    }

    func vibeBackground() -> some View {
        background(VibeBackground().ignoresSafeArea())
    }
}
