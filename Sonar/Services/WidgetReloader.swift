import Foundation
import WidgetKit

/// Throttles widget timeline reloads to avoid energy impact.
///
/// WidgetCenter API reference: framework-sources/WidgetKit.md lines 3146-3148 and 3139-3143
actor WidgetReloader {
    static let shared = WidgetReloader()

    private var lastReloadAt: Date? = nil

    /// Reloads all widget timelines if a minimum interval has elapsed.
    func reloadAllIfNeeded(minInterval: TimeInterval = 60) async {
        let now = Date()
        if let last = lastReloadAt, now.timeIntervalSince(last) < minInterval { return }
        lastReloadAt = now
        WidgetCenter.shared.reloadAllTimelines()
    }

    /// Call on app launch or foreground to refresh date-sensitive widgets (e.g., Daily Prompt) when the day changed.
    func reloadIfNewDay() async {
        let defaults = UserDefaults.standard
        let key = "widget.lastDayToken"
        let token = dayToken(for: .now)
        let previous = defaults.string(forKey: key)
        if previous != token {
            defaults.set(token, forKey: key)
            WidgetCenter.shared.reloadAllTimelines()
            lastReloadAt = .now
        }
    }

    private func dayToken(for date: Date) -> String {
        let comps = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return String(format: "%04d-%02d-%02d", comps.year ?? 0, comps.month ?? 0, comps.day ?? 0)
    }
}


