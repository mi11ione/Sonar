import SwiftData
import SwiftUI

struct SettingsView: View {
    @Environment(\.purchases) private var purchases
    @Environment(\.openURL) private var openURL
    @Query private var settingsRows: [UserSettings]
    @Query(sort: \PromptStyle.displayName) private var promptStyles: [PromptStyle]
    @State private var isSubscriber: Bool = false
    @State private var planId: String? = nil
    @State private var showPaywall: Bool = false
    @State private var devOverride: Bool = false
    @AppStorage("onboardingComplete") private var onboardingComplete: Bool = true

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
                    Toggle("Daily reminder", isOn: Binding(
                        get: { settings.dailyReminderHour != nil },
                        set: { enabled in
                            settings.dailyReminderHour = enabled ? (settings.dailyReminderHour ?? 20) : nil
                            if !enabled { UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["daily.reminder"]) }
                        }
                    ))
                    if settings.dailyReminderHour != nil {
                        Stepper("Reminder: \(settings.dailyReminderHour ?? 20):00", value: Binding(get: { settings.dailyReminderHour ?? 20 }, set: { newVal in
                            settings.dailyReminderHour = newVal
                            // Reschedule with new time
                            let content = UNMutableNotificationContent()
                            content.title = "Daily reflection"
                            content.body = "Take a minute to capture your thoughts."
                            var date = DateComponents(); date.hour = newVal
                            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
                            let req = UNNotificationRequest(identifier: "daily.reminder", content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(req)
                        }), in: 5 ... 22)
                    }
                    Picker("Default summary style", selection: Binding(get: { settings.selectedPromptStyleId }, set: { settings.selectedPromptStyleId = $0 })) {
                        Text("Default").tag(UUID?.none)
                        ForEach(promptStyles, id: \.id) { style in
                            Text(style.displayName).tag(Optional(style.id))
                        }
                    }
                }
            }
            Section("About") {
                LabeledContent("Version", value: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-")
                Button("Privacy Policy") { open(url: "https://example.com/privacy") }
                Button("Terms of Service") { open(url: "https://example.com/terms") }
                Button("Contact Support") { open(url: "mailto:support@example.com?subject=Sonar%20Support") }
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

    private func open(url: String) { if let u = URL(string: url) { openURL(u) } }
}

#Preview {
    NavigationStack { SettingsView() }
}
