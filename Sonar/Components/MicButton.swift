import SwiftUI

struct MicButton: View {
    var title: LocalizedStringKey
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: "mic.fill")
                .font(.title2.bold())
                .padding()
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .sensoryFeedback(.impact(weight: .light), trigger: title)
    }
}

#Preview {
    MicButton(title: "Start Recording", action: {})
        .padding()
}
