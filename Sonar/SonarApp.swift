//
//  SonarApp.swift
//  Sonar
//
//  Created by mi11ion on 10/8/25.
//

import SwiftData
import SwiftUI

@main
struct SonarApp: App {
    private var container: ModelContainer = {
        let schema = Schema([
            JournalEntry.self,
            AudioAsset.self,
            Tag.self,
            PromptStyle.self,
            UserSettings.self,
            MemoryThread.self,
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try! ModelContainer(for: schema, configurations: [configuration])
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(container)
                .task {
                    // Preload default prompt styles on first launch
                    let context = ModelContext(container)
                    let request = FetchDescriptor<PromptStyle>()
                    if let existing = try? context.fetch(request), existing.isEmpty {
                        context.insert(PromptStyle(displayName: "Concise", maxSentences: 3, includeActionItems: false, toneHint: nil, isPremium: false))
                        context.insert(PromptStyle(displayName: "Reflective", maxSentences: 4, includeActionItems: false, toneHint: "gentle, reflective tone", isPremium: false))
                        context.insert(PromptStyle(displayName: "Bulleted", maxSentences: 5, includeActionItems: true, toneHint: "bullet points with short phrases", isPremium: true))
                        try? context.save()
                    }
                }
        }
    }
}
