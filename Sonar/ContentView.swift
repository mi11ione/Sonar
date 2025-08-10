//
//  ContentView.swift
//  Sonar
//
//  Created by mi11ion on 10/8/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("onboardingComplete") private var onboardingComplete: Bool = false
    var body: some View {
        Group {
            if onboardingComplete {
                TabView {
                    NavigationStack { RecordView() }
                        .tabItem { Label("Record", systemImage: "mic.fill") }
                    NavigationStack { EntriesListView() }
                        .tabItem { Label("Journal", systemImage: "book.closed") }
                    NavigationStack { SearchFilterView() }
                        .tabItem { Label("Search", systemImage: "magnifyingglass") }
                    NavigationStack { SettingsView() }
                        .tabItem { Label("Settings", systemImage: "gear") }
                }
            } else {
                OnboardingFlow()
            }
        }
    }
}

#Preview {
    ContentView()
}
