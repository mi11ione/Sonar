import AppIntents

struct NextPromptIntent: AppIntent {
    static var title: LocalizedStringResource = "new_prompt"
    static var description = IntentDescription("intent_new_prompt_desc")
    static var openAppWhenRun: Bool = false

    func perform() async throws -> some IntentResult {
        let d = UserDefaults(suiteName: "group.com.mi11ion.Sonar") ?? .standard
        let seed = d.integer(forKey: "widget.promptSeed")
        d.set(seed + 1, forKey: "widget.promptSeed")
        return .result()
    }
}
