//
//  SonarApp.swift
//  Sonar
//
//  Created by mi11ion on 10/8/25.
//

import MetricKit
import OSLog
import SwiftData
import SwiftUI
import UserNotifications

@main
struct SonarApp: App {
    @State private var mxObserver = MXObserver()
    private var container: ModelContainer = {
        // Ensure Application Support directory exists before initializing the persistent store
        if let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            try? FileManager.default.createDirectory(at: appSupportURL, withIntermediateDirectories: true)
        }
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
                .onAppear {
                    MXMetricManager.shared.add(mxObserver)
                    UNUserNotificationCenter.current().delegate = NotificationResponder.shared
                    Task { await NotificationResponder.shared.registerCategories() }
                }
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

                    // Ensure a single UserSettings row exists
                    let settingsRequest = FetchDescriptor<UserSettings>()
                    let settings = (try? context.fetch(settingsRequest)) ?? []
                    if settings.isEmpty {
                        context.insert(UserSettings())
                        try? context.save()
                    }
                }
        }
    }
}

final class MXObserver: NSObject, MXMetricManagerSubscriber {
    func didReceive(_: [MXMetricPayload]) {}
    func didReceive(_: [MXDiagnosticPayload]) {}
}

final class NotificationResponder: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationResponder()
    func registerCategories() async {
        let start = UNNotificationAction(identifier: "start.recording", title: "Start Recording")
        let snooze = UNNotificationAction(identifier: "snooze.reminder", title: "Remind me in 1 hour")
        let category = UNNotificationCategory(identifier: "daily.reminder.category", actions: [start, snooze], intentIdentifiers: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }

    func userNotificationCenter(_: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        // Default tap on our daily reminder should open into Record and start
        if response.notification.request.identifier == "daily.reminder" || response.notification.request.content.categoryIdentifier == "daily.reminder.category" {
            switch response.actionIdentifier {
            case "start.recording":
                UserDefaults.standard.set(true, forKey: "deeplink.startRecording")
            case "snooze.reminder":
                let content = response.notification.request.content.mutableCopy() as! UNMutableNotificationContent
                let next = Calendar.current.date(byAdding: .hour, value: 1, to: .now)!
                let components = Calendar.current.dateComponents([.hour, .minute], from: next)
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                let req = UNNotificationRequest(identifier: "daily.reminder.snoozed", content: content, trigger: trigger)
                try? await UNUserNotificationCenter.current().add(req)
            default:
                UserDefaults.standard.set(true, forKey: "deeplink.startRecording")
            }
            UserDefaults.standard.set(true, forKey: "deeplink.startRecording")
        }
    }
}
