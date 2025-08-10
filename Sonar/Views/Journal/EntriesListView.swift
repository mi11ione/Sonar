import SwiftData
import SwiftUI

struct EntriesListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.indexing) private var indexing
    @Query(sort: \JournalEntry.sortRank, order: .reverse) private var entries: [JournalEntry]
    @State private var selection: Set<UUID> = []

    var body: some View {
        let pinned = entries.filter(\.isPinned)
        let others = entries.filter { !$0.isPinned }

        List(selection: $selection) {
            if !pinned.isEmpty {
                Section("Pinned") {
                    ForEach(pinned, id: \.id) { entry in
                        row(entry)
                            .tag(entry.id)
                    }
                }
            }
            Section("Recent") {
                ForEach(others, id: \.id) { entry in
                    row(entry)
                        .tag(entry.id)
                }
                .onMove { source, destination in moveWithinOthers(others: others, source: source, destination: destination) }
            }
        }
        .navigationTitle("Journal")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) { EditButton() }
            ToolbarItem(placement: .topBarTrailing) {
                if !selection.isEmpty {
                    Button(role: .destructive) { deleteSelected() } label: { Label("Delete", systemImage: "trash") }
                }
            }
        }
        .overlay {
            if entries.isEmpty {
                ContentUnavailableView(
                    "No entries yet",
                    systemImage: "mic",
                    description: Text("Tap the mic to start your first journal.")
                )
            }
        }
        .sheet(isPresented: Binding(get: { shareText != nil }, set: { if !$0 { shareText = nil } })) {
            ShareContainerView(text: shareText ?? "")
        }
    }

    @State private var shareText: String? = nil

    @ViewBuilder private func row(_ entry: JournalEntry) -> some View {
        NavigationLink {
            EntryDetailView(entry: entry)
        } label: {
            VStack(alignment: .leading, spacing: 6) {
                Text(entry.summary ?? String(entry.transcript.prefix(80)))
                    .font(.headline)
                HStack(spacing: 12) {
                    if let label = entry.moodLabel {
                        MoodBadge(label: label, score: entry.moodScore ?? 0)
                    }
                    Text(entry.createdAt, style: .date)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .swipeActions(edge: .trailing) {
            Button {
                entry.isPinned.toggle()
                try? modelContext.save()
            } label: {
                Label(entry.isPinned ? "Unpin" : "Pin", systemImage: entry.isPinned ? "pin.slash" : "pin")
            }.tint(.orange)
            Button(role: .destructive) {
                let id = entry.id
                modelContext.delete(entry)
                try? modelContext.save()
                Task { await indexing.deleteIndex(for: id) }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            Button {
                shareText = entry.summary ?? entry.transcript
            } label: {
                Label("Share", systemImage: "square.and.arrow.up")
            }.tint(.blue)
        }
        .contextMenu {
            Button(entry.isPinned ? "Unpin" : "Pin") { entry.isPinned.toggle(); try? modelContext.save() }
            ShareLink(item: entry.summary ?? entry.transcript) { Label("Share", systemImage: "square.and.arrow.up") }
            Button(role: .destructive) {
                let id = entry.id
                modelContext.delete(entry)
                try? modelContext.save()
                Task { await indexing.deleteIndex(for: id) }
            } label: { Label("Delete", systemImage: "trash") }
        }
    }

    private func moveWithinOthers(others: [JournalEntry], source: IndexSet, destination: Int) {
        var mutable = others
        mutable.move(fromOffsets: source, toOffset: destination)
        for (index, entry) in mutable.enumerated() {
            entry.sortRank = Double(mutable.count - index)
        }
        try? modelContext.save()
    }

    private func deleteSelected() {
        let ids = selection
        for entry in entries where ids.contains(entry.id) {
            let id = entry.id
            modelContext.delete(entry)
            Task { await indexing.deleteIndex(for: id) }
        }
        try? modelContext.save()
        selection.removeAll()
    }
}

private struct ShareContainerView: View {
    let text: String
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                ShareLink(item: text) { Label("Share", systemImage: "square.and.arrow.up") }
                Spacer()
            }
            .padding()
            .navigationTitle("Share Entry")
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Done") { dismiss() } } }
        }
    }
}

#Preview {
    NavigationStack { EntriesListView() }
}
