//
//  ContentView.swift
//  Sonar
//
//  Created by mi11ion on 10/8/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
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
    }
}

#Preview {
    ContentView()
}
