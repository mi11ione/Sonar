Sonar Monetization Strategy (MRR Maximization without Trials)

This document defines the pricing model, paywall strategy, conversion tactics, lifecycle incentives, and measurement plan to maximize MRR while preserving trust. There are no free trials. We include a one‑time Lifetime plan alongside monthly/annual subscriptions.

Objectives
- Maximize new subscriber conversion in first-session/first‑day window without harming long‑term LTV.
- Maintain healthy retention and reduce churn via value reinforcement and win‑back offers (no trials).
- Keep UX honest: no dark patterns, clear limits, frictionless restore/manage.
- Comply with Apple policies; use only StoreKit 2, OSLog for analytics, and on‑device processing.

Product Segmentation and Plans
Use the “Tracking/Data app” tiering baseline, tuned for Sonar’s value.

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
  - Max features remain subscription‑only to protect MRR while providing a high‑value escape hatch.

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
  - Plan cards for Pro, Premium, Max; “Most Popular” badge on Premium; “Best Value” badge on Annual.
  - Lifetime chip at the bottom: “Pay once, keep Premium forever.”
  - No trial messaging anywhere.

- Price Anchoring and Choice Architecture
  - Display Monthly vs Annual toggle defaulted to Annual on subsequent views (remember last choice).
  - Order plans: Max (right), Premium (center, highlighted), Pro (left).
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
- purchase_tap { plan: pro|premium|max|lifetime, term: monthly|annual|ot }
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
- StoreKit 2 only. One subscription group: Pro, Premium, Max; separate non‑consumable for Lifetime.
- No free trials. Use promotional offers (discounted pricing) for re‑engagement.
- Receipt verification via `StoreKit.Transaction`; restore supported from Settings.
- Universal links remain; privacy manifest present; no tracking/SDKs; on‑device processing preferred.

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

This plan aims for strong early conversion (first 5 hours), defensible recurring revenue via Annual/Premium emphasis, safety via Max, and a Lifetime outlet that minimizes MRR cannibalization while serving a distinct buyer preference.


