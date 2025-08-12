import AppIntents
import SwiftUI
import WidgetKit

struct DailyPromptWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "app.sonar.dailyprompt", provider: Provider()) { entry in
            DailyPromptView(entry: entry)
        }
        .configurationDisplayName("daily_prompt")
        .description("daily_prompt_desc")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .accessoryRectangular, .accessoryInline])
    }

    struct Entry: TimelineEntry { let date: Date; let prompt: String; let redacted: Bool }

    struct Provider: TimelineProvider {
        typealias Entry = DailyPromptWidget.Entry

        func placeholder(in _: Context) -> Entry { Entry(date: .now, prompt: "Take a minute to reflect.", redacted: true) }

        func getSnapshot(in _: Context, completion: @escaping (Entry) -> Void) {
            let d = groupDefaults()
            let seed = d.integer(forKey: "widget.promptSeed")
            let prompt = promptOfDay(locale: .current, seed: seed)
            let redacted = !d.bool(forKey: "widgets.showPromptsOnLock")
            completion(Entry(date: .now, prompt: prompt, redacted: redacted))
        }

        func getTimeline(in _: Context, completion: @escaping (Timeline<Entry>) -> Void) {
            let d = groupDefaults()
            let seed = d.integer(forKey: "widget.promptSeed")
            let prompt = promptOfDay(locale: .current, seed: seed)
            let redacted = !d.bool(forKey: "widgets.showPromptsOnLock")
            let now = Date()
            let next = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 1, to: now) ?? now)
            completion(Timeline(entries: [Entry(date: now, prompt: prompt, redacted: redacted)], policy: .after(next)))
        }

        // MARK: - Helpers

        private func groupDefaults() -> UserDefaults { UserDefaults(suiteName: "group.com.mi11ion.Sonar") ?? .standard }
        private func promptOfDay(locale: Locale, seed: Int) -> String {
            let list = prompts(locale: locale)
            if list.isEmpty { return "Take a minute to reflect." }
            let dayIndex = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
            return list[(dayIndex + seed) % list.count]
        }

        private func prompts(locale: Locale) -> [String] {
            if locale.language.languageCode?.identifier == "es" {
                return [
                    "¿Qué momento de hoy quieres recordar?",
                    "¿Cómo te sientes ahora mismo?",
                    "¿Qué te dio energía hoy? ¿Qué te la quitó?",
                    "Si pudieras dejar una nota a tu yo futuro, ¿qué diría?",
                    "¿Qué te sorprendió hoy?",
                ]
            }
            return [
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
        }
    }
}

private struct DailyPromptView: View {
    @Environment(\.widgetFamily) private var family
    let entry: DailyPromptWidget.Entry
    var body: some View {
        switch family {
        case .systemSmall:
            VStack(alignment: .leading) {
                Text("prompt_title").font(.headline)
                Button(intent: StartRecordingIntent()) { Text("record") }
            }
            .containerBackground(.fill.tertiary, for: .widget)
        case .systemMedium:
            VStack(alignment: .leading, spacing: 8) {
                Text(entry.redacted ? "prompt_available" : entry.prompt)
                    .font(.headline)
                    .lineLimit(3)
                    .foregroundStyle(.primary)
                HStack { Button(intent: StartRecordingIntent()) { Text("record") }; Button(intent: NextPromptIntent()) { Text("new_prompt") } }
            }
            .padding()
            .containerBackground(.fill.tertiary, for: .widget)
        case .systemLarge:
            VStack(alignment: .leading, spacing: 10) {
                Text(entry.redacted ? "prompt_available" : entry.prompt)
                    .font(.title3)
                    .lineLimit(5)
                Text("tap_to_capture").font(.footnote).foregroundStyle(.secondary)
                HStack { Button(intent: StartRecordingIntent()) { Label("record", systemImage: "mic.fill") }; Button(intent: NextPromptIntent()) { Text("new_prompt") } }
            }
            .padding()
            .containerBackground(.fill.tertiary, for: .widget)
        case .accessoryRectangular:
            HStack { Image(systemName: "lightbulb"); Text(entry.redacted ? "prompt_available" : String(entry.prompt.prefix(30))) }
        case .accessoryInline:
            Text(entry.redacted ? "prompt_available" : "Prompt: \(entry.prompt)")
        default:
            EmptyView()
        }
    }
}
