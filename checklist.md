### Sonar — Comprehensive Product Checklist for 1.0 (keep updated)

Legend
- [x] = done
- [ ] = pending

First‑Run & Core Value
- [ ] Welcome screen explains privacy-first, on-device promise
- [ ] Short value bullets: capture, summarize, mood, search
- [ ] First-run shows a single clear primary action (Record)
- [x] Tab bar includes Record, Journal, Search, Settings
- [ ] First-run hints show how to find past entries
- [ ] First entry can be created in < 10 seconds from install
- [ ] First save gives positive feedback (haptic + check)
- [ ] First-run teaches summary and mood badges
- [ ] Users can skip or revisit onboarding later in Settings
- [ ] Works without account creation or sign-in

Record — Start & Control
- [x] Dedicated Record screen exists
- [x] Big mic button starts recording instantly
- [ ] Visible level feedback (waveform or meter)
- [x] Timer shows elapsed recording time
- [ ] Pause/resume button with clear state
- [x] Stop button is unambiguous and within reach
- [x] Subtle haptic on start/stop
- [ ] Recording continues with screen off/locked when allowed
- [ ] Handles phone calls/alarms gracefully (auto-pause)
- [ ] Resumes safely after interruption
- [ ] Guardrails against extremely long sessions
- [ ] Clear error messages for mic/speech permissions

Transcription — Live & Reliable
- [x] Live transcript updates while speaking
- [x] On-device only by default; explain if unsupported
- [ ] Fall back to record-only with clear next steps
- [ ] Partial text updates without jitter (smooth cadence)
- [ ] Keeps up with normal speaking pace
- [ ] Auto-trims filler words where helpful
- [ ] Handles multi-minute sessions without stalls
- [ ] Finalizes the transcript on stop
- [ ] Allows review of transcript before saving
- [ ] Language settings honor device locale

Processing — Summary & Mood
- [x] Automatic summary generated after stop
- [ ] Summary is concise (1–3 sentences) by default
- [ ] Options: Concise, Reflective, Bulleted styles
- [ ] Summary respects user’s chosen style by default
- [ ] Users can regenerate summary for a different outcome
- [x] Mood signal calculated for each entry
- [ ] Mood badge text and color are understandable
- [ ] Short explanation of mood when tapped
- [x] Processing shows clear progress state
- [x] Processing completes quickly for typical entries

Journal — List
- [x] Journal tab shows recent entries
- [x] Rows contain summary (or transcript excerpt)
- [x] Rows show mood chip and created time
- [ ] Sticky “Pinned” area at top for important entries
- [ ] Swipe actions: Pin/Unpin, Delete, Share
- [ ] Batch select for multi-delete or export
- [ ] Empty state shows guidance to Record
- [ ] Pull to refresh derived content (if needed)
- [ ] Context menu on long-press for quick actions
- [ ] Scales well with large history (no lag)

Entry — Detail
- [ ] Full transcript readable with large text support
- [ ] Summary shown above transcript
- [ ] Mood chip with label/score
- [ ] Audio playback with scrubber and speed control
- [ ] Edit title/notes (optional short title)
- [ ] Edit tags inline
- [ ] Assign to a thread inline
- [ ] Pin/unpin in toolbar
- [ ] Share/export entry
- [ ] Delete with confirmation
- [ ] Clear affordance to return to list

Organization — Tags & Threads
- [ ] Create, rename, delete tags
- [ ] Assign multiple tags to an entry
- [ ] Quick tag chips in detail and list row
- [ ] Create memory threads (topics/people/goals)
- [ ] Assign entries to threads
- [ ] Thread page shows all entries and a mini rollup
- [ ] Per-thread highlights: top themes, pinned items
- [ ] Filter by tags and threads in search
- [ ] Edit tags/threads from Settings as well

Search — Text & Filters
- [x] Search tab accessible from tab bar
- [x] Search across transcript and summary text
- [x] Spotlight indexing of entries for system-wide search
- [ ] Highlight matching terms in results
- [ ] Filter by date ranges (Today, 7 days, Custom)
- [ ] Filter by mood bins (Negative/Neutral/Positive)
- [ ] Filter by tags (multi-select)
- [ ] Filter by threads
- [ ] Sort by newest/oldest/relevance
- [x] Result rows show summary/mood/time
- [ ] No-results state suggests removing filters
- [ ] Search is fast, even with large history

Insights — Weekly
- [ ] Weekly dashboard surfaces top themes
- [ ] Mood trend chart (week-over-week)
- [ ] Highlights: notable summaries, pinned items
- [ ] Suggested prompts for reflection
- [ ] Privacy note that insights are on-device
- [ ] Share weekly highlights (optional)
- [ ] Users can opt out of insights

Notifications — Gentle Reminders
- [ ] Friendly opt-in prompt explaining value
- [ ] Daily reminder at user-selected hour
- [ ] Tapping opens straight into Record
- [ ] Quick actions from notification (Start/Remind me later)
- [ ] Respect Focus modes and summary delivery
- [ ] Edit reminder time in Settings
- [ ] Easy to turn off reminders

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
- [ ] Start Recording shortcut
- [ ] Summarize Last Entry shortcut
- [ ] Search Entries shortcut (tag/mood parameters)
- [ ] Shortcuts return clear success messages
- [ ] Show up as suggestions in Spotlight

Onboarding — 3 Screens Max
- [ ] Value + privacy promise in friendly tone
- [ ] Permission education (Mic, Speech, Notifications)
- [ ] Choose summary style and reminder time
- [ ] Free limit and paid tiers explained succinctly
- [ ] Finish goes to Record with encouragement
- [ ] Progress indicators (1/3, 2/3, 3/3)

Settings — Control & Confidence
- [x] Settings screen exists
- [ ] Manage subscription (plans, trial, upgrade/downgrade)
- [ ] Restore purchases
- [ ] iCloud sync toggle with explanation
- [ ] Encryption toggle for transcripts/audio
- [ ] Export data (ZIP) and Import (advanced)
- [ ] Default summary style selector
- [ ] Notification preferences (hour, enable/disable)
- [ ] Daily prompt enable/disable
- [ ] App version and build visible
- [ ] Privacy policy and Terms links
- [ ] Contact support (mailto:)

Paywall — Clear & Honest
- [ ] Fast, clear comparison: Free vs paid
- [ ] Plan cards: Pro, Premium, Max + annuals
- [ ] Trial messaging (e.g., 7 days on Premium)
- [ ] Benefits explained in plain language
- [ ] Family Sharing guidance if applicable
- [ ] Restore Purchases visible
- [ ] Links to Terms/Privacy from paywall
- [ ] Exit affordance (X) and no dark patterns
- [ ] Paywall shown post-onboarding or on gate

Privacy — Local First
- [ ] On-device processing stated and honored
- [ ] No account, no third-party analytics
- [ ] Clear explanation of what’s stored
- [ ] Easy export or delete of personal data
- [ ] Privacy Manifest accurately describes use
- [ ] Spotlight indexing opt-out if encrypting
- [ ] Sensitive screens respect privacy (blur in app switcher if desired)

Performance — Budgets & Profiling
- [ ] Start record → first partial < 600ms
- [ ] Stop → summary < 1.5s for 2–3 min speech
- [ ] Reuse NLEmbedding and avoid repeated allocations
- [ ] Coalesce Spotlight updates; index on background tasks

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
- [ ] Modern review request after third day of successful saves (appropriate moment)

Security — Your Data, Your Device
- [ ] Encrypted export option with passphrase
- [ ] Local files use appropriate protection class
- [ ] Clear warnings about lost passphrases
- [ ] Data remains accessible offline

Sharing, Export & Import
- [ ] Share selected entries (text summary/transcript)
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
- [ ] ≥ 3 App Intents implemented (Start Recording, Summarize Last Entry, Search Entries)
- [ ] Intents return clear result summaries
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
- [ ] Deep link: start recording
- [ ] Deep link: open last entry
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
- [x] App shell with four tabs: Record, Journal, Search, Settings
- [x] Journal list basic screen exists
- [x] Search basic screen exists
- [x] Settings basic screen exists
- [x] Saving entries locally with summary and mood
- [x] Baseline on-device summary and mood signal foundation
- [x] Mic button with haptic feedback

Maintenance Rule
- Keep this checklist updated with every change (mark items [x] when completed; add items as scope expands).


