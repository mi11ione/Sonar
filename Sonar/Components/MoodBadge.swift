import SwiftUI

struct MoodBadge: View {
    var label: String
    var score: Double

    var body: some View {
        Text(label)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.15), in: Capsule())
            .foregroundStyle(color)
            .accessibilityLabel("Mood: \(label)")
    }

    private var color: Color {
        if score > 0.2 { return .green }
        if score < -0.2 { return .red }
        return .orange
    }
}

#Preview {
    HStack {
        MoodBadge(label: "Positive", score: 0.6)
        MoodBadge(label: "Neutral", score: 0.0)
        MoodBadge(label: "Negative", score: -0.5)
    }
}


