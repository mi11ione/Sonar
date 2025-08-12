import AppIntents
import SwiftUI
import WidgetKit

struct RecentSummaryWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "app.sonar.recentsummary", provider: Provider()) { entry in
            RecentSummaryView(entry: entry)
        }
        .configurationDisplayName("recent_summary")
        .description("recent_summary_desc")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .accessoryRectangular, .accessoryInline])
    }

    struct Entry: TimelineEntry { let date: Date; let text: String; let mood: String?; let redacted: Bool }

    struct Provider: TimelineProvider {
        typealias Entry = RecentSummaryWidget.Entry
        private var defaults: UserDefaults { UserDefaults(suiteName: "group.com.mi11ion.Sonar") ?? .standard }
        func placeholder(in _: Context) -> Entry { Entry(date: .now, text: "No entries yet.", mood: nil, redacted: true) }
        func getSnapshot(in _: Context, completion: @escaping (Entry) -> Void) { completion(load()) }
        func getTimeline(in _: Context, completion: @escaping (Timeline<Entry>) -> Void) {
            completion(Timeline(entries: [load()], policy: .atEnd))
        }

        private func load() -> Entry {
            let text = (defaults.string(forKey: "widget.lastSummary") ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            let mood = defaults.string(forKey: "widget.lastMood")
            let ts = defaults.double(forKey: "widget.lastDate")
            let date = ts > 0 ? Date(timeIntervalSince1970: ts) : .now
            let redacted = !UserDefaults.standard.bool(forKey: "widgets.showSummaryOnLock")
            let fallback = text.isEmpty ? "No entries yet." : text
            return Entry(date: date, text: fallback, mood: mood, redacted: redacted)
        }
    }
}

private struct RecentSummaryView: View {
    @Environment(\.widgetFamily) private var family
    let entry: RecentSummaryWidget.Entry
    var body: some View {
        switch family {
        case .systemSmall:
            VStack(alignment: .leading) {
                if let mood = entry.mood, !mood.isEmpty { Text(mood).font(.caption).padding(4).background(.ultraThinMaterial, in: Capsule()) }
                Text("latest_summary").font(.caption)
                Image(systemName: "chevron.right")
            }
            .containerBackground(.fill.tertiary, for: .widget)
        case .systemMedium:
            VStack(alignment: .leading, spacing: 6) {
                Text("latest").font(.headline)
                Text(entry.redacted ? "redacted" : entry.text).lineLimit(2)
                if let mood = entry.mood, !mood.isEmpty { Text(mood).font(.caption).foregroundStyle(.secondary) }
                HStack { Spacer(); Link(destination: URL(string: "sonarai://last-entry")!) { Text("open_last_entry") } }
            }
            .padding()
            .containerBackground(.fill.tertiary, for: .widget)
        case .systemLarge:
            VStack(alignment: .leading, spacing: 8) {
                Text("latest").font(.title3.bold())
                Text(entry.redacted ? "redacted" : entry.text).lineLimit(4)
                if let mood = entry.mood, !mood.isEmpty { Text(mood).font(.caption) }
                HStack { Link(destination: URL(string: "sonarai://last-entry")!) { Label("open_last_entry", systemImage: "text.alignleft") }; Spacer(); Button(intent: StartRecordingIntent()) { Label("record", systemImage: "mic.fill") } }
            }
            .padding()
            .containerBackground(.fill.tertiary, for: .widget)
        case .accessoryRectangular:
            HStack(spacing: 6) {
                if let mood = entry.mood, !mood.isEmpty { Text(mood).font(.caption2) }
                Text(entry.redacted ? "latest_summary" : String(entry.text.prefix(30)))
            }
        case .accessoryInline:
            Text(entry.redacted ? "latest_summary" : "Latest: \(entry.text)")
        default:
            EmptyView()
        }
    }
}
