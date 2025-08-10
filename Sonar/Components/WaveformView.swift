import SwiftUI

struct WaveformView: View {
    var transcript: String
    @State private var phase: CGFloat = 0

    var body: some View {
        Canvas { context, size in
            let path = waveformPath(in: size, phase: phase)
            context.stroke(path, with: .color(.accentColor), lineWidth: 2)
        }
        .frame(height: 60)
        .onAppear { startAnimation() }
        .onChange(of: transcript) { startAnimation() }
        .accessibilityLabel("Live waveform")
    }

    private func startAnimation() {
        withAnimation(.linear(duration: 0.15).repeatForever(autoreverses: false)) {
            phase += 0.2
        }
    }

    private func waveformPath(in size: CGSize, phase: CGFloat) -> Path {
        var path = Path()
        let width = size.width
        let height = size.height
        let midY = height / 2
        let amplitude = max(8, min(24, CGFloat(transcript.count % 40)))
        let frequency = CGFloat(2)
        path.move(to: CGPoint(x: 0, y: midY))
        for x in stride(from: 0, through: width, by: 2) {
            let progress = x / width
            let y = midY + sin((progress * .pi * 2 * frequency) + phase) * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }
        return path
    }
}

#Preview { WaveformView(transcript: "hello world") }
