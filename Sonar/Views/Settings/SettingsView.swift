import SwiftUI

struct SettingsView: View {
    var body: some View {
        List {
            Section("Subscription") {
                Button("Manage Subscription") {}
                Button("Restore Purchases") {}
            }
            Section("About") {
                LabeledContent("Version", value: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-")
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack { SettingsView() }
}
