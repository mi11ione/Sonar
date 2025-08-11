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
        if prompts.isEmpty { return "Take a minute to reflect on your day." }
        return prompts[dayIndex % prompts.count]
    }

    func randomPrompt(locale: Locale = .current) -> String {
        let prompts = promptsForLocale(locale)
        return prompts.randomElement() ?? "What's one thought on your mind right now?"
    }

    private func promptsForLocale(_ locale: Locale) -> [String] {
        // Basic English set; can be expanded per locale
        // Keep concise, encouraging tone
        let en: [String] = [
            "What's one moment from today you want to remember?",
            "How are you feeling right now?",
            "What energized you today? What drained you?",
            "If you could give your future self one note from today, what would it be?",
            "What surprised you today?",
            "What's one small win worth noting?",
            "Who or what are you grateful for right now?",
            "What's one thing you'd like to do differently tomorrow?",
            "What trend have you noticed in your mood this week?",
            "What matters most to you today, and why?",
        ]
        if locale.language.languageCode?.identifier == "es" {
            return [
                "¿Qué momento de hoy quieres recordar?",
                "¿Cómo te sientes ahora mismo?",
                "¿Qué te dio energía hoy? ¿Qué te la quitó?",
                "Si pudieras dejar una nota a tu yo futuro, ¿qué diría?",
                "¿Qué te sorprendió hoy?",
            ]
        }
        return en
    }
}
