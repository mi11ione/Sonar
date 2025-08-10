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
        }
    }
}
