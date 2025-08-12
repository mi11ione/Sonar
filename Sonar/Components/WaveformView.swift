import OSLog
import SwiftUI

struct WaveformView: View {
    var transcript: String
    @Environment(\.transcription) private var transcription
    @State private var phase: CGFloat = 0
    @State private var amplitude: CGFloat = 0.1

    var body: some View {
        Canvas { context, size in
            let path = waveformPath(in: size, phase: phase, amplitude: amplitude)
            context.stroke(path, with: .color(.accentColor), lineWidth: 2)
        }
        .frame(height: 60)
        .onAppear {
            startAnimation()
            Task { await listenForAmplitude() }
            // Precompile shader to avoid first-use hitch when applied
            Task.detached {
                if let shader = try? await Shader(function: .init(library: .default, name: "sonar_color_wave"), arguments: [
                    .float(Float(amplitude)), .float(Float(phase)),
                ]) {
                    try? await shader.compile(as: .colorEffect)
                }
            }
        }
        .onChange(of: transcript) { startAnimation() }
        .accessibilityLabel("live_waveform")
        // Optional bloom via a SwiftUI colorEffect shader if present
        .modifier(ShaderGlowModifier(amplitude: amplitude, phase: phase))
    }

    private func startAnimation() {
        withAnimation(.linear(duration: 0.15).repeatForever(autoreverses: false)) {
            phase += 0.2
        }
    }

    private func waveformPath(in size: CGSize, phase: CGFloat, amplitude: CGFloat) -> Path {
        var path = Path()
        let width = size.width
        let height = size.height
        let midY = height / 2
        let amp = max(4, min(height * 0.45, amplitude * height * 0.45 + 6))
        let frequency = CGFloat(2)
        path.move(to: CGPoint(x: 0, y: midY))
        for x in stride(from: 0, through: width, by: 2) {
            let progress = x / width
            let y = midY + sin((progress * .pi * 2 * frequency) + phase) * amp
            path.addLine(to: CGPoint(x: x, y: y))
        }
        return path
    }

    private func listenForAmplitude() async {
        for await level in transcription.amplitudeStream() {
            await MainActor.run {
                // Smooth with a simple ease-in/out to avoid jitter
                withAnimation(.linear(duration: 0.08)) {
                    amplitude = CGFloat(level)
                }
            }
        }
    }
}

#Preview { WaveformView(transcript: "hello world") }

// MARK: - Optional shader-based glow

private struct ShaderGlowModifier: ViewModifier {
    var amplitude: CGFloat
    var phase: CGFloat
    func body(content: Content) -> some View {
        // Try to load our shader; if unavailable (e.g., older OS or no library), show plain content
        if let shader = try? Shader(function: .init(library: .default, name: "sonar_color_wave"), arguments: [
            .float(Float(amplitude)),
            .float(Float(phase)),
        ]) {
            // Apply as a color effect
            content.colorEffect(shader)
        } else {
            content
        }
    }
}
