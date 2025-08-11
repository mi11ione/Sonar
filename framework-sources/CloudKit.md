import CloudKit.CKAcceptSharesOperation
import CloudKit.CKAllowedSharingOptions
import CloudKit.CKAsset
import CloudKit.CKContainer
import CloudKit.CKDatabase
import CloudKit.CKDatabaseOperation
import CloudKit.CKDefines
import CloudKit.CKDiscoverAllUserIdentitiesOperation
import CloudKit.CKDiscoverUserIdentitiesOperation
import CloudKit.CKError
import CloudKit.CKFetchDatabaseChangesOperation
import CloudKit.CKFetchNotificationChangesOperation
import CloudKit.CKFetchRecordChangesOperation
import CloudKit.CKFetchRecordZoneChangesOperation
import CloudKit.CKFetchRecordZonesOperation
import CloudKit.CKFetchRecordsOperation
import CloudKit.CKFetchShareMetadataOperation
import CloudKit.CKFetchShareParticipantsOperation
import CloudKit.CKFetchSubscriptionsOperation
import CloudKit.CKFetchWebAuthTokenOperation
import CloudKit.CKLocationSortDescriptor
import CloudKit.CKMarkNotificationsReadOperation
import CloudKit.CKModifyBadgeOperation
import CloudKit.CKModifyRecordZonesOperation
import CloudKit.CKModifyRecordsOperation
import CloudKit.CKModifySubscriptionsOperation
import CloudKit.CKNotification
import CloudKit.CKOperation
import CloudKit.CKOperationGroup
import CloudKit.CKQuery
import CloudKit.CKQueryOperation
import CloudKit.CKRecord
import CloudKit.CKRecordID
import CloudKit.CKRecordZone
import CloudKit.CKRecordZoneID
import CloudKit.CKReference
import CloudKit.CKServerChangeToken
import CloudKit.CKShare
import CloudKit.CKShareAccessRequester
import CloudKit.CKShareBlockedIdentity
import CloudKit.CKShareMetadata
import CloudKit.CKShareParticipant
import CloudKit.CKShareRequestAccessOperation
import CloudKit.CKSubscription
import CloudKit.CKSyncEngine
import CloudKit.CKSyncEngineConfiguration
import CloudKit.CKSyncEngineEvent
import CloudKit.CKSyncEngineRecordZoneChangeBatch
import CloudKit.CKSyncEngineState
import CloudKit.CKSystemSharingUIObserver
import CloudKit.CKUserIdentity
import CloudKit.CKUserIdentityLookupInfo
import CloudKit.NSItemProvider_CKSharingSupport
import CoreTransferable
import Foundation

/// Deprecation of transitional names
@available(swift 4.2)
@available(macOS, deprecated, introduced: 10.10, message: "renamed to CKContainer.ApplicationPermissionBlock")
@available(macCatalyst, deprecated, introduced: 13.1, message: "renamed to CKContainer.ApplicationPermissionBlock")
@available(iOS, deprecated, introduced: 8.0, message: "renamed to CKContainer.ApplicationPermissionBlock")
@available(tvOS, deprecated, introduced: 9.0, message: "renamed to CKContainer.ApplicationPermissionBlock")
@available(watchOS, deprecated, introduced: 3.0, message: "renamed to CKContainer.ApplicationPermissionBlock")
@available(visionOS, deprecated, message: "renamed to CKContainer.ApplicationPermissionBlock")
public typealias CKContainer_Application_PermissionBlock = CKContainer.ApplicationPermissionBlock

/// Deprecation of transitional names
@available(swift 4.2)
@available(macOS, deprecated, introduced: 10.10, message: "renamed to CKContainer.ApplicationPermissionStatus")
@available(macCatalyst, deprecated, introduced: 13.1, message: "renamed to CKContainer.ApplicationPermissionStatus")
@available(iOS, deprecated, introduced: 8.0, message: "renamed to CKContainer.ApplicationPermissionStatus")
@available(tvOS, deprecated, introduced: 9.0, message: "renamed to CKContainer.ApplicationPermissionStatus")
@available(watchOS, deprecated, introduced: 3.0, message: "renamed to CKContainer.ApplicationPermissionStatus")
@available(visionOS, deprecated, message: "renamed to CKContainer.ApplicationPermissionStatus")
public typealias CKContainer_Application_PermissionStatus = CKContainer.ApplicationPermissionStatus

/// Deprecation of transitional names
@available(swift 4.2)
@available(macOS, deprecated, introduced: 10.10, message: "renamed to CKContainer.ApplicationPermissions")
@available(macCatalyst, deprecated, introduced: 13.1, message: "renamed to CKContainer.ApplicationPermissions")
@available(iOS, deprecated, introduced: 8.0, message: "renamed to CKContainer.ApplicationPermissions")
@available(tvOS, deprecated, introduced: 9.0, message: "renamed to CKContainer.ApplicationPermissions")
@available(watchOS, deprecated, introduced: 3.0, message: "renamed to CKContainer.ApplicationPermissions")
@available(visionOS, deprecated, message: "renamed to CKContainer.ApplicationPermissions")
public typealias CKContainer_Application_Permissions = CKContainer.ApplicationPermissions

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
public struct CKRecordKeyValueIterator : IteratorProtocol {

    /// Advances to the next element and returns it, or `nil` if no next element
    /// exists.
    ///
    /// Repeatedly calling this method returns, in order, all the elements of the
    /// underlying sequence. As soon as the sequence has run out of elements, all
    /// subsequent calls return `nil`.
    ///
    /// You must not call this method if any other copy of this iterator has been
    /// advanced with a call to its `next()` method.
    ///
    /// The following example shows how an iterator can be used explicitly to
    /// emulate a `for`-`in` loop. First, retrieve a sequence's iterator, and
    /// then call the iterator's `next()` method until it returns `nil`.
    ///
    ///     let numbers = [2, 3, 5, 7]
    ///     var numbersIterator = numbers.makeIterator()
    ///
    ///     while let num = numbersIterator.next() {
    ///         print(num)
    ///     }
    ///     // Prints "2"
    ///     // Prints "3"
    ///     // Prints "5"
    ///     // Prints "7"
    ///
    /// - Returns: The next element in the underlying sequence, if a next element
    ///   exists; otherwise, `nil`.
    public mutating func next() -> (CKRecord.FieldKey, any CKRecordValueProtocol)?

    /// The type of element traversed by the iterator.
    @available(iOS 8.0, tvOS 9.0, watchOS 3.0, macOS 10.10, macCatalyst 13.1, *)
    public typealias Element = (CKRecord.FieldKey, any CKRecordValueProtocol)
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
public typealias CKRecordValue = __CKRecordObjCValue

/// Anything that can be a record value in Swift.
@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
public protocol CKRecordValueProtocol {
}

/// Deprecation of transitional names
@available(swift 4.2)
@available(macOS, deprecated, introduced: 10.10, message: "renamed to CKRecord.ReferenceAction")
@available(macCatalyst, deprecated, introduced: 13.1, message: "renamed to CKRecord.ReferenceAction")
@available(iOS, deprecated, introduced: 8.0, message: "renamed to CKRecord.ReferenceAction")
@available(tvOS, deprecated, introduced: 9.0, message: "renamed to CKRecord.ReferenceAction")
@available(watchOS, deprecated, introduced: 3.0, message: "renamed to CKRecord.ReferenceAction")
@available(visionOS, deprecated, message: "renamed to CKRecord.ReferenceAction")
public typealias CKRecord_Reference_Action = CKRecord.ReferenceAction

/// A transfer representation for types that support sharing via CloudKit
///
///     struct List: Transferable {
///
///         var existingShare: CKShare?
///
///         static var transferRepresentation: some TransferRepresentation {
///             CKShareTransferRepresentation { list in
///                 let container: CKContainer
///
///                 if let share = try list.existingShare {
///                     return .existing(share, container: container)
///                 } else {
///                     return .prepareShare(container: container) {
///                     // Save the CKShare to the server and return it...
///                 }
///             }
///         }
///     }
///
/// Use this transfer representation if your model object can be shared with others
/// by creating or modifying a CKShare.
@available(macOS 13.0, iOS 16.0, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
public struct CKShareTransferRepresentation<Item> : TransferRepresentation where Item : Transferable {

    /// Creates a representation that allows transporting an item as a CKShare
    /// - parameter exporter: A closure that provide an ExportedShare representation of the given item
    public init(exporter: @escaping @Sendable (Item) throws -> CKShareTransferRepresentation<Item>.ExportedShare)

    /// A builder expression that describes the process of importing and exporting an item.
    ///
    /// Combine multiple existing transfer representations
    /// to compose a single transfer representation that describes
    /// how to transfer an item in multiple scenarios.
    ///
    ///     struct CombinedRepresentation: TransferRepresentation {
    ///        var body: some TransferRepresentation {
    ///            DataRepresentation(...)
    ///            FileRepresentation(...)
    ///        }
    ///     }
    ///
    public var body: some TransferRepresentation { get }

    /// An intermediate structure that returns an existing share or prepares a new one if it doesn't exist
    public struct ExportedShare : Transferable, Sendable {

        /// Use this method when you want to share a collection of ``CKRecord``s but don't currently have a ``CKShare``.
        ///
        /// When the `preparationHandler` is called, you should create a new ``CKShare`` with the appropriate root ``CKRecord`` or ``CKRecordZoneID``.
        /// After ensuring the share and all records have been saved to the server, return the resulting ``CKShare`` or throw
        /// an error if saving failed.
        /// Invoking the share sheet with a ``CKShare`` registered with this method will prompt the user to start sharing.
        public static func prepareShare(container: CKContainer, allowedSharingOptions: CKAllowedSharingOptions = CKAllowedSharingOptions.standard, preparationHandler: @escaping @Sendable () async throws -> CKShare) -> CKShareTransferRepresentation<Item>.ExportedShare

        /// Use this method when you have a ``CKShare`` that is already saved to the server.
        ///
        /// Invoking the share sheet with a ``CKShare`` registered with this method will allow the owner to make modifications to the share settings,
        /// or will allow a participant to view the share settings.
        public static func existing(_ share: CKShare, container: CKContainer, allowedSharingOptions: CKAllowedSharingOptions = CKAllowedSharingOptions.standard) -> CKShareTransferRepresentation<Item>.ExportedShare

        /// The representation used to import and export the item.
        ///
        /// A ``transferRepresentation`` can contain multiple representations
        /// for different content types.
        public static var transferRepresentation: some TransferRepresentation { get }

        /// The type of the representation used to import and export the item.
        ///
        /// Swift infers this type from the return value of the
        /// ``transferRepresentation`` property.
        @available(iOS 16.0, macOS 13.0, *)
        @available(tvOS, unavailable)
        @available(watchOS, unavailable)
        public typealias Representation = some TransferRepresentation
    }

    /// The transfer representation for the item.
    @available(iOS 16.0, macOS 13.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public typealias Body = some TransferRepresentation
}

/// Deprecations of transitional names.
@available(swift 4.2)
@available(macOS, deprecated, introduced: 10.12, message: "renamed to CKShare.ParticipantAcceptanceStatus")
@available(macCatalyst, deprecated, introduced: 13.1, message: "renamed to CKShare.ParticipantAcceptanceStatus")
@available(iOS, deprecated, introduced: 10.0, message: "renamed to CKShare.ParticipantAcceptanceStatus")
@available(tvOS, deprecated, introduced: 10.0, message: "renamed to CKShare.ParticipantAcceptanceStatus")
@available(watchOS, deprecated, introduced: 3.0, message: "renamed to CKShare.ParticipantAcceptanceStatus")
@available(visionOS, deprecated, message: "renamed to CKShare.ParticipantAcceptanceStatus")
public typealias CKShare_Participant_AcceptanceStatus = CKShare.ParticipantAcceptanceStatus

/// Deprecations of transitional names.
@available(swift 4.2)
@available(macOS, deprecated, introduced: 10.12, message: "renamed to CKShare.ParticipantPermission")
@available(macCatalyst, deprecated, introduced: 13.1, message: "renamed to CKShare.ParticipantPermission")
@available(iOS, deprecated, introduced: 10.0, message: "renamed to CKShare.ParticipantPermission")
@available(tvOS, deprecated, introduced: 10.0, message: "renamed to CKShare.ParticipantPermission")
@available(watchOS, deprecated, introduced: 3.0, message: "renamed to CKShare.ParticipantPermission")
@available(visionOS, deprecated, message: "renamed to CKShare.ParticipantPermission")
public typealias CKShare_Participant_Permission = CKShare.ParticipantPermission

/// Deprecations of transitional names.
@available(swift 4.2)
@available(macOS, deprecated, introduced: 10.14, message: "renamed to CKShare.ParticipantRole")
@available(macCatalyst, deprecated, introduced: 13.1, message: "renamed to CKShare.ParticipantRole")
@available(iOS, deprecated, introduced: 12.0, message: "renamed to CKShare.ParticipantRole")
@available(tvOS, deprecated, introduced: 12.0, message: "renamed to CKShare.ParticipantRole")
@available(watchOS, deprecated, introduced: 5.0, message: "renamed to CKShare.ParticipantRole")
@available(visionOS, deprecated, message: "renamed to CKShare.ParticipantRole")
public typealias CKShare_Participant_Role = CKShare.ParticipantRole

/// `CKSyncEngine` encapsulates the logic of syncing data with a CloudKit database.
///
/// Syncing with CloudKit involves many moving pieces.
/// Apps need to schedule syncs, create and batch operations, subscribe to database changes,
/// listen for push notifications, store sync state, handle a multitude of errors, and more.
/// `CKSyncEngine` is designed to encapsulate this logic in a higher-level API.
///
/// # Start Your Sync Engine
///
/// Generally, you should initialize your `CKSyncEngine` soon after your process launches.
/// The sync engine will perform work in the background on your behalf, and it needs to be initialized
/// so that it can properly listen for push notifications and handle scheduled sync tasks.
///
/// When initializing your sync engine, you need to provide an object conforming to the ``CKSyncEngineDelegate-1q7g8`` protocol.
/// This protocol is the main method of communication between the sync engine and your app.
/// You also need to provide your last known version of the ``CKSyncEngine/State/Serialization``.
/// See ``CKSyncEngine/State`` and ``Event/StateUpdate`` for more details on the sync engine state.
///
/// Note that before using `CKSyncEngine` in your app, you need to add the CloudKit and remote notification capabilities.
///
/// # Sending Changes to the Server
///
/// In order to send changes to the server, you first need to tell the sync engine you have pending changes to send.
/// You can do this by adding pending changes to the sync engine's ``CKSyncEngine/state`` property.
///
/// When you add pending changes to the state, the sync engine will schedule a task to sync.
/// When the sync task runs, the sync engine will start sending changes to the server.
/// The sync engine will automatically send database changes from ``State/pendingDatabaseChanges``, but you need to provide the record zone changes yourself.
/// In order to send record zone changes, you need to return them from ``CKSyncEngineDelegate/nextRecordZoneChangeBatch(_:syncEngine:)``.
///
/// When the sync engine finishes sending a batch of changes to the server,
/// your ``CKSyncEngineDelegate-1q7g8`` will receive ``Event/sentDatabaseChanges(_:)`` and ``Event/sentRecordZoneChanges(_:)`` events.
/// These events will notify you of the success or failure of the changes you tried to send.
///
/// At a high level, sending changes to the server happens with the following order of operations:
///
/// 1. You add pending changes to ``CKSyncEngine/state``.
/// 2. You receive ``Event/willSendChanges(_:)`` in ``CKSyncEngineDelegate/handleEvent(_:syncEngine:)``
/// 3. If there are pending database changes, the sync engine sends the next batch.
/// 4. If any database changes were sent, your delegate receives``Event/sentDatabaseChanges(_:)``.
/// 5. Repeat from step 3 until all pending database changes are sent, then move on to record zone changes in step 6.
/// 6. The sync engine asks for the next batch of record zone changes by calling ``CKSyncEngineDelegate/nextRecordZoneChangeBatch(_:syncEngine:)``.
/// 7. The sync engine sends the next record zone change batch to the server.
/// 8. If any record zone changes were sent, your delegate receives ``Event/sentRecordZoneChanges(_:)``.
/// 9. If you added any pending database changes during steps 6-8, the sync engine repeats from step 3. Otherwise, it repeats from step 6.
/// 10. When all pending changes are sent, your delegate receives ``Event/didSendChanges(_:)``.
///
/// # Fetching Changes from the Server
///
/// The sync engine will automatically listen for remote notifications, and it will fetch changes from the server when necessary.
/// Generally, you'll receive events in this order:
///
/// 1. Your delegate receives ``Event/willFetchChanges(_:)``.
/// 2. If there are new database changes to fetch, you receive batches of them in ``Event/fetchedDatabaseChanges(_:)`` events.
/// 3. If there are new record zone changes to fetch, you will receive ``Event/willFetchRecordZoneChanges(_:)`` for each zone that has new changes.
/// 4. The sync engine fetches record zone changes and gives you batches of them in ``Event/fetchedRecordZoneChanges(_:)`` events.
/// 5. Your delegate receives ``Event/didFetchRecordZoneChanges(_:)`` for each zone that had changes to fetch.
/// 6. Your delegate receives ``Event/didFetchChanges(_:)``, indicating that sync engine has finished fetching changes.
///
/// # Sync Scheduling
///
/// ## Automatic sync
///
/// By default, the sync engine will automatically schedule sync tasks on your behalf.
/// If the user is signed in, the device has a network connection, and the system is generally in a good state, these scheduled syncs will happen relatively quickly.
/// However, if the device has no network, is low on power, or is otherwise under a heavy load, these automatic syncs might be delayed.
/// Similarly, if the user isn't signed in to an account, the sync engine won't perform any sync tasks at all.
///
/// ## Manual sync
///
/// Generally, you should rely on this automatic sync behavior, but there may be some cases where you want to manually trigger a sync.
/// For example, if you have a pull-to-refresh UI, you can call ``CKSyncEngine/fetchChanges(_:)`` to tell the sync engine to fetch immediately.
/// Or if you want to provide some sort of "backup now" button, you can call ``CKSyncEngine/sendChanges(_:)`` to send to the server immediately.
///
/// ### Testing
///
/// These manual sync functions might also be useful during automated testing.
/// When writing automated tests, you can turn off automatic sync via ``CKSyncEngine/Configuration/automaticallySync``.
/// Then, you'll have complete control over the ordering of sync events.
/// This allows you to interject behavior in the sync flow and simulate specific sequences of events.
///
/// # Error Handling
///
/// There are some transient errors that the sync engine will handle automatically behind the scenes.
/// The sync engine will retry the operations for these transient errors automatically when it makes sense to do so.
/// Specifically, the sync engine will handle the following errors on your behalf:
///
/// * ``CKError/notAuthenticated``
/// * ``CKError/accountTemporarilyUnavailable``
/// * ``CKError/networkFailure``
/// * ``CKError/networkUnavailable``
/// * ``CKError/requestRateLimited``
/// * ``CKError/serviceUnavailable``
/// * ``CKError/zoneBusy``
///
/// When the sync engine encounters one of these errors, it will wait for the system to be in a good state and try again.
/// For example, if the server sends back a `.requestRateLimited` error, the sync engine will respect this throttle and try again after the retry-after time.
///
/// `CKSyncEngine` will _not_ handle errors that require application-specific logic.
/// For example, if you try to save a record and get a ``CKError/serverRecordChanged``, you need to handle that error yourself.
/// There are plenty of errors that the sync engine cannot handle on your behalf, see ``CKError`` for a list of all the possible errors.
///
/// # Accounts
///
/// `CKSyncEngine` monitors for account status, and it will only sync if there's an account signed in.
/// Because of this, you can initialize your `CKSyncEngine` at any time, regardless of account status.
/// If there is no account, or if the user disabled sync in settings, the sync engine will stay dormant in the background.
/// Once an account is available, the sync engine will start syncing automatically.
///
/// It will also listen for when the user signs in or out of their account.
/// When it notices an account change, it will send an ``Event/accountChange(_:)`` to your delegate.
/// It's your responsibility to react appropriately to this change and update your local persistence.
@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
final public class CKSyncEngine : Sendable {

    /// Initializes a `CKSyncEngine` with the given configuration.
    /// See properties on ``CKSyncEngine/Configuration`` for more details on all the options.
    public init(_ configuration: CKSyncEngine.Configuration)

    /// The database this sync engine will sync with.
    final public var database: CKDatabase { get }

    /// A collection of state properties used to efficiently manage sync engine operation.
    /// See ``CKSyncEngine/State`` for more details.
    final public var state: CKSyncEngine.State { get }

    @objc deinit
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine {

    /// Fetches changes from the server immediately, bypassing the system scheduler.
    ///
    /// By default, the sync engine will automatically fetch changes from the server for you, and you should not have to call this function.
    /// However, you can call this if for some reason you need to ensure all changes have been fetched from the server before proceeding.
    /// For example, you might use this in your tests to simulate specific sync scenarios.
    ///
    /// Fetching changes from the server might result in some events being posted to your delegate via `handleEvent`.
    /// For example, you might receive ``CKSyncEngine/Event/WillFetchChanges`` or ``CKSyncEngine/Event/DidFetchChanges`` events.
    /// This function will not return until all the relevant events have been handled by your delegate.
    final public func fetchChanges(_ options: CKSyncEngine.FetchChangesOptions = .init()) async throws

    /// Sends any pending changes to the server immediately, bypassing the system scheduler.
    ///
    /// By default, the sync engine will automatically send changes to the server for you, and you should not have to call this function.
    /// However, you can call this if for some reason you need to ensure all changes have been sent to the server before proceeding.
    /// For example, you might consider using this in your tests to simulate specific sync scenarios.
    ///
    /// Sending changes to the server might result in some events being posted to your delegate via `handleEvent`.
    /// For example, you might receive ``CKSyncEngine/Event/WillSendChanges`` or ``CKSyncEngine/Event/DidSendChanges`` events.
    /// This function will not return until all the relevant events have been handled by your delegate.
    final public func sendChanges(_ options: CKSyncEngine.SendChangesOptions = .init()) async throws

    /// Cancels any currently executing or pending sync operations.
    ///
    /// Note that cancellation does not happen synchronously, and it's possible some in-flight operations will succeed.
    final public func cancelOperations() async
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine : CustomStringConvertible {

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    final public var description: String { get }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine {

    public struct Configuration : Sendable {

        /// The database for this sync engine to sync with.
        ///
        /// You can have multiple instances of ``CKSyncEngine-5sie5`` in the same process, each targeting a different database.
        /// For example, you might have one for your private database and one for your shared database.
        ///
        /// It's also technically possible to have multiple instances of ``CKSyncEngine-5sie5`` for the same ``CKDatabase``.
        /// This isn't recommended for production code, but it can be helpful for testing your ``CKSyncEngine-5sie5`` integration.
        /// For example, you might make multiple ``CKSyncEngine-5sie5`` instances to simulate multiple devices syncing back and forth.
        public var database: CKDatabase

        /// The state serialization you last received in a ``CKSyncEngine/Event/StateUpdate``.
        ///
        /// If this is the first time ever initializing your ``CKSyncEngine-5sie5``, you can provide `nil`.
        public var stateSerialization: CKSyncEngine.State.Serialization?

        /// Your implementation of ``CKSyncEngineDelegate-1q7g8``.
        public var delegate: any CKSyncEngineDelegate

        /// Whether or not the sync engine should automatically sync on your behalf.
        ///
        /// If true, then the sync engine will automatically sync using the system scheduler. This is the default value.
        /// When you add pending changes to the state, the sync engine will automatically schedule a sync task to send changes.
        /// When it receives a notification about new changes on the server, it will automatically schedule a sync task to fetch changes.
        /// It will also automatically re-schedule sync tasks for retryable errors such as network failures or server throttles.
        ///
        /// If ``CKSyncEngineConfiguration/automaticallySync`` is off, then the sync engine will not perform any operations unless you tell it to do so via ``CKSyncEngine/fetchChanges(_:)`` or ``CKSyncEngine/sendChanges(_:)``.
        ///
        /// Most applications likely want to enable automatic syncing during normal use.
        /// However, you might want to disable it if you have specific requirements for when you want to sync.
        /// For example, if you want to sync only once per day, you can turn off automatic sync and manually call ``CKSyncEngine/fetchChanges(_:)`` and ``CKSyncEngine/sendChanges(_:)`` once per day.
        ///
        /// You might also disable automatic sync when writing automated tests for your integration with ``CKSyncEngine-5sie5``.
        /// This way, you can have fine grained control over exactly when the sync engine fetches or sends changes.
        /// This allows you to simulate edge cases and deterministically test your logic around scenarios like conflict resolution and error handling.
        public var automaticallySync: Bool

        /// An optional override for the sync engine's default database subscription ID.
        /// Use this for backward compatibility with a previous CloudKit sync implementation.
        ///
        /// By default, ``CKSyncEngine-5sie5`` will create its own ``CKDatabaseSubscription`` with its own subscription ID.
        /// If you're migrating to ``CKSyncEngine-5sie5`` from a custom CloudKit sync implementation, you can specify your previous subscription ID here.
        /// This allows your ``CKSyncEngine-5sie5`` integration to be backward compatible with previous versions of your app.
        ///
        /// >Note: ``CKSyncEngine-5sie5`` will automatically attempt to discover any previous database subscriptions,
        /// but you can be more explicit by giving the subscription ID through this configuration option.
        public var subscriptionID: CKSubscription.ID?

        public init(database: CKDatabase, stateSerialization: CKSyncEngine.State.Serialization?, delegate: any CKSyncEngineDelegate)
    }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine {

    /// An event that occurs during the operation of a ``CKSyncEngine-5sie5``.
    ///
    /// While syncing, ``CKSyncEngine-5sie5`` posts several different types of events.
    /// Each event has an associated struct value with details describing the nature of the event.
    ///
    /// At a high level, the sync engine events can be grouped into a few different categories:
    ///
    /// ## Local state changes
    ///
    /// - ``CKSyncEngine/Event/StateUpdate``
    /// - ``CKSyncEngine/Event/AccountChange``
    ///
    /// ## Fetched changes
    ///
    /// - ``CKSyncEngine/Event/FetchedDatabaseChanges``
    /// - ``CKSyncEngine/Event/FetchedRecordZoneChanges``
    ///
    /// ## Sent changes
    ///
    /// - ``CKSyncEngine/Event/SentDatabaseChanges``
    /// - ``CKSyncEngine/Event/SentRecordZoneChanges``
    ///
    /// ## Fetch changes lifecycle
    ///
    /// - ``CKSyncEngine/Event/WillFetchChanges``
    /// - ``CKSyncEngine/Event/WillFetchRecordZoneChanges``
    /// - ``CKSyncEngine/Event/DidFetchRecordZoneChanges``
    /// - ``CKSyncEngine/Event/DidFetchChanges``
    ///
    /// ## Send changes lifecycle
    ///
    /// - ``CKSyncEngine/Event/WillSendChanges``
    /// - ``CKSyncEngine/Event/DidSendChanges``
    ///
    /// See the documentation for each event struct for more details about when and why an event might be posted.
    public enum Event : Sendable {

        /// The sync engine state was updated. You should persist it locally.
        case stateUpdate(CKSyncEngine.Event.StateUpdate)

        /// The user signed in or out of their account.
        case accountChange(CKSyncEngine.Event.AccountChange)

        /// The sync engine fetched new database changes from the server.
        case fetchedDatabaseChanges(CKSyncEngine.Event.FetchedDatabaseChanges)

        /// The sync engine fetched new record zone changes from the server.
        case fetchedRecordZoneChanges(CKSyncEngine.Event.FetchedRecordZoneChanges)

        /// The sync engine sent a batch of database changes to the server.
        case sentDatabaseChanges(CKSyncEngine.Event.SentDatabaseChanges)

        /// The sync engine sent a batch of record zone changes to the server.
        case sentRecordZoneChanges(CKSyncEngine.Event.SentRecordZoneChanges)

        /// The sync engine is about to fetch changes from the server.
        case willFetchChanges(CKSyncEngine.Event.WillFetchChanges)

        /// The sync engine is about to fetch record zone changes from the server for a specific zone.
        case willFetchRecordZoneChanges(CKSyncEngine.Event.WillFetchRecordZoneChanges)

        /// The sync engine finished fetching record zone changes from the server for a specific zone.
        case didFetchRecordZoneChanges(CKSyncEngine.Event.DidFetchRecordZoneChanges)

        /// The sync engine finished fetching changes from the server.
        case didFetchChanges(CKSyncEngine.Event.DidFetchChanges)

        /// The sync engine is about to send changes to the server.
        case willSendChanges(CKSyncEngine.Event.WillSendChanges)

        /// The sync engine finished sending changes to the server.
        case didSendChanges(CKSyncEngine.Event.DidSendChanges)
    }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine {

    /// A batch of record zone changes that ``CKSyncEngine-5sie5`` will send to the server in a single request.
    public struct RecordZoneChangeBatch : Sendable {

        /// The records to save to the server.
        public var recordsToSave: [CKRecord]

        /// The IDs of the records to delete from the server.
        public var recordIDsToDelete: [CKRecord.ID]

        /// If set to true, the sync engine will modify these records atomically by zone.
        ///
        /// If this is true, and if any record change fails, then any other changes from that zone in this batch will also fail with ``CKError/batchRequestFailed``.
        ///
        /// Records that exist in different zones will not be modified together atomically.
        public var atomicByZone: Bool

        /// Creates a batch of record zone changes according to a list of pending changes.
        ///
        /// This will iterate over the pending changes in order and add them to the batch until it reaches the max batch size.
        ///
        /// When it sees a pending save, it will ask the record provider for the actual ``CKRecord`` to send to the server.
        /// If you return `nil` from the record provider, this will skip to the next pending change.
        ///
        /// This will return `nil` if there are no pending changes to send.
        public init?(pendingChanges: [CKSyncEngine.PendingRecordZoneChange], recordProvider: @Sendable (CKRecord.ID) async -> CKRecord?) async

        /// Creates a batch of record zone changes to send to the server with a specific set of changes.
        ///
        /// If you'd like to construct your own custom batches of changes to send to the server, you can do so with this initializer.
        ///
        /// ## Batch size limitations
        ///
        /// When creating your own batches, you need to consider batch size limitations.
        /// There is a maximum count and size of records that can be sent to the server in a single batch.
        /// If you supply too many changes, or if the total size of the records is too large, then you might get a ``CKError/limitExceeded``.
        ///
        /// > Tip: These batch size limitations are handled automatically by the ``init(pendingChanges:recordProvider:)`` initializer.
        public init(recordsToSave: [CKRecord] = [], recordIDsToDelete: [CKRecord.ID] = [], atomicByZone: Bool = false)
    }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine {

    /// An object that tracks some state required for proper and efficient operation of ``CKSyncEngine-5sie5``.
    ///
    /// ``CKSyncEngine-5sie5`` needs to track several things in order to properly sync.
    /// For example, it needs to remember the last server change tokens for your database and zones.
    /// It also needs to keep track of things like the last known user record ID and other various pieces of state.
    ///
    /// A lot of this state is hidden internally, but some of it you can control.
    ///
    /// ## Pending changes
    ///
    /// One of the main things you can control is the list of pending changes to send to the server.
    /// You can control these by calling functions like ``CKSyncEngine/State/add(pendingDatabaseChanges:)``  and ``CKSyncEngine/State/add(pendingRecordZoneChanges:)``.
    /// When you add new pending changes, the sync engine will automatically schedule a task to sync with the server.
    ///
    /// ## State serialization
    ///
    /// ``CKSyncEngine-5sie5`` will occasionally update its state in the background.
    /// When it updates its state, your delegate will receive a ``CKSyncEngine/Event/stateUpdate(_:)``.
    ///
    /// This event will contain a ``CKSyncEngine/State/Serialization``, which you should persist locally.
    /// The next time your process launches, you initialize your sync engine with the last state serialization you received.
    final public class State : Sendable {

        /// A list of record changes that need to be sent to the server.
        ///
        /// ``CKSyncEngine-5sie5`` provides the convenience of tracking your pending record zone changes.
        /// When the user makes some changes that need to be sent to the server, you can track them in this list.
        /// Then, you can use this list when creating your next ``CKSyncEngine/RecordZoneChangeBatch`` in ``CKSyncEngineDelegate/nextRecordZoneChangeBatch(_:syncEngine:)``.
        ///
        /// The sync engine will ensure consistency and deduplicate these pending changes under the hood.
        /// For example, if you add a pending save for record A, then record B, then record A again, this will result in a list of `[saveRecordA, saveRecordB]`.
        /// Similarly, if you add a pending save for record A, then add a pending delete for the same record A, this will result in a single pending change of `[deleteRecordA]`.
        ///
        /// The sync engine will manage this list while it sends changes to the server.
        /// For example, when it successfully saves a record, it will remove that change from this list.
        /// If it fails to send a change due to some retryable error (e.g. a network failure), it will keep that change in this list.
        ///
        /// If you'd prefer to track pending changes yourself, you can use ``CKSyncEngine/State/hasPendingUntrackedChanges`` instead.
        final public var pendingRecordZoneChanges: [CKSyncEngine.PendingRecordZoneChange] { get }

        /// A list of database changes that need to be sent to the server, similar to `pendingRecordZoneChanges`.
        final public var pendingDatabaseChanges: [CKSyncEngine.PendingDatabaseChange] { get }

        /// This represents whether or not you have pending changes to send to the server that aren't tracked in ``CKSyncEngine/State/pendingRecordZoneChanges``.
        /// This is useful if you want to track pending changes in your own local database instead of the sync engine state.
        ///
        /// When this property is set, the sync engine will automatically schedule a sync.
        /// When the sync task runs, it will ask your delegate for pending changes in ``CKSyncEngineDelegate/nextRecordZoneChangeBatch(_:syncEngine:)``.
        final public var hasPendingUntrackedChanges: Bool

        /// The list of zone IDs that have new changes to fetch from the server.
        /// ``CKSyncEngine-5sie5`` keeps track of these zones and will update this list as it receives new information.
        final public var zoneIDsWithUnfetchedServerChanges: [CKRecordZone.ID] { get }

        /// Adds to the list of pending record zone changes.
        ///
        /// When you add a new pending change, the sync engine will automatically schedule a sync task.
        ///
        /// The sync engine will ensure consistency and deduplicate these changes under the hood.
        final public func add(pendingRecordZoneChanges: [CKSyncEngine.PendingRecordZoneChange])

        /// Removes from the list of pending record zone changes.
        final public func remove(pendingRecordZoneChanges: [CKSyncEngine.PendingRecordZoneChange])

        /// Adds to the list of pending database changes.
        ///
        /// When you add a new pending change, the sync engine will automatically schedule a sync task.
        ///
        /// The sync engine will ensure consistency and deduplicate these changes under the hood.
        final public func add(pendingDatabaseChanges: [CKSyncEngine.PendingDatabaseChange])

        /// Removes from the list of pending database changes.
        final public func remove(pendingDatabaseChanges: [CKSyncEngine.PendingDatabaseChange])

        /// A serialized representation of a ``CKSyncEngine/State``.
        ///
        /// This will be passed to your delegate via ``CKSyncEngine/Event/stateUpdate(_:)``.
        /// You should persist this locally alongside your other data and use it the next time you initialize your sync engine.
        public struct Serialization : Codable, Sendable {

            /// Encodes this value into the given encoder.
            ///
            /// If the value fails to encode anything, `encoder` will encode an empty
            /// keyed container in its place.
            ///
            /// This function throws an error if any values are invalid for the given
            /// encoder's format.
            ///
            /// - Parameter encoder: The encoder to write data to.
            public func encode(to encoder: any Encoder) throws

            /// Creates a new instance by decoding from the given decoder.
            ///
            /// This initializer throws an error if reading from the decoder fails, or
            /// if the data read is corrupted or otherwise invalid.
            ///
            /// - Parameter decoder: The decoder to read data from.
            public init(from decoder: any Decoder) throws
        }

        @objc deinit
    }

    /// A change in a record zone that needs to be sent to the server.
    public enum PendingRecordZoneChange : Sendable {

        /// A pending save of a record to the server.
        case saveRecord(CKRecord.ID)

        /// A pending deletion of a record from the server.
        case deleteRecord(CKRecord.ID)
    }

    /// A change in a database that needs to be sent to the server.
    public enum PendingDatabaseChange : Sendable {

        /// A pending save of a zone to the server.
        case saveZone(CKRecordZone)

        /// A pending deletion of a zone from the server.
        case deleteZone(CKRecordZone.ID)
    }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine {

    /// A set of options to use when fetching changes from the server.
    public struct FetchChangesOptions : Sendable {

        /// The scope in which to fetch changes.
        public var scope: CKSyncEngine.FetchChangesOptions.Scope

        /// The operation group to use for the underlying operations when fetching changes.
        ///
        /// You might set an operation group with a particular name in order to help you analyze telemetry in the CloudKit Console.
        /// If you don't provide an operation group, a default one will be created for you.
        public var operationGroup: CKOperationGroup

        /// A list of zones that should be prioritized over others while fetching changes.
        ///
        /// ``CKSyncEngine-5sie5`` will fetch changes for the zones in this list first before any other zones.
        /// You might use this to prioritize a specific set of zones for initial sync.
        /// You could also prioritize the object currently showing in the UI by putting it first in this list.
        ///
        /// Any zones not included in this list will be prioritized in a default manner.
        /// If a zone in this list has no changes to fetch, then that zone will be ignored.
        public var prioritizedZoneIDs: [CKRecordZone.ID]

        /// The scope for fetching changes from the server.
        public enum Scope : Sendable {

            /// Fetch all changes.
            case all

            /// Fetch changes for all zones except the given set of zones.
            case allExcluding([CKRecordZone.ID])

            /// Fetch changes in a specific set of zones.
            case zoneIDs([CKRecordZone.ID])

            /// Returns true if the specified zone ID is included in this scope.
            public func contains(_ zoneID: CKRecordZone.ID) -> Bool
        }

        /// Initializes a new set of request options with the given scope and operation group.
        ///
        /// If no operation group is specified, a default one will be used.
        public init(scope: CKSyncEngine.FetchChangesOptions.Scope = .all, operationGroup: CKOperationGroup? = nil)
    }

    /// The context of an attempt to fetch changes from the server.
    ///
    /// The sync engine might attempt to fetch changes from the server for many reasons.
    /// For example, if you call ``CKSyncEngine/fetchChanges(_:)``, it'll try to manually fetch changes immediately.
    /// Or if it receives a push notification, it'll schedule an automatic sync and fetch changes when the scheduler task runs.
    /// This object represents one of those attempts to fetch changes.
    public struct FetchChangesContext : Sendable {

        /// The reason why the sync engine is attempting to fetch changes.
        public let reason: CKSyncEngine.SyncReason

        /// The options being used for this attempt to fetch changes.
        public let options: CKSyncEngine.FetchChangesOptions
    }

    /// A set of options to use when sending changes to the server.
    public struct SendChangesOptions : Sendable {

        /// The scope of the changes to send.
        ///
        /// When creating the next batch of changes to send to the server, consult this and only send changes within this scope.
        public var scope: CKSyncEngine.SendChangesOptions.Scope

        /// The operation group to use for the underlying operations when sending changes.
        ///
        /// You might set an operation group with a particular name in order to help you analyze telemetry in the CloudKit Console.
        /// If you don't provide an operation group, a default one will be created for you.
        public var operationGroup: CKOperationGroup

        /// The scope for sending changes to the server.
        public enum Scope : Sendable {

            /// Send changes for all zones.
            case all

            /// Send changes for all zones except the given set of zones.
            case allExcluding([CKRecordZone.ID])

            /// Send changes in a specific set of zones.
            case zoneIDs([CKRecordZone.ID])

            /// Send changes for a specific set of records.
            case recordIDs([CKRecord.ID])

            /// Returns true if the specified record ID is included in this scope.
            public func contains(_ recordID: CKRecord.ID) -> Bool

            /// Returns true if the specified pending change is included in this scope.
            public func contains(_ pendingChange: CKSyncEngine.PendingRecordZoneChange) -> Bool
        }

        /// Initializes a new set of request options with the given scope and operation group.
        ///
        /// If no operation group is specified, a default one will be used.
        public init(scope: CKSyncEngine.SendChangesOptions.Scope = .all, operationGroup: CKOperationGroup? = nil)
    }

    /// The context of an attempt to send changes to the server.
    ///
    /// The sync engine might attempt to send changes to the server for many reasons.
    /// For example, if you call ``CKSyncEngine/sendChanges(_:)``, it'll try to manually send changes immediately.
    /// Or if you add pending changes to the state, it'll schedule an automatic sync and send changes when the scheduler task runs.
    /// This object represents one of those attempts to send changes.
    public struct SendChangesContext : Sendable {

        /// The reason why the sync engine is attempting to send changes.
        public let reason: CKSyncEngine.SyncReason

        /// The options being used for this attempt to send changes.
        public let options: CKSyncEngine.SendChangesOptions
    }

    /// A reason why the sync engine is attempting to sync.
    public enum SyncReason : Sendable {

        /// This sync was scheduled automatically by the sync engine.
        case scheduled

        /// This sync was requested manually by calling ``CKSyncEngine/fetchChanges(_:)`` or ``CKSyncEngine/sendChanges(_:)``.
        case manual

        /// Returns a Boolean value indicating whether two values are equal.
        ///
        /// Equality is the inverse of inequality. For any values `a` and `b`,
        /// `a == b` implies that `a != b` is `false`.
        ///
        /// - Parameters:
        ///   - lhs: A value to compare.
        ///   - rhs: Another value to compare.
        public static func == (a: CKSyncEngine.SyncReason, b: CKSyncEngine.SyncReason) -> Bool

        /// Hashes the essential components of this value by feeding them into the
        /// given hasher.
        ///
        /// Implement this method to conform to the `Hashable` protocol. The
        /// components used for hashing must be the same as the components compared
        /// in your type's `==` operator implementation. Call `hasher.combine(_:)`
        /// with each of these components.
        ///
        /// - Important: In your implementation of `hash(into:)`,
        ///   don't call `finalize()` on the `hasher` instance provided,
        ///   or replace it with a different instance.
        ///   Doing so may become a compile-time error in the future.
        ///
        /// - Parameter hasher: The hasher to use when combining the components
        ///   of this instance.
        public func hash(into hasher: inout Hasher)

        /// The hash value.
        ///
        /// Hash values are not guaranteed to be equal across different executions of
        /// your program. Do not save hash values to use during a future execution.
        ///
        /// - Important: `hashValue` is deprecated as a `Hashable` requirement. To
        ///   conform to `Hashable`, implement the `hash(into:)` requirement instead.
        ///   The compiler provides an implementation for `hashValue` for you.
        public var hashValue: Int { get }
    }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine.Configuration : CustomStringConvertible {

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String { get }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine.Event {

    /// The sync engine state was updated, and you should persist it locally.
    ///
    /// In order to function properly and efficiently, ``CKSyncEngine-5sie5`` tracks some state internally.
    /// When the sync engine state changes, it will give you the latest serialized version in a ``CKSyncEngine/Event/StateUpdate`` event.
    /// This event will happen occasionally when the sync engine modifies the state internally during normal sync operation.
    /// This event will also happen when you change the state yourself.
    ///
    /// The sync engine does not persist this state to disk, so you need to persist it in alongside your own local data.
    /// The next time your process launches, use this latest state serialization in ``CKSyncEngine/Configuration/stateSerialization`` to initialize your sync engine.
    ///
    /// This state is directly tied to the changes you fetch and send with the sync engine.
    /// You should ensure that any changes fetched prior to receiving this state are also persisted alongside this state.
    public struct StateUpdate : Sendable {

        public let stateSerialization: CKSyncEngine.State.Serialization
    }

    /// The user signed in or out of their account.
    ///
    /// The sync engine automatically listens for account changes, and it will send this event when the user signs in or out.
    /// It's your responsibility to react appropriately to this change and update your local persistence.
    ///
    /// When the logged-in account changes, the sync engine will reset its internal state under the hood.
    /// This means that it will clear any pending database or record zone changes that you may have added.
    ///
    /// Note that it's possible the account changes multiple times while your app is quit.
    /// If this happens, you will only receive one account change event representing the transition between the last known state and the current state.
    public struct AccountChange : Sendable {

        /// The type of account change that occurred.
        public let changeType: CKSyncEngine.Event.AccountChange.ChangeType

        public enum ChangeType : Sendable {

            /// The user signed in to an account.
            ///
            /// If you already have data stored locally, you have a few options:
            ///
            /// - Merge the local data with the newly-signed-in account's data.
            /// - Keep the local data separate from cloud-synced data (e.g. a separate "local account").
            /// - Delete the local data.
            /// - Prompt the user to make the decision.
            case signIn(currentUser: CKRecord.ID)

            /// The user signed out of their account.
            ///
            /// You should delete any locally-stored data for the previous account.
            case signOut(previousUser: CKRecord.ID)

            /// The user switched from one account to another.
            /// This might happen if the user signs out and in to a new account while your application is quit.
            ///
            /// You should delete any locally-stored data for the previous account.
            case switchAccounts(previousUser: CKRecord.ID, currentUser: CKRecord.ID)
        }
    }

    /// A batch of database changes was fetched from the server.
    ///
    /// If there are a lot of new changes on the server, then you might receive many of these events in a row.
    ///
    /// The ordering of fetched changes is not guaranteed, but changes will typically be fetched from oldest to newest.
    public struct FetchedDatabaseChanges : Sendable {

        public let modifications: [CKDatabase.DatabaseChange.Modification]

        public let deletions: [CKDatabase.DatabaseChange.Deletion]
    }

    /// A batch of record zone changes was fetched from the server.
    ///
    /// If there are a lot of new changes on the server, then you might receive many of these events in a row.
    ///
    /// The ordering of fetched changes is not guaranteed, but changes will typically be fetched from oldest to newest.
    public struct FetchedRecordZoneChanges : Sendable {

        public let modifications: [CKDatabase.RecordZoneChange.Modification]

        public let deletions: [CKDatabase.RecordZoneChange.Deletion]
    }

    /// The sync engine finished sending a batch of database changes to the server.
    ///
    /// If a change failed, try to resolve the issue causing the error and make the change again if necessary.
    public struct SentDatabaseChanges : Sendable {

        public let savedZones: [CKRecordZone]

        public let failedZoneSaves: [CKSyncEngine.Event.SentDatabaseChanges.FailedZoneSave]

        public let deletedZoneIDs: [CKRecordZone.ID]

        public let failedZoneDeletes: [CKRecordZone.ID : CKError]

        public struct FailedZoneSave : Sendable {

            public let zone: CKRecordZone

            public let error: CKError
        }
    }

    /// The sync engine finished sending a batch of record zone changes to the server.
    ///
    /// If a record save succeeded, you should encode the system fields of this record to use the next time you save. See `encodeSystemFields` on ``CKRecord``.
    ///
    /// If a record deletion succeeded, you should remove any local system fields for that record.
    ///
    /// If the record change failed, try to resolve the issue causing the error and save the record again if necessary.
    public struct SentRecordZoneChanges : Sendable {

        public let savedRecords: [CKRecord]

        public let failedRecordSaves: [CKSyncEngine.Event.SentRecordZoneChanges.FailedRecordSave]

        public let deletedRecordIDs: [CKRecord.ID]

        public let failedRecordDeletes: [CKRecord.ID : CKError]

        public struct FailedRecordSave : Sendable {

            public let record: CKRecord

            public let error: CKError
        }
    }

    /// The sync engine is about to fetch changes from the server.
    ///
    /// This might be a good signal to prepare your local data store for incoming changes if necessary.
    /// The changes themselves will be delivered in the ``CKSyncEngine/Event/FetchedDatabaseChanges`` and ``CKSyncEngine/Event/FetchedRecordZoneChanges`` events.
    ///
    /// Note that this event might not always occur every time you call ``CKSyncEngine/fetchChanges(_:)``.
    /// For example, if you call ``CKSyncEngine/fetchChanges(_:)`` concurrently while the engine is already fetching changes, this event might not be sent.
    /// Similarly, if there's no logged-in account, the engine might short-circuit the call to ``CKSyncEngine/fetchChanges(_:)``, and this event won't be sent.
    public struct WillFetchChanges : Sendable {

        @available(macOS 14.2, iOS 17.2, tvOS 17.2, watchOS 10.2, *)
        public let context: CKSyncEngine.FetchChangesContext
    }

    /// The sync engine is about to fetch record zone changes from the server for a specific zone.
    ///
    /// This might be a good signal to prepare your local data store for incoming changes if necessary.
    public struct WillFetchRecordZoneChanges : Sendable {

        public let zoneID: CKRecordZone.ID
    }

    /// The sync engine finished fetching record zone changes from the server for a specific zone.
    ///
    /// This might be a good signal to perform any post-processing tasks on a per-zone basis if necessary.
    ///
    /// You should receive one ``CKSyncEngine/Event/DidFetchRecordZoneChanges`` event for each ``CKSyncEngine/Event/WillFetchRecordZoneChanges`` event.
    public struct DidFetchRecordZoneChanges : Sendable {

        public let zoneID: CKRecordZone.ID

        public let error: CKError?
    }

    /// The sync engine finished fetching changes from the server.
    ///
    /// This might be a good signal to perform any post-processing tasks required after persisting fetched changes to disk.
    ///
    /// You should receive one ``CKSyncEngine/Event/DidFetchChanges`` event for each ``CKSyncEngine/Event/WillFetchChanges`` event.
    public struct DidFetchChanges : Sendable {

        @available(macOS 14.2, iOS 17.2, tvOS 17.2, watchOS 10.2, *)
        public let context: CKSyncEngine.FetchChangesContext
    }

    /// The sync engine is about to send changes to the server.
    public struct WillSendChanges : Sendable {

        public let context: CKSyncEngine.SendChangesContext
    }

    /// The sync engine finished sending changes to the server.
    ///
    /// You should receive one ``CKSyncEngine/Event/DidSendChanges`` event for every ``CKSyncEngine/Event/WillSendChanges`` event.
    public struct DidSendChanges : Sendable {

        public let context: CKSyncEngine.SendChangesContext
    }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine.Event : CustomStringConvertible {

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String { get }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine.RecordZoneChangeBatch : CustomStringConvertible {

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String { get }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine.PendingRecordZoneChange : Hashable, CustomStringConvertible {

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String { get }

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (a: CKSyncEngine.PendingRecordZoneChange, b: CKSyncEngine.PendingRecordZoneChange) -> Bool

    /// Hashes the essential components of this value by feeding them into the
    /// given hasher.
    ///
    /// Implement this method to conform to the `Hashable` protocol. The
    /// components used for hashing must be the same as the components compared
    /// in your type's `==` operator implementation. Call `hasher.combine(_:)`
    /// with each of these components.
    ///
    /// - Important: In your implementation of `hash(into:)`,
    ///   don't call `finalize()` on the `hasher` instance provided,
    ///   or replace it with a different instance.
    ///   Doing so may become a compile-time error in the future.
    ///
    /// - Parameter hasher: The hasher to use when combining the components
    ///   of this instance.
    public func hash(into hasher: inout Hasher)

    /// The hash value.
    ///
    /// Hash values are not guaranteed to be equal across different executions of
    /// your program. Do not save hash values to use during a future execution.
    ///
    /// - Important: `hashValue` is deprecated as a `Hashable` requirement. To
    ///   conform to `Hashable`, implement the `hash(into:)` requirement instead.
    ///   The compiler provides an implementation for `hashValue` for you.
    public var hashValue: Int { get }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine.PendingDatabaseChange : Hashable, CustomStringConvertible {

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: CKSyncEngine.PendingDatabaseChange, rhs: CKSyncEngine.PendingDatabaseChange) -> Bool

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String { get }

    /// Hashes the essential components of this value by feeding them into the
    /// given hasher.
    ///
    /// Implement this method to conform to the `Hashable` protocol. The
    /// components used for hashing must be the same as the components compared
    /// in your type's `==` operator implementation. Call `hasher.combine(_:)`
    /// with each of these components.
    ///
    /// - Important: In your implementation of `hash(into:)`,
    ///   don't call `finalize()` on the `hasher` instance provided,
    ///   or replace it with a different instance.
    ///   Doing so may become a compile-time error in the future.
    ///
    /// - Parameter hasher: The hasher to use when combining the components
    ///   of this instance.
    public func hash(into hasher: inout Hasher)

    /// The hash value.
    ///
    /// Hash values are not guaranteed to be equal across different executions of
    /// your program. Do not save hash values to use during a future execution.
    ///
    /// - Important: `hashValue` is deprecated as a `Hashable` requirement. To
    ///   conform to `Hashable`, implement the `hash(into:)` requirement instead.
    ///   The compiler provides an implementation for `hashValue` for you.
    public var hashValue: Int { get }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine.FetchChangesOptions : CustomStringConvertible {

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String { get }
}

@available(macOS 14.2, iOS 17.2, tvOS 17.2, watchOS 10.2, *)
extension CKSyncEngine.FetchChangesContext : CustomStringConvertible {

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    @available(macOS 14.2, iOS 17.2, tvOS 17.2, watchOS 10.2, *)
    public var description: String { get }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine.SendChangesOptions : CustomStringConvertible {

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String { get }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine.SendChangesContext : CustomStringConvertible {

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String { get }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine.SyncReason : CustomStringConvertible {

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String { get }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine.SyncReason : Equatable {
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine.SyncReason : Hashable {
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine.Event.StateUpdate : CustomStringConvertible {

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String { get }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine.Event.AccountChange : CustomStringConvertible {

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String { get }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine.Event.FetchedDatabaseChanges : CustomStringConvertible {

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String { get }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine.Event.FetchedRecordZoneChanges : CustomStringConvertible {

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String { get }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine.Event.SentDatabaseChanges : CustomStringConvertible {

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String { get }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine.Event.SentRecordZoneChanges : CustomStringConvertible {

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String { get }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine.Event.WillFetchChanges : CustomStringConvertible {

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String { get }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine.Event.WillFetchRecordZoneChanges : CustomStringConvertible {

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String { get }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine.Event.DidFetchRecordZoneChanges : CustomStringConvertible {

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String { get }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine.Event.DidFetchChanges : CustomStringConvertible {

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String { get }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine.Event.WillSendChanges : CustomStringConvertible {

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String { get }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine.Event.DidSendChanges : CustomStringConvertible {

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String { get }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine.FetchChangesOptions.Scope : Equatable {

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (a: CKSyncEngine.FetchChangesOptions.Scope, b: CKSyncEngine.FetchChangesOptions.Scope) -> Bool
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine.FetchChangesOptions.Scope : CustomStringConvertible {

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String { get }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine.SendChangesOptions.Scope : Equatable {

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (a: CKSyncEngine.SendChangesOptions.Scope, b: CKSyncEngine.SendChangesOptions.Scope) -> Bool
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine.SendChangesOptions.Scope : CustomStringConvertible {

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String { get }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine.Event.AccountChange.ChangeType : Equatable {

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (a: CKSyncEngine.Event.AccountChange.ChangeType, b: CKSyncEngine.Event.AccountChange.ChangeType) -> Bool
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine.Event.SentDatabaseChanges.FailedZoneSave : CustomStringConvertible {

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String { get }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngine.Event.SentRecordZoneChanges.FailedRecordSave : CustomStringConvertible {

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String { get }
}

/// An interface by which ``CKSyncEngine-5sie5`` communicates with your application.
@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
public protocol CKSyncEngineDelegate : AnyObject, Sendable {

    /// Called when an event occurs during the sync engine's operation.
    ///
    /// This is how you receive updates about local state changes, fetched changes, sent changes, and more.
    /// See ``CKSyncEngine/Event`` for all the possible events that might be posted.
    ///
    /// ## Event ordering
    ///
    /// Events will be given to your delegate serially.
    /// You will not receive the next event until you have returned from this function for the previous event.
    ///
    /// ### Recursion
    ///
    /// In order to maintain this serial event ordering guarantee, your delegate should not await any calls into the sync engine that might cause other events to be posted.
    /// For example, you should not `await` a call into ``CKSyncEngine/fetchChanges(_:)`` or ``CKSyncEngine/sendChanges(_:)`` from within the `handleEvent` callback.
    ///
    /// This is because ``CKSyncEngine/fetchChanges(_:)`` and ``CKSyncEngine/sendChanges(_:)`` will end up posting other events (e.g. `.willFetchChanges` or `.willSendChanges`),
    /// and ``CKSyncEngine-5sie5`` guarantees that `fetchChanges` and `sendChanges` won't return until you've handled all the relevant events.
    /// If you await `fetchChanges` from within `handleEvent`, and if `fetchChanges` awaits its calls into `handleEvent`, then the system is in a deadlock.
    /// If you want to fetch or send changes from within a delegate callback, you should perform that work in a detached task.
    func handleEvent(_ event: CKSyncEngine.Event, syncEngine: CKSyncEngine) async

    /// Called to get the next batch of record zone changes to send to the server.
    ///
    /// The sync engine will call this function when it's about to to send changes to the server.
    /// This might happen during an automatically scheduled sync or as a result of you calling ``CKSyncEngine/sendChanges(_:)``.
    /// Provide the next batch of record zone changes to send by returning them from this function.
    ///
    /// Once the sync engine starts sending changes, it will continue until there are no more pending changes to send.
    /// You can return `nil` to indicate that you have no more pending changes for now.
    /// The next time the sync engine tries to sync, it will call this again to get any new pending changes.
    ///
    /// ## Sending changes for specific zones
    ///
    /// When you call ``CKSyncEngine/sendChanges(_:)`` with a specific scope, you should make sure to only return a batch for that scope.
    /// You can do this by checking the ``CKSyncEngine/SendChangesOptions/scope`` property in ``CKSyncEngine/SendChangesContext/options``.
    ///
    /// For example, you might have some code like this:
    ///
    /// ```swift
    /// func nextRecordZoneChangeBatchToSend(_ context: CKSyncEngine.SendChangesContext, syncEngine: CKSyncEngine) async -> CKSyncEngine.RecordZoneChangeBatch? {
    ///
    ///     let pendingChanges = syncEngine.state.pendingRecordZoneChanges.filter { context.options.scope.contains($0) }
    ///
    ///     return await CKSyncEngine.RecordZoneChangeBatch(pendingChanges: pendingChanges) { recordID in
    ///         self.recordToSave(for: recordID)
    ///     }
    /// }
    /// ```
    func nextRecordZoneChangeBatch(_ context: CKSyncEngine.SendChangesContext, syncEngine: CKSyncEngine) async -> CKSyncEngine.RecordZoneChangeBatch?

    /// Returns a custom set of options for ``CKSyncEngine-5sie5`` to use while fetching changes.
    ///
    /// While ``CKSyncEngine-5sie5`` fetches changes from the server, it calls this function to determine priority and other options for fetching changes.
    /// This allows you to configure your fetches dynamically while the state changes in your app.
    ///
    /// For example, you can use this to prioritize fetching the object currently showing in the UI.
    /// You can also use this to prioritize specific zones during initial sync.
    ///
    /// By default, ``CKSyncEngine-5sie5`` will use whatever options are in the context.
    /// You can return `context.options` if you don't want to perform any customization.
    ///
    /// This callback will be called in between each server request while fetching changes.
    /// This allows the fetching mechanism to react dynamically while your app state changes.
    ///
    /// An example implementation might look something like this:
    /// ```swift
    /// func nextFetchChangesOptions(_ context: CKSyncEngine.FetchChangesContext, syncEngine: CKSyncEngine) async -> CKSyncEngine.FetchChangesOptions {
    ///
    ///     // Start with the options from the context.
    ///     var options = context.options
    ///
    ///     // By default, the sync engine will automatically fetch changes for all zones.
    ///     // If you know that you only want to sync a specific set of zones, you can override that here.
    ///     options.scope = .zoneIDs([...])
    ///
    ///     // You can prioritize specific zones to be fetched first by putting them in order.
    ///     var prioritizedZoneIDs: [CKRecordZone.ID] = []
    ///
    ///     // If you're showing some data in the UI, you might want to prioritize that zone first.
    ///     if let onScreenZoneID = uiController.currentlyViewedItem.zoneID {
    ///         prioritizedZoneIDs.append(onScreenZoneID)
    ///     }
    ///
    ///     // You could also prioritize special, well-known zones if that makes sense for your app.
    ///     // For example, if you have a top-level metadata zone that you'd like to sync first, you can prioritize that here.
    ///     let topLevelZoneID = CKRecordZone.ID(zoneName: "MyImportantMetadata")
    ///     prioritizedZoneIDs.append(topLevelZoneID)
    ///
    ///     options.prioritizedZoneIDs = prioritizedZoneIDs
    ///     return options
    /// }
    /// ```
    func nextFetchChangesOptions(_ context: CKSyncEngine.FetchChangesContext, syncEngine: CKSyncEngine) async -> CKSyncEngine.FetchChangesOptions
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKSyncEngineDelegate {

    /// Default implementation returns the options from the context.
    public func nextFetchChangesOptions(_ context: CKSyncEngine.FetchChangesContext, syncEngine: CKSyncEngine) async -> CKSyncEngine.FetchChangesOptions
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
@nonobjc extension CKAsset : @unchecked Sendable {
}

@available(macOS 13.3, iOS 16.4, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@nonobjc extension CKAllowedSharingOptions : @unchecked Sendable {
}

@available(macOS 10.12, macCatalyst 13.1, iOS 9.3, tvOS 9.2, watchOS 3.0, *)
extension CKContainer {

    /// If a long lived operation is cancelled or finishes completely it is no longer returned by this call.
    @available(swift 4.2)
    @preconcurrency public func fetchAllLongLivedOperationIDs(completionHandler: @escaping @Sendable ([CKOperation.ID]?, (any Error)?) -> Void)

    /// If a long lived operation is cancelled or finishes completely it is no longer returned by this call.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public func allLongLivedOperationIDs() async throws -> [CKOperation.ID]

    /// Long lived ``CKOperation``s returned by this call must be started on an operation queue.
    ///
    /// Remember to set the callback blocks before starting the operation.
    ///
    /// If an operation has already completed against the server, and is subsequently resumed, that operation will replay all of its callbacks from the start of the operation, but the request will not be re-sent to the server.
    ///
    /// If a long lived operation is cancelled or finishes completely it is no longer returned by this call.
    @available(swift 4.2)
    @preconcurrency public func fetchLongLivedOperation(withID operationID: CKOperation.ID, completionHandler: @escaping @Sendable (CKOperation?, (any Error)?) -> Void)

    /// Long lived ``CKOperation``s returned by this call must be started on an operation queue.
    ///
    /// Remember to set the callback blocks before starting the operation.
    ///
    /// If an operation has already completed against the server, and is subsequently resumed, that operation will replay all of its callbacks from the start of the operation, but the request will not be re-sent to the server.
    ///
    /// If a long lived operation is cancelled or finishes completely it is no longer returned by this call.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public func longLivedOperation(for operationID: CKOperation.ID) async throws -> CKOperation?
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
@nonobjc extension CKContainer {

    /// Calls the given closure with a configured container
    ///
    /// Any functions called on this configured container will be done with the configuration applied:
    ///
    ///     var denyCellularConfig = CKOperation.Configuration()
    ///     denyCellularConfig.allowsCellularAccess = false
    ///     myContainer.configuredWith(configuration: denyCellularConfig) { container in
    ///         container.fetchShareParticipant(withPhoneNumber: "867-5309") { ... }
    ///     }
    ///
    /// In this example, the container will not send any traffic over the cellular interface to fetch the requested share participant.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    @discardableResult
    public func configuredWith<R>(configuration: CKOperation.Configuration? = nil, group: CKOperationGroup? = nil, body: (_ configuredContainer: CKContainer) throws -> R) rethrows -> R

    /// Calls the given closure with a configured container
    ///
    /// Any functions called on this configured container will be done with the configuration applied:
    ///
    ///     var denyCellularConfig = CKOperation.Configuration()
    ///     denyCellularConfig.allowsCellularAccess = false
    ///     try await myContainer.configuredWith(configuration: denyCellularConfig) { container in
    ///         let participant = try await container.shareParticipant(forPhoneNumber: "867-5309")
    ///     }
    ///
    /// In this example, the container will not send any traffic over the cellular interface to fetch the requested share participant.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    @discardableResult
    @preconcurrency public func configuredWith<R>(configuration: CKOperation.Configuration? = nil, group: CKOperationGroup? = nil, body: @Sendable (_ configuredContainer: CKContainer) async throws -> R) async rethrows -> R

    /// Fetches all user identities that correspond to the given email addresses.
    ///
    /// Only users who have opted-in to user discoverability will have their identities returned by this function.
    ///
    /// Successfully discovered user identities will be present in the successful result parameter in `completionHandler`
    /// User identities which could not be discovered will be absent from that parameter
    ///
    /// ``CKDiscoverUserIdentitiesOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    @available(macOS, introduced: 12.0, deprecated: 14.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(macCatalyst, introduced: 15.0, deprecated: 17.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(iOS, introduced: 15.0, deprecated: 17.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(tvOS, introduced: 15.0, deprecated: 17.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(watchOS, introduced: 8.0, deprecated: 10.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(visionOS, deprecated, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @preconcurrency public func discoverUserIdentities(forEmailAddresses emails: [String], completionHandler: @escaping @Sendable (Result<[String : CKUserIdentity], any Error>) -> Void)

    /// Fetches all user identities that correspond to the given email addresses.
    ///
    /// Only users who have opted-in to user discoverability will have their identities returned by this function.
    ///
    /// Successfully discovered user identities will be present in the successful result parameter in `completionHandler`
    /// User identities which could not be discovered will be absent from that parameter
    ///
    /// ``CKDiscoverUserIdentitiesOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    @available(macOS, introduced: 12.0, deprecated: 14.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(macCatalyst, introduced: 15.0, deprecated: 17.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(iOS, introduced: 15.0, deprecated: 17.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(tvOS, introduced: 15.0, deprecated: 17.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(watchOS, introduced: 8.0, deprecated: 10.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(visionOS, deprecated, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    public func userIdentities(forEmailAddresses emails: [String]) async throws -> [String : CKUserIdentity]

    /// Fetches all user identities that correspond to the given phone numbers.
    ///
    /// Only users who have opted-in to user discoverability will have their identities returned by this function.
    ///
    /// Successfully discovered user identities will be present in the successful result parameter in `completionHandler`
    /// User identities which could not be discovered will be absent from that parameter
    ///
    /// ``CKDiscoverUserIdentitiesOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    @available(macOS, introduced: 12.0, deprecated: 14.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(macCatalyst, introduced: 15.0, deprecated: 17.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(iOS, introduced: 15.0, deprecated: 17.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(tvOS, introduced: 15.0, deprecated: 17.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(watchOS, introduced: 8.0, deprecated: 10.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(visionOS, deprecated, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @preconcurrency public func discoverUserIdentities(forPhoneNumbers phoneNumbers: [String], completionHandler: @escaping @Sendable (Result<[String : CKUserIdentity], any Error>) -> Void)

    /// Fetches all user identities that correspond to the given phone numbers.
    ///
    /// Only users who have opted-in to user discoverability will have their identities returned by this function.
    ///
    /// Successfully discovered user identities will be present in the successful result parameter in `completionHandler`
    /// User identities which could not be discovered will be absent from that parameter
    ///
    /// ``CKDiscoverUserIdentitiesOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    @available(macOS, introduced: 12.0, deprecated: 14.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(macCatalyst, introduced: 15.0, deprecated: 17.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(iOS, introduced: 15.0, deprecated: 17.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(tvOS, introduced: 15.0, deprecated: 17.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(watchOS, introduced: 8.0, deprecated: 10.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(visionOS, deprecated, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    public func userIdentities(forPhoneNumbers phoneNumbers: [String]) async throws -> [String : CKUserIdentity]

    /// Fetches all user identities that correspond to the given user record IDs.
    ///
    /// Only users who have opted-in to user discoverability will have their identities returned by this function.
    ///
    /// Successfully discovered user identities will be present in the successful result parameter in `completionHandler`
    /// User identities which could not be discovered will be absent from that parameter
    ///
    /// ``CKDiscoverUserIdentitiesOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    @available(macOS, introduced: 12.0, deprecated: 14.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(macCatalyst, introduced: 15.0, deprecated: 17.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(iOS, introduced: 15.0, deprecated: 17.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(tvOS, introduced: 15.0, deprecated: 17.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(watchOS, introduced: 8.0, deprecated: 10.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(visionOS, deprecated, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @preconcurrency public func discoverUserIdentities(forUserRecordIDs userRecordIDs: [CKRecord.ID], completionHandler: @escaping @Sendable (Result<[CKRecord.ID : CKUserIdentity], any Error>) -> Void)

    /// Fetches all user identities that correspond to the given user record IDs.
    ///
    /// Only users who have opted-in to user discoverability will have their identities returned by this function.
    ///
    /// Successfully discovered user identities will be present in the successful result parameter in `completionHandler`
    /// User identities which could not be discovered will be absent from that parameter
    ///
    /// ``CKDiscoverUserIdentitiesOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    @available(macOS, introduced: 12.0, deprecated: 14.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(macCatalyst, introduced: 15.0, deprecated: 17.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(iOS, introduced: 15.0, deprecated: 17.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(tvOS, introduced: 15.0, deprecated: 17.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(watchOS, introduced: 8.0, deprecated: 10.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(visionOS, deprecated, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    public func userIdentities(forUserRecordIDs userRecordIDs: [CKRecord.ID]) async throws -> [CKRecord.ID : CKUserIdentity]

    /// Fetches share participants matching the provided email addresses.
    ///
    /// Any valid email address can be translated into a share participant.  If the email address doesn't correspond to a known iCloud account, then at share-accept-time, the accepting participant will be offered a vetting process to link the email address to an iCloud account.
    ///
    /// ``CKFetchShareParticipantsOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    @preconcurrency public func fetchShareParticipants(forEmailAddresses emails: [String], completionHandler: @escaping @Sendable (Result<[String : Result<CKShare.Participant, any Error>], any Error>) -> Void)

    /// Fetches share participants matching the provided email addresses.
    ///
    /// Any valid email address can be translated into a share participant.  If the email address doesn't correspond to a known iCloud account, then at share-accept-time, the accepting participant will be offered a vetting process to link the email address to an iCloud account.
    ///
    /// ``CKFetchShareParticipantsOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public func shareParticipants(forEmailAddresses emails: [String]) async throws -> [String : Result<CKShare.Participant, any Error>]

    /// Fetches share participants matching the provided phone numbers.
    ///
    /// Any valid phone number can be translated into a share participant.  If the phone number doesn't correspond to a known iCloud account, then at share-accept-time, the accepting participant will be offered a vetting process to link the phone number to an iCloud account.
    ///
    /// ``CKFetchShareParticipantsOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    @preconcurrency public func fetchShareParticipants(forPhoneNumbers phoneNumbers: [String], completionHandler: @escaping @Sendable (Result<[String : Result<CKShare.Participant, any Error>], any Error>) -> Void)

    /// Fetches share participants matching the provided phone numbers.
    ///
    /// Any valid phone number can be translated into a share participant.  If the phone number doesn't correspond to a known iCloud account, then at share-accept-time, the accepting participant will be offered a vetting process to link the phone number to an iCloud account.
    ///
    /// ``CKFetchShareParticipantsOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public func shareParticipants(forPhoneNumbers phoneNumbers: [String]) async throws -> [String : Result<CKShare.Participant, any Error>]

    /// Fetches share participants matching the provided user record IDs.
    ///
    /// ``CKFetchShareParticipantsOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    @preconcurrency public func fetchShareParticipants(forUserRecordIDs userRecordIDs: [CKRecord.ID], completionHandler: @escaping @Sendable (Result<[CKRecord.ID : Result<CKShare.Participant, any Error>], any Error>) -> Void)

    /// Fetches share participants matching the provided user record IDs.
    ///
    /// ``CKFetchShareParticipantsOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public func shareParticipants(forUserRecordIDs userRecordIDs: [CKRecord.ID]) async throws -> [CKRecord.ID : Result<CKShare.Participant, any Error>]

    /// Fetches share participants matching the provided lookup infos.
    ///
    /// ``CKFetchShareParticipantsOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, watchOS 26.0, *)
    public func shareParticipants(for lookupInfos: [CKUserIdentity.LookupInfo]) async throws -> [CKUserIdentity.LookupInfo : Result<CKShare.Participant, any Error>]

    /// Fetches `CKShare.Metadata`s for the provided share URLs.
    ///
    /// This function may generate per-provided-URL errors, or function-wide errors.
    ///
    /// Example per-provided-URL errors:
    ///   - providing a URL that does not correspond to a share (`.unknownItem`)
    ///   - providing a URL that corresponds to a share the current user does not have access to (`.unknownItem`)
    ///
    /// Example function-wide errors:
    ///   - Network not connected; cannot reach server (`.networkUnavailable`)
    ///   - Current user does not have a valid credential on this device (`.notAuthenticated`)
    ///
    /// If this function hits a function-wide error, then the top-level result will be `.failure(that_function_wide_error)`
    ///
    /// If this function is able to round-trip to the server, then top-level result will be `.success(results_by_provided_URL)`
    ///   - Each provided URL will be mapped to either a `.success(CKShare.Metadata)` or a `.failure(provided_url_error)`
    ///
    /// ``CKFetchShareMetadataOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    @preconcurrency public func fetchShareMetadatas(for urls: [URL], completionHandler: @escaping @Sendable (Result<[URL : Result<CKShare.Metadata, any Error>], any Error>) -> Void)

    /// Fetches `CKShare.Metadata`s for the provided share URLs.
    ///
    /// This function may generate per-provided-URL errors, or function-wide errors.
    ///
    /// Example per-provided-URL errors:
    ///   - providing a URL that does not correspond to a share (`.unknownItem`)
    ///   - providing a URL that corresponds to a share the current user does not have access to (`.unknownItem`)
    ///
    /// Example function-wide errors:
    ///   - Network not connected; cannot reach server (`.networkUnavailable`)
    ///   - Current user does not have a valid credential on this device (`.notAuthenticated`)
    ///
    /// If this function hits a function-wide error, it will throw this error
    ///
    /// If this function is able to round-trip to the server, then the function will successfully complete with a dictionary of results by provided URLs.
    ///   - Each provided URL will be mapped to either a `.success(CKShare.Metadata)` or a `.failure(provided_url_error)`
    ///
    /// ``CKFetchShareMetadataOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public func shareMetadatas(for urls: [URL]) async throws -> [URL : Result<CKShare.Metadata, any Error>]

    /// Fetches ``CKShare``s for the provided share metadatas.
    ///
    /// This function may generate per-provided-metadata errors, or function-wide errors.
    ///
    /// Example per-provided-metadata errors:
    ///   - providing a metadata that no longer exists (`.unknownItem`)
    ///   - providing a metadata that corresponds to a share the current user no longer has access to (`.unknownItem`)
    ///
    /// Example function-wide errors:
    ///   - Network not connected; cannot reach server (`.networkUnavailable`)
    ///   - Current user does not have a valid credential on this device (`.notAuthenticated`)
    ///
    /// If this function hits a function-wide error, then the top-level result will be `.failure(that_function_wide_error)`
    ///
    /// If this function is able to round-trip to the server, then top-level result will be `.success(results_by_provided_metadata)`
    ///   - Each provided metadata will be mapped to either a `.success(CKShare)` or a `.failure(provided_metadata_error)`
    ///
    /// ``CKAcceptSharesOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    @preconcurrency public func accept(_ metadatas: [CKShare.Metadata], completionHandler: @escaping @Sendable (Result<[CKShare.Metadata : Result<CKShare, any Error>], any Error>) -> Void)

    /// Fetches ``CKShare``s for the provided share metadatas.
    ///
    /// This function may generate per-provided-metadata errors, or function-wide errors.
    ///
    /// Example per-provided-metadata errors:
    ///   - providing a metadata that no longer exists (`.unknownItem`)
    ///   - providing a metadata that corresponds to a share the current user no longer has access to (`.unknownItem`)
    ///
    /// Example function-wide errors:
    ///   - Network not connected; cannot reach server (`.networkUnavailable`)
    ///   - Current user does not have a valid credential on this device (`.notAuthenticated`)
    ///
    /// If this function hits a function-wide error, it will throw this error
    ///
    /// If this function is able to round-trip to the server, then the function will successfully complete with a dictionary of results by provided metadatas.
    ///   - Each provided metadata will be mapped to either a `.success(CKShare)` or a `.failure(provided_metadata_error)`
    ///
    /// ``CKAcceptSharesOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public func accept(_ metadatas: [CKShare.Metadata]) async throws -> [CKShare.Metadata : Result<CKShare, any Error>]

    /// Requests share access for the specified URLs.
    ///
    /// ``CKShareRequestAccessOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, watchOS 26.0, *)
    public func requestShareAccess(for urls: [URL]) async throws -> [URL : Result<Void, any Error>]
}

/// Deprecation of transitional names
@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
@nonobjc extension CKContainer {

    @available(swift 4.2)
    public enum Application {

        @available(swift 4.2)
        @available(macOS, deprecated, introduced: 10.10, message: "renamed to CKContainer.ApplicationPermissions")
        @available(macCatalyst, deprecated, introduced: 13.1, message: "renamed to CKContainer.ApplicationPermissions")
        @available(iOS, deprecated, introduced: 8.0, message: "renamed to CKContainer.ApplicationPermissions")
        @available(tvOS, deprecated, introduced: 9.0, message: "renamed to CKContainer.ApplicationPermissions")
        @available(watchOS, deprecated, introduced: 3.0, message: "renamed to CKContainer.ApplicationPermissions")
        @available(visionOS, deprecated, message: "renamed to CKContainer.ApplicationPermissions")
        public typealias Permissions = CKContainer.ApplicationPermissions

        @available(swift 4.2)
        @available(macOS, deprecated, introduced: 10.10, message: "renamed to CKContainer.ApplicationPermissionStatus")
        @available(macCatalyst, deprecated, introduced: 13.1, message: "renamed to CKContainer.ApplicationPermissionStatus")
        @available(iOS, deprecated, introduced: 8.0, message: "renamed to CKContainer.ApplicationPermissionStatus")
        @available(tvOS, deprecated, introduced: 9.0, message: "renamed to CKContainer.ApplicationPermissionStatus")
        @available(watchOS, deprecated, introduced: 3.0, message: "renamed to CKContainer.ApplicationPermissionStatus")
        @available(visionOS, deprecated, message: "renamed to CKContainer.ApplicationPermissionStatus")
        public typealias PermissionStatus = CKContainer.ApplicationPermissionStatus

        @available(swift 4.2)
        @available(macOS, deprecated, introduced: 10.10, message: "renamed to CKContainer.ApplicationPermissionBlock")
        @available(macCatalyst, deprecated, introduced: 13.1, message: "renamed to CKContainer.ApplicationPermissionBlock")
        @available(iOS, deprecated, introduced: 8.0, message: "renamed to CKContainer.ApplicationPermissionBlock")
        @available(tvOS, deprecated, introduced: 9.0, message: "renamed to CKContainer.ApplicationPermissionBlock")
        @available(watchOS, deprecated, introduced: 3.0, message: "renamed to CKContainer.ApplicationPermissionBlock")
        @available(visionOS, deprecated, message: "renamed to CKContainer.ApplicationPermissionBlock")
        public typealias PermissionBlock = CKContainer.ApplicationPermissionBlock
    }
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
@nonobjc extension CKDatabase {

    @available(macOS, introduced: 12.0, deprecated: 12.0, message: "renamed to records(matching:inZoneWith:desiredKeys:resultsLimit:)")
    @available(macCatalyst, introduced: 15.0, deprecated: 15.0, message: "renamed to records(matching:inZoneWith:desiredKeys:resultsLimit:)")
    @available(iOS, introduced: 15.0, deprecated: 15.0, message: "renamed to records(matching:inZoneWith:desiredKeys:resultsLimit:)")
    @available(tvOS, introduced: 15.0, deprecated: 15.0, message: "renamed to records(matching:inZoneWith:desiredKeys:resultsLimit:)")
    @available(watchOS, introduced: 8.0, deprecated: 8.0, message: "renamed to records(matching:inZoneWith:desiredKeys:resultsLimit:)")
    @available(visionOS, deprecated, message: "renamed to records(matching:inZoneWith:desiredKeys:resultsLimit:)")
    public func records(matching query: CKQuery, inZoneWith zoneID: CKRecordZone.ID?) async throws -> [CKRecord]
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 6.0, *)
extension CKDatabase {

    @available(swift 4.2)
    @preconcurrency public func fetch(withSubscriptionID subscriptionID: CKSubscription.ID, completionHandler: @escaping @Sendable (CKSubscription?, (any Error)?) -> Void)

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public func subscription(for subscriptionID: CKSubscription.ID) async throws -> CKSubscription

    @available(swift 4.2)
    @preconcurrency public func delete(withSubscriptionID subscriptionID: CKSubscription.ID, completionHandler: @escaping @Sendable (String?, (any Error)?) -> Void)

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    @discardableResult
    public func deleteSubscription(withID subscriptionID: CKSubscription.ID) async throws -> CKSubscription.ID
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
@nonobjc extension CKDatabase {

    /// Calls the given closure with a configured database
    ///
    /// Any functions called on this configured database will be done with the configuration applied:
    ///
    ///     var denyCellularConfig = CKOperation.Configuration()
    ///     denyCellularConfig.allowsCellularAccess = false
    ///     myDatabase.configuredWith(configuration: denyCellularConfig) { database in
    ///         database.fetch(withRecordIDs: recordIDs) { ... }
    ///     }
    ///
    /// In this example, the database will not send any traffic over the cellular interface to fetch the requested records.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    @discardableResult
    public func configuredWith<R>(configuration: CKOperation.Configuration? = nil, group: CKOperationGroup? = nil, body: (_ configuredDatabase: CKDatabase) throws -> R) rethrows -> R

    /// Calls the given closure with a configured database
    ///
    /// Any functions called on this configured database will be done with the configuration applied:
    ///
    ///     var denyCellularConfig = CKOperation.Configuration()
    ///     denyCellularConfig.allowsCellularAccess = false
    ///     try await myDatabase.configuredWith(configuration: denyCellularConfig) { database in
    ///         let results = try await database.records(for: recordIDs)
    ///     }
    ///
    /// In this example, the database will not send any traffic over the cellular interface to fetch the requested records.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    @discardableResult
    @preconcurrency public func configuredWith<R>(configuration: CKOperation.Configuration? = nil, group: CKOperationGroup? = nil, body: @Sendable (_ configuredDatabase: CKDatabase) async throws -> R) async rethrows -> R

    /// Fetches all records that correspond to the given record IDs.
    ///
    /// This function may generate per-provided-record-id errors, or function-wide errors.
    ///
    /// Example per-provided-record-id errors:
    ///   - attempting to fetch a record that does not exist (`.unknownItem`)
    ///
    /// Example function-wide errors:
    ///   - Network not connected; cannot reach server (`.networkUnavailable`)
    ///   - Current user does not have a valid credential on this device (`.notAuthenticated`)
    ///
    /// If this function hits a function-wide error, then the top-level result will be `.failure(that_function_wide_error)`
    ///
    /// If this function is able to round-trip to the server, then top-level result will be `.success()`
    ///   - Each provided record id to fetch will be mapped to either a `.success(CKRecord)` or a `.failure(per_record_failure)`
    ///
    /// ``CKFetchRecordsOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    ///
    /// - Parameter desiredKeys: Declares which user-defined keys should be fetched and added to the resulting ``CKRecord``s.  If `nil`, declares the entire record should be downloaded. If set to an empty array, declares that no user fields should be downloaded.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    @preconcurrency public func fetch(withRecordIDs recordIDs: [CKRecord.ID], desiredKeys: [CKRecord.FieldKey]? = nil, completionHandler: @escaping @Sendable (Result<[CKRecord.ID : Result<CKRecord, any Error>], any Error>) -> Void)

    /// Fetches all records that correspond to the given record IDs.
    ///
    /// This function may generate per-provided-record-id errors, or function-wide errors.
    ///
    /// Example per-provided-record-id errors:
    ///   - attempting to fetch a record that does not exist (`.unknownItem`)
    ///
    /// Example function-wide errors:
    ///   - Network not connected; cannot reach server (`.networkUnavailable`)
    ///   - Current user does not have a valid credential on this device (`.notAuthenticated`)
    ///
    /// If this function hits a function-wide error, it will throw this error
    ///
    /// If this function is able to round-trip to the server, then the function will successfully complete with a dictionary of fetch results by provided recordIDs.
    /// Each provided record id to fetch will be mapped to either a `.success(CKRecord)` or a `.failure(per_record_failure)`
    ///
    /// ``CKFetchRecordsOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    ///
    /// - Parameter desiredKeys: Declares which user-defined keys should be fetched and added to the resulting ``CKRecord``s.  If `nil`, declares the entire record should be downloaded. If set to an empty array, declares that no user fields should be downloaded.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public func records(for ids: [CKRecord.ID], desiredKeys: [CKRecord.FieldKey]? = nil) async throws -> [CKRecord.ID : Result<CKRecord, any Error>]

    /// Saves the provided `recordsToSave`, deletes the records identified by `recordIDsToDelete`
    ///
    /// This function may generate per-provided-record errors, or a function-wide error.
    ///
    /// Example per-provided-record errors:
    ///   - providing a record with an outdated `recordChangeTag` alongside a `.ifServerRecordUnchanged` save policy (`.serverRecordChanged`)
    ///
    /// Example function-wide errors:
    ///   - Network not connected; cannot reach server (`.networkUnavailable`)
    ///   - Current user does not have a valid credential on this device (`.notAuthenticated`)
    ///
    /// If this function hits a function-wide error, then the top-level result will be `.failure(that_function_wide_error)`
    ///
    /// If this function is able to round-trip to the server, then top-level result will be `.success()`
    ///   - Each provided record to save will be mapped to either a `.success(CKRecord)` or a `.failure(per_record_failure)`
    ///   - Each provided recordID to delete will be mapped to either a `.success` or a `.failure(per_record_id_failure)`
    ///
    /// ``CKModifyRecordsOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    ///
    /// - Parameter atomically: Determines whether the set of records being modified should be saved-or-failed as an atomic unit on the server.  Server-side write atomicity is only enforced on zones with `CKRecordZone.Capabilities.atomic`
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    @preconcurrency public func modifyRecords(saving recordsToSave: [CKRecord], deleting recordIDsToDelete: [CKRecord.ID], savePolicy: CKModifyRecordsOperation.RecordSavePolicy = .ifServerRecordUnchanged, atomically: Bool = true, completionHandler: @escaping @Sendable (Result<(saveResults: [CKRecord.ID : Result<CKRecord, any Error>], deleteResults: [CKRecord.ID : Result<Void, any Error>]), any Error>) -> Void)

    /// Saves the provided `recordsToSave`, deletes the records identified by `recordIDsToDelete`
    ///
    /// This function may generate per-provided-record errors, or a function-wide error.
    ///
    /// Example per-provided-record errors:
    ///   - providing a record with an outdated `recordChangeTag` alongside a `.ifServerRecordUnchanged` save policy (`.serverRecordChanged`)
    ///
    /// Example function-wide errors:
    ///   - Network not connected; cannot reach server (`.networkUnavailable`)
    ///   - Current user does not have a valid credential on this device (`.notAuthenticated`)
    ///
    /// If this function hits a function-wide error, it will throw this error
    ///
    /// If this function is able to round-trip to the server, then the function will successfully complete with a dictionary of save results by provided record recordIDs, and a dictionary of delete results by provided recordIDs.
    ///   - Each provided record to save will be mapped to either a `.success(CKRecord)` or a `.failure(per_record_failure)`
    ///   - Each provided recordID to delete will be mapped to either a `.success` or a `.failure(per_record_id_failure)`
    ///
    /// ``CKModifyRecordsOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    ///
    /// - Parameter atomically: Determines whether the set of records being modified should be saved-or-failed as an atomic unit on the server.  Server-side write atomicity is only enforced on zones with `CKRecordZone.Capabilities.atomic`
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public func modifyRecords(saving recordsToSave: [CKRecord], deleting recordIDsToDelete: [CKRecord.ID], savePolicy: CKModifyRecordsOperation.RecordSavePolicy = .ifServerRecordUnchanged, atomically: Bool = true) async throws -> (saveResults: [CKRecord.ID : Result<CKRecord, any Error>], deleteResults: [CKRecord.ID : Result<Void, any Error>])

    /// ``CKQueryOperation`` is the more configurable, ``CKOperation``-based alternative to this method
    ///
    /// Queries can potentially return a large number of records, and the server will return those records in batches.  This API may return a `queryCursor` which can be used to continue the query via the `fetch(withCursor:)` function.
    ///
    /// The successful result of this function includes a dictionary mapping matched record IDs to the fetched record.
    ///
    /// If a record fails in post-processing (say, a network failure materializing a ``CKAsset`` record field), the record ID will map to a per-record error instead
    ///
    /// - Parameter zoneID: Declares which zone the query should target.  Nil indicates "perform query across all zones in the database"
    /// Queries invoked within a `sharedCloudDatabase` must specify a `zoneID`; cross-zone queries are not supported in a `sharedCloudDatabase`
    /// - Parameter desiredKeys: Declares which user-defined keys should be fetched and added to the resulting ``CKRecord``s.  If `nil`, declares the entire record should be downloaded. If set to an empty array, declares that no user fields should be downloaded.
    /// - Parameter resultsLimit: If set, requests that the server limit the number of matched records sent in any one response.  The server may choose to set its own limit lower than this value.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    @preconcurrency public func fetch(withQuery query: CKQuery, inZoneWith zoneID: CKRecordZone.ID? = nil, desiredKeys: [CKRecord.FieldKey]? = nil, resultsLimit: Int = CKQueryOperation.maximumResults, completionHandler: @escaping @Sendable (Result<(matchResults: [(CKRecord.ID, Result<CKRecord, any Error>)], queryCursor: CKQueryOperation.Cursor?), any Error>) -> Void)

    /// This function can be used to continue a query previously started via the `fetch(withQuery:)` function.
    ///
    /// Queries can potentially return a large number of records, and the server will return those records in batches.  This API may return a `queryCursor` which can be used to continue the query via another invocation of the `fetch(withCursor:)` function.
    ///
    /// The successful result of this function includes a dictionary mapping matched record IDs to the fetched record.
    ///
    /// If a record fails in post-processing (say, a network failure materializing a ``CKAsset`` record field), the record ID will map to a per-record error instead
    ///
    /// Note that you may not specify zone IDs in this function, those are encoded into the `queryCursor`, and may not be changed without starting a new query via `fetch(withQuery:)`
    ///
    /// ``CKQueryOperation`` is the more configurable, ``CKOperation``-based alternative to this method
    ///
    /// - Parameter desiredKeys: Declares which user-defined keys should be fetched and added to the resulting ``CKRecord``s.  If `nil`, declares the entire record should be downloaded. If set to an empty array, declares that no user fields should be downloaded.
    /// - Parameter resultsLimit: If set, requests that the server limit the number of matched records sent in any one response.  The server may choose to set its own limit lower than this value.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    @preconcurrency public func fetch(withCursor queryCursor: CKQueryOperation.Cursor, desiredKeys: [CKRecord.FieldKey]? = nil, resultsLimit: Int = CKQueryOperation.maximumResults, completionHandler: @escaping @Sendable (Result<(matchResults: [(CKRecord.ID, Result<CKRecord, any Error>)], queryCursor: CKQueryOperation.Cursor?), any Error>) -> Void)

    /// ``CKQueryOperation`` is the more configurable, ``CKOperation``-based alternative to this method
    ///
    /// Queries can potentially return a large number of records, and the server will return those records in batches.  This API may return a `queryCursor` which can be used to continue the query via the `records(continuingMatchFrom:)` function.
    ///
    /// The successful result of this function includes a dictionary mapping matched record IDs to the fetched record.
    ///
    /// If a record fails in post-processing (say, a network failure materializing a ``CKAsset`` record field), the record ID will map to a per-record error instead
    ///
    /// - Parameter zoneID: Declares which zone the query should target.  Nil indicates "perform query across all zones in the database"
    /// Queries invoked within a `sharedCloudDatabase` must specify a `zoneID`; cross-zone queries are not supported in a `sharedCloudDatabase`
    /// - Parameter desiredKeys: Declares which user-defined keys should be fetched and added to the resulting ``CKRecord``s.  If `nil`, declares the entire record should be downloaded. If set to an empty array, declares that no user fields should be downloaded.
    /// - Parameter resultsLimit: If set, requests that the server limit the number of matched records sent in any one response.  The server may choose to set its own limit lower than this value.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public func records(matching query: CKQuery, inZoneWith zoneID: CKRecordZone.ID? = nil, desiredKeys: [CKRecord.FieldKey]? = nil, resultsLimit: Int = CKQueryOperation.maximumResults) async throws -> (matchResults: [(CKRecord.ID, Result<CKRecord, any Error>)], queryCursor: CKQueryOperation.Cursor?)

    /// This function can be used to continue a query previously started via the `records(matching:)` function.
    ///
    /// Queries can potentially return a large number of records, and the server will return those records in batches.  This API may return a `queryCursor` which can be used to continue the query via another invocation of the `records(continuingMatchFrom:)` function.
    ///
    /// Note that you may not specify zone IDs in this function, those are encoded into the `queryCursor`, and may not be changed without starting a new query via `records(matching:)`
    ///
    /// The successful result of this function includes a dictionary mapping matched record IDs to the fetched record.
    ///
    /// If a record fails in post-processing (say, a network failure materializing a ``CKAsset`` record field), the record ID will map to a per-record error instead
    ///
    /// ``CKQueryOperation`` is the more configurable, ``CKOperation``-based alternative to this method
    ///
    /// - Parameter desiredKeys: Declares which user-defined keys should be fetched and added to the resulting ``CKRecord``s.  If `nil`, declares the entire record should be downloaded. If set to an empty array, declares that no user fields should be downloaded.
    /// - Parameter resultsLimit: If set, requests that the server limit the number of matched records sent in any one response.  The server may choose to set its own limit lower than this value.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public func records(continuingMatchFrom queryCursor: CKQueryOperation.Cursor, desiredKeys: [CKRecord.FieldKey]? = nil, resultsLimit: Int = CKQueryOperation.maximumResults) async throws -> (matchResults: [(CKRecord.ID, Result<CKRecord, any Error>)], queryCursor: CKQueryOperation.Cursor?)

    /// Fetches all record zones that correspond to the given zone IDs.
    ///
    /// If this function hits a function-wide error, then the top-level result will be `.failure(that_function_wide_error)`
    ///
    /// If this function is able to round-trip to the server, then top-level result will be `.success()`
    ///   - Each provided record zone id to fetch will be mapped to either a `.success(CKRecordZone)` or a `.failure(per_record_zone_failure)`
    ///
    /// ``CKFetchRecordZonesOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    @preconcurrency public func fetch(withRecordZoneIDs zoneIDs: [CKRecordZone.ID], completionHandler: @escaping @Sendable (Result<[CKRecordZone.ID : Result<CKRecordZone, any Error>], any Error>) -> Void)

    /// Fetches all record zones that correspond to the given zone IDs.
    ///
    /// If this function hits a function-wide error, it will throw this error
    ///
    /// If this function is able to round-trip to the server, then the function will successfully complete with a dictionary of fetch results by provided recordZoneIDs.
    /// Each provided record zone id to fetch will be mapped to either a `.success(CKRecordZone)` or a `.failure(per_record_zone_failure)`
    ///
    /// ``CKFetchRecordZonesOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public func recordZones(for ids: [CKRecordZone.ID]) async throws -> [CKRecordZone.ID : Result<CKRecordZone, any Error>]

    /// ``CKModifyRecordZonesOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    @preconcurrency public func modifyRecordZones(saving recordZonesToSave: [CKRecordZone], deleting recordZoneIDsToDelete: [CKRecordZone.ID], completionHandler: @escaping @Sendable (Result<(saveResults: [CKRecordZone.ID : Result<CKRecordZone, any Error>], deleteResults: [CKRecordZone.ID : Result<Void, any Error>]), any Error>) -> Void)

    /// ``CKModifyRecordZonesOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public func modifyRecordZones(saving recordZonesToSave: [CKRecordZone], deleting recordZoneIDsToDelete: [CKRecordZone.ID]) async throws -> (saveResults: [CKRecordZone.ID : Result<CKRecordZone, any Error>], deleteResults: [CKRecordZone.ID : Result<Void, any Error>])

    /// Fetches all subscriptions that correspond to the given subscription IDs.
    ///
    /// If this function hits a function-wide error, then the top-level result will be `.failure(that_function_wide_error)`
    ///
    /// If this function is able to round-trip to the server, then top-level result will be `.success()`
    ///   - Each provided subscription id to fetch will be mapped to either a `.success(CKSubscription)` or a `.failure(per_subscription_failure)`
    ///
    /// ``CKFetchSubscriptionsOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    @preconcurrency public func fetch(withSubscriptionIDs subscriptionIDs: [CKSubscription.ID], completionHandler: @escaping @Sendable (Result<[CKSubscription.ID : Result<CKSubscription, any Error>], any Error>) -> Void)

    /// Fetches all subscriptions that correspond to the given subscription IDs.
    ///
    /// If this function hits a function-wide error, it will throw this error
    ///
    /// If this function is able to round-trip to the server, then the function will successfully complete with a dictionary of fetch results by provided subscriptionIDs.
    /// Each provided subscription id to fetch will be mapped to either a `.success(CKSubscription)` or a `.failure(per_subscription_failure)`
    ///
    /// ``CKFetchSubscriptionsOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public func subscriptions(for ids: [CKSubscription.ID]) async throws -> [CKSubscription.ID : Result<CKSubscription, any Error>]

    /// ``CKModifySubscriptionsOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    @preconcurrency public func modifySubscriptions(saving subscriptionsToSave: [CKSubscription], deleting subscriptionIDsToDelete: [CKSubscription.ID], completionHandler: @escaping @Sendable (Result<(saveResults: [CKSubscription.ID : Result<CKSubscription, any Error>], deleteResults: [CKSubscription.ID : Result<Void, any Error>]), any Error>) -> Void)

    /// ``CKModifySubscriptionsOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public func modifySubscriptions(saving subscriptionsToSave: [CKSubscription], deleting subscriptionIDsToDelete: [CKSubscription.ID]) async throws -> (saveResults: [CKSubscription.ID : Result<CKSubscription, any Error>], deleteResults: [CKSubscription.ID : Result<Void, any Error>])

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public enum DatabaseChange {

        /// Represents a zone that
        /// - was added or modified after the time represented by `changeToken`, or
        /// - contains record changes after the time represented by `changeToken`
        public struct Modification : Sendable {

            public var zoneID: CKRecordZone.ID { get }
        }

        /// Represents a zone that was deleted after the time represented by `changeToken`
        public struct Deletion : Sendable {

            public var zoneID: CKRecordZone.ID { get }

            @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
            public var reason: CKDatabase.DatabaseChange.Deletion.Reason { get }

            @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
            public enum Reason : Sendable, Equatable {

                /// A deletion from your software.
                case deleted

                /// A  deletion from the user via the iCloud storage UI.
                /// This is an indication that the user wanted all data deleted, so local cached data should be wiped and not re-uploaded to the server.
                case purged

                /// The user chose to reset all encrypted data for their account.
                /// This is an indication that the user had to reset encrypted data during account recovery, so local cached data should be re-uploaded to the server to minimize data loss.
                case encryptedDataReset

                /// Returns a Boolean value indicating whether two values are equal.
                ///
                /// Equality is the inverse of inequality. For any values `a` and `b`,
                /// `a == b` implies that `a != b` is `false`.
                ///
                /// - Parameters:
                ///   - lhs: A value to compare.
                ///   - rhs: Another value to compare.
                public static func == (a: CKDatabase.DatabaseChange.Deletion.Reason, b: CKDatabase.DatabaseChange.Deletion.Reason) -> Bool

                /// Hashes the essential components of this value by feeding them into the
                /// given hasher.
                ///
                /// Implement this method to conform to the `Hashable` protocol. The
                /// components used for hashing must be the same as the components compared
                /// in your type's `==` operator implementation. Call `hasher.combine(_:)`
                /// with each of these components.
                ///
                /// - Important: In your implementation of `hash(into:)`,
                ///   don't call `finalize()` on the `hasher` instance provided,
                ///   or replace it with a different instance.
                ///   Doing so may become a compile-time error in the future.
                ///
                /// - Parameter hasher: The hasher to use when combining the components
                ///   of this instance.
                public func hash(into hasher: inout Hasher)

                /// The hash value.
                ///
                /// Hash values are not guaranteed to be equal across different executions of
                /// your program. Do not save hash values to use during a future execution.
                ///
                /// - Important: `hashValue` is deprecated as a `Hashable` requirement. To
                ///   conform to `Hashable`, implement the `hash(into:)` requirement instead.
                ///   The compiler provides an implementation for `hashValue` for you.
                public var hashValue: Int { get }
            }

            @available(macOS, introduced: 12.0, deprecated: 14.0, message: "now surfaced as Reason.purged")
            @available(macCatalyst, introduced: 15.0, deprecated: 17.0, message: "now surfaced as Reason.purged")
            @available(iOS, introduced: 15.0, deprecated: 17.0, message: "now surfaced as Reason.purged")
            @available(tvOS, introduced: 15.0, deprecated: 17.0, message: "now surfaced as Reason.purged")
            @available(watchOS, introduced: 8.0, deprecated: 10.0, message: "now surfaced as Reason.purged")
            @available(visionOS, deprecated, message: "now surfaced as Reason.purged")
            public var purged: Bool { get }
        }
    }

    /// Fetches changes to record zones within a database
    ///
    /// ``CKFetchDatabaseChangesOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    ///
    /// - Parameter changeToken: a token returned from a previous `fetchDatabaseChanges()` invocation.
    /// If non-nil, only the zones with changes since that point will be returned.
    /// If this is the initial fetch, or you wish to re-fetch all zones, pass nil
    /// This per-database token is not to be confused with the per-recordZone change token from `fetchRecordZoneChanges()`
    /// Change tokens are opaque, and clients should not infer any behavior from their content.
    /// - Parameter resultsLimit: If set, requests that the server limit the number of changes sent in any one response.  The server may choose to set its own limit lower than this value.
    /// - Parameter completionHandler: On success, this is passed a tuple of changes, a changeToken representing the database version corresponding to those changes, and a bool indicating if additional changes are known to the server.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    @preconcurrency public func fetchDatabaseChanges(since changeToken: CKServerChangeToken?, resultsLimit: Int? = nil, completionHandler: @escaping @Sendable (Result<(modifications: [CKDatabase.DatabaseChange.Modification], deletions: [CKDatabase.DatabaseChange.Deletion], changeToken: CKServerChangeToken, moreComing: Bool), any Error>) -> Void)

    /// Fetches changes to record zones within a database
    ///
    /// ``CKFetchDatabaseChangesOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    ///
    /// - Parameter changeToken: a token returned from a previous `databaseChanges()` invocation.
    /// If non-nil, only the zones with changes since that point will be returned.
    /// If this is the initial fetch, or you wish to re-fetch all zones, pass nil
    /// This per-database token is not to be confused with the per-recordZone change token from `recordZoneChanges()`
    /// Change tokens are opaque, and clients should not infer any behavior from their content.
    /// - Parameter resultsLimit: If set, requests that the server limit the number of changes sent in any one response.  The server may choose to set its own limit lower than this value.
    /// - Returns: On success, a tuple of changes, a changeToken representing the database version corresponding to those changes, and a bool indicating if additional changes are known to the server.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public func databaseChanges(since changeToken: CKServerChangeToken?, resultsLimit: Int? = nil) async throws -> (modifications: [CKDatabase.DatabaseChange.Modification], deletions: [CKDatabase.DatabaseChange.Deletion], changeToken: CKServerChangeToken, moreComing: Bool)

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public enum RecordZoneChange {

        /// Represents a record that was added or modified after the time represented by `changeToken`
        public struct Modification : Sendable {

            public var record: CKRecord { get }
        }

        /// Represents a record that was deleted after the time represented by `changeToken`
        public struct Deletion : Sendable {

            public var recordID: CKRecord.ID { get }

            public var recordType: CKRecord.RecordType { get }
        }
    }

    /// Fetches changes to records within a record zone
    ///
    /// ``CKFetchRecordZoneChangesOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    ///
    /// If a changed record fails in post-processing (say, a network failure materializing a ``CKAsset`` record field), the
    /// `modificationResultsByID` dictionary will contain a per-item error keyed by the modified record id
    ///
    /// - Parameter changeToken: a token returned from a previous `fetchRecordZoneChanges()` invocation.
    /// If non-nil, only the records with changes since that point will be returned.
    /// If this is the initial fetch, or you wish to re-fetch all records, pass nil
    /// This per-recordZone token is not to be confused with the per-database change token from `fetchDatabaseChanges()`
    /// Change tokens are opaque, and clients should not infer any behavior from their content.
    /// - Parameter resultsLimit: If set, requests that the server limit the number of changes sent in any one response.  The server may choose to set its own limit lower than this value.
    /// - Parameter completionHandler: On success, this is passed a tuple of changes, a changeToken representing the record zone version corresponding to those changes, and a bool indicating if additional changes are known to the server.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    @preconcurrency public func fetchRecordZoneChanges(inZoneWith zoneID: CKRecordZone.ID, since changeToken: CKServerChangeToken?, desiredKeys: [CKRecord.FieldKey]? = nil, resultsLimit: Int? = nil, completionHandler: @escaping @Sendable (Result<(modificationResultsByID: [CKRecord.ID : Result<CKDatabase.RecordZoneChange.Modification, any Error>], deletions: [CKDatabase.RecordZoneChange.Deletion], changeToken: CKServerChangeToken, moreComing: Bool), any Error>) -> Void)

    /// Fetches changes to records within a record zone
    ///
    /// ``CKFetchRecordZoneChangesOperation`` is the more configurable, ``CKOperation``-based alternative to this function
    ///
    /// If a changed record fails in post-processing (say, a network failure materializing a ``CKAsset`` record field), the
    /// `modificationResultsByID` dictionary will contain a per-item error keyed by the modified record id
    ///
    /// - Parameter changeToken: a token returned from a previous `recordZoneChanges()` invocation.
    /// If non-nil, only the records with changes since that point will be returned.
    /// If this is the initial fetch, or you wish to re-fetch all records, pass nil
    /// This per-recordZone token is not to be confused with the per-database change token from `databaseChanges()`
    /// Change tokens are opaque, and clients should not infer any behavior from their content.
    /// - Parameter resultsLimit: If set, requests that the server limit the number of changes sent in any one response.  The server may choose to set its own limit lower than this value.
    /// - Returns: On success, a tuple of changes, a changeToken representing the record zone version corresponding to those changes, and a bool indicating if additional changes are known to the server.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public func recordZoneChanges(inZoneWith zoneID: CKRecordZone.ID, since changeToken: CKServerChangeToken?, desiredKeys: [CKRecord.FieldKey]? = nil, resultsLimit: Int? = nil) async throws -> (modificationResultsByID: [CKRecord.ID : Result<CKDatabase.RecordZoneChange.Modification, any Error>], deletions: [CKDatabase.RecordZoneChange.Deletion], changeToken: CKServerChangeToken, moreComing: Bool)
}

@available(macOS 10.12, macCatalyst 13.1, iOS 10.0, tvOS 10.0, watchOS 6.0, *)
@nonobjc extension CKDatabaseSubscription {

    @available(swift 4.2)
    public convenience init(subscriptionID: CKSubscription.ID)

    /// Optional property. If set, a database subscription is scoped to record changes for this record type
    @available(swift 4.2)
    public var recordType: CKRecord.RecordType?
}

@available(macOS 13.3, iOS 16.4, tvOS 16.4, watchOS 9.4, *)
@nonobjc extension CKDatabaseSubscription : @unchecked Sendable {
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
extension CKError {

    /// Retrieve partial error results associated by item ID.
    public var partialErrorsByItemID: [AnyHashable : any Error]? { get }

    /// If the server rejects a record save because it has been modified since the last time it was read,
    /// a `CKError.serverRecordChanged` will be returned.  `ancestorRecord` returns the original
    /// record used as a basis for making your changes.
    ///
    /// Note that if you had attempted to save a new ``CKRecord`` instance, this record may not have any
    /// key / value pairs set on it, as there was no ``CKRecord`` instance that represents an ancestor point.
    public var ancestorRecord: CKRecord? { get }

    /// If the server rejects a record save because it has been modified since the last time it was read,
    /// a `CKError.serverRecordChanged` will be returned.  `serverRecord` returns the
    /// ``CKRecord`` object that was found on the server.
    ///
    /// Use this record as the basis for merging your changes.
    public var serverRecord: CKRecord? { get }

    /// If the server rejects a record save because it has been modified since the last time it was read,
    /// a `CKError.serverRecordChanged` will be returned.  `clientRecord` returns the
    /// ``CKRecord`` object that you tried to save.
    public var clientRecord: CKRecord? { get }

    /// The number of seconds after which you may retry a request.
    /// 
    /// This key may be included in an error of type
    /// `CKError.serviceUnavailable` or `CKError.requestRateLimited`.
    public var retryAfterSeconds: Double? { get }
}

@available(macOS 10.11, macCatalyst 13.1, iOS 9.0, tvOS 9.0, watchOS 3.0, *)
@nonobjc extension CKNotification {

    /// The ID of the subscription that caused this notification to fire
    @available(swift 4.2)
    public var subscriptionID: CKSubscription.ID? { get }
}

@available(swift 4.2)
@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
@nonobjc extension CKNotification.ID : @unchecked Sendable {
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
@nonobjc extension CKQuery {

    /// Use `NSPredicate(value: true)` if you want to query for all records of a given type.
    @available(swift 4.2)
    public convenience init(recordType: CKRecord.RecordType, predicate: NSPredicate)

    @available(swift 4.2)
    public var recordType: CKRecord.RecordType { get }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension CKQuery : @unchecked Sendable {
}

@available(macOS 10.12, macCatalyst 13.1, iOS 10.0, tvOS 10.0, watchOS 6.0, *)
@nonobjc extension CKQuerySubscription {

    @available(swift 4.2)
    @available(macOS, introduced: 10.12, deprecated: 10.12, message: "Provide an explicit CKSubscription.ID at CKSubscription-init time")
    @available(macCatalyst, introduced: 13.1, deprecated: 13.1, message: "Provide an explicit CKSubscription.ID at CKSubscription-init time")
    @available(iOS, introduced: 10.0, deprecated: 10.0, message: "Provide an explicit CKSubscription.ID at CKSubscription-init time")
    @available(tvOS, introduced: 10.0, deprecated: 10.0, message: "Provide an explicit CKSubscription.ID at CKSubscription-init time")
    @available(watchOS, introduced: 6.0, deprecated: 6.0, message: "Provide an explicit CKSubscription.ID at CKSubscription-init time")
    @available(visionOS, deprecated, message: "Provide an explicit CKSubscription.ID at CKSubscription-init time")
    public convenience init(recordType: CKRecord.RecordType, predicate: NSPredicate, options querySubscriptionOptions: CKQuerySubscription.Options = [.firesOnRecordCreation, .firesOnRecordUpdate, .firesOnRecordDeletion])

    public convenience init(recordType: CKRecord.RecordType, predicate: NSPredicate, subscriptionID: CKSubscription.ID, options querySubscriptionOptions: CKQuerySubscription.Options = [.firesOnRecordCreation, .firesOnRecordUpdate, .firesOnRecordDeletion])

    /// The record type that this subscription watches
    @available(swift 4.2)
    public var recordType: CKRecord.RecordType? { get }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
@nonobjc extension CKQuerySubscription : @unchecked Sendable {
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
@nonobjc extension CKRecord : @unchecked Sendable {
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
@nonobjc extension CKRecord : Sequence {

    /// Returns an iterator over the elements of this sequence.
    public func makeIterator() -> CKRecordKeyValueIterator

    /// A type representing the sequence's elements.
    @available(iOS 8.0, tvOS 9.0, watchOS 3.0, macOS 10.10, macCatalyst 13.1, *)
    public typealias Element = (CKRecord.FieldKey, any CKRecordValueProtocol)

    /// A type that provides the sequence's iteration interface and
    /// encapsulates its iteration state.
    @available(iOS 8.0, tvOS 9.0, watchOS 3.0, macOS 10.10, macCatalyst 13.1, *)
    public typealias Iterator = CKRecordKeyValueIterator
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
@nonobjc extension CKRecord {

    public typealias RecordType = String

    public typealias FieldKey = String

    @available(swift 4.2)
    @available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
    public enum SystemType {

        @available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
        public static let userRecord: CKRecord.RecordType

        @available(macOS 10.12, macCatalyst 13.1, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
        public static let share: CKRecord.RecordType
    }

    @available(swift 4.2)
    @available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
    public enum SystemFieldKey {

        /// For use in queries to match on record properties.  Matches `record.recordID`.  Value is a `CKRecord.ID`
        @available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
        @backDeployed(before: macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0)
        public static var recordID: CKRecord.FieldKey { get }

        /// For use in queries to match on record properties.  Matches `record.creatorUserRecordID`.  Value is a `CKRecord.ID`
        @available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
        @backDeployed(before: macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0)
        public static var creatorUserRecordID: CKRecord.FieldKey { get }

        /// For use in queries to match on record properties.  Matches `record.creationDate`.  Value is a `Date`
        @available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
        @backDeployed(before: macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0)
        public static var creationDate: CKRecord.FieldKey { get }

        /// For use in queries to match on record properties.  Matches `record.lastModifiedUserRecordID`.  Value is a `CKRecord.ID`
        @available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
        @backDeployed(before: macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0)
        public static var lastModifiedUserRecordID: CKRecord.FieldKey { get }

        /// For use in queries to match on record properties.  Matches `record.modificationDate`.  Value is a `Date`
        @available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
        @backDeployed(before: macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0)
        public static var modificationDate: CKRecord.FieldKey { get }

        /// For use in queries to match on record properties.  Matches `record.parent`
        @available(macOS 10.12, macCatalyst 13.1, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
        public static let parent: CKRecord.FieldKey

        /// For use in queries to match on record properties.  Matches `record.share`
        @available(macOS 10.12, macCatalyst 13.1, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
        public static let share: CKRecord.FieldKey
    }

    @available(swift, introduced: 4.2, deprecated: 4.2, message: "Use init(recordType:recordID:) + CKRecord.ID(zoneID:) instead")
    public convenience init(recordType: CKRecord.RecordType, zoneID: CKRecordZone.ID)

    @available(swift 4.2)
    public convenience init(recordType: CKRecord.RecordType, recordID: CKRecord.ID = CKRecord.ID())

    @available(swift 4.2)
    public var recordType: CKRecord.RecordType { get }

    /// In addition to `object(forKey:)` and `setObject(_:forKey:)`, dictionary-style subscripting (`record[key]` and `record[key] = value`) can be used to get and set values.
    /// Acceptable value object classes are:
    /// - `String`
    /// - `Date`
    /// - `Data`
    /// - `Bool`
    /// - `Int`
    /// - `UInt`
    /// - `Float`
    /// - `Double`
    /// - `[U]Int8 et al`
    /// - `CKReference / CKRecord.Reference`
    /// - ``CKAsset``
    /// - `CLLocation`
    /// - `NSData`
    /// - `NSDate`
    /// - `NSNumber`
    /// - `NSString`
    /// - `Array` and/or `NSArray` containing objects of any of the types above
    ///
    /// Any other classes will result in an exception with name `NSInvalidArgumentException`.
    ///
    /// Field keys starting with `_` are reserved. Attempting to set a key prefixed with a `_` will result in an error.
    ///
    /// Key names roughly match C variable name restrictions. They must begin with an ASCII letter and can contain ASCII letters and numbers and the underscore character.
    ///
    /// The maximum key length is 255 characters.
    @available(swift 4.2)
    public func object(forKey key: CKRecord.FieldKey) -> (any __CKRecordObjCValue)?

    @available(swift 4.2)
    public func setObject(_ object: (any __CKRecordObjCValue)?, forKey key: CKRecord.FieldKey)

    @available(swift 4.2)
    public subscript(key: CKRecord.FieldKey) -> (any __CKRecordObjCValue)?

    @available(swift 4.2)
    public func allKeys() -> [CKRecord.FieldKey]

    /// A list of keys that have been modified on the local ``CKRecord`` instance
    @available(swift 4.2)
    public func changedKeys() -> [CKRecord.FieldKey]
}

/// A class coupling a record name and a record zone id
@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
@nonobjc extension CKRecord.ID {

    /// - parameter recordName: ``CKRecord`` names must be 255 characters or less. Most UTF-8 characters are valid.  Defaults to `UUID().uuidString`
    /// - parameter zoneID: defaults to the default record zone id
    @available(swift 4.2)
    public convenience init(recordName: String = UUID().uuidString, zoneID: CKRecordZone.ID = CKRecordZone.ID.default)
}

/// Deprecation of transitional names
@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
@nonobjc extension CKRecord.Reference {

    @available(swift 4.2)
    @available(macOS, deprecated, introduced: 10.10, message: "renamed to CKRecord.ReferenceAction")
    @available(macCatalyst, deprecated, introduced: 13.1, message: "renamed to CKRecord.ReferenceAction")
    @available(iOS, deprecated, introduced: 8.0, message: "renamed to CKRecord.ReferenceAction")
    @available(tvOS, deprecated, introduced: 9.0, message: "renamed to CKRecord.ReferenceAction")
    @available(watchOS, deprecated, introduced: 3.0, message: "renamed to CKRecord.ReferenceAction")
    @available(visionOS, deprecated, message: "renamed to CKRecord.ReferenceAction")
    public typealias Action = CKRecord.ReferenceAction
}

@available(macOS 10.11, macCatalyst 13.1, iOS 9.0, tvOS 9.0, watchOS 3.0, *)
extension CKRecordKeyValueSetting {

    @nonobjc public subscript<T>(key: CKRecord.FieldKey) -> T? where T : CKRecordValueProtocol

    @nonobjc public subscript(key: CKRecord.FieldKey) -> (any CKRecordValueProtocol)?
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
extension String : CKRecordValueProtocol {
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
extension Date : CKRecordValueProtocol {
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
extension Data : CKRecordValueProtocol {
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
extension Bool : CKRecordValueProtocol {
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
extension Double : CKRecordValueProtocol {
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
extension Int : CKRecordValueProtocol {
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
extension UInt : CKRecordValueProtocol {
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
extension Int8 : CKRecordValueProtocol {
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
extension UInt8 : CKRecordValueProtocol {
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
extension Int16 : CKRecordValueProtocol {
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
extension UInt16 : CKRecordValueProtocol {
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
extension Int32 : CKRecordValueProtocol {
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
extension UInt32 : CKRecordValueProtocol {
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
extension Int64 : CKRecordValueProtocol {
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
extension UInt64 : CKRecordValueProtocol {
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
extension Float : CKRecordValueProtocol {
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
extension Array : CKRecordValueProtocol where Element : CKRecordValueProtocol {
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
@nonobjc extension NSString : CKRecordValueProtocol {
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
@nonobjc extension NSDate : CKRecordValueProtocol {
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
@nonobjc extension NSData : CKRecordValueProtocol {
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
@nonobjc extension NSNumber : CKRecordValueProtocol {
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
@nonobjc extension NSArray : CKRecordValueProtocol {
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
@nonobjc extension CKRecord.Reference : CKRecordValueProtocol {
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
@nonobjc extension CKAsset : CKRecordValueProtocol {
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
@nonobjc extension CLLocation : CKRecordValueProtocol {
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
@nonobjc extension CKRecordZone : @unchecked Sendable {
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
@nonobjc extension CKRecordZone.ID {

    /// - parameter zoneName: Zone names must be 255 characters or less. Most UTF-8 characters are valid.  Defaults to `CKRecordZone.ID.defaultZoneName`
    /// - parameter ownerName: defaults to `CKCurrentUserDefaultName`
    @available(macOS 10.12, macCatalyst 13.1, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
    public convenience init(zoneName: String = CKRecordZone.ID.defaultZoneName, ownerName: String = CKCurrentUserDefaultName)

    @available(macOS, introduced: 10.10, deprecated: 10.12)
    @available(macCatalyst, introduced: 13.1, deprecated: 13.1)
    @available(iOS, introduced: 8.0, deprecated: 10.0)
    @available(tvOS, introduced: 9.0, deprecated: 10.0)
    @available(watchOS, introduced: 3.0, deprecated: 3.0)
    @available(visionOS, deprecated)
    public convenience init(zoneName: String = CKRecordZone.ID.defaultZoneName, ownerName: String? = CKOwnerDefaultName)

    @available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
    public static let `default`: CKRecordZone.ID

    @available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
    public static let defaultZoneName: String
}

@available(macOS 13.3, iOS 16.4, tvOS 16.4, watchOS 9.4, *)
@nonobjc extension CKRecordZone.ID : @unchecked Sendable {
}

@available(macOS 10.12, macCatalyst 13.1, iOS 10.0, tvOS 10.0, watchOS 6.0, *)
@nonobjc extension CKRecordZoneSubscription {

    @available(swift 4.2)
    public convenience init(zoneID: CKRecordZone.ID, subscriptionID: CKSubscription.ID)

    /// Optional property. If set, a zone subscription is scoped to record changes for this record type
    @available(swift 4.2)
    public var recordType: CKRecord.RecordType?
}

@available(macOS 13.3, iOS 16.4, tvOS 16.4, watchOS 9.4, *)
@nonobjc extension CKRecordZoneSubscription : @unchecked Sendable {
}

@available(macOS 10.12, macCatalyst 13.1, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
@nonobjc extension CKShare {

    @available(swift 4.2)
    public enum SystemFieldKey {

        @available(macOS 10.12, macCatalyst 13.1, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
        public static let title: CKRecord.FieldKey

        @available(macOS 10.12, macCatalyst 13.1, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
        public static let thumbnailImageData: CKRecord.FieldKey

        @available(macOS 10.12, macCatalyst 13.1, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
        public static let shareType: CKRecord.FieldKey
    }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
@nonobjc extension CKShare : @unchecked Sendable {
}

@available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
@nonobjc extension CKShare {

    @available(swift 4.2)
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, watchOS 26.0, *)
    public func oneTimeURL(for participantID: CKShare.Participant.ID) -> URL?
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
@nonobjc extension CKShare.Metadata : @unchecked Sendable {
}

/// Deprecations and obsoletions of transitional names.
@available(macOS 10.12, macCatalyst 13.1, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
@nonobjc extension CKShare.Participant {

    @available(swift 4.2)
    @available(macOS, deprecated, introduced: 10.12, message: "renamed to CKShare.ParticipantAcceptanceStatus")
    @available(macCatalyst, deprecated, introduced: 13.1, message: "renamed to CKShare.ParticipantAcceptanceStatus")
    @available(iOS, deprecated, introduced: 10.0, message: "renamed to CKShare.ParticipantAcceptanceStatus")
    @available(tvOS, deprecated, introduced: 10.0, message: "renamed to CKShare.ParticipantAcceptanceStatus")
    @available(watchOS, deprecated, introduced: 3.0, message: "renamed to CKShare.ParticipantAcceptanceStatus")
    @available(visionOS, deprecated, message: "renamed to CKShare.ParticipantAcceptanceStatus")
    public typealias AcceptanceStatus = CKShare.ParticipantAcceptanceStatus

    @available(swift 4.2)
    @available(macOS, deprecated, introduced: 10.12, message: "renamed to CKShare.ParticipantPermission")
    @available(macCatalyst, deprecated, introduced: 13.1, message: "renamed to CKShare.ParticipantPermission")
    @available(iOS, deprecated, introduced: 10.0, message: "renamed to CKShare.ParticipantPermission")
    @available(tvOS, deprecated, introduced: 10.0, message: "renamed to CKShare.ParticipantPermission")
    @available(watchOS, deprecated, introduced: 3.0, message: "renamed to CKShare.ParticipantPermission")
    @available(visionOS, deprecated, message: "renamed to CKShare.ParticipantPermission")
    public typealias Permission = CKShare.ParticipantPermission

    @available(swift 4.2)
    @available(macOS, deprecated, introduced: 10.14, message: "renamed to CKShare.ParticipantRole")
    @available(macCatalyst, deprecated, introduced: 13.1, message: "renamed to CKShare.ParticipantRole")
    @available(iOS, deprecated, introduced: 12.0, message: "renamed to CKShare.ParticipantRole")
    @available(tvOS, deprecated, introduced: 12.0, message: "renamed to CKShare.ParticipantRole")
    @available(watchOS, deprecated, introduced: 5.0, message: "renamed to CKShare.ParticipantRole")
    @available(visionOS, deprecated, message: "renamed to CKShare.ParticipantRole")
    public typealias Role = CKShare.ParticipantRole
}

@available(macOS 10.12, macCatalyst 13.1, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
extension CKShare.Participant {

    @available(swift 4.2)
    public typealias ID = String
}

@available(macOS 10.12, macCatalyst 13.1, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
@nonobjc extension CKShare.Participant {

    @available(swift 4.2)
    @available(macOS 10.12, macCatalyst 13.1, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
    @backDeployed(before: macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0)
    final public var participantID: CKShare.Participant.ID { get }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
@nonobjc extension CKShare.Participant : @unchecked Sendable {
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
extension CKSubscription {

    @available(swift 4.2)
    public typealias ID = String
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 6.0, *)
@nonobjc extension CKSubscription {

    @available(swift 4.2)
    public var subscriptionID: CKSubscription.ID { get }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
@nonobjc extension CKSubscription : @unchecked Sendable {
}

/// The payload of a push notification delivered in the
/// `UNUserNotificationCenterDelegate.userNotificationCenter(_:willPresent:withCompletionHandler:)` or
/// `UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)`
/// method contains information about the firing subscription.
///
/// Use `CKNotification(fromRemoteNotificationDictionary:)` to parse that payload.
/// 
/// On tvOS, alerts, badges, sounds, and categories are not handled in push notifications. However, Subscriptions remain available to help you avoid polling the server.
@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 6.0, *)
@nonobjc extension CKSubscription.NotificationInfo {

    @available(swift 4.2)
    @available(tvOS, unavailable)
    public var alertLocalizationArgs: [CKRecord.FieldKey]?

    /// A list of field names to take from the matching record that is used as substitution variables in a formatted title string.
    @available(swift 4.2)
    @available(macOS 10.13, macCatalyst 13.1, iOS 11.0, *)
    @available(tvOS, unavailable)
    public var titleLocalizationArgs: [CKRecord.FieldKey]?

    /// A list of field names to take from the matching record that is used as substitution variables in a formatted subtitle string.
    @available(swift 4.2)
    @available(macOS 10.13, macCatalyst 13.1, iOS 11.0, *)
    @available(tvOS, unavailable)
    public var subtitleLocalizationArgs: [CKRecord.FieldKey]?

    /// A list of keys from the matching record to include in the notification payload.
    ///
    /// Only some keys are allowed.  The value types associated with those keys on the server must be one of these value types:
    /// - `CKRecord.Reference`
    /// - `CLLocation`
    /// - `Date`
    /// - `Number`
    /// - `String`
    @available(swift 4.2)
    public var desiredKeys: [CKRecord.FieldKey]?

    public convenience init(alertBody: String? = nil, alertLocalizationKey: String? = nil, alertLocalizationArgs: [CKRecord.FieldKey] = [], title: String? = nil, titleLocalizationKey: String? = nil, titleLocalizationArgs: [CKRecord.FieldKey] = [], subtitle: String? = nil, subtitleLocalizationKey: String? = nil, subtitleLocalizationArgs: [CKRecord.FieldKey] = [], alertActionLocalizationKey: String? = nil, alertLaunchImage: String? = nil, soundName: String? = nil, desiredKeys: [CKRecord.FieldKey] = [], shouldBadge: Bool = false, shouldSendContentAvailable: Bool = false, shouldSendMutableContent: Bool = false, category: String? = nil, collapseIDKey: String? = nil)
}

@available(macOS 13.3, iOS 16.4, tvOS 16.4, watchOS 9.4, *)
@nonobjc extension CKSubscription.NotificationInfo : @unchecked Sendable {
}

@available(macOS 13.0, iOS 16.0, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
@nonobjc extension CKSystemSharingUIObserver {

    /// Called on success or failure of a ``CKShare`` save after user modifications via the system sharing UI
    ///
    /// Each ``CKSystemSharingUIObserver`` instance has a private serial queue. This queue is used for all callback block invocations.
    @available(macOS 13.0, iOS 16.0, *)
    @available(watchOS, unavailable)
    @available(tvOS, unavailable)
    @preconcurrency public var systemSharingUIDidSaveShareBlock: (@Sendable (_ recordID: CKRecord.ID, _ saveResult: Result<CKShare, any Error>) -> Void)?

    /// Called on success or failure of a ``CKShare`` delete when the user decides to stop sharing via the system sharing UI
    ///
    /// Each ``CKSystemSharingUIObserver`` instance has a private serial queue. This queue is used for all callback block invocations.
    @available(macOS 13.0, iOS 16.0, *)
    @available(watchOS, unavailable)
    @available(tvOS, unavailable)
    @preconcurrency public var systemSharingUIDidStopSharingBlock: (@Sendable (_ recordID: CKRecord.ID, _ deleteResult: Result<Void, any Error>) -> Void)?
}

@available(macOS 13.3, iOS 16.4, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
@nonobjc extension CKSystemSharingUIObserver : @unchecked Sendable {
}

@available(macOS 13.3, iOS 16.4, tvOS 16.4, watchOS 9.4, *)
@nonobjc extension CKUserIdentity : @unchecked Sendable {
}

@available(macOS 13.3, iOS 16.4, tvOS 16.4, watchOS 9.4, *)
@nonobjc extension CKUserIdentity.LookupInfo : @unchecked Sendable {
}

@available(macOS 13.0, iOS 16.0, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
extension NSItemProvider {

    /// Use this method when you want to share a collection of ``CKRecord``s but don't currently have a ``CKShare``.
    ///
    /// When the `preparationHandler` is called, you should create a new ``CKShare`` with the appropriate root ``CKRecord`` or ``CKRecordZoneID``.
    /// After ensuring the share and all records have been saved to the server, return the resulting ``CKShare`` or throw
    /// an error if saving failed.
    /// Invoking the share sheet with a ``CKShare`` registered with this method will prompt the user to start sharing.
    @available(macOS 13.0, iOS 16.0, *)
    @available(watchOS, unavailable)
    @available(tvOS, unavailable)
    public func registerCKShare(container: CKContainer, allowedSharingOptions: CKAllowedSharingOptions = CKAllowedSharingOptions.standard, preparationHandler: @escaping @Sendable () async throws -> CKShare)

    /// Use this method when you have a ``CKShare`` that is already saved to the server.
    ///
    /// Invoking the share sheet with a ``CKShare`` registered with this method will allow the owner to make modifications to the share settings,
    /// or will allow a participant to view the share settings.
    @available(macOS 13.0, iOS 16.0, *)
    @available(watchOS, unavailable)
    @available(tvOS, unavailable)
    public func registerCKShare(_ share: CKShare, container: CKContainer, allowedSharingOptions: CKAllowedSharingOptions = CKAllowedSharingOptions.standard)
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
@nonobjc extension CKQueryOperation {

    /// Declares which user-defined keys should be fetched and added to the resulting ``CKRecord``s.
    ///
    /// If `nil`, declares the entire record should be downloaded. If set to an empty array, declares that no user fields should be downloaded.
    /// Defaults to `nil`.
    @available(swift 4.2)
    public var desiredKeys: [CKRecord.FieldKey]?

    /// This block will be called once for every record that is returned as a result of the query.
    ///
    /// The callbacks will happen in the order that the results were sorted in.  If a record fails in post-processing (say, a network failure materializing a ``CKAsset`` record field), the per-record error will be passed here.
    ///
    /// Each ``CKOperation`` instance has a private serial queue. This queue is used for all callback block invocations.
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var recordMatchedBlock: ((_ recordID: CKRecord.ID, _ recordResult: Result<CKRecord, any Error>) -> Void)?

    /// This block is called when the operation completes.
    ///
    /// The `Operation.completionBlock` will also be called if both are set.
    /// 
    /// Each ``CKOperation`` instance has a private serial queue. This queue is used for all callback block invocations
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var queryResultBlock: ((_ operationResult: Result<CKQueryOperation.Cursor?, any Error>) -> Void)?
}

@available(macOS 13.3, iOS 16.4, tvOS 16.4, watchOS 9.4, *)
@nonobjc extension CKQueryOperation.Cursor : @unchecked Sendable {
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
@nonobjc extension CKFetchRecordsOperation {

    /// Declares which user-defined keys should be fetched and added to the resulting ``CKRecord``s.
    ///
    /// If `nil`, declares the entire record should be downloaded. If set to an empty array, declares that no user fields should be downloaded.
    /// Defaults to `nil`.
    @available(swift 4.2)
    public var desiredKeys: [CKRecord.FieldKey]?

    /// Called on success or failure for each record.
    ///
    /// Each ``CKOperation`` instance has a private serial queue. This queue is used for all callback block invocations.
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var perRecordResultBlock: ((_ recordID: CKRecord.ID, _ recordResult: Result<CKRecord, any Error>) -> Void)?

    /// This block is called when the operation completes.
    ///
    /// The top-level error will never be `CKError.partialFailure`.  Instead, per-item errors are surfaced in prior invocations of `perRecordResultBlock`
    ///
    /// The `Operation.completionBlock` will also be called if both are set.
    /// 
    /// Each ``CKOperation`` instance has a private serial queue. This queue is used for all callback block invocations
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var fetchRecordsResultBlock: ((_ operationResult: Result<Void, any Error>) -> Void)?
}

@available(macOS 10.12, macCatalyst 13.1, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
@nonobjc extension CKFetchRecordZoneChangesOperation {

    @available(swift 4.2)
    @available(macOS 10.14, macCatalyst 13.1, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    public convenience init(recordZoneIDs: [CKRecordZone.ID]? = nil, configurationsByRecordZoneID: [CKRecordZone.ID : CKFetchRecordZoneChangesOperation.ZoneConfiguration]? = nil)

    /// Each ``CKOperation`` instance has a private serial queue.  This queue is used for all callback block invocations.
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(swift 4.2)
    public var recordWithIDWasDeletedBlock: ((_ recordID: CKRecord.ID, _ recordType: CKRecord.RecordType) -> Void)?

    /// The block to execute with the contents of a changed record.
    ///
    /// If a changed record fails in post-processing (say, a network failure materializing a ``CKAsset`` record field), the per-record error will be passed here.
    ///
    /// Each ``CKOperation`` instance has a private serial queue. This queue is used for all callback block invocations.
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var recordWasChangedBlock: ((_ recordID: CKRecord.ID, _ recordResult: Result<CKRecord, any Error>) -> Void)?

    /// The block to execute when a record zone’s fetch finishes.
    ///
    /// Clients are responsible for saving this per-recordZone `serverChangeToken` and passing it in to the next call to ``CKFetchRecordZoneChangesOperation``.
    /// 
    /// Note that a fetch can fail partway. If that happens, an updated change token may be returned in this block so that already fetched records don't need to be re-downloaded on a subsequent operation.
    ///
    /// `recordZoneChangeTokensUpdatedBlock` will not be called after the last batch of changes in a zone; the `recordZoneFetchCompletionBlock` block will be called instead.
    ///
    /// The `clientChangeTokenData` from the most recent ``CKModifyRecordsOperation`` issued on this zone is also returned, or nil if none was provided.
    ///
    /// If the server returns a `CKError.changeTokenExpired` error, the `serverChangeToken` used for this record zone when initting this operation was too old and the client should toss its local cache and re-fetch the changes in this record zone starting with a nil `serverChangeToken`.
    ///
    /// `recordZoneChangeTokensUpdatedBlock` will not be called if `fetchAllChanges` is NO.
    ///
    /// The top-level error will never be `CKError.partialFailure`.  Instead, per-item errors are surfaced in prior invocations of `recordWasChangedBlock`
    ///
    /// Each ``CKOperation`` instance has a private serial queue. This queue is used for all callback block invocations.
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var recordZoneFetchResultBlock: ((_ recordZoneID: CKRecordZone.ID, _ fetchChangesResult: Result<(serverChangeToken: CKServerChangeToken, clientChangeTokenData: Data?, moreComing: Bool), any Error>) -> Void)?

    /// This block is called when the operation completes.
    ///
    /// `serverChangeToken`-s previously returned via a `recordZoneChangeTokensUpdatedBlock` or `recordZoneFetchCompletionBlock` invocation, along with the record changes that preceded it, are valid even if there is a subsequent `operationError`
    ///
    /// The top-level error will never be `CKError.partialFailure`.  Instead, per-record errors are surfaced in prior invocations of `recordWasChangedBlock`,
    /// and per-zone errors are surfaced in prior invocations of `recordZoneFetchResultBlock`
    /// 
    /// Each ``CKOperation`` instance has a private serial queue. This queue is used for all callback block invocations.
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var fetchRecordZoneChangesResultBlock: ((_ operationResult: Result<Void, any Error>) -> Void)?
}

@available(macOS 10.14, macCatalyst 13.1, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
@nonobjc extension CKFetchRecordZoneChangesOperation.ZoneConfiguration {

    /// Declares which user-defined keys should be fetched and added to the resulting ``CKRecord``s.
    ///
    /// If `nil`, declares the entire record should be downloaded. If set to an empty array, declares that no user fields should be downloaded.
    /// Defaults to `nil`.
    @available(swift 4.2)
    public var desiredKeys: [CKRecord.FieldKey]?

    @available(swift 4.2)
    public convenience init(previousServerChangeToken: CKServerChangeToken? = nil, resultsLimit: Int? = nil, desiredKeys: [CKRecord.FieldKey]? = nil)
}

@available(macOS 13.3, iOS 16.4, tvOS 16.4, watchOS 9.4, *)
@nonobjc extension CKFetchRecordZoneChangesOperation.ZoneConfiguration : @unchecked Sendable {
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
@nonobjc extension CKModifyRecordsOperation {

    @available(swift 4.2)
    public convenience init(recordsToSave: [CKRecord]? = nil, recordIDsToDelete: [CKRecord.ID]? = nil)

    /// Called on success or failure of a record save.
    ///
    /// Each ``CKOperation`` instance has a private serial queue. This queue is used for all callback block invocations.
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var perRecordSaveBlock: ((_ recordID: CKRecord.ID, _ saveResult: Result<CKRecord, any Error>) -> Void)?

    /// Called on success or failure of a record delete.
    ///
    /// Each ``CKOperation`` instance has a private serial queue. This queue is used for all callback block invocations.
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var perRecordDeleteBlock: ((_ recordID: CKRecord.ID, _ deleteResult: Result<Void, any Error>) -> Void)?

    /// This block is called when the operation completes.
    ///
    /// This call happens as soon as the server has seen all record changes, and may be invoked while the server is processing the side effects of those changes.
    ///
    /// The top-level error will never be `CKError.partialFailure`.  Instead, per-item errors are surfaced in prior invocations of `perRecordSaveBlock` and `perRecordDeleteBlock`
    ///
    /// The `Operation.completionBlock` will also be called if both are set.
    /// 
    /// Each ``CKOperation`` instance has a private serial queue. This queue is used for all callback block invocations
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var modifyRecordsResultBlock: ((_ operationResult: Result<Void, any Error>) -> Void)?
}

@available(macOS 10.12, macCatalyst 13.1, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
@nonobjc extension CKAcceptSharesOperation {

    /// Called once for each share metadata that the server processed
    ///
    /// Each ``CKOperation`` instance has a private serial queue. This queue is used for all callback block invocations.
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var perShareResultBlock: ((_ metadata: CKShare.Metadata, _ metadataResult: Result<CKShare, any Error>) -> Void)?

    /// This block is called when the operation completes.
    ///
    /// The top-level error will never be `CKError.partialFailure`.  Instead, per-item errors are surfaced in prior invocations of `perShareResultBlock`.
    ///
    /// The `Operation.completionBlock` will also be called if both are set.
    /// 
    /// Each ``CKOperation`` instance has a private serial queue. This queue is used for all callback block invocations.
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var acceptSharesResultBlock: ((_ operationResult: Result<Void, any Error>) -> Void)?
}

@available(macOS 10.12, macCatalyst 13.1, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
@nonobjc extension CKFetchShareMetadataOperation {

    /// Declares which user-defined keys should be fetched and added to the resulting `rootRecord`.
    ///
    /// Only consulted if `shouldFetchRootRecord` is `true`.
    ///
    /// If `nil`, declares the entire root record should be downloaded. If set to an empty array, declares that no user fields should be downloaded.
    /// Defaults to `nil`.
    @available(swift 4.2)
    public var rootRecordDesiredKeys: [CKRecord.FieldKey]?

    /// Called once for each share URL that the server processed
    ///
    /// Each ``CKOperation`` instance has a private serial queue. This queue is used for all callback block invocations.
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var perShareMetadataResultBlock: ((_ shareURL: URL, _ shareMetadataResult: Result<CKShare.Metadata, any Error>) -> Void)?

    /// This block is called when the operation completes.
    ///
    /// The top-level error will never be `CKError.partialFailure`.  Instead, per-item errors are surfaced in prior invocations of `perShareMetadataResultBlock`
    ///
    /// The `Operation.completionBlock` will also be called if both are set.
    /// 
    /// Each ``CKOperation`` instance has a private serial queue. This queue is used for all callback block invocations
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var fetchShareMetadataResultBlock: ((_ operationResult: Result<Void, any Error>) -> Void)?
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, watchOS 26.0, *)
@nonobjc extension CKShareRequestAccessOperation {

    /// A block called once for each share URL processed by the server.
    ///
    /// Use this block to handle results individually for each requested share.
    ///
    /// Each ``CKOperation`` instance uses a private serial queue for callback block invocations.
    /// This queue ensures serialized execution and thread safety for mutable state shared within the operation's blocks.
    /// Any mutable state should not be concurrently accessed outside these callback blocks.
    ///
    /// - Parameters:
    ///   - shareURL: The URL of the processed share.
    ///   - result: A result indicating success (`Void`) or an error.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, watchOS 26.0, *)
    public var perShareAccessRequestResultBlock: ((URL, Result<Void, any Error>) -> Void)?

    /// A block called when the entire share access request operation completes.
    ///
    /// Use this block to handle the overall success or failure of the operation.
    ///
    /// The top-level error returned here will never be `CKError.partialFailure`.
    /// Individual share errors are reported through the ``CloudKit/CKShareRequestAccessOperation/perShareAccessRequestResultBlock``.
    ///
    /// If the completionBlock is set on the ``CKOperation``, it will also be called after this block.
    ///
    /// Each ``CKOperation`` instance uses a private serial queue for callback block invocations.
    /// This queue ensures serialized execution and thread safety for mutable state shared within the operation's blocks.
    /// Any mutable state should not be concurrently accessed outside these callback blocks.
    ///
    /// - Parameter result: A result indicating success (`Void`) or an error.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, watchOS 26.0, *)
    public var shareAccessRequestResultBlock: ((Result<Void, any Error>) -> Void)?
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 6.0, *)
@nonobjc extension CKFetchSubscriptionsOperation {

    @available(swift 4.2)
    public convenience init(subscriptionIDs: [CKSubscription.ID])

    @available(swift 4.2)
    public var subscriptionIDs: [CKSubscription.ID]?

    /// Called on success or failure for each subscription
    ///
    /// Each ``CKOperation`` instance has a private serial queue. This queue is used for all callback block invocations.
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var perSubscriptionResultBlock: ((_ subscriptionID: CKSubscription.ID, _ subscriptionResult: Result<CKSubscription, any Error>) -> Void)?

    /// This block is called when the operation completes.
    ///
    /// If the error is `CKError.partialFailure`, the error's `partialErrorsByItemID` is a dictionary of subscriptionIDs to errors.
    ///
    /// The `Operation.completionBlock` will also be called if both are set.
    ///
    /// Each ``CKOperation`` instance has a private serial queue.  This queue is used for all callback block invocations.
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(swift 4.2)
    @available(macOS, introduced: 10.10, deprecated: 12.0, message: "Use fetchSubscriptionsResultBlock instead")
    @available(macCatalyst, introduced: 13.1, deprecated: 15.0, message: "Use fetchSubscriptionsResultBlock instead")
    @available(iOS, introduced: 8.0, deprecated: 15.0, message: "Use fetchSubscriptionsResultBlock instead")
    @available(tvOS, introduced: 9.0, deprecated: 15.0, message: "Use fetchSubscriptionsResultBlock instead")
    @available(watchOS, introduced: 6.0, deprecated: 8.0, message: "Use fetchSubscriptionsResultBlock instead")
    @available(visionOS, deprecated, message: "Use fetchSubscriptionsResultBlock instead")
    public var fetchSubscriptionCompletionBlock: ((_ subscriptionsBySubscriptionID: [CKSubscription.ID : CKSubscription]?, _ operationError: (any Error)?) -> Void)?

    /// This block is called when the operation completes.
    ///
    /// If the error is `CKError.partialFailure`, the error's `partialErrorsByItemID` is a dictionary of subscriptionIDs to errors.
    ///
    /// The `Operation.completionBlock` will also be called if both are set.
    /// 
    /// Each ``CKOperation`` instance has a private serial queue. This queue is used for all callback block invocations
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var fetchSubscriptionsResultBlock: ((_ operationResult: Result<Void, any Error>) -> Void)?
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 6.0, *)
@nonobjc extension CKModifySubscriptionsOperation {

    @available(swift 4.2)
    public convenience init(subscriptionsToSave: [CKSubscription]? = nil, subscriptionIDsToDelete: [CKSubscription.ID]? = nil)

    @available(swift 4.2)
    public var subscriptionIDsToDelete: [CKSubscription.ID]?

    /// Called on success or failure of a subscription save.
    ///
    /// Each ``CKOperation`` instance has a private serial queue. This queue is used for all callback block invocations.
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var perSubscriptionSaveBlock: ((_ subscriptionID: CKSubscription.ID, _ saveResult: Result<CKSubscription, any Error>) -> Void)?

    /// Called on success or failure of a subscription delete.
    ///
    /// Each ``CKOperation`` instance has a private serial queue. This queue is used for all callback block invocations.
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var perSubscriptionDeleteBlock: ((_ subscriptionID: CKSubscription.ID, _ deleteResult: Result<Void, any Error>) -> Void)?

    /// This block is called when the operation completes.
    ///
    /// If the error is `CKError.partialFailure`, the error's userInfo dictionary contains a dictionary of subscriptionIDs to errors keyed off of `partialErrorsByItemID`.
    ///
    /// The `Operation.completionBlock` will also be called if both are set.
    ///
    /// Each ``CKOperation`` instance has a private serial queue.  This queue is used for all callback block invocations.
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(macOS, introduced: 10.10, deprecated: 12.0, message: "Use modifySubscriptionsResultBlock instead")
    @available(macCatalyst, introduced: 13.1, deprecated: 15.0, message: "Use modifySubscriptionsResultBlock instead")
    @available(iOS, introduced: 8.0, deprecated: 15.0, message: "Use modifySubscriptionsResultBlock instead")
    @available(tvOS, introduced: 9.0, deprecated: 15.0, message: "Use modifySubscriptionsResultBlock instead")
    @available(watchOS, introduced: 6.0, deprecated: 8.0, message: "Use modifySubscriptionsResultBlock instead")
    @available(visionOS, deprecated, message: "Use modifySubscriptionsResultBlock instead")
    public var modifySubscriptionsCompletionBlock: ((_ savedSubscriptions: [CKSubscription]?, _ deletedSubscriptionIDs: [CKSubscription.ID]?, _ operationError: (any Error)?) -> Void)?

    /// This block is called when the operation completes.
    ///
    /// The top-level error will never be `CKError.partialFailure`.  Instead, per-item errors are surfaced in prior invocations of `perSubscriptionSaveBlock` and `perSubscriptionDeleteBlock`
    ///
    /// The `Operation.completionBlock` will also be called if both are set.
    /// 
    /// Each ``CKOperation`` instance has a private serial queue.  This queue is used for all callback block invocations.
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var modifySubscriptionsResultBlock: ((_ operationResult: Result<Void, any Error>) -> Void)?
}

@available(macOS 10.12, macCatalyst 13.1, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
@nonobjc extension CKFetchDatabaseChangesOperation {

    /// This block is called when the operation completes.
    ///
    /// Clients are responsible for saving the change token at the end of the operation and passing it in to the next call to ``CKFetchDatabaseChangesOperation``.
    ///
    /// If the server returns a `CKError.changeTokenExpired` error, the `previousServerChangeToken` value was too old and the client should toss its local cache and re-fetch the changes in this record zone starting with a nil `previousServerChangeToken`.
    ///
    /// If `moreComing` is true then the server wasn't able to return all the changes in this response. Another ``CKFetchDatabaseChangesOperation`` operation should be run with the `previousServerChangeToken` token from this operation.
    /// 
    /// Each ``CKOperation`` instance has a private serial queue. This queue is used for all callback block invocations
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var fetchDatabaseChangesResultBlock: ((_ operationResult: Result<(serverChangeToken: CKServerChangeToken, moreComing: Bool), any Error>) -> Void)?
}

@available(macOS 10.12, macCatalyst 13.1, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
@nonobjc extension CKFetchRecordZonesOperation {

    /// Called on success or failure for each record zone
    ///
    /// Each ``CKOperation`` instance has a private serial queue. This queue is used for all callback block invocations.
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var perRecordZoneResultBlock: ((_ recordZoneID: CKRecordZone.ID, _ recordZoneResult: Result<CKRecordZone, any Error>) -> Void)?

    /// This block is called when the operation completes.
    ///
    /// The top-level error will never be `CKError.partialFailure`.  Instead, per-item errors are surfaced in prior invocations of `perRecordZoneResultBlock`
    ///
    /// The `Operation.completionBlock` will also be called if both are set.
    /// 
    /// Each ``CKOperation`` instance has a private serial queue. This queue is used for all callback block invocations
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var fetchRecordZonesResultBlock: ((_ operationResult: Result<Void, any Error>) -> Void)?
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
@nonobjc extension CKModifyRecordZonesOperation {

    @available(swift 4.2)
    public convenience init(recordZonesToSave: [CKRecordZone]? = nil, recordZoneIDsToDelete: [CKRecordZone.ID]? = nil)

    /// Called on success or failure of a record zone save.
    ///
    /// Each ``CKOperation`` instance has a private serial queue. This queue is used for all callback block invocations.
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var perRecordZoneSaveBlock: ((_ recordZoneID: CKRecordZone.ID, _ saveResult: Result<CKRecordZone, any Error>) -> Void)?

    /// Called on success or failure of a record zone delete.
    ///
    /// Each ``CKOperation`` instance has a private serial queue. This queue is used for all callback block invocations.
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var perRecordZoneDeleteBlock: ((_ recordZoneID: CKRecordZone.ID, _ deleteResult: Result<Void, any Error>) -> Void)?

    /// This block is called when the operation completes.
    ///
    /// If the error is `CKError.partialFailure`, the error's `partialErrorsByItemID` is a dictionary of zoneIDs to errors.
    ///
    /// The `Operation.completionBlock` will also be called if both are set.
    /// 
    /// Each ``CKOperation`` instance has a private serial queue. This queue is used for all callback block invocations
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var modifyRecordZonesResultBlock: ((_ operationResult: Result<Void, any Error>) -> Void)?
}

@available(macOS 10.11, macCatalyst 13.1, iOS 9.2, tvOS 9.1, watchOS 3.0, *)
@nonobjc extension CKFetchWebAuthTokenOperation {

    /// This block is called when the operation completes.
    ///
    /// The `Operation.completionBlock` will also be called if both are set.
    /// 
    /// Each ``CKOperation`` instance has a private serial queue. This queue is used for all callback block invocations
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var fetchWebAuthTokenResultBlock: ((_ operationResult: Result<String, any Error>) -> Void)?
}

@available(macOS, introduced: 10.12, deprecated: 14.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
@available(macCatalyst, introduced: 13.1, deprecated: 17.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
@available(iOS, introduced: 10.0, deprecated: 17.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
@available(watchOS, introduced: 3.0, deprecated: 10.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
@available(visionOS, deprecated, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
@available(tvOS, unavailable)
@nonobjc extension CKDiscoverAllUserIdentitiesOperation {

    /// This block is called when the operation completes.
    ///
    /// The `Operation.completionBlock` will also be called if both are set.
    /// 
    /// Each ``CKOperation`` instance has a private serial queue. This queue is used for all callback block invocations.
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(macOS, introduced: 12.0, deprecated: 14.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(macCatalyst, introduced: 15.0, deprecated: 17.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(iOS, introduced: 15.0, deprecated: 17.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(watchOS, introduced: 8.0, deprecated: 10.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(visionOS, deprecated, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    public var discoverAllUserIdentitiesResultBlock: ((_ operationResult: Result<Void, any Error>) -> Void)?
}

@available(macOS, introduced: 10.12, deprecated: 14.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
@available(macCatalyst, introduced: 13.1, deprecated: 17.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
@available(iOS, introduced: 10.0, deprecated: 17.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
@available(tvOS, introduced: 10.0, deprecated: 17.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
@available(watchOS, introduced: 3.0, deprecated: 10.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
@available(visionOS, deprecated, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
@nonobjc extension CKDiscoverUserIdentitiesOperation {

    /// This block is called when the operation completes.
    ///
    /// The `Operation.completionBlock` will also be called if both are set.
    /// 
    /// Each ``CKOperation`` instance has a private serial queue. This queue is used for all callback block invocations.
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(macOS, introduced: 12.0, deprecated: 14.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(macCatalyst, introduced: 15.0, deprecated: 17.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(iOS, introduced: 15.0, deprecated: 17.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(tvOS, introduced: 15.0, deprecated: 17.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(watchOS, introduced: 8.0, deprecated: 10.0, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    @available(visionOS, deprecated, message: "No longer supported. Please see Sharing CloudKit Data with Other iCloud Users.")
    public var discoverUserIdentitiesResultBlock: ((_ operationResult: Result<Void, any Error>) -> Void)?
}

@available(macOS 10.12, macCatalyst 13.1, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
@nonobjc extension CKFetchShareParticipantsOperation {

    /// Called once for each lookup info
    ///
    /// Each ``CKOperation`` instance has a private serial queue. This queue is used for all callback block invocations.
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var perShareParticipantResultBlock: ((_ lookupInfo: CKUserIdentity.LookupInfo, _ shareParticipantResult: Result<CKShare.Participant, any Error>) -> Void)?

    /// This block is called when the operation completes.
    ///
    /// The top-level error will never be `CKError.partialFailure`.  Instead, per-item errors are surfaced in prior invocations of `perShareParticipantResultBlock`
    /// 
    /// The `Operation.completionBlock` will also be called if both are set.
    ///
    /// Each ``CKOperation`` instance has a private serial queue. This queue is used for all callback block invocations.
    /// This block may share mutable state with other blocks assigned to this operation, but any such mutable state
    /// should not be concurrently used outside of blocks assigned to this operation.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var fetchShareParticipantsResultBlock: ((_ operationResult: Result<Void, any Error>) -> Void)?
}

@available(macOS 10.10, macCatalyst 13.1, iOS 8.0, tvOS 9.0, watchOS 3.0, *)
@nonobjc extension CKOperation {

    public typealias ID = String

    /// This is an identifier unique to this ``CKOperation``.
    ///
    /// This value is chosen by the system, and will be unique to this instance of a ``CKOperation``.  This identifier will be sent to Apple's servers, and can be used to identify any server-side logging associated with this operation.
    @available(swift 4.2)
    @available(macOS 10.12, macCatalyst 13.1, iOS 9.3, tvOS 9.2, watchOS 3.0, *)
    public var operationID: CKOperation.ID { get }
}

@available(macOS 13.3, iOS 16.4, tvOS 16.4, watchOS 9.4, *)
@nonobjc extension CKOperation.Configuration : @unchecked Sendable {
}

@available(macOS 13.3, iOS 16.4, tvOS 16.4, watchOS 9.4, *)
@nonobjc extension CKOperationGroup : @unchecked Sendable {
}

