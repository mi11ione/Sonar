### Sonar — Comprehensive Product Checklist for 1.0 (keep updated)

Legend
- [ ] = pending

First‑Run & Core Value
- [ ] First-run teaches summary and mood badges

Record — Start & Control
- [ ] Recording continues with screen off/locked when allowed

Organization — Tags & Threads
- [ ] Create, rename, delete tags
- [ ] Per-thread highlights: top themes, pinned items
- [ ] Filter by tags and threads in search

Insights — Weekly
- [ ] Privacy note that insights are on-device
- [ ] Share weekly highlights

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
- [ ] Shortcuts return clear success messages
- [ ] Show up as suggestions in Spotlight

Settings — Control & Confidence
- [ ] Encryption toggle for transcripts/audio

Privacy — Local First
- [ ] No account, no third-party analytics
- [ ] Clear explanation of what’s stored
- [ ] Easy export or delete of personal data
- [ ] Privacy Manifest accurately describes use
- [ ] Spotlight indexing opt-out if encrypting
- [ ] Sensitive screens respect privacy (blur in app switcher if desired)

Performance — Budgets & Profiling
- [ ] Start record → first partial < 600ms
- [ ] Stop → summary < 1.5s for 2–3 min speech
- [ ] Coalesce Spotlight updates; index on background tasks (title/notes added to Spotlight)

File Management — Storage & Protection
- [ ] Audio stored under Library/Application Support/Audio with UUID filenames
- [ ] File protection set to CompleteUntilFirstUserAuthentication
- [ ] Temp files cleaned after export/playback

Crash Resilience — Recovery
- [ ] Engine/session safely stopped on relaunch after crash
- [ ] UI to recover/salvage partial audio if present
- [ ] Critical steps wrapped with user-visible fallback

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

iOS Shortcuts & App Intents
- [ ] Appear as Spotlight suggestions

iPad
- [ ] iPad two-column layout (list + detail)
- [ ] Inspector or sidebar for details where helpful

Navigation & Deep Links
- [ ] Navigation is predictable and reversible
- [ ] Back behavior matches user expectations
- [ ] Deep link: open search with filters

Offline & Reliability
- [ ] Recording works with no connectivity
- [ ] Saving never silently fails
- [ ] Clear recovery if something goes wrong
- [ ] Handles low battery gracefully
- [ ] Handles device storage low warnings

Trust, Help & Support
- [ ] In-app “How it works” in Settings
- [ ] Contact support via email draft with context
- [ ] Clear privacy stance reiterated
- [ ] Changelog or “What’s new” view for updates

Store Presence & Launch
- [ ] App name, subtitle, keywords sharpened
- [ ] Screenshots tell the story (Record → Summary → Find)
- [ ] Optional preview video with captions
- [ ] Compelling description highlights privacy-first
- [ ] Support URL, Privacy policy, Terms URLs live
- [ ] Version notes focus on improvements users feel

Maintenance Rule
- Keep this checklist updated with every change (mark items [x] when completed; add items as scope expands).


