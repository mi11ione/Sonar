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
internal import AVFAudio
import ActivityKit
import WidgetKit

@main
struct SonarApp: App {
    @State private var mxObserver = MXObserver()
    @State private var container: ModelContainer = {
        // Ensure Application Support directory exists before initializing the persistent store
        if let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            try? FileManager.default.createDirectory(at: appSupportURL, withIntermediateDirectories: true)
        }
        // Initialize via the container manager (local by default)
        let manager = ModelContainerManager.shared
        // Wire your iCloud container identifier here after capability is enabled.
        manager.cloudKitContainerIdentifier = Bundle.main.object(forInfoDictionaryKey: "ICloudContainerIdentifier") as? String
        return manager.currentContainer
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(container)
                .onAppear {
                    MXMetricManager.shared.add(mxObserver)
                    UNUserNotificationCenter.current().delegate = NotificationResponder.shared
                    Task { await NotificationResponder.shared.registerCategories() }
                    // Bridge any AppIntent flags from the widget extension's App Group defaults
                    bridgeGroupDeepLinksToStandard()
                    // Review: track active days for cadence heuristics
                    DefaultReviewRequestService().recordAppActive(now: .now)
                    // Safety: ensure audio session/engine are not left running from a prior crash
                    Task { await DefaultTranscriptionService().stop() }
                    try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
                    // Clean up any leftover temporary export files
                    cleanupTemporaryExports()
                }
                .task {
                    // Merge any deep-link flags written by the widget extension (App Group)
                    bridgeGroupDeepLinksToStandard()
                }
                .task {
                    // Schedule daily prompt notification content if enabled
                    let context = ModelContext(container)
                    let settings = (try? context.fetch(FetchDescriptor<UserSettings>()))?.first
                    if let hour = settings?.dailyReminderHour {
                        await NotificationResponder.shared.scheduleDailyPrompt(atHour: hour)
                    }
                }
                .task {
                    // Honor user's sync preference at launch
                    let manager = ModelContainerManager.shared
                    do {
                        let context = ModelContext(manager.currentContainer)
                        let settings = (try? context.fetch(FetchDescriptor<UserSettings>()))?.first
                        if settings?.iCloudSyncEnabled == true {
                            try await manager.switchTo(.cloud)
                            container = manager.currentContainer
                        }
                    } catch {
                        // If cloud container creation fails, stay on local and continue; avoid crash
                        Logger.sync.error("Container switch at launch failed: \(error.localizedDescription, privacy: .public)")
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: ModelContainerManager.didChangeNotification)) { _ in
                    container = ModelContainerManager.shared.currentContainer
                }
                .task {
                    // End any stale recording activities from prior runs to avoid dangling UI
                    for activity in Activity<RecordingActivityAttributes>.activities {
                        await activity.end(nil, dismissalPolicy: .default)
                    }
                }
                .task {
                    // Preload default prompt styles on first launch
                    let context = ModelContext(container)
                    let request = FetchDescriptor<PromptStyle>()
                    if let existing = try? context.fetch(request), existing.isEmpty {
                        context.insert(PromptStyle(displayName: String(localized: "style_concise"), maxSentences: 3, includeActionItems: false, toneHint: nil, isPremium: false))
                        context.insert(PromptStyle(displayName: String(localized: "style_reflective"), maxSentences: 4, includeActionItems: false, toneHint: String(localized: "tone_reflective_hint"), isPremium: false))
                        context.insert(PromptStyle(displayName: String(localized: "style_bulleted"), maxSentences: 5, includeActionItems: true, toneHint: String(localized: "tone_bulleted_hint"), isPremium: true))
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
                .task {
                    // Reload widgets on day rollover for Daily Prompt
                    await WidgetReloader.shared.reloadIfNewDay()
                }
                .task {
                    // Monitor churn heuristically: if previously subscribed and now not
                    let was = UserDefaults.standard.bool(forKey: "entitlement.wasSubscribed")
                    let isNow = await DefaultPurchasesService().isSubscriber()
                    if was, !isNow {
                        Logger.purchase.log("churn_detected reason=expired")
                        UserDefaults.standard.set(true, forKey: "promo.winback.eligible")
                    }
                    UserDefaults.standard.set(isNow, forKey: "entitlement.wasSubscribed")
                }
        }
    }
}

final class MXObserver: NSObject, MXMetricManagerSubscriber {
    func didReceive(_: [MXMetricPayload]) {}
    func didReceive(_: [MXDiagnosticPayload]) {}
}

private func cleanupTemporaryExports() {
    let fm = FileManager.default
    let tmp = fm.temporaryDirectory
    let candidates = ["Sonar-Export.json", "Sonar-Export.zip", "Sonar-Temp-Playback.caf"]
    for name in candidates {
        let url = tmp.appendingPathComponent(name)
        if fm.fileExists(atPath: url.path) { try? fm.removeItem(at: url) }
    }
}

/// Pulls deep-link flags written by the widget extension via App Group defaults into the main defaults,
/// then clears them in the group store to avoid repeated triggers.
private func bridgeGroupDeepLinksToStandard() {
    guard let d = UserDefaults(suiteName: "group.com.mi11ion.Sonar") else { return }
    let keys = [
        "deeplink.startRecording",
        "deeplink.stopNow",
        "deeplink.togglePause",
        "deeplink.showLastEntry",
        "deeplink.searchRequest",
        "deeplink.targetTab",
    ]
    for key in keys {
        let value = d.object(forKey: key)
        if let value {
            UserDefaults.standard.set(value, forKey: key)
            d.removeObject(forKey: key)
        }
    }
}

final class NotificationResponder: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationResponder()
    func registerCategories() async {
        let start = UNNotificationAction(identifier: "start.recording", title: String(localized: "start_recording"))
        let snooze = UNNotificationAction(identifier: "snooze.reminder", title: String(localized: "remind_in_1_hour"))
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

extension NotificationResponder {
    func scheduleDailyPrompt(atHour hour: Int) async {
        let center = UNUserNotificationCenter.current()
        // Remove existing to prevent duplicates
        center.removePendingNotificationRequests(withIdentifiers: ["daily.reminder"])

        let content = UNMutableNotificationContent()
        content.title = String(localized: "daily_reflection")
        // Add a localized, friendly prompt pulled from PromptsService via plain lookup here
        let prompt = DefaultPromptsService().todayPrompt(locale: .current)
        content.body = prompt
        content.categoryIdentifier = "daily.reminder.category"
        // Respect Focus/summary: keep alerts minimal; system handles Focus policies
        // We avoid critical alerts, no interruption-level override

        var date = DateComponents()
        date.hour = hour
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: "daily.reminder", content: content, trigger: trigger)
        do { try await center.add(request) } catch {}
    }
}
