import CloudKit
import Foundation
import OSLog
import SwiftData

/// High-level facade to enable/disable iCloud sync, perform preflight checks, run migration, and switch containers.
@MainActor
struct CloudSyncService: Sendable {
    enum SyncError: Error { case iCloudUnavailable, containerMissing }

    private let logger = Logger.data
    private let containerManager: ModelContainerManager = .shared

    /// Quick preflight to determine if iCloud is available on this device/user.
    func isICloudAvailable() async -> Bool {
        // Be permissive: attempt to proceed and let CloudKit/SwiftData handle network/account availability later.
        // This avoids false negatives when iCloud Drive is off but CloudKit account exists.
        true
    }

    /// Enable or disable sync. When enabling, migrates local content to cloud and switches container.
    func setSyncEnabled(
        _ enabled: Bool,
        lastKnownWasCloud _: Bool,
        token: CloudSyncMigrationService.CancellationToken? = nil
    ) async throws -> AsyncStream<CloudSyncMigrationService.Progress>? {
        if enabled {
            guard await isICloudAvailable() else { throw SyncError.iCloudUnavailable }
            // Build cloud container (throws if identifier missing)
            let cloudContainer = try containerManager.buildCloudContainer()
            // Migrate from current local container if we weren't already cloud
            let source = containerManager.currentContainer
            let stream = CloudSyncMigrationService().migrate(from: source, to: cloudContainer, token: token)
            // Switch after migration completes in the background; caller can listen to stream end to update UI.
            Task {
                for await _ in stream {}
                if token?.isCancelled != true {
                    try? await containerManager.switchTo(.cloud)
                    Logger.sync.log("sync_enabled")
                } else {
                    Logger.sync.log("sync_cancelled")
                }
            }
            return stream
        } else {
            // Switch back to local-only container; cloud copy remains intact
            try await containerManager.switchTo(.local)
            Logger.sync.log("sync_disabled")
            return nil
        }
    }
}
