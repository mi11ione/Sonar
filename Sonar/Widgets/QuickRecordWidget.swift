import AppIntents
import SwiftUI
import WidgetKit

struct QuickRecordWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "app.sonar.quickrecord", provider: Provider()) { _ in
            QuickRecordWidgetView()
        }
        .configurationDisplayName("quick_record")
        .description("quick_record_desc")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .accessoryCircular, .accessoryRectangular, .accessoryInline])
    }

    private struct Provider: TimelineProvider {
        struct Entry: TimelineEntry { let date: Date }
        func placeholder(in _: Context) -> Entry { Entry(date: .now) }
        func getSnapshot(in _: Context, completion: @escaping (Entry) -> Void) { completion(Entry(date: .now)) }
        func getTimeline(in _: Context, completion: @escaping (Timeline<Entry>) -> Void) {
            completion(Timeline(entries: [Entry(date: .now)], policy: .never))
        }
    }
}

private struct QuickRecordWidgetView: View {
    @Environment(\.widgetFamily) private var family
    var body: some View {
        switch family {
        case .systemSmall:
            VStack(spacing: 8) {
                Image(systemName: "mic.fill").font(.title)
                Button(intent: StartRecordingIntent()) { Text("record") }
            }
            .containerBackground(.fill.tertiary, for: .widget)
        case .systemMedium:
            HStack {
                VStack(alignment: .leading) {
                    Text("app_name").font(.headline)
                    Text("on_device_private").font(.footnote).foregroundStyle(.secondary)
                }
                Spacer()
                Button(intent: StartRecordingIntent()) { Label("record", systemImage: "mic.fill") }
            }
            .padding(.horizontal)
            .containerBackground(.fill.tertiary, for: .widget)
        case .systemLarge:
            VStack(alignment: .leading, spacing: 8) {
                Text("record_title").font(.title2.bold())
                Text("record_sub").font(.footnote).foregroundStyle(.secondary)
                Button(intent: StartRecordingIntent()) { Label("record", systemImage: "mic.fill") }
                Divider()
                Link(destination: URL(string: "sonarai://search")!) { Label("open_journal", systemImage: "book.closed") }
            }
            .padding()
            .containerBackground(.fill.tertiary, for: .widget)
        case .accessoryCircular:
            ZStack { Circle().strokeBorder(); Button(intent: StartRecordingIntent()) { Image(systemName: "mic") } }
        case .accessoryRectangular:
            HStack { Image(systemName: "mic"); Button(intent: StartRecordingIntent()) { Text("record") } }
        case .accessoryInline:
            Button(intent: StartRecordingIntent()) { Text("record_inline") }
        default:
            EmptyView()
        }
    }
}
