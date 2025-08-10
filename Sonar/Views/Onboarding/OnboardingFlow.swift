import SwiftUI
import SwiftData
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
            Text("Private, on-device voice journaling with instant summaries and mood insights.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
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
                Stepper("\(reminderHour):00", value: $reminderHour, in: 5...22)
                    .labelsHidden()
            }
            Picker("Summary style", selection: $selectedPromptStyleId) {
                Text("Default").tag(Optional<UUID>.none)
                ForEach(promptStyles, id: \.id) { style in
                    Text(style.displayName).tag(Optional(style.id))
                }
            }
            .pickerStyle(.menu)
            Spacer(minLength: 8)
            HStack {
                Button("Back") { step = 1 }
                Spacer()
                Button("Finish") { finish() }
                    .buttonStyle(.borderedProminent)
            }
        }
    }

    private var progress: some View {
        HStack {
            Text("\(step+1)/3")
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


