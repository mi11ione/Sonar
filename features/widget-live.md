## Widgets and Live Activities — Sonar (Deep Design & Implementation Guide)

### Goals
- Launch recording from anywhere with near-zero friction.
- Encourage daily reflection with tasteful, privacy‑respecting nudges.
- Surface recent insights without exposing sensitive content.
- Keep energy, memory, and privacy budgets strictly in check.

### Guardrails and constraints
- iOS 18+, SwiftUI, WidgetKit, AppIntents. No third‑party SDKs. No background daemons.
- Lock Screen redaction by default; opt‑in to show more content explicitly.
- Coalesce updates; avoid periodic refresh unless justified (e.g., Daily Prompt at a specific hour).
- STOP gates: Creating the Widget extension and Live Activity target will be proposed separately and executed only after approval.

---

## Widgets — Quick Actions (Full Spec)

### Families we will support
- System: small, medium, large
- Accessory: circular, rectangular, inline (for Smart Stack / Lock Screen contexts)

### 1) Quick Record (primary)
- Purpose: One‑tap to begin recording in Sonar.
- Primary action: `StartRecordingIntent` via `AppIntentButton`.
- Secondary affordances (only medium/large): tiny hint label beneath the button (e.g., “On‑device transcription”).

Layout by family
- Small: Centered mic icon + label “Record”; single button. No subtitle.
- Medium: Left icon and title; right-aligned button or full‑width tappable row. Optional footnote: “On‑device, private”.
- Large: Title, descriptive sentence, primary button; subtle divider; second link for “Open Journal”.
- Accessory circular: mic glyph only; tap triggers record.
- Accessory rectangular: mic + short label.
- Accessory inline: “Record” text with mic symbol.

States
- Idle: default visuals.
- Pending: brief state after tap (e.g., subtle spinner or “Opening…”). Keep transient (≤1s) since the host opens the app.
- Error hint: only if previous attempt failed permission checks; display “Enable Mic & Speech in Settings”. No persistent failure UI.

Privacy
- No user data is shown. All text is generic.

Timeline
- Static. No periodic refresh. Update only when the app signals capability changes (optional, low frequency), otherwise snapshot-only.

Accessibility
- VoiceOver: “Start Recording. Starts a new voice journal in Sonar.”
- Minimum hit target: 44×44 points.
- Dynamic Type: labels scale; icons keep minimum optical size.

Performance
- No data fetch; no heavy view trees.
- Zero background work; action-only widget.

QA
- Verify action triggers app and starts recording with `.openAppWhenRun = true` intent behavior.
- Verify VoiceOver labels; contrast; focus order.

---

### 2) Daily Prompt
- Purpose: Provide a daily reflection nudge with a friendly prompt.
- Data source: `DefaultPromptsService.todayPrompt(locale:)` (deterministic per day and locale).
- Actions: Primary “Record” (with prompt shown in-app); Secondary “New Prompt” (cycles deterministically or randomly).

Layout by family
- Small: Title “Prompt” + single action.
- Medium: Prompt text (2–3 lines max) + two buttons (Record, New).
- Large: Prompt text (up to 5 lines), contextual subtext (e.g., “Tap to capture your thoughts”), and both actions.
- Accessory rectangular: short prompt (≤30 chars) + mic glyph; action on tap.
- Accessory inline: “Prompt: <short>”.

Privacy
- Lock Screen default: show “Prompt available” (no prompt text). In‑app toggle can enable showing the actual prompt on Lock Screen.
- Home Screen default: show prompt text.

Timeline policy
- Refresh at the user’s reminder hour (if set); else at midnight local time.
- Fallback: if the app is opened and a new day has started, request a reload (throttled) to sync the widget.

Error/edge cases
- Prompts unavailable (should not happen locally): show “Take a minute to reflect.”
- Locale change: refresh on next timeline request.

Accessibility
- VoiceOver: reads “Daily Prompt. <text or redacted>. Action: Record. Action: New Prompt.”

Performance
- Small string rendering only; no images; no network.

QA
- Verify scheduling: appears at set hour; changes at midnight; opt‑in redaction works.
- Ensure long prompts truncate gracefully (line limit + fade).

---

### 3) Recent Summary (privacy‑aware)
- Purpose: Surface the latest entry’s summary at a glance, with strict privacy.
- Data: most recent `JournalEntry` summary and mood label from local store (via a lightweight timeline snapshot provider).
- Actions: “Open Last Entry”; secondary “Record”.

Privacy
- Lock Screen default: redacted content (title “Latest summary”) with lock badge. In‑app toggle can allow showing one‑line snippet.
- Home Screen: show one‑ to three‑line snippet; never show full transcript.

Layout by family
- Small: app badge or mood chip + date (“Today”/relative) + chevron.
- Medium: title “Latest” + summary snippet (1–2 lines) + mood badge + action.
- Large: title, 2–4 lines of summary, mood badge, timestamp, two actions.
- Accessory rectangular: mood chip + 1 short phrase.
- Accessory inline: “Latest: …” truncated.

Timeline policy
- Update on app foreground and after a new entry save, coalesced: at most a few times/day.
- If Spotlight indexing is disabled, widget still shows recent summary (feature is independent).

Moods & badges
- Map moodLabel to semantic tint: Negative (red), Neutral (gray), Positive (green). This is purely a visual hint; no numeric scores in the widget.

Error/empty
- No entries: “No entries yet.” Primary action “Record”.

Accessibility
- Announce “Latest summary: <redacted>” on Lock Screen; “Latest summary: <snippet>” on Home Screen.

Performance
- Pull at most the latest one item; avoid sorting large datasets in the provider.

QA
- Verify redaction; verify correct last item; verify actions.

---

### Widget behaviors common to all
- Localization: All visible strings use keys; keep strings concise and neutral.
- Dark mode: Ensure sufficient contrast (WCAG AA); avoid thin text over transparency.
- Haptics: host controls tap feel; we don’t synthesize haptics inside widgets.
- Logging: Use OSLog in the app around widget-triggered flows for funnel metrics (e.g., recording start from widget).

---

## Live Activities — Recording (Full Spec)

### Activity model
- Attributes (`RecordingActivityAttributes`):
  - `id: String` (UUID string)
  - `startedAt: Date`
  - `deviceLocale: String`
- Content State:
  - `elapsedSeconds: Int`
  - `isPaused: Bool`
  - `levelHint: Float` (0…1, debounced)
  - `entryId: UUID?` (assigned after save)

### Lifecycle
- Start: When user starts recording in-app and permissions are granted, begin activity with `elapsedSeconds = 0` and `isPaused = false`.
- Update cadence:
  - Timer: 1s; align to wall clock to reduce jitter.
  - Level hint: ≤ 4 Hz (every ~250 ms), computed from audio RMS (already available in transcription service) and debounced.
- Stop/end:
  - On Stop action (from activity or app), end activity and finalize save in-app.
  - On app termination, end any stale activity on next launch.
- Pause/Resume (optional): Mirror in-app state; only present if engine supports pause.

### UI layouts
- Lock Screen (expanded): Title “Recording…”, monospaced timer, thin level bar, primary Stop button (prominent), optional Pause/Resume secondary.
- Dynamic Island:
  - Compact: mic dot + mm:ss.
  - Minimal: mic glyph only.
  - Expanded: title, timer, thin level bar, Stop button.

### Actions
- Stop: Immediate intent or deep link to trigger in-app stop; idempotent.
- Pause/Resume: Optional; toggles `isPaused` and engine state.

### Privacy & safety
- No transcript or summary text in the activity.
- Defensive against double taps; ensure the app treats repeating Stop as no‑ops.
- If permissions are revoked during activity, allow Stop to function and show education on next launch.

### Performance & energy budgets
- CPU: negligible (UI only); no heavy waveform drawing; update loop bounded.
- Memory: small content state; no images beyond SF Symbols.
- Logging: OSLog signposts around start/stop and save duration to monitor user‑perceived latency.

### Edge cases
- Very long sessions: cap visible timer to 23:59:59; keep internal timer correct.
- Audio route changes: do not stop activity; reflect pause if applicable; Stop always available.
- Low Power Mode: no additional updates; all updates already throttled.

### QA
- Tapping Stop reliably ends activity and saves entry.
- Timer alignment consistent with in-app timer.
- Pause/Resume (if exposed) stays synchronized with engine.
- Works correctly in dark/light modes, all text sizes, and with VoiceOver.

---

## Implementation plan (STOP‑gate approval required)

### Widgets
1) Create `SonarWidget` extension and `WidgetBundle` containing:
   - `QuickRecordWidget` (small/medium/large/accessory variants)
   - `DailyPromptWidget`
   - `RecentSummaryWidget`
2) Providers: placeholders, snapshots, minimal timelines; avoid `.timeline` where not needed.
3) Interactivity: `AppIntentButton` for actions; keep one intent per tap target.
4) Privacy toggle in Settings for Lock Screen redaction (persisted; widgets read via `AppStorage`/shared defaults).
5) Reload triggers: call `WidgetCenter.shared.reloadTimelines` from the app after a save (throttled) and on day roll‑over.
6) Localization: add string keys for all user‑visible labels.
7) QA scripts: screenshots in dark/light, large text, with/without redaction.

### Live Activity
1) Define Activity attributes and content state types; configuration for Lock Screen and Island.
2) Start activity in record flow; hold a reference in a lightweight coordinator.
3) Bind timer to a wall‑clock driven Task; throttle `levelHint`.
4) Wire Stop and optional Pause/Resume to app actions with idempotency.
5) End activity on save/stop/app termination; ensure no dangling activity remains.
6) Add OSLog signposts and expose errors in development builds.
7) QA across route changes, interruptions, and background transitions.

### Risks & mitigations
- Privacy leakage in widgets → default redaction; explicit opt‑in; unit tests for redaction path.
- Excessive timeline reloads → coalesce; cap maximum per day; prefer static timelines.
- Activity desync with app → centralized coordinator and idempotent actions.

---

## Acceptance criteria
- Quick Record, Daily Prompt, and Recent Summary support small/medium/large and accessory variants with correct actions.
- Widgets obey privacy settings and never show transcript text by default.
- Live Activity reliably shows timer and Stop; ends correctly in all flows.
- All components meet accessibility, contrast, localization, and performance requirements.


