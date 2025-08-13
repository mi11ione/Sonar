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
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    var body: some View {
        Group {
            if onboardingComplete {
                TabView(selection: $selectedTab) {
                    NavigationStack { RecordView() }
                        .tabItem { Label("record_tab", systemImage: "mic.fill") }
                        .tag(0)
                    journalTab
                        .tabItem { Label("journal_tab", systemImage: "book.closed") }
                        .tag(1)
                    NavigationStack { SettingsView() }
                        .tabItem { Label("settings_tab", systemImage: "gear") }
                        .tag(2)
                }
                // Invisible keyboard shortcuts to switch tabs on hardware keyboards (iPad)
                .overlay(
                    HStack { EmptyView() }
                        .allowsHitTesting(false)
                        .opacity(0.001)
                        .background(Color.clear)
                        .overlay(
                            HStack(spacing: 0) {
                                Button("") { selectedTab = 0 }.keyboardShortcut("r", modifiers: [.command]).opacity(0.001)
                                Button("") { selectedTab = 1 }.keyboardShortcut("f", modifiers: [.command]).opacity(0.001)
                                Button("") { selectedTab = 2 }.keyboardShortcut(",", modifiers: [.command]).opacity(0.001)
                            }
                        )
                )
            } else {
                OnboardingFlow()
            }
        }
        .vibeBackground()
        .onOpenURL { url in
            guard url.scheme == "sonarai" else { return }
            switch url.host {
            case "start-recording":
                selectedTab = 0
                deepLinkStart = true
                if let comps = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                    for item in comps.queryItems ?? [] {
                        if item.name == "stop", item.value == "1" {
                            UserDefaults.standard.set(true, forKey: "deeplink.stopNow")
                        }
                        if item.name == "pause", item.value == "1" {
                            UserDefaults.standard.set(true, forKey: "deeplink.togglePause")
                        }
                    }
                }
            case "search":
                selectedTab = 1
                if let comps = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                    var payload: [String: Any] = [:]
                    for item in comps.queryItems ?? [] {
                        switch item.name {
                        case "query": payload["query"] = item.value
                        case "tag": payload["tag"] = item.value
                        case "mood": payload["mood"] = item.value
                        default: break
                        }
                    }
                    UserDefaults.standard.set(payload, forKey: "deeplink.searchURL")
                }
            case "summarize-last":
                selectedTab = 1
            case "last-entry":
                selectedTab = 1
            default:
                break
            }
        }
        .task {
            // Handle tab deep link requests set by App Intents
            let requestedTab = UserDefaults.standard.object(forKey: "deeplink.targetTab") as? Int
            if let requestedTab {
                selectedTab = requestedTab
                UserDefaults.standard.removeObject(forKey: "deeplink.targetTab")
            }
            if UserDefaults.standard.bool(forKey: "deeplink.showLastEntry") {
                // Future: present last entry detail; for now, ensure Journal tab is shown
                selectedTab = 1
                UserDefaults.standard.removeObject(forKey: "deeplink.showLastEntry")
            }
        }
    }

    @ViewBuilder private var journalTab: some View {
        if horizontalSizeClass == .regular {
            NavigationSplitView {
                EntriesListView()
            } detail: {
                ContentUnavailableView("select_an_entry", systemImage: "note.text")
            }
        } else {
            NavigationStack { EntriesListView() }
        }
    }
}

#Preview {
    ContentView()
}
