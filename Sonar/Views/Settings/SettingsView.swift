import SwiftData
import SwiftUI
internal import AVFAudio

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
            Section("Tags") {
                NavigationLink("Manage tags") { ManageTagsView() }
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
                    NavigationLink("Text-to-speech options") { TTSSettingsView() }
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

private struct TTSSettingsView: View {
    @Environment(\.tts) private var tts
    @State private var selectedVoiceIdentifier: String? = nil
    @State private var rate: Float = 0.5
    @State private var pitch: Float = 1.0
    var body: some View {
        List {
            Section("Voice") {
                ForEach(tts.availableVoices(), id: \.identifier) { voice in
                    Button {
                        selectedVoiceIdentifier = voice.identifier
                    } label: {
                        HStack {
                            Text(voice.name)
                            Spacer()
                            if selectedVoiceIdentifier == voice.identifier { Image(systemName: "checkmark") }
                        }
                    }
                }
            }
            Section("Preview") {
                Slider(value: Binding(get: { Double(rate) }, set: { rate = Float($0) }), in: 0.2 ... 0.7) { Text("Rate") }
                Slider(value: Binding(get: { Double(pitch) }, set: { pitch = Float($0) }), in: 0.5 ... 2.0) { Text("Pitch") }
                Button("Play sample") {
                    let voice = tts.availableVoices().first(where: { $0.identifier == selectedVoiceIdentifier })
                    tts.speak("This is your Sonar summary voice.", voice: voice, rate: rate, pitch: pitch)
                }
                Button("Stop") { tts.stop() }
            }
        }
        .navigationTitle("Text-to-speech")
    }
}

private struct ManageTagsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Tag.name) private var tags: [Tag]
    @State private var newTag: String = ""
    var body: some View {
        List {
            Section("New Tag") {
                HStack {
                    TextField("Name", text: $newTag)
                    Button("Add") { addTag() }.disabled(newTag.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            Section("All Tags") {
                ForEach(tags) { tag in
                    Text(tag.name)
                }
                .onDelete(perform: delete)
            }
        }
        .navigationTitle("Manage Tags")
    }

    private func addTag() {
        let name = newTag.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return }
        if tags.first(where: { $0.name.caseInsensitiveCompare(name) == .orderedSame }) == nil {
            let t = Tag(name: name)
            modelContext.insert(t)
            try? modelContext.save()
        }
        newTag = ""
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(tags[index])
        }
        try? modelContext.save()
    }
}

#Preview {
    NavigationStack { SettingsView() }
}
