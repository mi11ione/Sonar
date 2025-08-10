import SwiftData
import SwiftUI
import UserNotifications

struct OnboardingFlow: View {
    @AppStorage("onboardingComplete") private var onboardingComplete: Bool = false
    @Environment(\.modelContext) private var modelContext
    @Environment(\.transcription) private var transcription

    @Query private var settingsRows: [UserSettings]
    @Query(sort: \PromptStyle.displayName) private var promptStyles: [PromptStyle]

    @State private var step: Int = 0
    @State private var onDeviceOnly: Bool = true
    @State private var reminderHour: Int = 20
    @State private var selectedPromptStyleId: UUID? = nil
    @State private var notificationsEnabled: Bool = false

    var body: some View {
        VStack(spacing: 24) {
            switch step {
            case 0: intro
            case 1: permissions
            default: personalization
            }
            progress
        }
        .padding()
        .task { hydrateFromStore() }
    }

    private var intro: some View {
        VStack(spacing: 16) {
            Text("Welcome to Sonar")
                .font(.largeTitle.bold())
            VStack(alignment: .leading, spacing: 8) {
                Text("Private, on-device voice journaling.")
                    .foregroundStyle(.secondary)
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
                    Text("Tap to record. Low-latency, on-device transcription.")
                }
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
                    Text("Instant summaries tailored to your style.")
                }
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
                    Text("Mood insight at a glance. Fast search across your thoughts.")
                }
                HStack(spacing: 8) {
                    MoodBadge(label: "Positive", score: 0.6)
                    Text("Mood badges summarize tone without sharing your data.")
                        .foregroundStyle(.secondary)
                }
            }
            Toggle("On-device transcription only", isOn: $onDeviceOnly)
            Spacer(minLength: 8)
            Button("Continue") { step = 1 }
                .buttonStyle(.borderedProminent)
        }
    }

    private var permissions: some View {
        VStack(spacing: 16) {
            Text("Permissions")
                .font(.title.bold())
            Text("We'll ask for Microphone and Speech so you can record and transcribe on device. Notifications are optional for gentle reminders.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            HStack(spacing: 12) {
                Button("Enable Mic & Speech") { Task { try? await transcription.requestAuthorization() } }
                Button("Enable Notifications") { Task { await requestNotifications() } }
            }
            .buttonStyle(.bordered)
            Spacer(minLength: 8)
            HStack {
                Button("Back") { step = 0 }
                Spacer()
                Button("Continue") { step = 2 }
                    .buttonStyle(.borderedProminent)
            }
        }
    }

    private var personalization: some View {
        VStack(spacing: 16) {
            Text("Make it yours")
                .font(.title.bold())
            HStack {
                Text("Daily reminder")
                Spacer()
                Stepper("\(reminderHour):00", value: $reminderHour, in: 5 ... 22)
                    .labelsHidden()
            }
            Picker("Summary style", selection: $selectedPromptStyleId) {
                Text("Default").tag(UUID?.none)
                ForEach(promptStyles, id: \.id) { style in
                    Text(style.displayName).tag(Optional(style.id))
                }
            }
            .pickerStyle(.menu)
            Spacer(minLength: 8)
            HStack {
                Button("Back") { step = 1 }
                Spacer()
                Button("Start Recording") { finish() }
                    .buttonStyle(.borderedProminent)
            }
        }
    }

    private var progress: some View {
        HStack {
            Text("\(step + 1)/3")
                .font(.caption.monospacedDigit())
                .foregroundStyle(.secondary)
            Spacer()
        }
    }

    private func hydrateFromStore() {
        let settings = settingsRows.first
        onDeviceOnly = settings?.allowOnDeviceOnly ?? true
        if let hour = settings?.dailyReminderHour { reminderHour = hour }
        selectedPromptStyleId = settings?.selectedPromptStyleId
    }

    private func requestNotifications() async {
        let center = UNUserNotificationCenter.current()
        let granted: Bool = await withCheckedContinuation { continuation in
            center.requestAuthorization(options: [.alert, .sound]) { ok, _ in
                continuation.resume(returning: ok)
            }
        }
        notificationsEnabled = granted
    }

    private func scheduleDailyReminder(at hour: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Daily reflection"
        content.body = "Take a minute to capture your thoughts."
        var date = DateComponents()
        date.hour = hour
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: "daily.reminder", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    private func finish() {
        // Persist settings
        let settings = settingsRows.first ?? {
            let s = UserSettings()
            modelContext.insert(s)
            return s
        }()
        settings.allowOnDeviceOnly = onDeviceOnly
        settings.dailyReminderHour = reminderHour
        settings.selectedPromptStyleId = selectedPromptStyleId
        try? modelContext.save()

        if notificationsEnabled { scheduleDailyReminder(at: reminderHour) }
        onboardingComplete = true
    }
}

#Preview {
    OnboardingFlow()
}
