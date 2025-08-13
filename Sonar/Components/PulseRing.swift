import SwiftUI

struct PulseRing: View {
    var color: Color = .accentColor
    var lineWidth: CGFloat = 3
    var count: Int = 3
    var body: some View {
        ZStack {
            ForEach(0 ..< count, id: \.self) { i in
                Circle()
                    .stroke(color.opacity(0.4 - Double(i) * 0.1), lineWidth: lineWidth)
                    .scaleEffect(animate ? CGFloat(1 + i) : 0.8)
                    .opacity(animate ? 0.0 : 1.0)
                    .animation(
                        .easeOut(duration: 1.6)
                            .repeatForever(autoreverses: false)
                            .delay(Double(i) * 0.25),
                        value: animate
                    )
            }
        }
        .onAppear { animate = true }
    }

    @State private var animate = false
}

#Preview { PulseRing() }
