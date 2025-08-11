## Sonar — Design System and Experience (Accessibility, Delight, Visual Identity)

This document is the single source of truth for Sonar’s Experience and Visual Design. It defines tokens, interaction rules, accessibility guarantees, component specifications, and QA gates. It should be comprehensive enough for any contributor to make consistent, shippable changes without guesswork.

### Accessibility — Inclusive by Default

- Typography and Dynamic Type
  - Use system text styles and allow scaling across the full Dynamic Type range.
  - Primary titles: Title 1–3 depending on context; lists use Headline for rows; body content uses Body/Large Title where appropriate.
  - Ensure no text truncation at the largest sizes. Favor multi-line with adaptive line spacing and minimum 16pt base sizes in compact contexts.
  - Avoid hard-coded font sizes; rely on `.font(.title2)`, `.font(.headline)`, `.font(.body)`, etc.

- Color and contrast
  - Maintain WCAG AA (≥ 4.5:1 for normal text) in both light and dark.
  - Use semantic roles instead of fixed RGB: foreground `.primary`/`.secondary`, backgrounds `.background`/`.secondarySystemBackground`, emphasis via `.thinMaterial` only when contrast remains compliant.
  - MoodBadge colors: Positive → green (accessible green), Neutral → orange/amber, Negative → red. Ensure label text color meets contrast in both themes; apply 15% tint background on capsule to maintain legibility.
  - Never encode meaning solely in color. Include text labels for mood states and use system image hints only as secondary.

- Screen reader support (VoiceOver)
  - Provide descriptive labels for primary controls:
    - Record: "Start Recording" / "Pause Recording" / "Resume Recording" / "Stop Recording".
    - WaveformView: "Live waveform"; not interactive; mark as accessibility element with meaningful label only.
    - Audio player controls: "Play", "Pause", "Playback speed", "Playback position".
    - Mood chip: "Mood: Positive/Neutral/Negative, score N.N" when score present; expose value and label.
  - Reading order: group related elements (e.g., row title then metadata) to avoid noisy traversal.
  - Insights sparkline: add an accessibility label describing the range and trend, e.g., "Mood trend, average 0.32 this week".
  - Provide actions via context menus with clear labels, and ensure equivalents are reachable via buttons.

- Hit targets and spacing
  - Minimum tappable area 44x44pt for all interactive elements (buttons, chips, icons).
  - Favor vertical spacing in multiples of 8pt; keep touch paths generous around critical actions like Stop.

- Reduced motion and focus preferences
  - Honor Reduce Motion: prefer crossfade or instant state transitions instead of large movement; limit physics-based animations.
  - Keep `.sensoryFeedback` gentle and sparse; never block VoiceOver feedback.

- Keyboard and input (iPad)
  - Provide key equivalents for primary actions (⌘R Start/Stop, ⌘F Search, ⌘, Settings) where feasible; respect focus changes without visual jitter.

### Delight & UX Polish

- Microcopy guidelines
  - Tone: supportive, affirmative, friendly. Avoid clinical or judgmental language.
  - Short, vivid prompts. Example: "What energized you today?" vs. "Describe your day".
  - Empty states invite action:
    - Record: "Tap the mic to start your first journal." with the mic button nearby.
    - Search: "Try broadening your query or clearing filters." when empty.
  - Error states provide next steps:
    - Mic denied: explain why and include "Open Settings" button.

- Motion and transitions
  - Record state changes use small, consistent springs: duration 0.2–0.3s, low damping; no large translations.
  - Progress uses unobtrusive indicators: circular spinner, no blocking full-screen modals during capture.
  - Saved confirmation: subtle success haptic with a short visual affirmation (checkmark and dismissal after ~1.2s).

- Haptics
  - Start/Stop/Pause: light impact.
  - Save: `.success`.
  - Avoid repeated or stacked haptics; never vibrate on every keystroke.

- Thread and search ergonomics
  - Rows reveal primary signal first (summary), then metadata (mood, time, tags) with subdued styling.
  - Chips and filters are scrollable horizontally and avoid tight scroll clashes.

- Paywall clarity
  - Short, honest value framing with immediate plan controls; privacy badge present.
  - Cards use `.thinMaterial` surface with r12 radii, price row and a primary Buy button aligned right.

### Visual Identity — Calm & Clear

- Palette and tone
  - Accent color is the brand’s primary; all surfaces avoid harsh solids—favor subtle neutrals.
  - Use translucency sparingly (thin material) for secondary surfaces such as promotional sections to avoid over-busyness.
  - Mood colors: constrained, consistent mapping; keep saturation modest for calmness.

- Typography scale and rhythm
  - Titles: LargeTitle for app hero only; title2/title3 for section headers; Headline for list row titles; Body for content.
  - Use weight for hierarchy (semibold for titles), not color intensity.
  - Maintain vertical rhythm using base-8 spacing. Keep line length between 45–75 characters where possible.
  - Do not center long-form text; left align for readability; center short hero headings only.

- Iconography
  - SF Symbols only; weight and scale consistent with surrounding text style.
  - Use filled variants for primary actions (e.g., mic.fill, stop.fill) to improve recognition and hit targets.

- Waveform motif
  - Minimal, responsive canvas line with amplitude-reactive motion; ensure performance smoothness and legibility in both light/dark.
  - Shader-based glow is optional and gracefully degrades if unavailable; never reduce text contrast.

- Dark mode
  - Use semantic colors so contrast is preserved automatically.
  - Avoid bright saturated accents on dark backgrounds; verify MoodBadge remains legible with a 15% tint fill.

- Elevation and surfaces
  - Reserve elevation (cards/panels) for focus areas like paywall product tiles; background remains calm, low contrast.

### Component Guidelines

- MicButton
  - Large, full-width, borderedProminent; color communicates action state (primary for start, orange for pause, red for stop).
  - Accessible label mirrors the visible title.

- WaveformView
  - 60pt height minimum to be legible; retains animation at low amplitude to avoid a dead feel; hide entirely when not recording.
  - Accessibility label only; no VoiceOver focus.

- MoodBadge
  - Capsule with 15% background tint and clear label text; tap reveals mood info where relevant.

- Entry rows
  - Title/summary first; metadata row (mood, date, tags preview) second; ensure truncation is graceful.
  - Swipe actions include Pin/Unpin (leading) and Delete/Share (trailing) with clear iconography and roles.
  - Accessibility value announces pinned state when pinned.

- Insights sparkline
  - Thin line, rounded caps, contrasting but not aggressive; provide accessibility string summary.

- Paywall product card
  - Bordered card with price row and action button; "Manage Subscription" entry pinned and visually secondary.

### Content Design

- Strings are friendly and succinct. Examples:
  - Save success: "Saved".
  - Insight privacy: "Insights are computed on your device. No summaries or transcripts leave your phone."
- Recording fallback: "On‑device transcription unavailable. Recording audio only."
  - If fallback persists > N sessions, suggest enabling network recognition with a clear privacy note (future).

### QA checklist (design-specific)

- Dynamic Type
  - Verify all screens at the largest size: no truncation/clipping; interactive controls remain visible and reachable.
- Contrast
  - Check light/dark across primary screens; confirm MoodBadge text contrast ≥ 4.5:1.
- VoiceOver path
  - Traverse Record, Entry Detail, List rows, Insights; labels are clear and controls announce purpose.
- Reduced Motion
  - Enable system Reduce Motion: transitions default to crossfade; no unexpected parallax or bouncing.
  - Verify shader-based visuals are deactivated; check latency isn’t affected when toggling.
- Hit targets
  - Confirm 44x44pt minimum; toolbar icons and chips meet target via padding.
- Widgets/Lock Screen
  - Placeholders and privacy-safe content; no sensitive text unless user opted-in.
- Error and empty states
  - Mic denied shows help + Settings link; empty states encourage action.


