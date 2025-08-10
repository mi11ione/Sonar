import SwiftUI

struct MicButton: View {
    var title: LocalizedStringKey
    var systemImageName: String = "mic.fill"
    var tint: Color? = nil
    var isDisabled: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImageName)
                .font(.title2.bold())
                .padding()
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(tint ?? .accentColor)
        .disabled(isDisabled)
        .sensoryFeedback(.impact(weight: .light), trigger: title)
    }
}

#Preview {
    VStack(spacing: 16) {
        MicButton(title: "Start Recording", action: {})
        MicButton(title: "Stop", systemImageName: "stop.fill", tint: .red, action: {})
        MicButton(title: "Processing…", systemImageName: "hourglass", tint: .gray, isDisabled: true, action: {})
    }
        .padding()
}
