import Foundation

protocol PromptsService: Sendable {
    func todayPrompt(locale: Locale) -> String
    func randomPrompt(locale: Locale) -> String
}

struct DefaultPromptsService: PromptsService, Sendable {
    func todayPrompt(locale: Locale = .current) -> String {
        let prompts = promptsForLocale(locale)
        // Deterministic by day
        let dayIndex = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        if prompts.isEmpty { return String(localized: "prompt_placeholder_reflect") }
        return prompts[dayIndex % prompts.count]
    }

    func randomPrompt(locale: Locale = .current) -> String {
        let prompts = promptsForLocale(locale)
        return prompts.randomElement() ?? String(localized: "prompt_bank_2")
    }

    private func promptsForLocale(_: Locale) -> [String] {
        // Basic set via localization keys; translations handled in xcstrings
        let keys = [
            "prompt_bank_1",
            "prompt_bank_2",
            "prompt_bank_3",
            "prompt_bank_4",
            "prompt_bank_5",
            "prompt_bank_6",
            "prompt_bank_7",
            "prompt_bank_8",
            "prompt_bank_9",
            "prompt_bank_10",
        ]
        return keys.map { NSLocalizedString($0, comment: "") }
    }
}
