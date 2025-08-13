import SwiftUI

struct MicButton: View {
    var title: LocalizedStringKey
    var systemImageName: String = "mic.fill"
    var tint: Color? = nil
    var isDisabled: Bool = false
    var font: Font? = nil
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImageName)
                .font(font ?? .title2.bold())
                .padding()
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(tint ?? .accentColor)
        .disabled(isDisabled)
        .sensoryFeedback(.impact(weight: .light), trigger: title)
        .frame(minHeight: 44)
        .contentShape(Rectangle())
        .accessibilityLabel(title)
    }
}

#Preview {
    VStack(spacing: 16) {
        MicButton(title: "start_recording", action: {})
        MicButton(title: "stop", systemImageName: "stop.fill", tint: .red, action: {})
        MicButton(title: "processing_ellipsis", systemImageName: "hourglass", tint: .gray, isDisabled: true, action: {})
    }
    .padding()
}
