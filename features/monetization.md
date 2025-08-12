Sonar Monetization Strategy (Final, Ready for Release — No Trials)

This document defines the pricing model, paywall strategy, conversion tactics, lifecycle incentives, and measurement plan to maximize MRR while preserving trust. There are no free trials. We include a one‑time Lifetime plan alongside monthly/annual subscriptions.

Objectives
- Maximize new subscriber conversion in first-session/first‑day window without harming long‑term LTV.
- Maintain healthy retention and reduce churn via value reinforcement and win‑back offers (no trials).
- Keep UX honest: no dark patterns, clear limits, frictionless restore/manage.
- Comply with Apple policies; use only StoreKit 2, OSLog for analytics, and on‑device processing.

Product Segmentation and Plans
Use the “Tracking/Data app” baseline, tuned for Sonar’s value. No free trials. Lifetime is offered as a separate non‑consumable.

- Free: Try the core loop, feel the “aha” moment.
  - 3 saved entries total, then paywall gates saving.
  - Live transcription preview always visible; saving blocked after limit.
  - 7‑day history visibility (read‑only) for saved items (while under limit).
  - Basic summary style (Concise), no bulk export, no advanced insights.

- Pro — $3.99/mo or $24.99/yr (~48% off):
  - Up to 5 saved entries/day, 30‑day history.
  - All summary styles (Concise, Reflective, Bulleted without action items).
  - Mood score + label; lightweight search filters.

- Premium — $6.99/mo or $44.99/yr (~46% off):
  - Unlimited entries, full history.
  - All current and future prompt styles, bulk export, smart filters.
  - Weekly insights dashboard (themes, trend sparkline) updated automatically.

- Lifetime (One‑time, non‑consumable) — $79.99:
  - Unlocks Premium feature set forever on the purchasing Apple ID.
  - Family Sharing optional; recommended ON for goodwill (Apple allows for non‑consumables).

Notes
- Prices are US tiers; localize using Apple price tiers with psychological thresholds (x.99).
- Annual discount ~45–50% to anchor perceived savings.
- Lifetime should not be in the subscription group; it’s a separate non‑consumable product.

Paywall Strategy (No Trials)
Design goals: immediate clarity, strong value framing, effortless checkout, no traps.

- Placement and Timing
  - Show paywall after onboarding OR upon hitting the 3‑entry save gate.
  - Also surface a soft paywall from Settings (“Unlock unlimited”).
  - Never interrupt active recording; only after save/idle transitions.

- Content and Framing
  - Headline: “Unlock Sonar” with 2–3 crisp benefit bullets tied to emotion + outcomes.
  - Plan cards for Pro and Premium; “Most Popular” badge on Premium; “Best Value” badge on Annual.
  - Lifetime chip at the bottom: “Pay once, keep Premium forever.”
  - No trial messaging anywhere.

- Price Anchoring and Choice Architecture
  - Display Monthly vs Annual toggle; remember last choice. For returning visitors, default to Annual.
  - Order plans: Premium (center, highlighted), Pro (left).
  - Lifetime below the grid; always visible but secondary to subscriptions.

- Social Proof and Trust Elements
  - “Private, on‑device processing” trust badge.
  - Tiny, honest note: “Cancel anytime in Settings.”
  - Terms/Privacy links and Restore Purchases button visible.

- Friction and Exit
  - Visible Close button; respect the user. No fake countdowns or scarcity claims.
  - If user closes twice at gate, escalate value messaging with specific benefits (see Messaging below).

Messaging System (Value‑moment Copy that Converts)
Map benefit copy to the user’s context to raise motivation:

- After 1st save: “That felt good. Keep your momentum — unlock summaries that fit your style.”
- On hitting gate at 3rd save: “Keep unlimited entries, deeper insights, and search your history.”
- After first week with ≥3 entries/day: “You’re building a habit. Premium keeps everything organized and searchable forever.”
- For heavy writers (>10 min/session): “Long sessions deserve better summaries and themes. Premium highlights what matters.”
- For users revisiting old entries: “Find trends you can act on. Premium surfaces themes and mood changes over time.”

Early Conversion Funnel (First 5 Hours)
The majority of paying users convert early; optimize the Day‑0/Hour‑0 experience:

- Onboarding prime: clearly state the privacy promise and the top 3 benefits.
- Fast path to first save (<10 minutes) to create an emotional “win”.
- After the first save, subtly preview higher‑tier features (e.g., blurred advanced insights with “Unlock” CTA).
- Hit the hard gate at the 3rd save — the moment of maximum motivation — with a clean, honest paywall.

Incentives without Trials
- Annual Highlighting: default emphasis; show “Save ~46% vs monthly”.
- Founders Pricing Windows: time‑boxed copy for new releases (truthful, no false scarcity), e.g. “Launch pricing for a limited time.”
- Promotional Offers (StoreKit 2) for win‑back: 50% off 1 month or 3 months discounted for lapsed users (no trials).
- Lifetime: clear “one‑time” simplicity for users allergic to subscriptions — placed below the grid to keep MRR strong.

Churn Reduction and Win‑Back
- At risk signals (7 days no usage, or closing paywall repeatedly): show softer paywall with Annual value reinforcement and a smaller Pro option.
- For cancellations (via entitlement state change): email is optional; in‑app win‑back banner when returning: “Welcome back — pick up where you left off. Try Premium at 50% off for 1 month.”
- Limit promotional offer frequency; never stack discounts.

Lifecycle and Nudges
- Notifications: daily gentle prompt at chosen hour; tapping opens Record.
- Weekly Insights: value email not used; instead, an in‑app “This week’s highlights” upsell tile that previews Premium insights and invites upgrade.
- Ratings: in‑app review request within first 5 hours if user saves ≥2 entries; 60‑day cooldown; skip within 12h after paywall.

Measurement (OSLog, Privacy‑friendly)
No third‑party analytics. Emit OSLog events with categories and parameters to compute conversion and retention in Instruments/Console.

- paywall_shown { source: onboarding|gate|settings, planDefault: annual|monthly }
- purchase_tap { plan: pro|premium|lifetime, term: monthly|annual|ot }
- purchase_success { plan, term, priceTier }
- restore_tap / restore_success
- churn_detected { reason: expired|revoked|downgraded }
- insights_viewed, export_used, search_used (feature adoption correlates with retention)

Track Funnels and KPIs
- View→Purchase tap→Purchase success by entry count at gate.
- Annual vs Monthly take‑rate, plan mix, and Lifetime cannibalization.
- 7/30/90‑day retention by plan.

A/B Test Matrix (Config‑gated, serverless)
Keep A/B toggles local, deterministic by device hash.

- Gate Strictness: 3 entries (control) vs 5 entries (variant) before paywall.
- Annual Emphasis: on by default vs off.
- Lifetime Visibility: below grid (control) vs peer tile with subdued highlight (variant).
- Copy Variants: “Unlimited entries” vs “Journal without limits”.

Success Metric: paywall→purchase conversion and 30‑day retention; ensure no regression in Day‑0 conversion.

Compliance and Implementation Notes
- StoreKit 2 only. One subscription group: Pro and Premium. Separate non‑consumable for Lifetime.
- No free trials. Use promotional offers (discounted pricing) for re‑engagement.
- Receipt verification via `StoreKit.Transaction`; restore supported from Settings.
- Universal links remain; privacy manifest present; no tracking/SDKs; on‑device processing preferred.

StoreKit Product Mapping (App Store Connect)
- Subscription Group ID: sonar.subscriptions
- Products
  - sonar.pro.monthly — Auto‑renewable, 1 month
  - sonar.premium.monthly — Auto‑renewable, 1 month
  - sonar.premium.annual — Auto‑renewable, 1 year
  - sonar.lifetime — Non‑consumable (Premium entitlement forever)
- Entitlements
  - Group: upgrade/downgrade paths enabled between Pro and Premium.
  - Lifetime is independent (not in the group). In app logic, treat Lifetime as Premium entitlement.
- Pricing
  - Use Apple price tiers; set introductory offers to None (no trials). Configure promotional offers only for win‑back (discounted pricing).
  - Enable Family Sharing for the Lifetime product if desired.

Entitlements Matrix (Summary)
- Free: 3 total saves; basic summary; 7‑day history; no export; limited filters.
- Pro: 5 saves/day; 30‑day history; all summary styles; mood label; basic filters.
- Premium: Unlimited saves; full history; all styles; export; smart filters; weekly insights.
- Lifetime: Same as Premium, perpetual.

Feature Gating Map (Complete App)
- Capture & Save
  - Free: Save up to 3 entries total; after that, hard gate on save (paywall). Live transcript preview still visible.
  - Pro: Save up to 5 entries/day; soft gate at 5 with upsell to Premium for unlimited.
  - Premium/Lifetime: Unlimited saves.

- Summarization & Styles
  - Free: “Concise” only, capped to 3 sentences.
  - Pro: All styles (Concise, Reflective, Bulleted without action items); 3–5 sentences max.
  - Premium/Lifetime: All styles including Bulleted with action items; up to 7 sentences; tone hints honored.

- Insights
  - Free: No weekly insights. Show preview tile with blur and CTA.
  - Pro: Basic weekly highlights (top themes list only); mood sparkline locked (blur + CTA).
  - Premium/Lifetime: Full weekly insights: top themes, mood trend sparkline, highlight summaries.

- Search & Filters
  - Free: Full‑text search across existing entries; basic filters (Today, 7 days; mood bins).
  - Pro: Adds tag filter and date ranges up to 30 days.
  - Premium/Lifetime: All filters (tags multi‑select, mood bins, flexible date ranges, sort by relevance/time).

- Export & Sharing
  - Free: Share single entry as text only.
  - Pro: Share single entry as text or audio (if recorded); no bulk export.
  - Premium/Lifetime: Bulk export (JSON) of selected entries with audio; optional password protection when implemented.

- Tags & Threads
  - Free: View tags/threads; assign up to 3 tags per entry; create up to 5 tags total.
  - Pro: Unlimited tags/threads; quick chips editing.
  - Premium/Lifetime: Same as Pro, plus per‑thread highlights in Insights (when implemented).

- Text‑to‑Speech (TTS)
  - Free: System default voice; playback in Entry Detail.
  - Pro: Choose voice and rate.
  - Premium/Lifetime: Voice, rate, and pitch; queued reading for multiple entries.

- Widgets & App Intents
  - Free: Quick Record widget; Start Recording, Summarize Last Entry intents.
  - Pro: Daily Prompt widget; Search Entries intent with basic parameters.
  - Premium/Lifetime: Recent Summary widget (privacy safe), advanced Search parameters.

- Settings & Privacy
  - Free: Basic settings; restore purchases.
  - Pro: Default summary style selector; notification preferences.
  - Premium/Lifetime: Export data; advanced preferences (e.g., encryption toggle when available).

Gating Triggers by View
- RecordView
  - On save: enforce plan save limits; show paywall when exceeding.
  - After first save: show soft upsell for styles (if user isn’t entitled).

- EntryDetailView
  - TTS controls beyond default → upsell based on plan.
  - Export button: upsell if plan lacks audio export or bulk export.

- InsightsView
  - Free/Pro: show blurred sections with “Unlock Premium” CTA for locked cards.
  - Premium/Lifetime: fully interactive insights.

- SearchFilterView
  - Show all filter affordances; lock Premium‑only ones with badges and inline CTA.

Paywall Moments (Contextual)
- Hard gate: After Free’s 3rd save; after Pro’s 5th save of the day.
- Feature gate: On locked actions (export/bulk, insights cards, advanced filters, TTS advanced controls).
- Settings gate: On export data, advanced preferences.

UX Patterns for Gates
- Blurred previews with inline “Unlock” for non‑destructive features (insights, filters).
- Action interstitial for destructive or time‑critical actions (exceeding save limits, bulk export).
- Always provide a dismiss path; never interrupt in‑progress recording.

Rollout Plan
1) Phase 1 — Pricing & Paywall
   - Ship Pro/Premium monthly + annual; Lifetime (Premium scope). No trials.
   - Gate after 3 saves; soft paywall from Settings.
   - Emit OSLog events; sanity‑check funnel in TestFlight.

2) Phase 2 — Insights‑led Upsell
   - Add upsell tiles in Insights and Entry Detail with blurred previews.
   - Add win‑back promotional offers for lapsed subscribers.

3) Phase 3 — Optimize
   - Run gate/annual emphasis/lifetime visibility experiments.
   - Tune price tiers per region if needed (respect psychological thresholds).

Copy Snippets (Reusable)
- Headline: “Unlock Sonar”
- Subhead: “Unlimited entries, deeper insights, and search that remembers.”
- Premium CTA: “Go Premium — Save ~46% with annual”
- Lifetime CTA: “Pay once — keep Premium forever”
- Trust: “Private. On‑device processing.”

This plan aims for strong early conversion (first 5 hours), defensible recurring revenue via Annual/Premium emphasis, and a Lifetime outlet that minimizes MRR cannibalization while serving a distinct buyer preference.

Final QA Checklist (Monetization‑only, end of project)
- Paywall shows after onboarding or at 3rd save; does not interrupt live recording.
- Product list loads reliably on Wi‑Fi and cellular; handles empty/error states.
- Purchase flows: Pro monthly/annual, Premium monthly/annual, Lifetime — all succeed; price displays correct locale/tier.
- Upgrade/downgrade: Pro→Premium and vice‑versa reflected via subscription status view.
- Lifetime purchase grants Premium entitlements; remains even if subscription group expires.
- Restore Purchases works after reinstall; Lifetime restored correctly.
- Promotional offers only for win‑back (no trials); signature handling tested.
- Entitlements respected across app (unlimited saves, insights, export, filters).
- Legal links present; Family Sharing note (Lifetime) confirmed if enabled.
- OSLog events emitted for paywall, purchase taps/success, restore, churn; verified in Console.


