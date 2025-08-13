## Sonar — Complete Design Overhaul Plan (Vibe Theme)

This document specifies a full, end-to-end redesign of Sonar’s UI. It replaces current layouts with an organic, calm, vivid system that is friendly, bouncy, and never harsh. It uses subtle color, soft depth, gentle animation, and consistent materials. It avoids saturated gradients and aggressive shadows.

### Design Goals
- Friendly, supportive tone. Calm surfaces with moments of delight.
- High readability and scannability at all Dynamic Type sizes.
- Gentle motion tied to intent; honors Reduce Motion.
- Organic, cohesive appearance across all screens.

### Rebrand North Star (Vision)
- Promise: “Think out loud. Sonar finds the signal.”
- Personality: warm, optimistic, quietly confident, never clinical.
- Feel: a tranquil studio with soft acoustics; modern, tactile, helpful.
- Differentiator: powerful local AI with a friendly face. We show the value, not the machinery.

### Brand System (Identity)
- Wordmark: rounded geometry, wide tracking; lowercase preferred for approachability.
- Icon motif: acoustic wave + capsule forms; minimal, clear at small sizes.
- Haptics: light impacts for primary taps, success haptic on save; no buzz fatigue.
- Sonic hint (optional): a gentle chime on save (off by default; respects mute). 

### Feature Rebrand
- Purpose: Sonar isn’t a toolbox; it’s a practice. A place to speak freely, see clearly, and grow steadily. The feature set should tell that story.

- Problem we solve:
  - Minds are overloaded; thoughts are scattered; reflection time is scarce.
  - Traditional journaling feels like homework; most quit in days.
  - Users need quick capture, forgiving structure, and meaningful, private insights.

- Positioning statement:
  - “Speak your mind; Sonar finds the signal and helps you move forward.”

- Narrative pillars (how features ladder up to a story):
  - Capture → Clarity → Continuity → Confidence
  - Day to day: quick unloading and tiny wins.
  - Week to week: see patterns (tone, themes) and feel progress.
  - Long arc: build personal storylines; reflect on how you’ve changed.

- Rebranded user-facing features (renames and framing):
  - Quick Capture → “Speak & Unload” (one-tap voice space with live waveform hero and calming cues)
  - Summaries → “Clarity Cards” (short, human-friendly recaps with optional style: Concise/Reflective/Bulleted)
  - Mood signal → “Tone Signal” (gentle, non-judgmental tone reading; explained and optional)
  - Threads → “Storylines” (living topics/people/goals that evolve; show momentum and highlights)
  - Insights → “Weekly Glance” (pill-cloud themes, arc meter mood, highlight cards; shareable recap if desired)
  - Prompts → “Gentle Nudges” (curated one-liners at the right time; in Journal and notifications)
  - Search → “Find by Feeling” (search text but also filter by tone, tags, and time windows)
  - TTS → “Read Back” (hands-free recap in a voice you like; great for review while walking)
  - Export/Import → “Take It With You” (own your data; private by default, simple when you need it)
  - Widgets/Live Activity → “Right From the Lock Screen” (record, prompt of the day, last summary glance)

- Signature journeys (from first minute to habit):
  - Day 0–1 (Activation):
    - Onboarding shows value, privacy, and a single action: Start recording. First save triggers a small success moment.
  - Day 2–7 (Aha → Habit):
    - Daily Gentle Nudge appears (opt-in). Entries surface Clarity Cards and Tone Signal. Journal begins to feel personal.
  - Week 1 (Wow):
    - Weekly Glance highlights 3–5 themes, average tone, and a couple of “standout” moments.
  - Week 2+ (Retention):
    - Storylines become the anchoring lens; search finds past insights quickly; users export/share highlights when useful.

- Personalization & trust:
  - On-device by default; clear explainers and toggles.
  - Choose summary style and reminder time; Tone Signal and Insights are optional.
  - Private achievements and gentle streaks — only you see them.

- Packaging & value framing:
  - Free: frictionless capture, core Clarity Cards, and basic Tone Signal; weekly glance preview.
  - Pro/Premium: deeper insights (themes cloud sizing, arc meter history), unlimited history, custom styles/voices, export.

- Microcopy tone (examples):
  - “Think out loud. We’ll find the signal.”
  - “You spoke. Here’s the gist.”
  - “Looks like this week leaned reflective.”
  - “A small nudge for tonight’s reflection?”

- Ethical guardrails:
  - No judgment labels; tone is informational, never diagnostic.
  - Default to private; sharing is explicit and minimal.
  - No manipulative dark patterns; unlock prompts are honest and skippable.

- Success metrics:
  - D1 activation: ≥ 65% complete first recording.
  - D7 retention: +15–20% over baseline.
  - Weekly insights open rate: ≥ 35%.
  - Median time to find a past insight: < 12s.

- Launch & iteration plan:
  - A/B onboarding hero copy and permission tiles.
  - Test Gentle Nudge timing cohorts.
  - Test Insights card ordering and microcopy variants.
  - Track habit formation signals (3+ days/week over 2 weeks) and refine prompts.

### Theme Tokens (Vibe)
- Corner radii: 14pt primary, 10pt small.
- Card: thin material background with 1pt subtle stroke (.primary opacity 10%).
- Spacing: base 8pt grid; sections: 16–20pt; card internal padding: 12pt.
- Chips: capsule with accent/secondary tint at ~14% fill and label in same tint.
- Background: system background with two very subtle radial tints (accent 8%, blue 4%).
- Typography: Titles use weight for hierarchy (semibold), not color. Headings ≈ Title3/Headline; body text = Body; metadata = Footnote/Caption.

Color palette (calm, non-saturated)
- Mist (background wash): #0A0A0A in dark, #F7F8FA in light (via system background).
- Ocean (accent primary): #3B82F6 at 60–80% opacity in UI fills.
- Seafoam (secondary accent): #22C55E at 40–60% opacity fills.
- Coral (positive): #10B981 (accessible greens) or #2BAA88 depending on mode.
- Amber (neutral): #F59E0B with reduced saturation, used mostly for chips and indicators.
- Rose (negative): #EF4444 reduced ~15% fill for backgrounds.
- Slate (text primary/secondary): via system `.primary`/`.secondary` to respect modes.

Note: Use semantic roles; exact hex are conceptual anchors for marketing/illustration, not hard-coded UI colors.

Mapping to code:
- Card: `vibeCard()` modifier
- Chip: `vibeTag(tint:)`
- Background: `vibeBackground()` applied at app root (`ContentView`)

### Motion, Haptics, And Interaction
- Transitions: small, low-damping springs for core state changes (0.2–0.3s).
- Microinteractions: buttons nudge 2–3pt scale on press; list row selection fades.
- Haptics: light impact for primary taps, success on save, no repeated vibrations.
- Reduce Motion: disable continuous animations (e.g., waveform phase), keep state changes crisp.

Motion levels
- L0 (static): accessibility first; no movement beyond focus changes.
- L1 (subtle): fades, small springs on primary buttons, list row selection ripple.
- L2 (expressive): waveform sheen, chip cloud rearrange, card hover/press.
- L3 (delight): success confetti of tiny dots (muted colors) for milestones (off by default).

### Accessibility
- Dynamic Type: all screens adapt with no clipping or overflow; multi-line titles and labels.
- Contrast: maintain AA in light/dark; chip backgrounds at ~14% tint, label in tint color verified.
- VoiceOver: clear labels and values; group elements logically; expose essential info only.
- Focus order: title → primary action → content → secondary actions.

---

## Global Structure
- The app uses a calm radial `vibeBackground()` across all tabs.
- Primary surfaces are `vibeCard()`; never heavy drop shadows.
- Lists interleave with card rows to add rhythm while keeping density reasonable.
 - Ambient context: headings often accompanied by a one-line supportive microcopy.

---

## Screens

### Onboarding-1 (Intro)
- Layout:
  - Hero title “Welcome to Sonar” (Large Title, semibold) over subtle background.
  - Value bullets in a vertical stack card: capture instantly, on-device privacy, summaries and mood.
  - Mood badge example chip to introduce semantics.
  - Toggle for “On‑device only mode”.
  - Primary “Continue” button.
- Components:
  - Hero block: large type with soft underlay; playful, tiny sparkles (emoji/SF Symbol) that float subtly.
  - One `vibeCard()` grouping bullets and the toggle.
  - Chips: `vibeTag()` for any example tags.
- Motion:
  - Fade-in hero text and card with slight spring.
  - Reduce Motion: no entrance animations.
- Accessibility:
  - VoiceOver order: Title → Value bullets (combined) → Toggle → Continue.
  - Descriptive labels for each bullet.
 - Microcopy examples:
   - Title: “Welcome to Sonar”
   - Subtitle: “Think out loud. We’ll help you find the signal.”
   - Bullet labels: “Tap to record • On-device privacy • Instant summaries & mood”.

### Onboarding-2 (Permissions)
- Layout:
  - Title: “Permissions”.
  - Two permission tiles as separate `vibeCard()`s: Microphone & Speech; Notifications.
  - Each tile: large SF Symbol in matching tint halo (very light ring), one-line benefit copy, and a primary “Enable” button.
  - Inline small print about why and how data is used.
  - Navigation buttons: Back/Continue.
- Motion:
  - Pressing Enable gives a gentle spring on tile and a light haptic.
- Accessibility:
  - Each tile is a single accessibility element; clear labels for what enabling will do.
 - Microcopy examples:
   - Mic/Speech: “We only listen when you tap Record.”
   - Notifications: “A gentle nudge at your chosen time.”

### Onboarding-3 (Personalization)
- Layout:
  - Title: “Make it yours”.
  - Daily reminder time stepper inside card; show selected time as monospaced digits.
  - Default summary style picker (menu) with a brief hint.
  - Back/Start Recording.
- Accessibility:
  - Stepper and picker expose labels and values; VoiceOver reads selected style and time.
 - Microcopy examples:
   - Reminder: “I’ll nudge you at 8:00 PM.”
   - Style hint: “Concise keeps it short. Reflective slows down and looks inward.”

### Record
- Layout:
  - Top bar: subtle contextual title that switches between “Listening…”, “Paused”, and “Review”.
  - Waveform canvas elevated as the hero: full-width `vibeCard()` with dual-stroke line; soft sheen.
  - Below waveform: transcript area in a `vibeCard()` with soft inset divider and “live” pill indicator.
  - Bottom dock: rounded, segmented controls (Pause/Resume on left, prominent red Stop on right). Controls feel tactile but subtle.
  - Status row above waveform: elapsed timer (monospaced), recording indicator (small pulsing dot), and capture hint text.
- State rendering:
  - Idle: “Start Recording” prominent; no waveform.
  - Recording: Waveform visible; live transcript; timer.
  - Review: Transcript editor; Save/Discard actions.
  - Processing: Compact circular progress; keep context visible.
  - Saved: Brief success affirmation then reset.
- Motion & Haptics:
  - Start/Stop springs; success haptic on save.
  - Reduce Motion: no continuous phase animation; amplitude updates without interpolation.
- Accessibility:
  - Mic controls labeled and 44pt hit targets.
  - Waveform labeled “Live waveform”, no focus.
  - Error state includes “Open Settings”.
  - Keyboard shortcuts (iPad): ⌘R Start/Stop.
 - Microcopy examples:
   - Idle: “Tap the mic when you’re ready.”
   - Recording hint: “Pause anytime. We’ll pick up where you left.”
   - Review hint: “Make quick edits, then Save.”

### Journal (List)
- Structure:
  - Header treatment: “Journal” with gentle hero subtitle (e.g., “Welcome back!”) above the list to humanize the feed.
  - Pinned carousel (optional): Pinned entries shown as horizontally scrolling `vibeCard()` tiles with 3D depth reduced to 0; or fallback to a Pinned section if density is preferred.
  - Recent section list with card rows.
  - Row layout: summary/title (1–3 lines), metadata strip (mood chip, date, scrollable tag chips). First line uses Headline with subtle truncation gradient for elegance.
- Interactions:
  - Swipe leading: Pin/Unpin.
  - Swipe trailing: Delete and Share.
  - Long-press context menu: same actions.
- Empty/No results:
  - ContentUnavailableView: “No entries yet” or “No results, try removing filters.”
- Accessibility:
  - Row labeled as one element: summary + “Mood: X, score Y.YY” + date + pinned state.
 - Microcopy examples:
   - Empty: “No entries yet. Tap the mic and speak your mind.”
   - Filters empty: “No results. Try broadening your search or clearing filters.”

### Journal Entry (Detail)
- Structure (single or dual cards based on device width):
  - Top card: title + summary block with a soft gradient accent bar at top edge (2–3pt, very subtle).
  - Mood row with tappable chip reveals a short explainer sheet (accessible).
  - Audio player redesigned: compact transport controls on left (Play/Pause), speed chip on right (tapping reveals choices 0.5–2.0 in a small sheet), scrubber below.
  - Tag editor: chips editable inline; add tag uses a plus chip that expands to a text field.
  - Thread selector: segmented chip showing current thread; tap to choose from a popover of recent threads.
  - Transcript card: larger type scale with comfortable line height; selectable.
  - Notes editor: lined-notebook effect via subtle background stripe (low contrast); retains system text visuals for clarity.
- Accessibility:
  - Player controls labeled (“Play”, “Pause”, “Playback speed”, “Playback position”).
  - Mood info button labeled.
 - Microcopy examples:
   - Mood explainer: “We read tone based on word patterns. You’re in control.”
   - Notes helper: “Add any clarifications or next steps here.”

### Threads (List)
- Layout:
  - `vibeCard()` rows: title, entry count, small “Theme: X” line, and mood badge.
  - Swipe trailing: Rename.
  - Empty state guidance.
 - Microcopy examples:
   - Empty: “Organize long-term themes—people, goals, projects.”

### Thread Detail
- Structure:
  - Optional `Pinned` section.
  - Card rows identical to Journal list with the thread filter applied.
  - Toolbar action to rename (sheet/alert in future).
 - Microcopy examples:
   - Header caption: “A look across time in this thread.”

### Search & Filters
- Structure:
  - Search field in nav cascades into a dedicated `vibeCard()` filter panel when user taps the filter icon.
  - Filter panel presents chips for mood (Negative/Neutral/Positive), date presets (Today/7d/Custom), tag scroller with add/remove chips, thread picker, and sort mode selector.
  - Results appear below as the same `vibeCard()` rows from Journal.
- Empty state: unobtrusive help text.
 - Microcopy examples:
   - Placeholder: “Search transcript, summary, tags, threads…”
   - Panel hint: “Filters stack—combine mood with tags and date.”

### Insights
- Structure:
  - Hero banner card: “Your week at a glance” with a soft accent halo.
  - Grid of cards (adaptive columns):
    - Top Themes: pill cloud of tokens (chips sized by frequency within min/max bounds).
    - Average Mood: meter arc with a calm color ramp; numeric center; friendly caption.
    - Mood Trend: sparkline with rounded caps and tiny dots on min/max; accessibility label summarizes range and current.
     - Highlights: two-column list of short cards with 1–2 line summaries; Share button builds a weekly report.
- Gating:
  - Premium sections display blurred placeholders with a clear Unlock CTA (no dark patterns).
 - Microcopy examples:
   - Hero: “Your week at a glance.”
   - Average mood caption: “A gentle reading of tone across your entries.”
   - Highlights caption: “Standout moments worth revisiting.”

### Settings
- Sections organized as cards grouped under category headers:
  - Subscription: current plan card, “View plans”, “Restore”, and a skinny info strip for trials/offers.
  - Preferences: On‑device only, Daily prompts (toggle + time inline), Default summary style, TTS options, Weekly insights, Widget privacy.
  - Sync: last synced, migration card with progress and controls.
  - Data: Export/Import/Delete grouped; export result appears inline with a ShareLink.
  - About: How It Works, Version, Privacy, Terms, Contact (mailto:).
- Interactions:
  - iCloud migration progress sheet uses a linear progress indicator with counts.
  - Export/Share uses a small sheet with `ShareLink`.
 - Microcopy examples:
   - Privacy toggle: “Transcribe on this device only.”
   - Daily prompts: “A thoughtful nudge once a day.”

### Paywall
- Structure:
  - Title and short value framing.
  - Billing term segmented control with an annual “Save vs monthly” microcopy badge.
  - Plan cards: elevated feel using `vibeCard()`, with small animated accent underline that slides in on hover/tap (Reduce Motion: static).
  - Lifetime: compact card; makes value clear.
  - Manage/Restore sections styled as secondary actions beneath plans.
  - Footer: Terms/Privacy and a lock shield “Privacy promise: on-device”.
  - Motion: card hover/press scale micro-motion; focus rings soft and clear.
 - Microcopy examples:
   - Context: “Unlock unlimited entries, deeper insights, and custom styles.”
   - Trust: “On-device processing. You’re always in control.”
  
### Manage Tags
- Structure:
  - New Tag card with inline TextField and Add.
  - All Tags list with swipe to rename/delete.
  - Rename: alert sheet; merging when duplicate names.

### Manage Threads
- Structure:
  - New Thread card with inline TextField and Add.
  - All Threads list with counts, swipe rename/delete.

### TTS Settings
- Structure:
  - Voice gallery: grouped by language as expandable cards with tiny example phrase badges.
  - Preview section: larger play button, rate and pitch chips that expand to sliders.
  - Persisted selections with a small “Reset to system default” action.
 - Microcopy examples:
   - Preview: “Hear it in your voice.”
   - Reset: “Back to the default voice.”

### How It Works
- Structure:
  - Scrollable educational content in softly separated sections.
  - Bullet lists with clear icons and short, friendly text.

---

## Components

### Cards
- `vibeCard()` surfaces in all flows: consistent padding, thin material, 1pt stroke.
- Use for groupings (onboarding sections, transcript/review, list rows, insights tiles, paywall plans).
 - Tile mosaic variant: small square/rectangular tiles for pinned and highlights (more playful on iPhone).

### Buttons
- Primary: `.borderedProminent` with accent tint; full-width where it clarifies flow (Record, Buy, Save). Subtle scale feedback.
- Secondary: `.bordered` for supporting actions (Read Aloud, Manage Subscription, Open Settings).
- Tertiary text buttons for quiet actions; micro underline animation (Reduce Motion: none).
- Hit target: 44pt min height.

### Chips
- Tags and badges: `vibeTag()`; mood chips rely on `MoodBadge` colors with 15% tint fill.
 - Filter chips: include icon + label; selected state boldens label and raises background tint.

### Waveform
- Min height 60pt; dual-stroke for depth.
- Glow shader available as a flavor toggle; keep contrast safe.
- Background pulse halo (very faint) when recording; disabled in Reduce Motion.

### Empty & Success States
- Empty: pleasant illustration placeholder (SF Symbol composition) with friendly copy, no shaming.
- Success: small animated checkmark in a circle with a subtle burst of 6–8 dots (very muted), 1.2s auto-dismiss.

---

## States & Patterns
- Empty: clear, concise encouragement (Record’s first use, Journal empty, Search no results).
- Error: simple explanation and next steps (e.g., Open Settings for mic permissions).
- Loading: prefer inline spinners in context (no full-screen blockers during capture).
- Offline: everything works on-device; no special UI beyond transient hints if needed.
 - Progressive disclosure: advanced controls tucked behind chips or menus until relevant.

---

## iPad Adaptation
- `NavigationSplitView` for Journal: primary list → details on right.
- Keyboard shortcuts: ⌘R (Record), ⌘F (Search), ⌘, (Settings). Shortcuts are unobtrusive (no visible chrome).
- Wider reading width target for transcript and notes; cards retain generous surrounding paddings.
 - Use sidebars with larger icons and labels; hover states where applicable.

---

## Dark Mode
- The subtle radial background remains low-contrast; verify AA for text and chips.
- Avoid bright saturated accents on dark surfaces; keep accent saturation modest.
 - Increase stroke opacity on cards slightly (12–14%) for separation.

---

## QA Gates
- Dynamic Type: review all screens at largest sizes; no clipping.
- Contrast: AA verified in light/dark for primary text and chip labels.
- VoiceOver: Record, Journal row, Entry Detail, Insights sparkline; labels are clear; groupings are sensible.
- Reduce Motion: disable continuous animations; transitions are crossfades/instant where appropriate.
- Hit Targets: buttons and icons meet 44x44pt; toolbar icons padded.
 - iPad pointer interactions: buttons scale subtly and cards raise tint by ~4% on hover.

---

## Implementation Notes
- Apply `vibeBackground()` at the app root (`ContentView`).
- Prefer `vibeCard()` for all content blocks; avoid custom shadows.
- Replace ad-hoc chip styling with `vibeTag()`.
- Keep motion gentle; gate spring animations behind Reduce Motion when appropriate.
- Maintain semantics via system colors for automatic dark mode support.
 - Ship feature flags to roll out visual changes progressively if needed.

---

## Engagement & Growth Surfaces (Lightweight, Ethical)
- Daily prompts: curated, friendly line at the top of Journal; tap opens Record with prefilled prompt.
- Weekly recap notification: “Peek at your week’s highlights” (respects permissions; taps deep-link to Insights).
- Streaks (gentle): a tiny flame/leaf indicator with no guilt; resets without penalty.
- Achievements (private-only): “5-day reflection streak” badge shown inline on Insights for positive reinforcement.
- Share out (optional): export weekly highlights as an image card with minimal data; defaults to private.

## Marketing Surfaces (App Store & Landing)
- Hero screenshots: Record hero with waveform canvas; Journal mosaic; Insights grid; Paywall elegance.
- Short tagline overlays; consistent brand halo and chips.
- Icon variants tested in dark/light sets; keep wave motif central.

## Rebrand Roadmap (Phased)
1) Foundations: theme tokens, background, cards, chips, motion levels, empty/success states.
2) Record & Journal: hero waveform, dock controls, card rows, pinned carousel variant.
3) Entry Detail & Search: redesigned audio and filter panel chips.
4) Insights & Paywall: adaptive grid, arc meter, animated underlines.
5) Settings & Onboarding polish: permission tiles, category cards.
6) Widgets/Live Activity refresh: consistent visuals; lock-screen safe content.
7) QA pass: accessibility, contrast, motion, hit targets, iPad pointer support.



