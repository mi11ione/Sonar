//
//  ContentView.swift
//  Sonar
//
//  Created by mi11ion on 10/8/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("onboardingComplete") private var onboardingComplete: Bool = false
    @AppStorage("deeplink.startRecording") private var deepLinkStart: Bool = false
    @State private var selectedTab: Int = 0
    var body: some View {
        Group {
            if onboardingComplete {
                TabView(selection: $selectedTab) {
                    NavigationStack { RecordView() }
                        .tabItem { Label("Record", systemImage: "mic.fill") }
                        .tag(0)
                    NavigationStack { EntriesListView() }
                        .tabItem { Label("Journal", systemImage: "book.closed") }
                        .tag(1)
                    NavigationStack { SearchFilterView() }
                        .tabItem { Label("Search", systemImage: "magnifyingglass") }
                        .tag(2)
                    NavigationStack { SettingsView() }
                        .tabItem { Label("Settings", systemImage: "gear") }
                        .tag(3)
                }
            } else {
                OnboardingFlow()
            }
        }
        .onOpenURL { url in
            guard url.scheme == "sonarai" else { return }
            switch url.host {
            case "start-recording":
                selectedTab = 0
                deepLinkStart = true
            default:
                break
            }
        }
    }
}

#Preview {
    ContentView()
}
