# Sonar — To Fix (Robustness gaps for already-checked items)

This document tracks items that are marked as done in the checklist but still need upgrades to be fully production‑ready (beyond MVP).

1) Waveform level feedback
- Current state: `WaveformView` renders a synthetic waveform based on text length.
- Gap: Not driven by actual mic amplitude (RMS/peak).
- Fix plan:
  - Compute RMS/peak from `AVAudioPCMBuffer` in `DefaultTranscriptionService` tap and publish a lightweight amplitude stream.
  - Bind `WaveformView` to live amplitude for accurate metering.

2) RequestReview timing
- Current state: Requests review after 3rd save overall.
- Gap: Spec requires “first 2 hours of successful saves.”
- Fix plan:
  - Track time with successful saves in `UserDefaults` or SwiftData and trigger on ≥ 2 distinct hours.

3) Summarization locale support
- Current state: Uses English sentence embedding only.
- Gap: Non‑English locales degrade quality.
- Fix plan:
  - Map device locale to supported embeddings; use heuristics fallback when embedding unavailable; keep performance in budget.

4) Subscription management UX (upgrade/downgrade/trials)
- Current state: Products list with Buy/Restore, pricing/period shown.
- Gap: No entitlement‑aware upgrade/downgrade affordances, trial or promo visibility, or group guidance.
- Fix plan:
  - Fetch subscription group and current entitlement; render upgrade/downgrade buttons and trial indicators; add pro‑ration note.

5) Weekly Insights depth
- Current state: Tag frequency, average mood, top summaries.
- Gap: No topic/keyphrase extraction or trend visualization.
- Fix plan:
  - Add keyphrase extraction from summaries; add simple week‑over‑week mood trend sparkline.

6) MetricKit observability
- Current state: Subscriber is a no‑op.
- Gap: Lacks diagnostic recording.
- Fix plan:
  - In `MXObserver`, log basic diagnostic summaries to `Logger.perf` with privacy annotations.

7) Spotlight coalescing
- Current state: Index updates per entry save/delete occur immediately.
- Gap: For batch edits, this can be chatty.
- Fix plan:
  - Add a simple coalescer/throttle to group updates on a short background window.


