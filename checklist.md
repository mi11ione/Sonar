### Sonar — Comprehensive Product Checklist for 1.0 (keep updated)

Legend
- [x] = done
- [ ] = pending

AI Agent — API Verification (keep this green before edits)
- [x] Use `framework-sources/` as canonical reference for framework symbols
- [x] Verify function/type names, parameters, and availability in the relevant `*.md`
- [x] Add inline citation(s) to the exact lines used from `framework-sources/`
- [x] Prefer iOS 18+ modern APIs; avoid deprecated items in the sources
- [x] If symbol missing or unclear, pause and request updated sources or cite Apple docs

First‑Run & Core Value
- [x] Welcome screen explains privacy-first, on-device promise
- [x] Short value bullets: capture, summarize, mood, search
- [x] First-run shows a single clear primary action (Record)
- [x] Tab bar includes Record, Journal, Settings
- [x] First-run hints show how to find past entries
 - [x] First entry can be created in < 10 seconds from install
- [x] First save gives positive feedback (haptic + check)
- [ ] First-run teaches summary and mood badges
- [x] Works without account creation or sign-in

Record — Start & Control
- [x] Dedicated Record screen exists
- [x] Big mic button starts recording instantly
- [x] Visible level feedback (waveform or meter)
- [x] Timer shows elapsed recording time
- [x] Pause/resume button with clear state
- [x] Stop button is unambiguous and within reach
- [x] Subtle haptic on start/stop
- [ ] Recording continues with screen off/locked when allowed
 - [x] Handles phone calls/alarms gracefully (auto-pause)
 - [x] Resumes safely after interruption
 - [x] Guardrails against extremely long sessions
- [x] Clear error messages for mic/speech permissions

Transcription — Live & Reliable
- [x] Live transcript updates while speaking
- [x] On-device only by default; explain if unsupported
- [x] Fall back to record-only with clear next steps
 - [x] Partial text updates without jitter (smooth cadence)
 - [x] Keeps up with normal speaking pace
  - [x] Auto-trims filler words where helpful
 - [x] Handles multi-minute sessions without stalls
- [x] Finalizes the transcript on stop
- [x] Allows review of transcript before saving
 - [x] Language settings honor device locale

Processing — Summary & Mood
- [x] Automatic summary generated after stop
- [x] Summary is concise (1–3 sentences) by default
- [x] Options: Concise, Reflective, Bulleted styles
- [x] Summary respects user’s chosen style by default
- [x] Users can regenerate summary for a different outcome
- [x] Mood signal calculated for each entry
- [x] Mood badge text and color are understandable
- [x] Short explanation of mood when tapped
- [x] Processing shows clear progress state
- [x] Processing completes quickly for typical entries

Journal — List
- [x] Journal tab shows recent entries
- [x] Rows contain summary (or transcript excerpt)
- [x] Rows show mood chip and created time
- [x] Sticky “Pinned” area at top for important entries
- [x] Swipe actions: Pin/Unpin, Delete, Share
- [x] Batch select for multi-delete or export (delete supported)
- [x] Empty state shows guidance to Record
 - [x] Pull to refresh derived content (if needed)
- [x] Context menu on long-press for quick actions

Entry — Detail
- [x] Full transcript readable with large text support
- [x] Summary shown above transcript
- [x] Mood chip with label/score
- [x] Audio playback with scrubber and speed control (UI stub)
- [x] Edit title/notes (optional short title)
- [x] Text-to-speech playback with chosen voice
- [x] Edit tags inline
- [x] Assign to a thread inline
- [x] Pin/unpin in toolbar
- [x] Share/export entry
- [x] Delete with confirmation
- [x] Clear affordance to return to list

Organization — Tags & Threads
- [ ] Create, rename, delete tags
- [x] Assign multiple tags to an entry
 - [x] Quick tag chips in detail and list row
- [x] Create memory threads (topics/people/goals)
- [x] Assign entries to threads
- [x] Threads list and per-thread detail with average mood
- [ ] Per-thread highlights: top themes, pinned items
- [ ] Filter by tags and threads in search
- [x] Edit tags/threads from Settings as well

Search — Text & Filters
- [x] Search across transcript and summary text
- [x] Spotlight indexing of entries for system-wide search
- [x] Highlight matching terms in results
- [x] Filter by date ranges (Today, 7 days)
  - [x] Filter by custom date ranges
- [x] Filter by mood bins (Negative/Neutral/Positive)
- [x] Filter by tags (multi-select)
  - [x] Filter by threads
  - [x] Sort by newest/oldest/relevance
- [x] Result rows show summary/mood/time
- [x] No-results state suggests removing filters

Insights — Weekly
 - [x] Weekly dashboard surfaces top themes
 - [x] Mood trend chart (week-over-week)
 - [x] Highlights: notable summaries, pinned items
 - [x] Suggested prompts for reflection
- [ ] Privacy note that insights are on-device
- [ ] Share weekly highlights (optional)
 - [x] Users can opt out of insights

Notifications — Gentle Reminders
- [x] Friendly opt-in prompt explaining value
- [x] Daily reminder at user-selected hour
- [x] Tapping opens straight into Record
- [x] Quick actions from notification (Start/Remind me later)
 - [x] Respect Focus modes and summary delivery
- [x] Edit reminder time in Settings
- [x] Easy to turn off reminders

Widgets — Quick Actions
- [ ] Quick Record widget (tap to record)
- [ ] Daily Prompt widget (tap to record with prompt)
- [ ] Recent Summary widget (privacy-aware)
- [ ] Placeholder states for all sizes
- [ ] Looks good in light/dark and on Lock Screen
- [ ] Doesn’t reveal sensitive text by default

Live Activities — During Recording
- [ ] Shows elapsed time and a Stop action
- [ ] Uses compact/expanded/Dynamic Island layouts
- [ ] Ends reliably when recording stops
- [ ] Resilient across app/background transitions

App Shortcuts — Spotlight & Siri
 - [x] Start Recording shortcut
- [x] Summarize Last Entry shortcut
- [x] Search Entries shortcut (tag/mood parameters)
- [ ] Shortcuts return clear success messages
- [ ] Show up as suggestions in Spotlight

Onboarding — 3 Screens Max
 - [x] Value + privacy promise in friendly tone
 - [x] Permission education (Mic, Speech, Notifications)
 - [x] Choose summary style and reminder time
  - [x] Free limit and paid tiers explained succinctly
 - [x] Finish goes to Record with encouragement
 - [x] Progress indicators (1/3, 2/3, 3/3)

Settings — Control & Confidence
- [x] Settings screen exists
- [x] Manage subscription (plans, upgrade/downgrade)
- [x] Restore purchases
 - [x] iCloud sync toggle with explanation
- [ ] Encryption toggle for transcripts/audio
 - [x] Export data (ZIP) and Import (advanced)
- [x] Default summary style selector
- [x] Text-to-speech voice and rate selection
- [x] Notification preferences (hour, enable/disable)
 - [x] Daily prompt enable/disable
- [x] App version and build visible
- [x] Privacy policy and Terms links
- [x] Contact support (mailto:)

 Paywall — Clear & Honest
- [x] Fast, clear comparison: Free vs paid
- [x] Plan cards: Pro, Premium, Max + annuals
- [x] No free trials anywhere in the app
- [x] Benefits explained in plain language
- [ ] Family Sharing guidance if applicable
- [x] Restore Purchases visible
- [x] Links to Terms/Privacy from paywall
- [x] Exit affordance (X) and no dark patterns
- [x] Paywall shown post-onboarding or on gate

Privacy — Local First
- [x] On-device processing stated and honored
- [ ] No account, no third-party analytics
- [ ] Clear explanation of what’s stored
- [ ] Easy export or delete of personal data
- [ ] Privacy Manifest accurately describes use
- [ ] Spotlight indexing opt-out if encrypting
- [ ] Sensitive screens respect privacy (blur in app switcher if desired)

Performance — Budgets & Profiling
- [ ] Start record → first partial < 600ms
- [ ] Stop → summary < 1.5s for 2–3 min speech
- [x] Reuse NLEmbedding and avoid repeated allocations
- [ ] Coalesce Spotlight updates; index on background tasks (title/notes added to Spotlight)

File Management — Storage & Protection
- [ ] Audio stored under Library/Application Support/Audio with UUID filenames
- [ ] File protection set to CompleteUntilFirstUserAuthentication
- [ ] Temp files cleaned after export/playback

Crash Resilience — Recovery
- [ ] Engine/session safely stopped on relaunch after crash
- [ ] UI to recover/salvage partial audio if present
- [ ] Critical steps wrapped with user-visible fallback

Compliance — ATS & Export
- [ ] App Transport Security enabled (ATS)
- [ ] Export compliance key present in Info

Request Review
- [x] Modern review request via service with multi-signal cadence (active days, milestones, cooldowns)

Security — Your Data, Your Device
- [ ] Encrypted export option with passphrase
 - [x] Local files use appropriate protection class
- [ ] Clear warnings about lost passphrases
- [ ] Data remains accessible offline

Sharing, Export & Import
 - [x] Share selected entries (text summary/transcript)
- [ ] Export ZIP (entries + audio)
- [ ] Optional password on export
- [ ] Import merges by entry ID without duplicates
- [ ] AirDrop and Files integration
- [ ] Share sheet previews look clean

Accessibility — Inclusive by Default
- [ ] Large text support across all key screens
- [ ] VoiceOver labels for mic, waveform, playback
- [ ] Sufficient color contrast in light/dark
- [ ] Respect Reduce Motion; use gentle springs
- [ ] Haptics are helpful, not noisy
- [ ] Hit targets meet comfortable sizes
- [ ] Dynamic layouts avoid truncation

Delight & UX Polish
- [ ] Microcopy feels supportive, not clinical
- [ ] Subtle animations on key transitions
- [ ] Empty states invite action (Record/Search)
- [ ] Error states offer next steps (Try again/Open Settings)
- [ ] Success confirmation after save (visual + haptic)
- [ ] No unexpected modals during recording

Visual Identity — Calm & Clear
- [ ] Palette supports calm journaling mood
- [ ] Typography scale is readable and balanced
- [ ] Iconography consistent with Apple design
- [ ] App icon looks great in all contexts
- [ ] Waveform motif used tastefully
- [ ] Visuals feel coherent across screens

Internationalization & Localization
- [ ] User-facing strings prepared for localization
- [ ] English complete and consistent
- [ ] RTL layouts render properly
- [ ] Dates and numbers use locale formats

Cloud Sync — SwiftData + CloudKit (optional)
- [ ] iCloud capability enabled for the app target
- [ ] ModelContainer configured for CloudKit syncing
- [ ] Tested with development container; clear rollback to local-only
- [ ] Conflict strategy documented (append-only entries)

iOS Shortcuts & App Intents
 - [x] ≥ 3 App Intents implemented (Start Recording, Summarize Last Entry, Search Entries)
 - [x] Intents return clear result summaries
- [ ] Appear as Spotlight suggestions

Testing — Unit & UI
- [ ] Unit: summarization ranking deterministic for fixtures
- [ ] Unit: mood analyzer bins known texts correctly
- [ ] Unit: encryption round-trip byte-identical (when implemented)
- [ ] UI: onboarding path with permissions stubbed
- [ ] UI: record → stop → summary appears
- [ ] UI: paywall gating after free limit

iPad & Keyboard
- [ ] iPad two-column layout (list + detail)
- [ ] Keyboard shortcut: Start/Stop recording
- [ ] Keyboard shortcut: Search
- [ ] Keyboard shortcut: New tag/thread
- [ ] Inspector or sidebar for details where helpful

Navigation & Deep Links
- [ ] Navigation is predictable and reversible
- [ ] Back behavior matches user expectations
- [x] Deep link: start recording (code wired; add URL scheme `sonarai` in Info.plist)
 - [x] Deep link: open last entry
- [ ] Deep link: open search with filters

Offline & Reliability
- [ ] Recording works with no connectivity
- [ ] Saving never silently fails
- [ ] Clear recovery if something goes wrong
- [ ] Handles low battery gracefully
- [ ] Handles device storage low warnings

Trust, Help & Support
- [ ] In-app “How it works” in Settings
- [ ] Contact support via email draft with context (optional)
- [ ] Clear privacy stance reiterated
- [ ] Changelog or “What’s new” view for updates

Store Presence & Launch
- [ ] App name, subtitle, keywords sharpened
- [ ] Screenshots tell the story (Record → Summary → Find)
- [ ] Optional preview video with captions
- [ ] Compelling description highlights privacy-first
- [ ] Support URL, Privacy policy, Terms URLs live
- [ ] Version notes focus on improvements users feel

Already Completed (snapshot)
- [x] App shell with three tabs: Record, Journal, Settings
- [x] Journal list basic screen exists
- [x] Settings basic screen exists
- [x] Saving entries locally with summary and mood
- [x] Baseline on-device summary and mood signal foundation
- [x] Mic button with haptic feedback

Maintenance Rule
- Keep this checklist updated with every change (mark items [x] when completed; add items as scope expands).


