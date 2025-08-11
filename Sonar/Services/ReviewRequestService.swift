import Foundation

enum ReviewEvent: Sendable {
    case entrySaved
}

protocol ReviewRequestService: Sendable {
    func recordAppActive(now: Date)
    func recordPaywallShown(now: Date)
    func record(event: ReviewEvent, now: Date)
    func shouldRequestReview(after event: ReviewEvent, now: Date) -> Bool
}

struct DefaultReviewRequestService: ReviewRequestService, Sendable {
    // UserDefaults keys
    private enum Key {
        static let firstLaunch = "rr.firstLaunch"
        static let lastActiveDay = "rr.lastActiveDay"
        static let activeDayCount = "rr.activeDayCount"
        static let entriesSaved = "rr.entriesSaved"
        static let lastPaywallShownAt = "rr.lastPaywallShownAt"
        static let lastPromptAt = "rr.lastPromptAt"
        static let promptedVersion = "rr.promptedVersion"
        static let promptCountAllTime = "rr.promptCountAllTime"
    }

    func recordAppActive(now: Date = .now) {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: Key.firstLaunch) == nil {
            defaults.set(now, forKey: Key.firstLaunch)
        }
        let dayToken = dayIdentifier(for: now)
        let lastDay = defaults.string(forKey: Key.lastActiveDay)
        if lastDay != dayToken {
            let current = defaults.integer(forKey: Key.activeDayCount)
            defaults.set(current + 1, forKey: Key.activeDayCount)
            defaults.set(dayToken, forKey: Key.lastActiveDay)
        }
    }

    func recordPaywallShown(now: Date = .now) {
        let defaults = UserDefaults.standard
        defaults.set(now, forKey: Key.lastPaywallShownAt)
    }

    func record(event: ReviewEvent, now _: Date = .now) {
        switch event {
        case .entrySaved:
            incrementCounter(Key.entriesSaved)
        }
    }

    func shouldRequestReview(after event: ReviewEvent, now: Date = .now) -> Bool {
        // Update counters for the event first
        record(event: event, now: now)

        let defaults = UserDefaults.standard

        // Ensure firstLaunch exists
        if defaults.object(forKey: Key.firstLaunch) == nil { defaults.set(now, forKey: Key.firstLaunch) }
        let firstLaunch = (defaults.object(forKey: Key.firstLaunch) as? Date) ?? now
        let hoursSinceFirstLaunch = now.timeIntervalSince(firstLaunch) / 3600.0

        let entries = defaults.integer(forKey: Key.entriesSaved)

        // Cooldowns: avoid spamming or colliding with paywall moments
        if let lastPrompt = defaults.object(forKey: Key.lastPromptAt) as? Date, now.timeIntervalSince(lastPrompt) < 60 * 60 * 24 * 60 {
            return false // 60 days cooldown
        }
        if let lastPaywall = defaults.object(forKey: Key.lastPaywallShownAt) as? Date, now.timeIntervalSince(lastPaywall) < 60 * 60 * 12 {
            return false // skip within 12h of paywall
        }

        // One prompt per app version
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        if let currentVersion, let promptedVersion = defaults.string(forKey: Key.promptedVersion), promptedVersion == currentVersion {
            return false
        }

        // Early window: Encourage reviews within first 5 hours if some engagement exists
        if hoursSinceFirstLaunch <= 5.0 {
            if entries >= 2 {
                defaults.set(now, forKey: Key.lastPromptAt)
                if let currentVersion { defaults.set(currentVersion, forKey: Key.promptedVersion) }
                incrementCounter(Key.promptCountAllTime)
                return true
            }
        }

        // Fallback milestones beyond the early window
        let milestoneHits: Set<Int> = [3, 7, 15, 30]
        if milestoneHits.contains(entries) {
            defaults.set(now, forKey: Key.lastPromptAt)
            if let currentVersion { defaults.set(currentVersion, forKey: Key.promptedVersion) }
            incrementCounter(Key.promptCountAllTime)
            return true
        }

        return false
    }

    // MARK: - Helpers

    private func incrementCounter(_ key: String) {
        let defaults = UserDefaults.standard
        let value = defaults.integer(forKey: key)
        defaults.set(value + 1, forKey: key)
    }

    private func dayIdentifier(for date: Date) -> String {
        let comps = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return String(format: "%04d-%02d-%02d", comps.year ?? 0, comps.month ?? 0, comps.day ?? 0)
    }
}
