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
        .vibeCard()
        .task { hydrateFromStore() }
    }

    private var intro: some View {
        VStack(spacing: 16) {
            Text("onboard_welcome")
                .font(.largeTitle.bold())
            VStack(alignment: .leading, spacing: 8) {
                Text("onboard_private_local")
                    .foregroundStyle(.secondary)
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
                    Text("onboard_tap_to_record")
                }
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("onboard_instant_summaries")
                        Text("onboard_summary_privacy")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
                    Text("onboard_mood_search")
                }
                HStack(spacing: 8) {
                    MoodBadge(label: "Positive", score: 0.6)
                    Text("onboard_mood_privacy")
                        .foregroundStyle(.secondary)
                }
                HStack(spacing: 8) {
                    Image(systemName: "lock.fill").foregroundStyle(.green)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("onboard_no_account")
                        Text("onboard_whats_stored")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            Toggle("on_device_only", isOn: $onDeviceOnly)
            Spacer(minLength: 8)
            Button("continue") { step = 1 }
                .buttonStyle(.borderedProminent)
            Text("onboard_find_later")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .vibeCard()
    }

    private var permissions: some View {
        VStack(spacing: 16) {
            Text("onboard_permissions")
                .font(.title.bold())
            Text("onboard_permissions_copy")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            HStack(spacing: 12) {
                Button("enable_mic_speech") { Task { try? await transcription.requestAuthorization() } }
                Button("enable_notifications") { Task { await requestNotifications() } }
            }
            .buttonStyle(.bordered)
            if !notificationsEnabled {
                Text("onboard_reminders_later")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 8)
            HStack {
                Button("back") { step = 0 }
                Spacer()
                Button("continue") { step = 2 }
                    .buttonStyle(.borderedProminent)
            }
        }
        .vibeCard()
    }

    private var personalization: some View {
        VStack(spacing: 16) {
            Text("onboard_make_it_yours")
                .font(.title.bold())
            HStack {
                Text("daily_reminder")
                Spacer()
                Stepper("\(reminderHour):00", value: $reminderHour, in: 5 ... 22)
                    .labelsHidden()
            }
            Picker("summary_style", selection: $selectedPromptStyleId) {
                Text("default").tag(UUID?.none)
                ForEach(promptStyles, id: \.id) { style in
                    Text(style.displayName).tag(Optional(style.id))
                }
            }
            .pickerStyle(.menu)
            Spacer(minLength: 8)
            HStack {
                Button("back") { step = 1 }
                Spacer()
                Button("start_recording") { finish() }
                    .buttonStyle(.borderedProminent)
            }
        }
        .vibeCard()
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
        content.title = String(localized: "daily_reflection")
        content.body = String(localized: "daily_reflection_body")
        var date = DateComponents()
        date.hour = hour
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        content.categoryIdentifier = "daily.reminder.category"
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
        // On finish, deep link to the Record tab immediately
        UserDefaults.standard.set(0, forKey: "deeplink.targetTab")
    }
}

#Preview {
    OnboardingFlow()
}
