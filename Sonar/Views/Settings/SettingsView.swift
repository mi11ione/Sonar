import SwiftData
import SwiftUI
internal import AVFAudio

struct SettingsView: View {
    @Environment(\.purchases) private var purchases
    @Environment(\.openURL) private var openURL
    @Environment(\.modelContext) private var modelContext
    @Query private var settingsRows: [UserSettings]
    @Query(sort: \PromptStyle.displayName) private var promptStyles: [PromptStyle]
    @State private var isSubscriber: Bool = false
    @State private var planId: String? = nil
    @State private var showPaywall: Bool = false
    @State private var devOverride: Bool = false
    @State private var exportURL: URL? = nil
    @State private var showExporter: Bool = false
    @AppStorage("onboardingComplete") private var onboardingComplete: Bool = true

    var body: some View {
        List {
            Section("Subscription") {
                if isSubscriber { LabeledContent("Status", value: planId ?? "Active") }
                Button(isSubscriber ? "Change Plan" : "View Plans") { showPaywall = true }
                Button("Restore Purchases") { Task { try? await purchases.restore() } }
            }
            Section("Tags") { NavigationLink("Manage tags") { ManageTagsView() } }
            Section("Threads") { NavigationLink("Manage threads") { ManageThreadsView() } }
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
                    Toggle("iCloud sync", isOn: Binding(get: { settings.iCloudSyncEnabled }, set: { settings.iCloudSyncEnabled = $0 }))
                    Toggle("On-device transcription only", isOn: Binding(get: { settings.allowOnDeviceOnly }, set: { settings.allowOnDeviceOnly = $0 }))
                    Toggle("Daily prompt", isOn: Binding(
                        get: { (settings.dailyReminderHour ?? 20) >= 0 },
                        set: { enabled in
                            settings.dailyReminderHour = enabled ? (settings.dailyReminderHour ?? 20) : nil
                            if enabled, let hour = settings.dailyReminderHour {
                                Task { await NotificationResponder.shared.scheduleDailyPrompt(atHour: hour) }
                            } else {
                                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["daily.reminder"])
                            }
                        }
                    ))
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
                            Task { await NotificationResponder.shared.scheduleDailyPrompt(atHour: newVal) }
                        }), in: 5 ... 22)
                    }
                    Picker("Default summary style", selection: Binding(get: { settings.selectedPromptStyleId }, set: { settings.selectedPromptStyleId = $0 })) {
                        Text("Default").tag(UUID?.none)
                        ForEach(promptStyles, id: \.id) { style in
                            Text(style.displayName).tag(Optional(style.id))
                        }
                    }
                    NavigationLink("Text-to-speech options") { TTSSettingsView() }
                    Toggle("Weekly insights", isOn: Binding(
                        get: { settings.weeklyInsightsEnabled },
                        set: { settings.weeklyInsightsEnabled = $0 }
                    ))
                }
                Section("Data") {
                    Button("Export JSON (entries only)") { generateExportJSON() }
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
        .sheet(isPresented: $showExporter) {
            VStack(spacing: 16) {
                Text("Share your export").font(.headline)
                if let url = exportURL {
                    ShareLink(item: url) { Label("Share Export", systemImage: "square.and.arrow.up") }
                } else {
                    ContentUnavailableView("No export available", systemImage: "doc")
                }
            }
            .padding()
        }
    }

    private func open(url: String) { if let u = URL(string: url) { openURL(u) } }

    // MARK: - Lightweight JSON export

    private func generateExportJSON() {
        let entries: [JournalEntry] = (try? modelContext.fetch(FetchDescriptor<JournalEntry>())) ?? []
        let payload: [[String: Any]] = entries.map { e in
            var dict: [String: Any] = [
                "id": e.id.uuidString,
                "createdAt": e.createdAt.timeIntervalSince1970,
                "updatedAt": e.updatedAt.timeIntervalSince1970,
                "title": e.title ?? "",
                "transcript": e.transcript,
                "summary": e.summary ?? "",
                "tags": e.tags.map(\.name),
            ]
            if let s = e.moodScore { dict["moodScore"] = s }
            if let l = e.moodLabel { dict["moodLabel"] = l }
            return dict
        }
        guard JSONSerialization.isValidJSONObject(payload),
              let data = try? JSONSerialization.data(withJSONObject: payload, options: [.prettyPrinted])
        else { return }
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("Sonar-Export.json")
        do {
            try data.write(to: url)
            exportURL = url
            showExporter = true
        } catch {
            exportURL = nil
            showExporter = false
        }
    }
}

private struct TTSSettingsView: View {
    @Environment(\.tts) private var tts
    @Query private var settingsRows: [UserSettings]
    @State private var selectedVoiceIdentifier: String? = nil
    @State private var rate: Float = 0.5
    @State private var pitch: Float = 1.0
    private let samplePhrases: [String] = [
        "Hi, I'm Sonar. I'll read your summaries just like this.",
        "Hello from Sonar. Here's a quick preview of your journal voice.",
        "Hey! Sonar here. This is how entries will sound when spoken.",
        "Nice to meet you! I'm Sonar, reading a sample out loud.",
        "Welcome to Sonar. Your summaries can be read in this voice.",
        "Hi there, this is Sonar giving you a quick voice check.",
        "Sonar speaking! Here's a short sample for you.",
        "Preview from Sonar: this is your reading voice.",
    ]

    private func randomSample() -> String {
        samplePhrases.randomElement() ?? "Hi from Sonar."
    }

    private var voicesByLanguage: [(code: String, display: String, voices: [AVSpeechSynthesisVoice])] {
        let all = tts.availableVoices()
        var grouped: [String: [AVSpeechSynthesisVoice]] = [:]
        for v in all {
            grouped[v.language, default: []].append(v)
        }

        var result: [(code: String, display: String, voices: [AVSpeechSynthesisVoice])] = []
        for (code, voices) in grouped {
            var seenNames: Set<String> = []
            let dedup = voices.filter { v in
                if seenNames.contains(v.name) { return false }
                seenNames.insert(v.name)
                return true
            }.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
            let display = Locale.current.localizedString(forIdentifier: code) ?? code
            result.append((code: code, display: display, voices: dedup))
        }
        result.sort(by: { lhs, rhs in
            lhs.display.localizedCaseInsensitiveCompare(rhs.display) == .orderedAscending
        })
        return result
    }

    var body: some View {
        List {
            ForEach(voicesByLanguage, id: \.code) { group in
                Section(group.display) {
                    ForEach(group.voices, id: \.identifier) { voice in
                        Button {
                            selectedVoiceIdentifier = voice.identifier
                            tts.stop()
                            tts.speak(randomSample(), voice: voice, rate: rate, pitch: pitch)
                        } label: {
                            HStack {
                                Text(voice.name)
                                Spacer()
                                if selectedVoiceIdentifier == voice.identifier { Image(systemName: "checkmark") }
                            }
                        }
                    }
                }
            }
            Section("Preview") {
                Slider(value: Binding(get: { Double(rate) }, set: { rate = Float($0) }), in: 0.2 ... 0.7) { Text("Rate") }
                Slider(value: Binding(get: { Double(pitch) }, set: { pitch = Float($0) }), in: 0.5 ... 2.0) { Text("Pitch") }
                Button("Play sample") {
                    let voice = tts.availableVoices().first(where: { $0.identifier == selectedVoiceIdentifier })
                    tts.speak(randomSample(), voice: voice, rate: rate, pitch: pitch)
                }
                Button("Stop") { tts.stop() }
            }
        }
        .navigationTitle("Text-to-speech")
        .task { hydrate() }
        .onDisappear { persist() }
    }

    private func hydrate() {
        let s = settingsRows.first
        selectedVoiceIdentifier = s?.ttsVoiceIdentifier
        rate = Float(s?.ttsRate ?? 0.5)
        pitch = Float(s?.ttsPitch ?? 1.0)
    }

    private func persist() {
        guard let settings = settingsRows.first else { return }
        settings.ttsVoiceIdentifier = selectedVoiceIdentifier
        settings.ttsRate = Double(rate)
        settings.ttsPitch = Double(pitch)
        try? settings.modelContext?.save()
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

private struct ManageThreadsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MemoryThread.title) private var threads: [MemoryThread]
    @State private var newTitle: String = ""
    @State private var renamingThread: MemoryThread? = nil
    @State private var renameText: String = ""

    var body: some View {
        List {
            Section("New Thread") {
                HStack {
                    TextField("Title", text: $newTitle)
                    Button("Add") { addThread() }.disabled(newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            Section("All Threads") {
                ForEach(threads) { thread in
                    HStack { Text(thread.title); Spacer(); Text("\(thread.entries.count)").foregroundStyle(.secondary) }
                        .swipeActions {
                            Button("Rename") { renamingThread = thread; renameText = thread.title }.tint(.blue)
                            Button(role: .destructive) {
                                if let idx = threads.firstIndex(where: { $0.id == thread.id }) { delete(at: IndexSet(integer: idx)) }
                            } label: { Label("Delete", systemImage: "trash") }
                        }
                }
                .onDelete(perform: delete)
            }
        }
        .navigationTitle("Manage Threads")
        .alert("Rename Thread", isPresented: Binding(get: { renamingThread != nil }, set: { if !$0 { renamingThread = nil } })) {
            TextField("Title", text: $renameText)
            Button("Save") { renameThread() }
            Button("Cancel", role: .cancel) { renamingThread = nil }
        }
    }

    private func addThread() {
        let title = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return }
        if threads.first(where: { $0.title.caseInsensitiveCompare(title) == .orderedSame }) == nil {
            let t = MemoryThread(title: title)
            modelContext.insert(t)
            try? modelContext.save()
        }
        newTitle = ""
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(threads[index])
        }
        try? modelContext.save()
    }

    private func renameThread() {
        guard let thread = renamingThread else { return }
        let title = renameText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return }
        thread.title = title
        try? modelContext.save()
        renamingThread = nil
    }
}

#Preview {
    NavigationStack { SettingsView() }
}
