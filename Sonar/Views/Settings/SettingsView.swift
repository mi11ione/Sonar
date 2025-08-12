import SwiftData
import SwiftUI
internal import AVFAudio
import CoreSpotlight
import UniformTypeIdentifiers

struct SettingsView: View {
    @Environment(\.purchases) private var purchases
    @Environment(\.openURL) private var openURL
    @Environment(\.modelContext) private var modelContext
    @Environment(\.backup) private var backup
    @Environment(\.cloudSync) private var cloudSync
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
    @State private var showingImporter: Bool = false

    @State private var isMigrating: Bool = false
    @State private var migrationProgress: (current: Int, total: Int)? = nil
    @State private var lastSyncedAt: Date? = nil
    @State private var showMigrationSheet: Bool = false
    @State private var migrationToken: CloudSyncMigrationService.CancellationToken? = nil
    @State private var showDisableConfirm: Bool = false
    @State private var showICloudUnavailableAlert: Bool = false
    @AppStorage("widgets.showPromptsOnLock") private var showPromptsOnLock: Bool = false
    @AppStorage("widgets.showSummaryOnLock") private var showSummaryOnLock: Bool = false

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
                    Toggle("icloud_sync", isOn: Binding(get: { settings.iCloudSyncEnabled }, set: { newVal in
                        Task {
                            if !newVal { showDisableConfirm = true } else { await toggleICloudSync(true) }
                        }
                    }))
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
                    // Widget privacy preferences
                    Toggle("show_prompts_on_lock", isOn: $showPromptsOnLock)
                    Toggle("show_summary_on_lock", isOn: $showSummaryOnLock)
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
                Section("sync_status") {
                    LabeledContent("last_synced", value: (lastSyncedAt ?? .distantPast).formatted(date: .abbreviated, time: .shortened))
                    if let p = migrationProgress, isMigrating {
                        ProgressView(value: Double(p.current), total: Double(max(p.total, 1))) { Text("migrating") }
                            .progressViewStyle(.linear)
                    }
                }
                Section("data") {
                    Button("export_json") { Task { await exportAll() } }
                    Button("import_json") { showingImporter = true }
                    Button("delete_all_data", role: .destructive) { confirmDeleteAll = true }
                }
            }
            Section("about") {
                NavigationLink("how_it_works") { HowItWorksView() }
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
            lastSyncedAt = UserDefaults.standard.object(forKey: "sync.last") as? Date
        }
        .sheet(isPresented: $showPaywall) { PaywallView() }
        .sheet(isPresented: $showMigrationSheet) {
            MigrationSheet(progress: migrationProgress, onCancel: {
                migrationToken?.cancel()
                isMigrating = false
                migrationProgress = nil
                showMigrationSheet = false
            })
        }
        .alert("icloud_disable_confirm", isPresented: $showDisableConfirm) {
            Button("disable", role: .destructive) { Task { await toggleICloudSync(false) } }
            Button("cancel", role: .cancel) {}
        } message: {
            Text("icloud_disable_explainer")
        }
        .alert("icloud_unavailable", isPresented: $showICloudUnavailableAlert) {
            Button("ok", role: .cancel) {}
        } message: {
            Text("icloud_unavailable_message")
        }
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
        .fileImporter(isPresented: $showingImporter, allowedContentTypes: [UTType.json]) { result in
            switch result {
            case let .success(url):
                Task { await importFrom(url: url) }
            case .failure:
                break
            }
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

    // MARK: - Export / Import via BackupService

    private func exportAll() async {
        if let url = try? await backup.exportAll(toTemporaryFilename: nil, using: modelContext) {
            exportURL = url
            showExporter = true
        } else {
            exportURL = nil
            showExporter = false
        }
    }

    private func importFrom(url: URL) async {
        if let result = try? await backup.import(from: url, using: modelContext) {
            let message = String(localized: "import_success") + " (\(result.entriesUpserted + result.entriesUpdated))"
            await MainActor.run {
                let _ = message // placeholder to keep message in scope if showing a toast later
            }
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

// MARK: - iCloud Sync Toggle

extension SettingsView {
    @MainActor
    private func toggleICloudSync(_ enabled: Bool) async {
        guard let settings = settingsRows.first else { return }
        if enabled == settings.iCloudSyncEnabled { return }
        // Preflight
        if enabled {
            let available = await cloudSync.isICloudAvailable()
            if !available {
                // Surface helpful error (use simple alert for now)
                await MainActor.run {
                    settings.iCloudSyncEnabled = false
                    showICloudUnavailableAlert = true
                }
                return
            }
        }

        // Grab current container from manager, run migration if enabling, and switch containers
        do {
            let token = CloudSyncMigrationService.CancellationToken()
            migrationToken = token
            let stream = try await cloudSync.setSyncEnabled(enabled, lastKnownWasCloud: settings.iCloudSyncEnabled, token: token)
            if let stream {
                isMigrating = true
                migrationProgress = (0, 1)
                showMigrationSheet = true
                Task {
                    for await p in stream {
                        migrationProgress = (p.migrated, p.total)
                    }
                    isMigrating = false
                    migrationProgress = nil
                    showMigrationSheet = false
                    lastSyncedAt = Date()
                    UserDefaults.standard.set(lastSyncedAt, forKey: "sync.last")
                }
            } else {
                lastSyncedAt = Date()
                UserDefaults.standard.set(lastSyncedAt, forKey: "sync.last")
            }
            // Flip the setting last so UI reflects reality
            settings.iCloudSyncEnabled = enabled
            try? modelContext.save()
        } catch {
            // Rollback UI
            settings.iCloudSyncEnabled = false
            try? modelContext.save()
        }
    }
}

private struct MigrationSheet: View {
    let progress: (current: Int, total: Int)?
    var onCancel: () -> Void
    var body: some View {
        VStack(spacing: 16) {
            Text("icloud_migration_title").font(.title2.bold())
            Text("icloud_migration_explainer").foregroundStyle(.secondary)
            if let p = progress {
                ProgressView(value: Double(p.current), total: Double(max(p.total, 1)))
                    .progressViewStyle(.linear)
                Text("\(p.current) / \(p.total)")
                    .font(.footnote).foregroundStyle(.secondary)
            } else {
                ProgressView().progressViewStyle(.linear)
            }
            HStack {
                Spacer()
                Button("cancel") { onCancel() }
                    .buttonStyle(.bordered)
            }
        }
        .padding()
    }
}

private struct TTSSettingsView: View {
    @Environment(\.tts) private var tts
    @Query private var settingsRows: [UserSettings]
    @State private var selectedVoiceIdentifier: String? = nil
    @State private var rate: Float = 0.5
    @State private var pitch: Float = 1.0
    private let samplePhrases: [String] = [
        String(localized: "tts_sample_1"),
        String(localized: "tts_sample_2"),
        String(localized: "tts_sample_3"),
        String(localized: "tts_sample_4"),
        String(localized: "tts_sample_5"),
        String(localized: "tts_sample_6"),
        String(localized: "tts_sample_7"),
        String(localized: "tts_sample_8"),
    ]

    private func randomSample() -> String {
        samplePhrases.randomElement() ?? String(localized: "tts_sample_fallback")
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

private struct HowItWorksView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                intro
                section(title: "howit_recording_title", content: recording)
                section(title: "howit_summaries_title", content: summaries)
                section(title: "howit_search_title", content: search)
                section(title: "howit_privacy_title", content: privacy)
                section(title: "howit_icloud_title", content: icloud)
                section(title: "howit_export_title", content: exportDelete)
                section(title: "howit_tips_title", content: tips)
                section(title: "howit_support_title", content: support)
            }
            .padding()
        }
        .navigationTitle("nav_how_it_works")
    }

    private var intro: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("onboard_welcome")
                .font(.title.bold())
            Text("howit_intro_copy")
                .foregroundStyle(.secondary)
        }
    }

    private func section(title: LocalizedStringKey, content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title).font(.headline)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Sections

    private func recording() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            bullet("howit_record_bullet_1")
            bullet("howit_record_bullet_2")
            bullet("howit_record_bullet_3")
        }
    }

    private func summaries() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            bullet("howit_summaries_bullet_1")
            bullet("howit_summaries_bullet_2")
            bullet("howit_summaries_bullet_3")
        }
    }

    private func search() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            bullet("howit_search_bullet_1")
            bullet("howit_search_bullet_2")
        }
    }

    private func privacy() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            bullet("howit_privacy_bullet_1")
            bullet("howit_privacy_bullet_2")
            bullet("howit_privacy_bullet_3")
        }
    }

    private func icloud() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            bullet("howit_icloud_bullet_1")
            bullet("howit_icloud_bullet_2")
        }
    }

    private func exportDelete() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            bullet("howit_export_bullet_1")
            bullet("howit_export_bullet_2")
        }
    }

    private func tips() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            bullet("howit_tips_bullet_1")
            bullet("howit_tips_bullet_2")
            bullet("howit_tips_bullet_3")
        }
    }

    private func support() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            bullet("howit_support_bullet_1")
            bullet("howit_support_bullet_2")
        }
    }

    private func bullet(_ text: LocalizedStringKey) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            Image(systemName: "checkmark.seal.fill").foregroundStyle(.tint)
            Text(text)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    NavigationStack { SettingsView() }
}
