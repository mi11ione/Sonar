import CloudKit
import OSLog
import SwiftData
import SwiftUI

/// Controls creation and switching of SwiftData containers for local-only and CloudKit-backed storage.
/// - Local container includes all models, including `AudioAsset`.
/// - Cloud container excludes `AudioAsset` to avoid syncing large blobs per v1 scope.
@MainActor
final class ModelContainerManager: @unchecked Sendable {
    enum StorageMode: Equatable { case local, cloud }

    static let shared = ModelContainerManager()
    static let didChangeNotification = Notification.Name("ModelContainerDidChange")

    /// The current container used by the app UI.
    private(set) var currentContainer: ModelContainer

    /// CloudKit container identifier. Fill this with your iCloud container once capability is enabled.
    /// Example: "iCloud.com.example.sonar"
    var cloudKitContainerIdentifier: String?

    /// Build-time default is local-only to ensure the app runs without capabilities.
    private init() {
        currentContainer = Self.makeLocalContainer()
    }

    // MARK: - Builders

    private static func makeLocalContainer() -> ModelContainer {
        // Full local schema including audio files
        let localSchema = Schema([
            JournalEntry.self,
            AudioAsset.self,
            Tag.self,
            PromptStyle.self,
            UserSettings.self,
            MemoryThread.self,
        ])
        // 1) Try default on-disk store
        do {
            let cfg = ModelConfiguration(
                nil,
                schema: localSchema,
                isStoredInMemoryOnly: false,
                allowsSave: true,
                groupContainer: .automatic,
                cloudKitDatabase: .none
            )
            return try ModelContainer(for: localSchema, configurations: [cfg])
        } catch {
            Logger.sync.error("Local container default store failed: \(error.localizedDescription, privacy: .public). Trying explicit URL store…")
        }
        // 2) Try explicit store URL under Application Support
        do {
            let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            let storeDir = appSupport.appendingPathComponent("SwiftDataStore", isDirectory: true)
            try? FileManager.default.createDirectory(at: storeDir, withIntermediateDirectories: true)
            let storeURL = storeDir.appendingPathComponent("Local.store")
            let cfg = ModelConfiguration(
                nil,
                schema: localSchema,
                url: storeURL,
                allowsSave: true,
                cloudKitDatabase: .none
            )
            return try ModelContainer(for: localSchema, configurations: [cfg])
        } catch {
            Logger.sync.error("Local container explicit URL failed: \(error.localizedDescription, privacy: .public). Falling back to in-memory store.")
        }
        // 3) Last resort: in-memory (keeps app running)
        do {
            let memCfg = ModelConfiguration(
                nil,
                schema: localSchema,
                isStoredInMemoryOnly: true,
                allowsSave: true,
                groupContainer: .automatic,
                cloudKitDatabase: .none
            )
            return try ModelContainer(for: localSchema, configurations: [memCfg])
        } catch {
            // As a final fallback, crash with clear diagnostics instead of a force-unwrap crash
            fatalError("SwiftData failed to create even an in-memory container: \(error.localizedDescription)")
        }
    }

    func buildCloudContainer() throws -> ModelContainer {
        // Cloud schema excludes AudioAsset per v1 scope (avoid syncing large blobs)
        let cloudSchema = Schema([
            JournalEntry.self,
            Tag.self,
            PromptStyle.self,
            UserSettings.self,
            MemoryThread.self,
        ])
        // Use CloudKit private database linked to the app's container.
        // References:
        //  - ModelConfiguration has a cloudKitDatabase parameter and CloudKitDatabase.private(_:) factory
        //    1011:1065:framework-sources/SwiftData.md
        // First, try with explicit identifier if provided; on failure, fall back to automatic discovery
        if let id = cloudKitContainerIdentifier, !id.isEmpty {
            do {
                let cfg = ModelConfiguration(
                    nil,
                    schema: cloudSchema,
                    isStoredInMemoryOnly: false,
                    allowsSave: true,
                    groupContainer: .automatic,
                    cloudKitDatabase: .private(id)
                )
                return try ModelContainer(for: cloudSchema, configurations: [cfg])
            } catch {
                Logger.sync.error("Failed to create cloud container with id \(id, privacy: .public): \(error.localizedDescription, privacy: .public). Falling back to automatic container.")
            }
        }
        do {
            let autoCfg = ModelConfiguration(
                nil,
                schema: cloudSchema,
                isStoredInMemoryOnly: false,
                allowsSave: true,
                groupContainer: .automatic,
                cloudKitDatabase: .automatic
            )
            return try ModelContainer(for: cloudSchema, configurations: [autoCfg])
        } catch {
            Logger.sync.error("Cloud container automatic failed: \(error.localizedDescription, privacy: .public). Falling back to local container.")
            return Self.makeLocalContainer()
        }
    }

    // MARK: - Switching

    /// Switch the app's active container. If switching to cloud for the first time, caller should migrate data beforehand.
    func switchTo(_ mode: StorageMode) async throws {
        switch mode {
        case .local:
            currentContainer = Self.makeLocalContainer()
        case .cloud:
            currentContainer = try buildCloudContainer()
        }
        NotificationCenter.default.post(name: Self.didChangeNotification, object: nil)
    }
}
