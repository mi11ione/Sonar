import SwiftData
import SwiftUI
internal import AVFAudio
import CoreSpotlight

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
    @State private var confirmDeleteAll: Bool = false

    var body: some View {
        List {
            Section("how_data_stored") {
                Text("data_storage_copy")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Section("subscription") {
                if isSubscriber { LabeledContent("status", value: planId ?? String(localized: "active")) }
                Button(isSubscriber ? "change_plan" : "view_plans") { showPaywall = true }
                Button("restore_purchases") { Task { try? await purchases.restore() } }
            }
            Section("tags") { NavigationLink("manage_tags") { ManageTagsView() } }
            Section("threads") { NavigationLink("manage_threads") { ManageThreadsView() } }
            Section("developer") {
                Toggle("developer_unlimited_sub", isOn: Binding(
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
                Section("preferences") {
                    Toggle("icloud_sync", isOn: Binding(get: { settings.iCloudSyncEnabled }, set: { settings.iCloudSyncEnabled = $0 }))
                    Toggle("on_device_only", isOn: Binding(get: { settings.allowOnDeviceOnly }, set: { settings.allowOnDeviceOnly = $0 }))
                    Toggle("daily_prompt", isOn: Binding(
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
                    Toggle("daily_reminder", isOn: Binding(
                        get: { settings.dailyReminderHour != nil },
                        set: { enabled in
                            settings.dailyReminderHour = enabled ? (settings.dailyReminderHour ?? 20) : nil
                            if !enabled { UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["daily.reminder"]) }
                        }
                    ))
                    if settings.dailyReminderHour != nil {
                        Stepper(String(format: String(localized: "reminder_time_format %lld"), settings.dailyReminderHour ?? 20), value: Binding(get: { settings.dailyReminderHour ?? 20 }, set: { newVal in
                            settings.dailyReminderHour = newVal
                            // Reschedule with new time
                            Task { await NotificationResponder.shared.scheduleDailyPrompt(atHour: newVal) }
                        }), in: 5 ... 22)
                    }
                    Picker("default_summary_style", selection: Binding(get: { settings.selectedPromptStyleId }, set: { settings.selectedPromptStyleId = $0 })) {
                        Text("default").tag(UUID?.none)
                        ForEach(promptStyles, id: \.id) { style in
                            Text(style.displayName).tag(Optional(style.id))
                        }
                    }
                    NavigationLink("tts_options") { TTSSettingsView() }
                    Toggle("weekly_insights", isOn: Binding(
                        get: { settings.weeklyInsightsEnabled },
                        set: { settings.weeklyInsightsEnabled = $0 }
                    ))
                    Toggle("spotlight_indexing", isOn: Binding(
                        get: { settings.spotlightIndexingEnabled },
                        set: { enabled in
                            settings.spotlightIndexingEnabled = enabled
                            UserDefaults.standard.set(enabled, forKey: "pref.spotlightIndexing")
                            try? modelContext.save()
                            Task {
                                if enabled {
                                    // Reindex all entries in background
                                    let entries: [JournalEntry] = (try? modelContext.fetch(FetchDescriptor<JournalEntry>())) ?? []
                                    for e in entries {
                                        await DefaultSearchIndexingService().index(entry: e)
                                    }
                                } else {
                                    // Clear existing Spotlight items
                                    try? await CSSearchableIndex.default().deleteAllSearchableItems()
                                }
                            }
                        }
                    ))
                }
                Section("data") {
                    Button("export_json") { generateExportJSON() }
                    Button("delete_all_data", role: .destructive) { confirmDeleteAll = true }
                }
            }
            Section("about") {
                LabeledContent("version", value: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-")
                Button("privacy_policy") { open(url: "https://example.com/privacy") }
                Button("terms_of_service") { open(url: "https://example.com/terms") }
                Button("contact_support") { contactSupport() }
            }
        }
        .navigationTitle("nav_settings")
        .task {
            isSubscriber = await purchases.isSubscriber()
            planId = await purchases.currentPlanIdentifier()
            devOverride = purchases.developerOverrideEnabled()
        }
        .sheet(isPresented: $showPaywall) { PaywallView() }
        .sheet(isPresented: $showExporter) {
            VStack(spacing: 16) {
                Text("share_your_export").font(.headline)
                if let url = exportURL {
                    ShareLink(item: url) { Label("share_export", systemImage: "square.and.arrow.up") }
                } else {
                    ContentUnavailableView("no_export_available", systemImage: "doc")
                }
            }
            .padding()
        }
        .onChange(of: showExporter) { isPresented in
            if !isPresented, let url = exportURL {
                try? FileManager.default.removeItem(at: url)
                exportURL = nil
            }
        }
        .alert("delete_all_data_q", isPresented: $confirmDeleteAll) {
            Button("delete", role: .destructive) { performDeleteAllDataCleanup() }
            Button("cancel", role: .cancel) {}
        } message: {
            Text("delete_all_data_message")
        }
    }

    private func open(url: String) { if let u = URL(string: url) { openURL(u) } }

    private func contactSupport() {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-"
        let osVersion = ProcessInfo.processInfo.operatingSystemVersionString
        let subject = "Sonar Support"
        let body = "\n\n—\nApp Version: \(appVersion)\nOS: \(osVersion)\n"
        let query = "subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "subject=Sonar"
        let urlString = "mailto:support@example.com?\(query)"
        open(url: urlString)
    }

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

    private func performDeleteAllDataCleanup() {
        // 1) SwiftData entities
        let entries: [JournalEntry] = (try? modelContext.fetch(FetchDescriptor<JournalEntry>())) ?? []
        let threads: [MemoryThread] = (try? modelContext.fetch(FetchDescriptor<MemoryThread>())) ?? []
        let tags: [Tag] = (try? modelContext.fetch(FetchDescriptor<Tag>())) ?? []
        let assets: [AudioAsset] = (try? modelContext.fetch(FetchDescriptor<AudioAsset>())) ?? []
        for e in entries {
            modelContext.delete(e)
        }
        for t in threads {
            modelContext.delete(t)
        }
        for t in tags {
            modelContext.delete(t)
        }
        for a in assets {
            modelContext.delete(a)
        }
        try? modelContext.save()
        // 2) Local audio files
        if let dir = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Audio", isDirectory: true),
           let items = try? FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil)
        {
            for url in items {
                try? FileManager.default.removeItem(at: url)
            }
        }
        // 3) Spotlight index
        Task { try? await CSSearchableIndex.default().deleteAllSearchableItems() }
        // 4) Notifications
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["daily.reminder"])
        // 5) App state defaults (freeCount, review cadence hints, deep links)
        let defaults = UserDefaults.standard
        ["freeCount", "deeplink.targetTab", "deeplink.showLastEntry", "deeplink.searchRequest", "deeplink.searchURL", "recording.inProgress"].forEach { defaults.removeObject(forKey: $0) }
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
            Section("preview") {
                Slider(value: Binding(get: { Double(rate) }, set: { rate = Float($0) }), in: 0.2 ... 0.7) { Text("tts_rate") }
                Slider(value: Binding(get: { Double(pitch) }, set: { pitch = Float($0) }), in: 0.5 ... 2.0) { Text("tts_pitch") }
                Button("play_sample") {
                    let voice = tts.availableVoices().first(where: { $0.identifier == selectedVoiceIdentifier })
                    tts.speak(randomSample(), voice: voice, rate: rate, pitch: pitch)
                }
                Button("stop") { tts.stop() }
            }
        }
        .navigationTitle("nav_tts")
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
    @State private var renamingTag: Tag? = nil
    @State private var renameText: String = ""
    var body: some View {
        List {
            Section("new_tag") {
                HStack {
                    TextField("name", text: $newTag)
                    Button("add") { addTag() }.disabled(newTag.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            Section("all_tags") {
                ForEach(tags) { tag in
                    HStack { Text(tag.name); Spacer() }
                        .swipeActions {
                            Button("rename") { renamingTag = tag; renameText = tag.name }.tint(.blue)
                            Button(role: .destructive) {
                                if let idx = tags.firstIndex(where: { $0.id == tag.id }) { delete(at: IndexSet(integer: idx)) }
                            } label: { Label("delete", systemImage: "trash") }
                        }
                }
                .onDelete(perform: delete)
            }
        }
        .navigationTitle("nav_manage_tags")
        .alert("rename_tag", isPresented: Binding(get: { renamingTag != nil }, set: { if !$0 { renamingTag = nil } })) {
            TextField("name", text: $renameText)
            Button("save") { renameTag() }
            Button("cancel", role: .cancel) { renamingTag = nil }
        }
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

    private func renameTag() {
        guard let tag = renamingTag else { return }
        let name = renameText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return }
        if let existing = tags.first(where: { $0.name.caseInsensitiveCompare(name) == .orderedSame && $0.id != tag.id }) {
            // Merge entries into existing tag and delete the old tag
            for e in tag.entries where !existing.entries.contains(where: { $0.id == e.id }) {
                existing.entries.append(e)
            }
            modelContext.delete(tag)
        } else {
            tag.name = name
        }
        try? modelContext.save()
        renamingTag = nil
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
            Section("new_thread") {
                HStack {
                    TextField("title", text: $newTitle)
                    Button("add") { addThread() }.disabled(newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            Section("all_threads") {
                ForEach(threads) { thread in
                    HStack { Text(thread.title); Spacer(); Text("\(thread.entries.count)").foregroundStyle(.secondary) }
                        .swipeActions {
                            Button("rename") { renamingThread = thread; renameText = thread.title }.tint(.blue)
                            Button(role: .destructive) {
                                if let idx = threads.firstIndex(where: { $0.id == thread.id }) { delete(at: IndexSet(integer: idx)) }
                            } label: { Label("delete", systemImage: "trash") }
                        }
                }
                .onDelete(perform: delete)
            }
        }
        .navigationTitle("nav_manage_threads")
        .alert("rename_thread", isPresented: Binding(get: { renamingThread != nil }, set: { if !$0 { renamingThread = nil } })) {
            TextField("title", text: $renameText)
            Button("save") { renameThread() }
            Button("cancel", role: .cancel) { renamingThread = nil }
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
