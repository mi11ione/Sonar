## Sonar [AI] — Voice‑First Journaling (Agent Workshop)

This is a complete, on‑device–first build plan for Sonar [AI]: a private, voice‑first journaling app that captures speech, transcribes locally, summarizes entries, tags mood/keywords, and makes everything fast to find. It is designed for iOS 18+, SwiftUI‑only, with zero or near‑zero backend. Where sync is desired, use SwiftData with CloudKit. No third‑party SDKs.

Read end‑to‑end before writing code. Follow THE VIEW architecture and workspace rules. Do not introduce ViewModels or Combine. All async work uses Swift Concurrency.

---

### 1) Product pillars and constraints

- Privacy by default: on‑device processing; no tracking. Optional iCloud sync only.
- Capture friction = near zero: tap‑to‑record, lock‑screen/Widget/App Shortcut entry.
- Clarity out of chaos: automatic transcription + summarization + mood signal.
- Fast retrieval: full‑text search, filters, Spotlight, and App Shortcuts.
- Sustainable model: simple subscription tiers via StoreKit 2, no custom payments.

Non‑goals:
- No social graph. No public cloud feeds. No third‑party analytics.
- No external LLM calls; summaries must be computed on device.

Platform constraints:
- iOS 18+. SwiftUI only. Services injected via `EnvironmentValues`. THE VIEW architecture (views coordinate, services are protocol‑oriented and stateless). Use SwiftData for persistence.

### Canonical API reference & verification workflow

- Source of truth: `framework-sources/` contains the extracted Swift interfaces for Apple frameworks used (e.g., `AVFAudio.md`, `Speech.md`, `NaturalLanguage.md`, `StoreKit.md`, `SwiftUI.md`, `SwiftData.md`, `CoreSpotlight.md`, `UniformTypeIdentifiers.md`, `CoreGraphics.md`, `Metal.md`, `Foundation.md`). Treat these files as authoritative for symbols, signatures, and availability.
- Order of precedence when writing code: (1) `framework-sources/` local interfaces; (2) Apple docs for clarification; (3) Xcode Quick Help. Do not invent APIs.
- Preflight before any code edit that touches Apple frameworks:
  1) Identify the frameworks required and locate the symbol(s) in the corresponding `framework-sources/{Framework}.md`.
  2) Verify the exact names, signatures, enums/options, and iOS availability (target is iOS 18+, no `@available` guards).
  3) Cite the relevant lines inline when proposing or writing code using the citing format, and ensure `import` statements match the module names used in the interfaces.
  4) If a symbol isn’t present or appears deprecated, stop and either request an updated dump or propose a standards‑compliant alternative with citations.
- Coding constraints: prefer modern APIs present in these sources; avoid deprecated APIs; no Combine/GCD/completion handlers; Swift Concurrency only.

### STOP gates (copilot oversight — do not proceed without approval)

The agent must FULL STOP and ask for approval with a step‑by‑step plan before:
- Project file or capability changes:
  - Adding a Widget or App Clip target
  - Enabling CloudKit/iCloud, Background Tasks, App Groups, or Live Activity push updates
  - Adding/altering entitlements or Info.plist keys beyond strings descriptions
- Creating non‑Swift and non‑asset files:
  - `PrivacyInfo.xcprivacy`
  - `Localizable.strings`
  - StoreKit configuration files (`*.storekit`)
  - Any JSON/ML assets beyond Apple frameworks

Proposed plans (execute only after explicit approval):
- Widget target:
  1) Create Widget Extension target named `SonarWidget`.
  2) Link AppIntents; add `WidgetBundle` with quick record and daily prompt widgets.
  3) Verify deployment target and signing; no third‑party frameworks.
- CloudKit sync:
  1) Turn on iCloud (CloudKit) capability for the app target.
  2) Configure `ModelContainer` for CloudKit.
  3) Test with development container; provide rollback path to local‑only.
- Background tasks (for periodic insights):
  1) Enable Background Modes → Background fetch/processing.
  2) Add `BGTaskSchedulerPermittedIdentifiers` to Info.
  3) Schedule weekly compute; fallback to foreground compute if not approved.
- Privacy manifest:
  1) Create `Resources/PrivacyInfo.xcprivacy` with microphone/audio declarations.
  2) Keep content minimal, no tracking.
- Localization:
  1) Create `Resources/Localizable.strings` (en base) with keys referenced in views.
  2) Add additional languages later as needed.

---

### 2) User stories (1.0 complete)

1. Press Record and speak; get live on‑device transcription and safe pause/resume.
2. See Today at a glance; continue an in‑progress session seamlessly.
3. Receive an on‑device summary and mood tagging automatically; pin important entries.
4. Customize summary style (concise, reflective, actionable) and optional TTS playback with chosen voice.
5. Organize entries into long‑term Memory Threads (topics/people/goals); get per‑thread rollups.
6. Weekly Insights feed: mood trends, themes, highlights, and suggested reflection prompts.
7. Full‑text search with filters (date, mood bins, tags, threads) and Spotlight integration.
8. Encrypted sharing of selected entries or threads as password‑protected packages; import on another device.
9. Export to PDF/Text/ZIP; AirDrop or Files share.
10. Start quickly from Widgets, Live Activity, and App Shortcuts.
11. Daily reminders with gentle prompts; optional prompt packs.
12. Optional iCloud sync toggle.
13. Subscription unlocks unlimited minutes, custom styles/voices, encrypted sharing, threads, insights, and export.

Edge cases to support:
- Loss of connectivity (everything must work offline).
- Long recordings (auto‑chunking transcription; resumable processing).
- Interruptions (phone calls, alarms) → safe pause/resume.
- Background execution time limits → Live Activity + short tasks; persist intermediate state.

---

### 3) System design (no/low‑backend)

- Persistence: SwiftData `@Model` types with optional CloudKit sync. Local storage is primary.
- Audio pipeline: `AVAudioSession` + `AVAudioEngine` for mic capture; `SFSpeechRecognizer` with `requiresOnDeviceRecognition = true` when available.
- Summarization: on‑device extractive summarization using `NaturalLanguage` embeddings and ranking; optional lightweight Create ML classifier(s) for mood/prompt style.
- Search: SwiftData queries + Spotlight (`CSSearchableItem`) indexing for universal search.
- UX atoms: SwiftUI + `.task(id:)` for effects; `.sensoryFeedback()` on interactions; Dynamic Type.
- Privacy & security: Audio/transcripts stored locally; optional symmetric encryption for on‑disk blobs using CryptoKit; keys in Keychain. Privacy manifest included.
- Observability: OSLog categories; MetricKit; Instruments signposts. No third‑party analytics.

---

### 4) Project layout (folders/files)

Follow workspace target structure. Primary target is the app; a Widget Extension target is optional (STOP gate applies).

```
SonarAI/
  - SonarAIApp.swift
  - Models/
    - JournalEntry.swift
    - AudioAsset.swift
    - Tag.swift
    - PromptStyle.swift
    - UserSettings.swift
    - Thread.swift
  - Services/
    - SpeechTranscriptionService.swift
    - SummarizationService.swift
    - MoodAnalysisService.swift
    - EncryptionService.swift
    - SearchIndexingService.swift
    - BackupSyncService.swift
    - TextToSpeechService.swift
    - InsightsService.swift
    - SharePackageService.swift
  - Views/
    - ContentView.swift
    - Onboarding/
      - OnboardingFlow.swift
    - Journal/
      - RecordView.swift
      - EntryDetailView.swift
      - EntriesListView.swift
      - SearchFilterView.swift
    - Insights/
      - InsightsView.swift
    - Paywall/
      - PaywallView.swift
    - Settings/
      - SettingsView.swift
  - Components/
    - MicButton.swift
    - WaveformView.swift
    - MoodBadge.swift
    - SummaryBlock.swift
  - Extensions/
    - EnvironmentKeys.swift
    - OSLog+Categories.swift
    - Date+Formatting.swift
  - Resources/
    - Assets.xcassets
    - Localizable.strings
    - PrivacyInfo.xcprivacy
  - Widgets/ (extension target)
    - SonarWidget.swift
    - WidgetViews/
      - QuickRecordWidgetView.swift
      - DailyPromptWidgetView.swift
  - LiveActivities/
    - RecordingActivityAttributes.swift
    - RecordingLiveActivity.swift
```

One primary type per file; explicit imports; `#Preview` with sample data.

---

### 5) Data model (SwiftData)

Use domain‑pure models. Keep heavy media outside the row (store URLs to encrypted files when using CryptoKit).

```swift
// Models/JournalEntry.swift
import SwiftData

@Model
final class JournalEntry {
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var updatedAt: Date

    // Transcript and summary are user data; keep small enough for indexing.
    var transcript: String
    var summary: String?

    // Mood score in [-1, 1], optional label (e.g., "calm", "anxious").
    var moodScore: Double?
    var moodLabel: String?

    // Relationships
    @Relationship(deleteRule: .cascade) var audio: AudioAsset?
    @Relationship(inverse: \Tag.entries) var tags: [Tag] = []

    // Flags
    var isPinned: Bool

    init(id: UUID = .init(), createdAt: Date = .now, transcript: String) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = createdAt
        self.transcript = transcript
        self.isPinned = false
    }
}
```

```swift
// Models/AudioAsset.swift
import SwiftData

@Model
final class AudioAsset {
    @Attribute(.unique) var id: UUID
    var fileURL: URL  // file in app container; optionally encrypted
    var durationSec: Double
    var sampleRate: Double

    init(id: UUID = .init(), fileURL: URL, durationSec: Double, sampleRate: Double) {
        self.id = id
        self.fileURL = fileURL
        self.durationSec = durationSec
        self.sampleRate = sampleRate
    }
}
```

```swift
// Models/Tag.swift
import SwiftData

@Model
final class Tag {
    @Attribute(.unique) var id: UUID
    @Attribute(.unique) var name: String

    @Relationship var entries: [JournalEntry] = []

    init(id: UUID = .init(), name: String) {
        self.id = id
        self.name = name
    }
}
```

```swift
// Models/PromptStyle.swift
import SwiftData

@Model
final class PromptStyle {
    @Attribute(.unique) var id: UUID
    var displayName: String           // e.g. "Concise", "Reflective", "Bullet points"
    var maxSentences: Int
    var includeActionItems: Bool
    var toneHint: String?             // optional instruction for rewrite heuristics
    var isPremium: Bool

    init(id: UUID = .init(), displayName: String, maxSentences: Int = 3, includeActionItems: Bool = false, toneHint: String? = nil, isPremium: Bool = false) {
        self.id = id
        self.displayName = displayName
        self.maxSentences = maxSentences
        self.includeActionItems = includeActionItems
        self.toneHint = toneHint
        self.isPremium = isPremium
    }
}
```

```swift
// Models/UserSettings.swift
import SwiftData

@Model
final class UserSettings {
    @Attribute(.unique) var id: UUID
    var hasCompletedOnboarding: Bool
    var iCloudSyncEnabled: Bool
    var dailyReminderHour: Int?     // 0..23
    var selectedPromptStyleId: UUID?
    var allowOnDeviceOnly: Bool     // enforce on‑device transcription

    init(id: UUID = .init()) {
        self.id = id
        self.hasCompletedOnboarding = false
        self.iCloudSyncEnabled = false
        self.allowOnDeviceOnly = true
    }
}
```

```swift
// Models/Thread.swift
import SwiftData

@Model
final class Thread {
    @Attribute(.unique) var id: UUID
    var title: String
    @Relationship var entries: [JournalEntry] = []
    var createdAt: Date
    var updatedAt: Date

    init(id: UUID = .init(), title: String, createdAt: Date = .now) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.updatedAt = createdAt
    }
}
```

Model notes:
- Keep `transcript` normalized (trim whitespace, collapse repeats) to help summarizer.
- If enabling CryptoKit, `AudioAsset.fileURL` points to an encrypted container; derive ephemeral read URLs during playback.

---

### 6) Environment and services (protocol seams)

Define protocol‑oriented services; inject via `EnvironmentValues`. Services are `Sendable` where appropriate and stateless (or reference types without shared mutable state).

```swift
// Services/SpeechTranscriptionService.swift
import AVFoundation
import Speech

protocol SpeechTranscriptionService: Sendable {
    func requestAuthorization() async throws
    func startStreamingTranscription(onDeviceOnly: Bool) async throws -> AsyncStream<String>
    func stop() async
}
```

```swift
// Services/SummarizationService.swift
import NaturalLanguage

protocol SummarizationService: Sendable {
    func summarize(text: String, maxSentences: Int, toneHint: String?) async -> String
}
```

```swift
// Services/MoodAnalysisService.swift
import NaturalLanguage

protocol MoodAnalysisService: Sendable {
    func analyze(text: String) async -> (score: Double, label: String)
}
```

```swift
// Services/EncryptionService.swift
import CryptoKit

protocol EncryptionService: Sendable {
    func encryptFile(at plaintextURL: URL) throws -> URL
    func decryptFile(at ciphertextURL: URL) throws -> URL
}
```

```swift
// Services/SearchIndexingService.swift
import CoreSpotlight

protocol SearchIndexingService: Sendable {
    func index(entry: JournalEntry) async
    func deleteIndex(for id: UUID) async
}
```

```swift
// Services/BackupSyncService.swift
import SwiftData

protocol BackupSyncService: Sendable {
    func enableCloudSync(_ enabled: Bool, modelContext: ModelContext) async throws
}
```

```swift
// Services/TextToSpeechService.swift
import AVFoundation

protocol TextToSpeechService: Sendable {
    func availableVoices() -> [AVSpeechSynthesisVoice]
    func speak(_ text: String, voice: AVSpeechSynthesisVoice?, rate: Float, pitch: Float)
    func stop()
}
```

```swift
// Services/InsightsService.swift
protocol InsightsService: Sendable {
    struct WeeklyInsights: Sendable { let topThemes: [String]; let avgMood: Double; let highlightSummaries: [String] }
    func computeWeeklyInsights(from entries: [JournalEntry]) async -> WeeklyInsights
}
```

```swift
// Services/SharePackageService.swift
import Foundation

protocol SharePackageService: Sendable {
    /// Builds an encrypted package (ZIP) for selected entries with passphrase.
    func exportEncryptedPackage(entries: [JournalEntry], passphrase: String) async throws -> URL
    /// Imports a previously exported package into the local store.
    func `import`(from url: URL, passphrase: String) async throws -> [JournalEntry]
}
```

Environment keys:

```swift
// Extensions/EnvironmentKeys.swift
import SwiftUI

private struct TranscriptionKey: EnvironmentKey { static let defaultValue: any SpeechTranscriptionService = DefaultTranscriptionService() }
private struct SummarizationKey: EnvironmentKey { static let defaultValue: any SummarizationService = DefaultSummarizationService() }
private struct MoodKey: EnvironmentKey { static let defaultValue: any MoodAnalysisService = DefaultMoodAnalysisService() }
private struct EncryptionKey: EnvironmentKey { static let defaultValue: any EncryptionService = DefaultEncryptionService() }
private struct IndexingKey: EnvironmentKey { static let defaultValue: any SearchIndexingService = DefaultSearchIndexingService() }
private struct BackupSyncKey: EnvironmentKey { static let defaultValue: any BackupSyncService = DefaultBackupSyncService() }
private struct TTSKey: EnvironmentKey { static let defaultValue: any TextToSpeechService = DefaultTextToSpeechService() }
private struct InsightsKey: EnvironmentKey { static let defaultValue: any InsightsService = DefaultInsightsService() }
private struct SharePkgKey: EnvironmentKey { static let defaultValue: any SharePackageService = DefaultSharePackageService() }

extension EnvironmentValues {
    var transcription: any SpeechTranscriptionService { get { self[TranscriptionKey.self] } set { self[TranscriptionKey.self] = newValue } }
    var summarization: any SummarizationService { get { self[SummarizationKey.self] } set { self[SummarizationKey.self] = newValue } }
    var moodAnalysis: any MoodAnalysisService { get { self[MoodKey.self] } set { self[MoodKey.self] = newValue } }
    var encryption: any EncryptionService { get { self[EncryptionKey.self] } set { self[EncryptionKey.self] = newValue } }
    var indexing: any SearchIndexingService { get { self[IndexingKey.self] } set { self[IndexingKey.self] = newValue } }
    var backupSync: any BackupSyncService { get { self[BackupSyncKey.self] } set { self[BackupSyncKey.self] = newValue } }
    var tts: any TextToSpeechService { get { self[TTSKey.self] } set { self[TTSKey.self] = newValue } }
    var insights: any InsightsService { get { self[InsightsKey.self] } set { self[InsightsKey.self] = newValue } }
    var sharePackage: any SharePackageService { get { self[SharePkgKey.self] } set { self[SharePkgKey.self] = newValue } }
}
```

---

### 7) THE VIEW wiring (no ViewModels)

Views coordinate services directly. Use explicit state enums for exhaustiveness.

```swift
// Views/Journal/RecordView.swift
import SwiftUI
import SwiftData

struct RecordView: View {
    @Environment(\.transcription) private var transcription
    @Environment(\.summarization) private var summarization
    @Environment(\.moodAnalysis) private var mood
    @Environment(\.indexing) private var indexing
    @Environment(\.modelContext) private var modelContext

    enum ViewState { case idle, recording, processing, saved(Error?), error(Error) }
    @State private var state: ViewState = .idle
    @State private var liveTranscript: String = ""

    var body: some View {
        content
            .task(id: state) { await handleStateChange() }
    }

    @ViewBuilder private var content: some View {
        switch state {
        case .idle: MicButton(title: "Start Recording") { state = .recording }
        case .recording: WaveformView(transcript: liveTranscript).toolbar { MicButton(title: "Stop") { state = .processing } }
        case .processing: ProgressView("Processing…")
        case .saved: ContentUnavailableView("Done", systemImage: "checkmark")
        case .error(let error): ErrorView(error: error) { state = .idle }
        }
    }

    private func handleStateChange() async {
        switch state {
        case .recording:
            liveTranscript = ""
            for await chunk in try! await transcription.startStreamingTranscription(onDeviceOnly: true) {
                liveTranscript = chunk
            }
        case .processing:
            await saveEntry(from: liveTranscript)
        default: break
        }
    }

    private func saveEntry(from transcript: String) async {
        do {
            let summary = await summarization.summarize(text: transcript, maxSentences: 3, toneHint: nil)
            let (score, label) = await mood.analyze(text: transcript)

            let entry = JournalEntry(transcript: transcript)
            entry.summary = summary
            entry.moodScore = score
            entry.moodLabel = label
            modelContext.insert(entry)
            try modelContext.save()

            await indexing.index(entry: entry)
            state = .saved(nil)
        } catch {
            state = .error(error)
        }
    }
}
```

Notes:
- Use `.task(id:)` to attach cancellable effects to state transitions.
- Keep the view in charge; services do pure work; persistence happens in the view with `modelContext`.

---

### 8) Speech stack (on‑device)

Goal: low‑latency local transcription. Use `SFSpeechRecognizer` with `SFSpeechAudioBufferRecognitionRequest` and `requiresOnDeviceRecognition = true` when supported. Fallback path: if on‑device unavailable and `allowOnDeviceOnly == true`, show message and let user record audio only; add “transcribe later” option when device idle.

Implementation checklist:
- Ask `SFSpeechRecognizer.requestAuthorization()` and mic permission.
- Configure `AVAudioSession` to `.playAndRecord` with appropriate category options (e.g., `.defaultToSpeaker`, `.allowBluetooth`).
- Start `AVAudioEngine` and append buffers to the recognition request.
- Track partial and final transcriptions; push incremental text into `liveTranscript`.
- Debounce UI updates to ~50–150ms.
- Stop cleanly on interruptions; persist raw audio asset if recording.

Pitfalls:
- On‑device models vary by language/device. Handle `isOnDeviceRecognitionAvailable`.
- Long sessions: periodically restart the recognition request to avoid memory growth; stitch text.

---

### 9) Summarization (extractive, on‑device)

We will implement extractive summarization with NaturalLanguage sentence embeddings. Steps:
1) Split transcript into sentences (`NLTokenizer` with `.sentence`).
2) Embed sentences via `NLEmbedding.sentenceEmbedding(for: .english)`.
3) Compute centroid vector and rank sentences by cosine similarity to centroid (TextRank‑like but simpler).
4) Take top N non‑redundant sentences; preserve chronological order.
5) Optional rewrite heuristics: apply light transformations (trim fillers, normalize pronouns) using simple rules.

This approach is private, fast, and robust without shipping third‑party models.

```swift
// Services/DefaultSummarizationService.swift (sketch)
import NaturalLanguage

struct DefaultSummarizationService: SummarizationService, Sendable {
    func summarize(text: String, maxSentences: Int, toneHint: String?) async -> String {
        let sentences = SentenceSplitter.split(text)
        guard let embedding = NLEmbedding.sentenceEmbedding(for: .english), !sentences.isEmpty else { return text }

        let vectors = sentences.compactMap { embedding.vector(for: $0) }
        let centroid = VectorOps.centroid(of: vectors)
        let scored: [(String, Double)] = zip(sentences, vectors).map { ($0, VectorOps.cosine($1, centroid)) }
        let top = scored.sorted { $0.1 > $1.1 }.prefix(maxSentences).map { $0.0 }
        let ordered = sentences.filter { top.contains($0) }
        return Rewriter.rewrite(ordered.joined(separator: " "), toneHint: toneHint)
    }
}
```

Mood detection:
- Option A: Use NaturalLanguage sentiment where available (per‑sentence, average → score, then map to label bins).
- Option B: Ship a small Create ML sentiment classifier (`.mlmodel`) trained on journaling tone; run fully on device.

---

### 10) Encryption (optional but recommended)

Use CryptoKit with a single symmetric key stored in Keychain. Encrypt large audio files with `ChaChaPoly`. Keep transcripts as plain text for Spotlight indexing by default; provide a Settings toggle to encrypt everything (disables Spotlight for those entries).

Checklist:
- Generate symmetric key once; store in Keychain with access group limited to the app.
- When saving audio, write to temp file → encrypt → move to persistent location.
- For decryption, create ephemeral temp files and scrub after playback.

---

### 11) Search and discovery

- In‑app search: `@Query` filters by date ranges, mood score bins, tags, full‑text (simple `contains` on transcript/summary). For large local stores, consider lightweight inverted index in memory at runtime.
- Spotlight: Create `CSSearchableItemAttributeSet` for each entry: title (summary), contentDescription (transcript prefix), keywords (tags, mood labels), thumbnail (waveform snapshot or app icon). Use the entry UUID as unique identifier.
- App Shortcuts: Provide intents for starting a new recording, creating a summary of the last entry, and searching by tag/mood.

---

### 12) Notifications (daily nudges)

- Ask notification permission during onboarding (explain benefit).
- Schedule a daily `UNCalendarNotificationTrigger` at the chosen hour with a gentle prompt; notification action can deep‑link to `RecordView`.
- Respect Focus modes and Notification Summary.

---

### 13) Widgets (interactive)

Widget ideas:
- Quick Record: tap to start recording immediately (AppIntent triggers the app into recording state).
- Daily Prompt: shows today’s prompt and a button to record.
- Last Summary: displays most recent entry’s summary; tap to open detail.

Implementation:
- Use AppIntents for interactivity. Provide placeholders, snapshot provider, and a compact layout that works in all sizes.
- Keep privacy: never render full transcript on the lock screen unless user opts in.

---

### 14) Live Activities (Recording)

- Start a Live Activity when recording begins. Show elapsed time, waveform level indication, and a Stop action. Support Dynamic Island.
- Ensure Activity ends when recording stops or app is terminated.

---

### 15) App Shortcuts (≥ 3)

Provide at least these intents:
1) StartRecordingIntent: starts recording immediately.
2) SummarizeLastEntryIntent: regenerates summary for the most recent entry (or reads it aloud).
3) SearchEntriesIntent: parameterized by tag or mood; opens search filtered view.

All intents should be safe when offline, return result summaries, and support Spotlight.

---

### 16) Onboarding (≤ 3 screens)

Screens:
1) Value proposition + privacy promise. Toggle: On‑device only mode.
2) Permissions: Mic + Speech + Notifications (optional). Explain why.
3) Choose default prompt style; offer daily reminder hour.

Implementation:
- Track completion via `@AppStorage("onboardingComplete")` and/or `UserSettings` row.
- After onboarding, show paywall or grant 3 free recordings before gating.

---

### 17) Settings

Include:
- Manage subscription (StoreKit views), Restore purchases.
- iCloud sync toggle; encryption level toggle.
- Export data (ZIP of JSON + audio). Import data (advanced).
- Privacy policy, Terms, Contact support (mailto:), App version.
- Notification preferences (reminder hour).

---

### 18) StoreKit 2 (subscriptions — compelling funnel)

Tiers (tracking/data app baseline):
- Free: 1–2 entries/week, 7‑day history.
- Pro $3.99/mo: up to 5 entries/week, 30‑day history.
- Premium $6.99/mo: unlimited entries, export, custom prompt styles.
- Max $9.99/mo: everything + advanced insights (extra mood analytics).

Notes:
- Annual options at ~35% discount. One subscription group; allow upgrade/downgrade; handle prorations.
- Smart trial offers: 7‑day trial for Premium; win‑back offer for churned users via promotional offers.
- Gating: after 3 free recordings OR on attempting premium features, present paywall.
- Entitlement checks with `Transaction.currentEntitlements` drive feature flags.

---

### 19) Paywall UX

Principles:
- Fast, clear, honest. Show value versus free.
- Native StoreKit views for reliability. Offer trials where appropriate.
- Provide Restore Purchases. Respect Family Sharing if enabled.

Placement:
- After onboarding completion OR upon hitting free limit.
- Settings → Manage Subscription.

---

### 20) Observability (no third‑party)

- OSLog categories: `capture`, `transcription`, `summarization`, `purchase`, `performance`.
- Use `Logger` with privacy annotations. Avoid logging user content unless user opts into diagnostics.
- MetricKit: collect crash and hang diagnostics. Add `MXMetricManager` subscriber.
- Instruments: add signposts around start/stop recording, summarization, Spotlight indexing.

```swift
// Extensions/OSLog+Categories.swift
import OSLog

extension Logger {
    static let capture = Logger(subsystem: "app.sonar.ai", category: "capture")
    static let nlp = Logger(subsystem: "app.sonar.ai", category: "nlp")
    static let purchase = Logger(subsystem: "app.sonar.ai", category: "purchase")
    static let perf = Logger(subsystem: "app.sonar.ai", category: "performance")
}
```

---

### 21) Accessibility, haptics, and motion

- Support Dynamic Type; ensure controls don’t clip at largest sizes.
- Respect reduced motion; use `.spring(duration: 0.3)` animations tastefully.
- Add `.sensoryFeedback(.impact(.light))` on taps; `.success` on save.
- Color contrast passes WCAG AA in both light/dark.

---

### 22) Testing strategy

Unit tests:
- Summarization ranking returns deterministic top sentences for fixtures.
- Mood analyzer maps known texts to expected bins.
- Encryption round‑trip results in byte‑identical plaintext.

UI tests:
- Onboarding path with permissions stubbed.
- Record → stop → see summary appears.
- Paywall gating after free limit.

Service mocks:
- Provide mock implementations for `SpeechTranscriptionService` (feed canned chunks) and `SummarizationService` (return fixed summary).

---

### 23) Security & privacy

- Privacy manifest `PrivacyInfo.xcprivacy` declares microphone/audio usage and data types.
- App Transport Security enabled; minimal permissions with clear usage descriptions.
- Keychain only for encryption keys; user data stays local unless iCloud sync enabled.
- No tracking (no ATT prompt). No third‑party analytics.

---

### 24) Cloud sync (optional)

If enabled, use SwiftData + CloudKit. Keep merges last‑write‑wins for transcript/summary; append‑only model for entries minimizes conflicts. Provide a manual “Resolve Conflict” screen only if needed in edge cases.

---

### 25) Localization

- Use `LocalizedStringKey` in views; define keys in `Resources/Localizable.strings`.
- Avoid hardcoded user‑visible strings. Keep tone friendly and concise.

---

### 26) Error handling

Define typed errors per service. Views render `ContentUnavailableView` for common failures (e.g., mic denied). Offer retry paths and education (why/how to fix permissions).

```swift
enum CaptureError: Error { case micDenied, speechDenied, onDeviceUnavailable }
enum NLPError: Error { case embeddingUnavailable, emptyInput }
enum CryptoError: Error { case keyMissing, encryptFailed, decryptFailed }
```

---

### 27) Record → Process → Save flow (detailed)

1) Tap Mic → request permissions if first run.
2) Configure session → start engine → create recognition request with on‑device flag.
3) Start receiving partial text; update `liveTranscript`.
4) On Stop: end audio, finalize text; write audio to file (encrypt if enabled); compute summary + mood on background priority.
5) Insert `JournalEntry`, associate `AudioAsset`, save context.
6) Index into Spotlight.
7) Haptic success, show summary confirmation.

Latency budgets (targets on modern devices):
- Start record to first partial: < 600ms.
- Stop to summary: < 1.5s for 2–3 minutes of speech.

---

### 28) Search UX (detailed)

Filters:
- Date: Today, Last 7 days, Custom range.
- Mood: Negative (< −0.2), Neutral (−0.2..0.2), Positive (> 0.2).
- Tags: multi‑select. Provide quick chip UI.

Results list shows summary, mood badge, and timestamp. Swipe actions: Pin, Share, Delete.

---

### 29) Export/Import

Export:
- Generate a ZIP containing `entries.json` (transcript, summary, mood, tags) + `audio/` files.
- Use `ShareLink` to share ZIP. If encrypted mode, include a password flow and caution about recovery.

Import:
- Advanced: parse ZIP and merge by UUID. Non‑MVP.

---

### 30) App navigation and structure

Use `NavigationStack` with root tabs or a single column depending on scope:
- Primary tabs: Journal, Search, Settings. Fresh installs may hide Search until first entry exists.
- Consider `.inspector()` for entry details on iPad.

---

### 31) Implementation steps (for the agent, copilot mode — no PRs)

Phase A — Skeleton & models (STOP if capabilities or targets are needed)
1) Create app target; set iOS 18 minimum.
2) Add SwiftData models (`JournalEntry`, `AudioAsset`, `Tag`, `PromptStyle`, `UserSettings`).
3) Set up `ModelContainer` in `SonarAIApp.swift` with optional CloudKit configuration.
4) Implement `EnvironmentKeys.swift` with default service stubs.
5) Build `ContentView` shell with tabs and placeholder screens.

Status: Implemented — Models present; `ModelContainer` configured; Environment keys wired for transcription/summarization/mood/indexing; `ContentView` with tab bar.

Phase B — Capture and transcription
6) Implement `DefaultTranscriptionService` using `AVAudioEngine` + `SFSpeechRecognizer` with on‑device flag.
7) Build `RecordView` with `MicButton`, waveform visualization, and live transcript.
8) Handle permission flows and interruptions; add haptics.

Status: Implemented — Transcription service on-device; `RecordView` live transcript, timer, waveform, haptics.

Phase C — NLP pipeline (summary styles & mood)
9) Implement `DefaultSummarizationService` (embeddings + centroid ranking) and `DefaultMoodAnalysisService`.
10) Wire `RecordView` save path: compute summary/mood → save `JournalEntry` → index Spotlight.
11) Build `EntriesListView` and `EntryDetailView`.

Status: Implemented — Services exist; background post-save summary/mood; Spotlight indexing; `EntriesListView` and `EntryDetailView` added.

Phase D — Widgets, Live Activity, and Shortcuts (STOP before creating Widget/Live Activity targets)
12) Add Widget Extension with Quick Record + Daily Prompt. [PROPOSED — STOP GATE]
13) Add Live Activity for recording with stop action. [PROPOSED — STOP GATE]
14) Add AppIntents for StartRecording, SummarizeLastEntry, SearchEntries. [PROPOSED]

Phase E — Paywall and settings (trial/promo offers)
15) Implement StoreKit 2 products and subscription gating in views.
16) Build `PaywallView` and Settings (subscription management, iCloud, encryption toggle, export, contact).
17) Add onboarding (≤ 3 screens) tracked with `@AppStorage`.

Status: Implemented — Purchases service; `PaywallView`; gating after 3 free saves; Settings section shows status/restore; onboarding flow with permissions and preferences.

Phase F — Polish and QA (STOP before adding non‑Swift resource files; propose plan first)
18) Add OSLog, MetricKit, and Instruments signposts. [OSLog implemented; others pending]
19) Add localization keys and initial English strings. [PROPOSED — STOP GATE for adding files]
20) Write unit tests for summarization, mood, encryption; UI tests for main flows. [PROPOSED]

---

### 32) Key view sketches

Record button component:

```swift
// Components/MicButton.swift
import SwiftUI

struct MicButton: View {
    var title: LocalizedStringKey
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Label(title, systemImage: "mic.fill")
                .font(.title2.bold())
                .padding()
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .sensoryFeedback(.impact(weight: .light), trigger: title)
    }
}
```

Entries list view:

```swift
// Views/Journal/EntriesListView.swift
import SwiftUI
import SwiftData

struct EntriesListView: View {
    @Query(sort: \JournalEntry.createdAt, order: .reverse) var entries: [JournalEntry]

    var body: some View {
        List(entries) { entry in
            NavigationLink(value: entry.id) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.summary ?? String(entry.transcript.prefix(80)))
                        .font(.headline)
                    HStack {
                        if let label = entry.moodLabel { MoodBadge(label: label, score: entry.moodScore ?? 0) }
                        Text(entry.createdAt, style: .date).foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Journal")
        .overlay { if entries.isEmpty { ContentUnavailableView("No entries yet", systemImage: "mic", description: Text("Tap the mic to start your first journal.")) } }
    }
}
```

Search view sketch:

```swift
// Views/Journal/SearchFilterView.swift
import SwiftUI
import SwiftData

struct SearchFilterView: View {
    @State private var query = ""
    @State private var moodBin: Int? = nil
    @State private var startDate: Date? = nil
    @State private var endDate: Date? = nil

    @Query var entries: [JournalEntry]

    var body: some View {
        List(filtered(entries)) { entry in /* row */ }
        .searchable(text: $query)
        .navigationTitle("Search")
        .toolbar { /* filters */ }
    }

    private func filtered(_ all: [JournalEntry]) -> [JournalEntry] {
        all.filter { entry in
            let t = entry.transcript + "\n" + (entry.summary ?? "")
            let matchText = query.isEmpty || t.localizedCaseInsensitiveContains(query)
            let matchDate = (startDate == nil || entry.createdAt >= startDate!) && (endDate == nil || entry.createdAt <= endDate!)
            let matchMood = moodBin == nil || moodMatches(entry.moodScore, bin: moodBin!)
            return matchText && matchDate && matchMood
        }
    }

    private func moodMatches(_ score: Double?, bin: Int) -> Bool {
        guard let s = score else { return false }
        switch bin { case 0: return s < -0.2; case 1: return abs(s) <= 0.2; case 2: return s > 0.2; default: return true }
    }
}
```

---

### 33) Widget and AppIntent sketches

AppIntent to start recording:

```swift
// Widgets/Intents/StartRecordingIntent.swift
import AppIntents

struct StartRecordingIntent: AppIntent {
    static var title: LocalizedStringKey = "Start Recording"
    static var description = IntentDescription("Begin a new voice journal entry.")

    func perform() async throws -> some IntentResult {
        // Deep link into the app with a custom URL, app handles auto‑record start
        return .openURL(URL(string: "sonarai://start-recording")!)
    }
}
```

Widget entry view:

```swift
// Widgets/QuickRecordWidgetView.swift (simplified)
import SwiftUI
import WidgetKit

struct QuickRecordWidgetView: View {
    var body: some View {
        VStack {
            Text("Sonar")
            AppIntentButton(intent: StartRecordingIntent()) { Label("Record", systemImage: "mic.fill") }
        }
    }
}
```

---

### 34) Paywall sketch

```swift
// Views/Paywall/PaywallView.swift (conceptual)
import SwiftUI
import StoreKit

struct PaywallView: View {
    @State private var products: [Product] = []

    var body: some View {
        VStack(spacing: 16) {
            Text("Unlock Sonar Premium").font(.largeTitle.bold())
            Text("Unlimited entries, custom styles, and more.")
            ForEach(products) { product in
                Button(product.displayName) { Task { try? await purchase(product) } }
                    .buttonStyle(.borderedProminent)
            }
            Button("Restore Purchases") { Task { try? await AppStore.sync() } }
                .buttonStyle(.plain)
        }
        .task { products = await loadProducts() }
    }

    private func loadProducts() async -> [Product] { /* fetch by IDs */ return [] }
    private func purchase(_ product: Product) async throws { /* transact */ }
}
```

Gate usage after free limit using `@AppStorage("freeCount")`. After threshold, present `PaywallView`.

---

### 35) Performance considerations

- Keep audio buffer sizes balanced to minimize latency without starving recognizer.
- Reuse `NLEmbedding` instance; avoid repeated allocations.
- Coalesce Spotlight updates; index on a background Task.
- Avoid storing giant transcripts; consider truncating raw filler segments.

---

### 36) File management

- Store audio under `Library/Application Support/Audio/` with UUID filenames.
- Use `.fileProtectionCompleteUntilFirstUserAuthentication` by default.
- Clean temp files proactively after export/playback.

---

### 37) Crash resilience

- On crash during recording, ensure engine stops on next launch; show recovery UI to salvage partial audio file if present.
- Wrap critical steps (save, index) in `do/catch` with user‑visible fallback.

---

### 38) Visual identity

- Minimal, calming palette. Acoustic waveform motif. High readability.
- App icon variants in assets; dark mode optimized.

---

### 39) Compliance

- Medical disclaimers not required (non‑medical), but be clear about privacy and no cloud unless enabled.
- Export compliance key in Info.

---

### Appendix A — Transcription service notes (sketch)

Pseudocode outline:

```swift
final class DefaultTranscriptionService: SpeechTranscriptionService {
    private let engine = AVAudioEngine()
    private var task: SFSpeechRecognitionTask?

    func requestAuthorization() async throws { /* mic + speech */ }

    func startStreamingTranscription(onDeviceOnly: Bool) async throws -> AsyncStream<String> {
        let stream = AsyncStream<String> { continuation in
            // Configure session, engine, request
            let request = SFSpeechAudioBufferRecognitionRequest()
            request.requiresOnDeviceRecognition = onDeviceOnly
            // Append buffers...
            self.task = SFSpeechRecognizer()?.recognitionTask(with: request) { result, error in
                if let t = result?.bestTranscription.formattedString { continuation.yield(t) }
                if let error { continuation.finish() } else if result?.isFinal == true { continuation.finish() }
            }
        }
        return stream
    }

    func stop() async { engine.stop(); task?.cancel() }
}
```

---

### Appendix B — Summarization helpers (sketch)

```swift
enum SentenceSplitter {
    static func split(_ text: String) -> [String] {
        let tokenizer = NLTokenizer(unit: .sentence)
        tokenizer.string = text
        var sentences: [String] = []
        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { range, _ in
            let s = String(text[range]).trimmingCharacters(in: .whitespacesAndNewlines)
            if !s.isEmpty { sentences.append(s) }
            return true
        }
        return sentences
    }
}

enum VectorOps {
    static func centroid(of vectors: [[Double]]) -> [Double] {
        guard let count = vectors.first?.count, !vectors.isEmpty else { return [] }
        var sum = Array(repeating: 0.0, count: count)
        for v in vectors { for i in 0..<count { sum[i] += v[i] } }
        return sum.map { $0 / Double(vectors.count) }
    }
    static func cosine(_ a: [Double], _ b: [Double]) -> Double {
        guard a.count == b.count, !a.isEmpty else { return 0 }
        var dot = 0.0, na = 0.0, nb = 0.0
        for i in 0..<a.count { dot += a[i]*b[i]; na += a[i]*a[i]; nb += b[i]*b[i] }
        return dot / (sqrt(na) * sqrt(nb) + 1e-9)
    }
}

enum Rewriter {
    static func rewrite(_ text: String, toneHint: String?) -> String {
        // Optionally strip fillers, normalize whitespace; keep fast.
        text.replacingOccurrences(of: "  ", with: " ")
    }
}
```

---

### Appendix C — Spotlight indexing (sketch)

```swift
struct DefaultSearchIndexingService: SearchIndexingService, Sendable {
    func index(entry: JournalEntry) async {
        let attr = CSSearchableItemAttributeSet(contentType: .text)
        attr.title = entry.summary ?? "Journal Entry"
        attr.contentDescription = String(entry.transcript.prefix(200))
        attr.keywords = entry.tags.map { $0.name } + [entry.moodLabel].compactMap { $0 }
        let item = CSSearchableItem(uniqueIdentifier: entry.id.uuidString, domainIdentifier: "journal", attributeSet: attr)
        try? CSSearchableIndex.default().indexSearchableItems([item])
    }
    func deleteIndex(for id: UUID) async {
        try? CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [id.uuidString])
    }
}
```

---

### Appendix D — Privacy manifest (example contents)

Document microphone usage and data collection minimalism. Example keys to include in `Resources/PrivacyInfo.xcprivacy`:

- Microphone access: used for user‑initiated recording only; not used for tracking.
- Data types: Audio (user content), Text transcription (user content), Diagnostics (crash logs via MetricKit, no user content).
- No tracking across apps.

---

### Appendix E — Request review

After a successful save on the third day of use, call the modern review request API at an appropriate moment in app foreground to avoid interrupting capture flow.

---

### Appendix F — Risk notes and mitigations

- On‑device recognition unavailability: gracefully fall back to record‑only mode and defer transcription until device supports it (user‑visible toggle to allow server is out‑of‑scope).
- Long recordings memory pressure: chunk summaries per 2–3 minutes and combine.
- Spotlight privacy: if user enables full encryption, disable spotlight indexing for those entries and show a badge.

---

### Final checklist for 1.0 ship (copilot mode)

- iOS 18 target; app compiles cleanly; no extra setup.
– Onboarding complete; permissions obtained; on‑device‑only mode honored.
– Recording/transcription/summarization/mood work offline reliably.
– Threads, tags, weekly insights implemented.
– Search, Spotlight, Widgets, Live Activity, App Shortcuts working.
– Encrypted sharing/export/import flows tested end‑to‑end.
– StoreKit 2: products, trials, promos, restore purchases, gating.
– Settings: iCloud sync toggle, encryption toggle, export, contact, version, notification prefs.
– Privacy manifest present; ATS enabled; no third‑party SDKs.
– OSLog + MetricKit; unit and UI tests added and passing in local runs.
– Any project/target/non‑Swift file additions were pre‑approved via STOP gate plan.


