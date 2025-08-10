import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.purchases) private var purchases
    @Environment(\.openURL) private var openURL
    @Query private var settingsRows: [UserSettings]
    @State private var isSubscriber: Bool = false
    @State private var planId: String? = nil
    @State private var showPaywall: Bool = false
    @State private var devOverride: Bool = false

    var body: some View {
        List {
            Section("Subscription") {
                if isSubscriber { LabeledContent("Status", value: planId ?? "Active") }
                Button(isSubscriber ? "Change Plan" : "View Plans") { showPaywall = true }
                Button("Restore Purchases") { Task { try? await purchases.restore() } }
            }
            Section("Developer") {
                Toggle("Developer: Unlimited subscription", isOn: Binding(
                    get: { devOverride },
                    set: { newValue in
                        devOverride = newValue
                        purchases.setDeveloperOverrideEnabled(newValue)
                        Task {
                            isSubscriber = await purchases.isSubscriber()
                            planId = await purchases.currentPlanIdentifier()
                        }
                    }
                ))
                .tint(.pink)
            }
            if let settings = settingsRows.first {
                Section("Preferences") {
                    Toggle("On-device transcription only", isOn: Binding(get: { settings.allowOnDeviceOnly }, set: { settings.allowOnDeviceOnly = $0 }))
                    Stepper("Reminder: \(settings.dailyReminderHour ?? 20):00", value: Binding(get: { settings.dailyReminderHour ?? 20 }, set: { settings.dailyReminderHour = $0 }), in: 5...22)
                }
            }
            Section("About") {
                LabeledContent("Version", value: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-")
            }
        }
        .navigationTitle("Settings")
        .task {
            isSubscriber = await purchases.isSubscriber()
            planId = await purchases.currentPlanIdentifier()
            devOverride = purchases.developerOverrideEnabled()
        }
        .sheet(isPresented: $showPaywall) { PaywallView() }
    }
}

#Preview {
    NavigationStack { SettingsView() }
}
