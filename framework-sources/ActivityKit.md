import Combine
import Foundation

/// The object you use to start, update, and end a Live Activity.
///
/// The `Activity` object offers functionality to start, update, and end a Live Activity from within your app.
/// You can update or end a Live Activity while your app is in the background, but you can only start a
/// Live Activity while the app is in the foreground.
///
/// Additionally, `Activity` offers functionality to observe changes to:
/// * The Live Activity
/// * The Live Activity's state in its life cycle
/// * A person's permission to start Live Activities
/// * The Live Activity's push token if you configure it to receive updates through ActivityKit push notifications.
///
/// To observe these changes, use the asynchronous sequences the activity object offers; for
/// example, use the ``ActivityKit/Activity/activityStateUpdates-swift.property``
/// sequence to observe changes to the state of a Live Activity.
@available(iOS 16.1, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public class Activity<Attributes> : Identifiable where Attributes : ActivityAttributes {

    /// The type alias for the structure that describes the dynamic content of a Live Activity.
    public typealias ContentState = Attributes.ContentState

    /// Requests and starts a Live Activity.
    ///
    /// Use this function to request and start a Live Activity from your app while it's in the foreground. Note
    /// that you can't do this while your app is in the background.
    ///
    /// If your Live Activity displays image assets, the system requires them to use a resolution that’s
    /// smaller or equal to the size of the Live Activity presentation for a device. If you use an image asset
    /// that’s larger than the size of the Live Activity presentation, the system may fail to start the Live
    /// Activity. For information about the sizes of Live Activity presentations, see
    /// [Human Interface Guidelines > Live Activities](https://developer.apple.com/design/human-interface-guidelines/components/system-experiences/live-activities).
    ///
    /// For additional information on starting a Live Activity, see <doc:displaying-live-data-with-live-activities>.
    ///
    /// - Parameters:
    ///     - attributes: A set of attributes that describe the Live Activity and its static content.
    ///     - contentState: A structure that describes the dynamic content of the Live Activity that changes over time.
    ///     - pushType: A value that indicates whether the Live Activity receives updates to its dynamic
    ///     content with ActivityKit push notifications. Pass `nil` to start a Live Activity that only receives
    ///     updates from the app with the ``ActivityKit/Activity/update(_:)`` function.
    ///     To start a Live Activity that receives updates to its dynamic content with ActivityKit push
    ///     notifications in addition to the ``ActivityKit/Activity/update(_:)`` function, pass
    ///     ``ActivityKit/PushType/token`` to this parameter.
    ///
    /// - Returns: The object that represents the started Live Activity.
    ///
    /// - Throws: ``ActivityKit/ActivityAuthorizationError`` if the app can't start a new Live Activity. For example, ``ActivityKit/ActivityAuthorizationError/denied`` indicates that a person deactivated Live Activities for the app.
    @available(iOS, deprecated: 16.2, message: "Use request(attributes:content:pushType:) instead")
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static func request(attributes: Attributes, contentState: Activity<Attributes>.ContentState, pushType: PushType? = nil) throws -> Activity<Attributes>

    /// Requests and starts a standard Live Activity.
    ///
    /// Use this function to request and start a standard Live Activity from your app while it's in the foreground. Note
    /// that you can't start a Live Activity while your app is in the background. The Live Activity that started
    /// continues until the app, a push notification,
    /// or a person ends it, or until it exceeds the maximum duration for Live Activities.
    ///
    /// Using this function is the same as passing ``ActivityStyle/standard`` to ``request(attributes:content:pushType:style:)``.
    /// To request a Live Activity that displays the expanded presentation in the Dynamic Island while the app is visible and ends automatically
    /// when a person performs other actions, use ``request(attributes:content:pushType:style:)`` and pass ``ActivityStyle/transient``
    /// to its `style` parameter.
    ///
    /// If your Live Activity displays image assets, the system requires them to use a resolution that’s
    /// smaller or equal to the size of the Live Activity presentation for a device. If you use an image asset
    /// that’s larger than the size of the Live Activity presentation, the system may fail to start the Live
    /// Activity. For information about the sizes of Live Activity presentations, see
    /// [Human Interface Guidelines > Live Activities](https://developer.apple.com/design/human-interface-guidelines/components/system-experiences/live-activities).
    ///
    /// For additional information on starting a Live Activity, see <doc:displaying-live-data-with-live-activities>.
    ///
    /// - Parameters:
    ///     - attributes: A set of attributes that describe the Live Activity and its static content.
    ///     - content: A structure that describes the dynamic content of the Live Activity that changes over time.
    ///     - pushType: A value that indicates whether the Live Activity receives updates to its dynamic
    ///     content with ActivityKit push notifications. Pass `nil` to start a Live Activity that only receives
    ///     updates from the app with the ``ActivityKit/Activity/update(_:)`` function.
    ///     To start a Live Activity that receives updates to its dynamic content with ActivityKit push notifications in
    ///     addition to the ``ActivityKit/Activity/update(_:)`` function, pass ``ActivityKit/PushType/token`` to this parameter.
    ///
    /// - Returns: The object that represents the Live Activity you started.
    ///
    /// - Throws: ``ActivityKit/ActivityAuthorizationError`` if the app can't start a
    ///     new Live Activity. For example, ``ActivityKit/ActivityAuthorizationError/denied``
    ///     indicates that the person deactivated Live Activities for the app.
    @available(iOS 16.2, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static func request(attributes: Attributes, content: ActivityContent<Activity<Attributes>.ContentState>, pushType: PushType? = nil) throws -> Activity<Attributes>

    /// Requests and starts a Live Activity.
    ///
    /// Use this function to request and start Live Activity from your app while it's in the foreground. Note
    /// that you can't start a Live Activity while your app is in the background.
    ///
    /// If your Live Activity displays image assets, the system requires them to use a resolution that’s
    /// smaller or equal to the size of the Live Activity presentation for a device. If you use an image asset
    /// that’s larger than the size of the Live Activity presentation, the system may fail to start the Live
    /// Activity. For information about the sizes of Live Activity presentations, see
    /// [Human Interface Guidelines > Live Activities](https://developer.apple.com/design/human-interface-guidelines/components/system-experiences/live-activities).
    ///
    /// For additional information on starting a Live Activity, see <doc:displaying-live-data-with-live-activities>.
    ///
    /// - Parameters:
    ///     - attributes: A set of attributes that describe the Live Activity and its static content.
    ///     - content: A structure that describes the dynamic content of the Live Activity that changes over time.
    ///     - pushType: A value that indicates whether the Live Activity receives updates to its dynamic
    ///     content with ActivityKit push notifications. Pass `nil` to start a Live Activity that only receives
    ///     updates from the app with the ``ActivityKit/Activity/update(_:)`` function.
    ///     To start a Live Activity that receives updates to its dynamic content with ActivityKit push notifications in
    ///     addition to the ``ActivityKit/Activity/update(_:)`` function, pass ``ActivityKit/PushType/token`` to this parameter.
    ///     - style: A flag that indicates whether the Live Activity uses standard or transient behavior. For most apps, passing ``ActivityStyle/standard``
    ///     is the best choice. It starts a standard Live Activity that continues until the app, a push notification, or a person ends it,
    ///     or until it exceeds the maximum duration for Live Activities.
    ///     By passing ``ActivityStyle/transient``, you start a Live Activity that appears in the extended presentation in the Dynamic Island
    ///     but ends automatically when a person automatically locks the device, collapses the extended presentation, leaves the app,
    ///     or performs other tasks outside the Dynamic Island.
    ///
    /// - Returns: The object that represents the Live Activity you started.
    ///
    /// - Throws: ``ActivityKit/ActivityAuthorizationError`` if the app can't start a
    ///     new Live Activity. For example, ``ActivityKit/ActivityAuthorizationError/denied``
    ///     indicates that the person deactivated Live Activities for the app.
    @available(iOS 18.0, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(visionOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static func request(attributes: Attributes, content: ActivityContent<Activity<Attributes>.ContentState>, pushType: PushType? = nil, style: ActivityStyle) throws -> Activity<Attributes>

    /// Requests and schedules a Live Activity for a specific date.
    ///
    /// Use this function to request Live Activity from your app while it's in the foreground. Note
    /// that you can't request a Live Activity while your app is in the background. The system starts the Live Activity at the specified
    /// date, even if the app is in the background. Note that you must provide an ``AlertConfiguration``. This
    /// makes sure that the system notifies people when your app starts the Live Activity.
    ///
    /// > Note: The system limits the number of simultaneous ongoing Live Activities. Scheduled Live Activities count towards this limit.
    ///
    /// If your Live Activity displays image assets, the system requires them to use a resolution that’s
    /// smaller or equal to the size of the Live Activity presentation for a device. If you use an image asset
    /// that’s larger than the size of the Live Activity presentation, the system may fail to start the Live
    /// Activity. For information about the sizes of Live Activity presentations, see
    /// [Human Interface Guidelines > Live Activities](https://developer.apple.com/design/human-interface-guidelines/components/system-experiences/live-activities).
    ///
    /// For additional information on starting a Live Activity, see <doc:displaying-live-data-with-live-activities>.
    ///
    /// - Parameters:
    ///     - attributes: A set of attributes that describe the Live Activity and its static content.
    ///     - content: A structure that describes the dynamic content of the Live Activity that changes over time.
    ///     - pushType: A value that indicates whether the Live Activity receives updates to its dynamic
    ///     content with ActivityKit push notifications. Pass `nil` to start a Live Activity that only receives
    ///     updates from the app with the ``ActivityKit/Activity/update(_:)`` function.
    ///     To start a Live Activity that receives updates to its dynamic content with ActivityKit push notifications in
    ///     addition to the ``ActivityKit/Activity/update(_:)`` function, pass ``ActivityKit/PushType/token`` to this parameter.
    ///     - style: A flag that indicates whether the Live Activity uses standard or transient behavior. For most apps, passing ``ActivityStyle/standard``
    ///     is the best choice. It starts a standard Live Activity that continues until the app, a push notification, or a person ends it,
    ///     or until it exceeds the maximum duration for Live Activities.
    ///     By passing ``ActivityStyle/transient``, you start a Live Activity that appears in the extended presentation in the Dynamic Island
    ///     but ends automatically when a person automatically locks the device, collapses the extended presentation, leaves the app,
    ///     or performs other tasks outside the Dynamic Island.
    ///     - alertConfiguration: The alert configuration you use to configure how the system notifies
    ///     a person about the updated content of the Live Activity.
    ///     - start: The date to schedule the start of your Live Activity; for example, for an upcoming sports game. You must provide
    ///     an `alertConfiguration` to let people know that your app started a Live Activity. The ``ActivityState`` for a scheduled
    ///     but not yet started Live Activity is ``ActivityState/pending``.
    ///
    /// - Returns: The object that represents the Live Activity you started.
    ///
    /// - Throws: ``ActivityKit/ActivityAuthorizationError`` if the app can't start a
    ///     new Live Activity. For example, ``ActivityKit/ActivityAuthorizationError/denied``
    ///     indicates that the person deactivated Live Activities for the app.
    @available(iOS 26.0, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(visionOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static func request(attributes: Attributes, content: ActivityContent<Activity<Attributes>.ContentState>, pushType: PushType? = nil, style: ActivityStyle, alertConfiguration: AlertConfiguration, start: Date) throws -> Activity<Attributes>

    @available(iOS, introduced: 26.0, deprecated: 26.0, message: "Use `request(attributes:content:pushType:style:alertConfiguration:start:)` instead")
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(visionOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static func request(attributes: Attributes, content: ActivityContent<Activity<Attributes>.ContentState>, pushType: PushType? = nil, style: ActivityStyle, alertConfiguration: AlertConfiguration, startDate: Date) throws -> Activity<Attributes>

    /// An array of your app's current Live Activities.
    public static var activities: [Activity<Attributes>] { get }

    /// An asynchronous sequence you use to observe changes to ongoing Live Activities and to asynchronously access a Live Activity when you start it.
    public static var activityUpdates: Activity<Attributes>.ActivityUpdates { get }

    /// A unique identifier for a Live Activity.
    final public let id: String

    /// The current state of a Live Activity in its life cycle.
    public var activityState: ActivityState { get }

    /// An asynchronous sequence you use to observe activity state changes.
    public var activityStateUpdates: Activity<Attributes>.ActivityStateUpdates { get }

    /// The dynamic content of a Live Activity.
    @available(iOS, deprecated: 16.2, message: "Use `content` instead")
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public var contentState: Activity<Attributes>.ContentState { get }

    /// An asynchronous sequence you use to observe changes to the dynamic content of a Live Activity.
    @available(iOS, deprecated: 16.2, message: "Use contentUpdates instead")
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public var contentStateUpdates: Activity<Attributes>.ContentStateUpdates { get }

    /// The dynamic content of a Live Activity.
    @available(iOS 16.2, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public var content: ActivityContent<Activity<Attributes>.ContentState> { get }

    /// An asynchronous sequence you use to observe changes to the dynamic content of a Live Activity.
    @available(iOS 16.2, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public var contentUpdates: Activity<Attributes>.ContentUpdates { get }

    /// The token you use to send ActivityKit push notifications to a Live Activity.
    ///
    /// The push token for a Live Activity may change over time. Use the ``ActivityKit/Activity/pushTokenUpdates``
    /// asynchronous sequence to receive the updated push token. When you receive an updated push
    /// token, make sure to send it to your server and invalidate the outdated token.
    public var pushToken: Data? { get }

    /// An asynchronous sequence you use to observe changes to the push token of a Live Activity.
    public var pushTokenUpdates: Activity<Attributes>.PushTokenUpdates { get }

    /// An asynchronous sequence you use to observe changes to the token
    /// for starting a Live Activity with an ActivityKit push notification.
    ///
    /// Adopt push notifications to not only
    /// update ongoing Live Activities, but also to start a new Live Activity.
    /// For additional information, see <doc:starting-and-updating-live-activities-with-activitykit-push-notifications>.
    @available(iOS 17.2, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static var pushToStartTokenUpdates: Activity<Attributes>.PushTokenUpdates { get }

    /// The token you use to start a Live Activity with an ActivityKit push
    /// notification.
    ///
    /// The push token for a Live Activity may change over time. Use the ``ActivityKit/Activity/pushToStartTokenUpdates``
    /// asynchronous sequence to receive an updated push-to-start token. When
    /// you receive an updated push token, make sure to send it to your server
    /// and invalidate the outdated token.
    @available(iOS 17.2, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static var pushToStartToken: Data? { get }

    /// A set of attributes that describe a Live Activity and its content.
    final public let attributes: Attributes

    /// Updates the dynamic content of the Live Activity.
    ///
    /// Use this function to update the Live Activity while your app is in the foreground or while it's in the background —
    /// for example, by using <doc://com.apple.documentation/documentation/backgroundtasks>.
    ///
    /// > Note: The system ignores attempts to update a Live Activity that ended.
    ///
    /// - Parameters:
    ///     - contentState: The updated dynamic content for the Live Activity. The size of
    ///     the encoded content can't exceed 4KB in size.
    @available(iOS, deprecated: 16.2, message: "Use update(_:) instead")
    @available(watchOS, unavailable)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    public func update(using contentState: Activity<Attributes>.ContentState) async

    /// Updates the dynamic content of the Live Activity.
    ///
    /// Use this function to update the Live Activity while your app is in the foreground or while it's in the background —
    /// for example, by using <doc://com.apple.documentation/documentation/backgroundtasks>.
    ///
    /// > Note: The system ignores attempts to update a Live Activity that ended.
    ///
    /// - Parameters:
    ///     - content: The updated dynamic content for the Live Activity. The size of its
    ///      ``ActivityKit/ActivityContent/state`` property can't exceed 4KB in size.
    @available(iOS 16.2, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func update(_ content: ActivityContent<Activity<Attributes>.ContentState>) async

    /// Updates the dynamic content of a Live Activity and alerts a person about the Live Activity update.
    ///
    /// The system ignores updates to a Live Activity that's in the ``ActivityKit/ActivityState/ended``
    /// state.
    ///
    /// - Parameters:
    ///     - contentState: The updated dynamic content for the Live Activity. The size of
    ///     the encoded content can't exceed 4KB in size.
    ///     - alertConfiguration: The alert configuration you use to configure how the system notifies
    ///     a person about the updated content of the Live Activity.
    @available(iOS, deprecated: 16.2, message: "Use update(_:alertConfiguration:) instead")
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func update(using contentState: Activity<Attributes>.ContentState, alertConfiguration: AlertConfiguration? = nil) async

    /// Updates the dynamic content of a Live Activity and alerts a person about the Live Activity update.
    ///
    /// The system ignores updates to a Live Activity that's in the ``ActivityKit/ActivityState/ended``
    /// state.
    ///
    /// - Parameters:
    ///     - content: The updated dynamic content for the Live Activity. The size of its
    ///      ``ActivityKit/ActivityContent/state`` property can't exceed 4KB in size.
    ///     - alertConfiguration: The alert configuration you use to configure how the system notifies
    ///     a person about the updated content of the Live Activity.
    @available(iOS 16.2, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func update(_ content: ActivityContent<Activity<Attributes>.ContentState>, alertConfiguration: AlertConfiguration? = nil) async

    /// Updates the dynamic content of a Live Activity and alerts a person about the Live Activity update.
    ///
    /// The system ignores updates to a Live Activity that's in the ``ActivityKit/ActivityState/ended``
    /// state.
    ///
    /// - Parameters:
    ///     - content: The updated dynamic content for the Live Activity. The size of its
    ///      ``ActivityKit/ActivityContent/state`` property can't exceed 4KB in size.
    ///     - alertConfiguration: The alert configuration you use to configure how the system notifies
    ///     a person about the updated content of the Live Activity.
    ///     - timestamp: The time the data in the payload was generated. If this is older than a previous 
    ///     update or push payload, the system ignores this update.
    @available(iOS 17.2, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func update(_ content: ActivityContent<Activity<Attributes>.ContentState>, alertConfiguration: AlertConfiguration? = nil, timestamp: Date) async

    /// Ends an active Live Activity.
    ///
    /// End an active Live Activity while your app is in the foreground or while it's in the background —
    /// for example, by using <doc://com.apple.documentation/documentation/backgroundtasks>.
    ///
    /// Include updated data in the `contentState` parameter to ensure the Live Activity shows the
    /// latest and final content update after it ends. This is important because the Live Activity remains
    /// visible until the system or the person removes it.
    ///
    /// - Parameters:
    ///     - contentState: The latest and final dynamic content for the Live Activity that ended.
    ///     The size of the encoded content can't exceed 4KB in size.
    ///     - dismissalPolicy: Describes how and when the system should dismiss a Live Activity and
    ///     and remove it from the Lock Screen.
    @available(iOS, deprecated: 16.2, message: "Use end(content:dismissalPolicy:) instead")
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func end(using contentState: Activity<Attributes>.ContentState? = nil, dismissalPolicy: ActivityUIDismissalPolicy = .default) async

    /// Ends an active Live Activity.
    ///
    /// End an active Live Activity while your app is in the foreground or while it's in the background —
    /// for example, by using <doc://com.apple.documentation/documentation/backgroundtasks>.
    /// When you end a Live Activity, include a final content update using the `content` parameter to
    /// ensure the Live Activity shows the latest and final content update after it ends. This is important
    /// because the Live Activity may remain visible until the system or the person removes it.
    ///
    /// - Parameters:
    ///     - content: The latest and final dynamic content for the Live Activity that ended.
    ///     The size of the encoded content can't exceed 4KB in size.
    ///     - dismissalPolicy: Describes how and when the system should dismiss a Live Activity and
    ///     and remove it from the Lock Screen.
    @available(iOS 16.2, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func end(_ content: ActivityContent<Activity<Attributes>.ContentState>?, dismissalPolicy: ActivityUIDismissalPolicy = .default) async

    /// Ends an active Live Activity.
    ///
    /// End an active Live Activity while your app is in the foreground or while it's in the background —
    /// for example, by using <doc://com.apple.documentation/documentation/backgroundtasks>.
    /// When you end a Live Activity, include a final content update using the `content` parameter to
    /// ensure the Live Activity shows the latest and final content update after it ends. This is important
    /// because the Live Activity may remain visible until the system or the person removes it.
    ///
    /// - Parameters:
    ///     - content: The latest and final dynamic content for the Live Activity that ended.
    ///     The size of the encoded content can't exceed 4KB in size.
    ///     - dismissalPolicy: Describes how and when the system should dismiss a Live Activity and
    ///     and remove it from the Lock Screen.
    ///     - timestamp: The time the data in the payload was generated. If this is older than a previous
    ///     update or push payload, the system ignores this update.
    @available(iOS 17.2, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func end(_ content: ActivityContent<Activity<Attributes>.ContentState>?, dismissalPolicy: ActivityUIDismissalPolicy = .default, timestamp: Date) async

    /// A type representing the stable identity of the entity associated with
    /// an instance.
    @available(iOS 16.1, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    public typealias ID = String

    @objc deinit
}

@available(iOS 16.1, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Activity {

    /// A structure that offers functionality to observe changes to a Live Activity.
    public struct ActivityUpdates : AsyncSequence {

        /// The type of element this asynchronous sequence produces.
        public typealias Element = Activity<Attributes>

        /// Creates the asynchronous iterator that produces results from this asynchronous sequence.
        public func makeAsyncIterator() -> Activity<Attributes>.ActivityUpdates.Iterator

        /// An iterator for accessing individual data entries from the series.
        public struct Iterator : AsyncIteratorProtocol {

            /// Asynchronously advances to the next element and returns it, or ends the
            /// sequence if there is no next element.
            ///
            /// - Returns: The next element, if it exists, or `nil` to signal the end of
            ///   the sequence.
            public func next() async -> Activity<Attributes>.ActivityUpdates.Element?

            @available(iOS 16.1, *)
            @available(tvOS, unavailable)
            @available(watchOS, unavailable)
            @available(macOS, unavailable)
            @available(macCatalyst, unavailable)
            public typealias Element = Activity<Attributes>.ActivityUpdates.Element
        }

        /// The type of asynchronous iterator that produces elements of this
        /// asynchronous sequence.
        @available(iOS 16.1, *)
        @available(tvOS, unavailable)
        @available(watchOS, unavailable)
        @available(macOS, unavailable)
        @available(macCatalyst, unavailable)
        public typealias AsyncIterator = Activity<Attributes>.ActivityUpdates.Iterator
    }

    /// A structure that offers functionality to observe state changes of a Live Activity.
    public struct ActivityStateUpdates : AsyncSequence {

        /// The type of element this asynchronous sequence produces.
        public typealias Element = ActivityState

        /// Creates the asynchronous iterator that produces results from this asynchronous sequence.
        public func makeAsyncIterator() -> Activity<Attributes>.ActivityStateUpdates.Iterator

        /// An iterator for accessing individual data entries from the series.
        public struct Iterator : AsyncIteratorProtocol, Sendable {

            /// Asynchronously advances to the next element and returns it, or ends the
            /// sequence if there is no next element.
            ///
            /// - Returns: The next element, if it exists, or `nil` to signal the end of
            ///   the sequence.
            public func next() async -> Activity<Attributes>.ActivityStateUpdates.Element?

            @available(iOS 16.1, *)
            @available(tvOS, unavailable)
            @available(watchOS, unavailable)
            @available(macOS, unavailable)
            @available(macCatalyst, unavailable)
            public typealias Element = Activity<Attributes>.ActivityStateUpdates.Element
        }

        /// The type of asynchronous iterator that produces elements of this
        /// asynchronous sequence.
        @available(iOS 16.1, *)
        @available(tvOS, unavailable)
        @available(watchOS, unavailable)
        @available(macOS, unavailable)
        @available(macCatalyst, unavailable)
        public typealias AsyncIterator = Activity<Attributes>.ActivityStateUpdates.Iterator
    }

    /// A structure that offers functionality to observe changes to the dynamic content of a Live Activity.
    @available(iOS, deprecated: 16.2, message: "Use `ContentUpdates` instead")
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public struct ContentStateUpdates : AsyncSequence {

        /// The type of element this asynchronous sequence produces.
        public typealias Element = Activity<Attributes>.ContentState

        /// Creates the asynchronous iterator that produces results from this asynchronous sequence.
        public func makeAsyncIterator() -> Activity<Attributes>.ContentStateUpdates.Iterator

        /// An iterator for accessing individual data entries from the series.
        public struct Iterator : AsyncIteratorProtocol {

            /// Asynchronously advances to the next element and returns it, or ends the
            /// sequence if there is no next element.
            ///
            /// - Returns: The next element, if it exists, or `nil` to signal the end of
            ///   the sequence.
            public func next() async -> Activity<Attributes>.ContentStateUpdates.Element?

            @available(iOS, introduced: 16.1, deprecated: 16.2, message: "Use `ContentUpdates` instead")
            @available(tvOS, unavailable)
            @available(watchOS, unavailable)
            @available(macOS, unavailable)
            @available(macCatalyst, unavailable)
            public typealias Element = Activity<Attributes>.ContentStateUpdates.Element
        }

        /// The type of asynchronous iterator that produces elements of this
        /// asynchronous sequence.
        @available(iOS, introduced: 16.1, deprecated: 16.2, message: "Use `ContentUpdates` instead")
        @available(tvOS, unavailable)
        @available(watchOS, unavailable)
        @available(macOS, unavailable)
        @available(macCatalyst, unavailable)
        public typealias AsyncIterator = Activity<Attributes>.ContentStateUpdates.Iterator
    }

    /// A structure that offers functionality to observe changes to the dynamic content of a Live Activity.
    @available(iOS 16.2, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public struct ContentUpdates : AsyncSequence {

        /// The type of element this asynchronous sequence produces.
        public typealias Element = ActivityContent<Activity<Attributes>.ContentState>

        /// Creates the asynchronous iterator that produces results from this asynchronous sequence.
        public func makeAsyncIterator() -> Activity<Attributes>.ContentUpdates.Iterator

        /// An iterator for accessing individual data entries from the series.
        public struct Iterator : AsyncIteratorProtocol {

            /// Asynchronously advances to the next element and returns it, or ends the
            /// sequence if there is no next element.
            ///
            /// - Returns: The next element, if it exists, or `nil` to signal the end of
            ///   the sequence.
            public func next() async -> Activity<Attributes>.ContentUpdates.Element?

            @available(iOS 16.2, *)
            @available(tvOS, unavailable)
            @available(watchOS, unavailable)
            @available(macOS, unavailable)
            @available(macCatalyst, unavailable)
            public typealias Element = Activity<Attributes>.ContentUpdates.Element
        }

        /// The type of asynchronous iterator that produces elements of this
        /// asynchronous sequence.
        @available(iOS 16.2, *)
        @available(tvOS, unavailable)
        @available(watchOS, unavailable)
        @available(macOS, unavailable)
        @available(macCatalyst, unavailable)
        public typealias AsyncIterator = Activity<Attributes>.ContentUpdates.Iterator
    }

    /// A structure that offers functionality to observe changes to the push token of a Live Activity.
    public struct PushTokenUpdates : AsyncSequence {

        /// The type of element this asynchronous sequence produces.
        public typealias Element = Data

        /// Creates the asynchronous iterator that produces results from this asynchronous sequence.
        public func makeAsyncIterator() -> Activity<Attributes>.PushTokenUpdates.Iterator

        /// An iterator for accessing individual data entries from the series.
        public struct Iterator : AsyncIteratorProtocol {

            /// Asynchronously advances to the next element and returns it, or ends the
            /// sequence if there is no next element.
            ///
            /// - Returns: The next element, if it exists, or `nil` to signal the end of
            ///   the sequence.
            public func next() async -> Activity<Attributes>.PushTokenUpdates.Element?

            @available(iOS 16.1, *)
            @available(tvOS, unavailable)
            @available(watchOS, unavailable)
            @available(macOS, unavailable)
            @available(macCatalyst, unavailable)
            public typealias Element = Activity<Attributes>.PushTokenUpdates.Element
        }

        /// The type of asynchronous iterator that produces elements of this
        /// asynchronous sequence.
        @available(iOS 16.1, *)
        @available(tvOS, unavailable)
        @available(watchOS, unavailable)
        @available(macOS, unavailable)
        @available(macCatalyst, unavailable)
        public typealias AsyncIterator = Activity<Attributes>.PushTokenUpdates.Iterator
    }
}

/// The protocol you implement to describe the content of a Live Activity.
///
/// The `ActivityAttributes` protocol describes the content that appears in your Live Activity. Its
/// inner type ``ActivityKit/ActivityAttributes/ContentState`` represents the dynamic content
/// of the Live Activity.
///
/// The following example shows an implementation of the `ActivityAttributes` protocol for a pizza
/// delivery app. The app's Live Activity shows the number of ordered pizzas and the total amount on the
/// bill as static data and the name of the driver and an estimated delivery time as dynamic data that changes
/// over time. Note how the implementation defines the type alias `PizzaDeliveryStatus` to make
/// the code more descriptive and easier to read.
///
/// ```swift
/// public import Foundation
/// import ActivityKit
///
/// struct PizzaDeliveryAttributes: ActivityAttributes {
///     public typealias PizzaDeliveryStatus = ContentState
///
///     public struct ContentState: Codable, Hashable {
///         var driverName: String
///         var deliveryTimer: ClosedRange<Date>
///     }
///
///     var numberOfPizzas: Int
///     var totalAmount: String
///     var orderNumber: String
/// }
/// ```
@available(iOS 16.1, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public protocol ActivityAttributes : Decodable, Encodable {

    /// The associated type that describes the dynamic content of a Live Activity.
    ///
    /// The dynamic data of a Live Activity that's encoded by `ContentState` can't exceed 4KB.
    associatedtype ContentState : Decodable, Encodable, Hashable
}

/// An error that indicates why the request to start a Live Activity failed.
@available(iOS 16.1, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public enum ActivityAuthorizationError : CustomNSError, LocalizedError {

    /// The domain for errors that can happen when starting a Live Activity.
    public static var errorDomain: String { get }

    /// The provided Live Activity attributes exceeded the maximum size of 4KB.
    case attributesTooLarge

    /// The device doesn't support Live Activities.
    case unsupported

    /// A person deactivated Live Activities in Settings.
    case denied

    /// The device reached the maximum number of ongoing Live Activities.
    case globalMaximumExceeded

    /// The app has already started the maximum number of concurrent Live Activities.
    case targetMaximumExceeded

    /// The app doesn't have the required entitlement to start a Live Activities.
    case unsupportedTarget

    /// The app tried to start the Live Activity while it was in the background.
    case visibility

    /// The system couldn't persist the Live Activity.
    case persistenceFailure

    /// The process that tried to start the Live Activity is missing a process identifier.
    case missingProcessIdentifier

    /// The app doesn't have the required entitlement to start a Live Activity.
    case unentitled

    /// The provided activity identifier is malformed.
    case malformedActivityIdentifier

    /// The process that tried to recreate the Live Activity is not the process
    /// that originally created the Live Activity.
    case reconnectNotPermitted

    /// An integer value that represents the error code.
    public var errorCode: Int { get }

    /// A string that describes the error that occurred.
    public var failureReason: String? { get }

    /// A localized message that describes how to recover from the error.
    public var recoverySuggestion: String? { get }

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (a: ActivityAuthorizationError, b: ActivityAuthorizationError) -> Bool

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

@available(iOS 16.1, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension ActivityAuthorizationError : Equatable {
}

@available(iOS 16.1, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension ActivityAuthorizationError : Hashable {
}

/// An object with information about whether a person allowed your app to start Live Activities and permitted
/// content updates with frequent ActivityKit push notifications.
///
/// By default, your app can start, update, and end a Live Activity if you use ActivityKit to offer
/// Live Activities. However, a person can deactivate Live Activities for an app in Settings. To check if your
/// app can start, update, or end a Live Activity, use the synchronous ``ActivityKit/ActivityAuthorizationInfo/areActivitiesEnabled``
/// property or the asynchronous ``ActivityKit/ActivityAuthorizationInfo/activityEnablementUpdates-swift.property``
/// sequence.
///
/// Similarly, `ActivityAuthorizationInfo` provides functionality to check whether a person has
/// permitted your app to update Live Activities with frequent ActivityKit push notifications. To check whether
/// you can send frequent ActivityKit push notifications to update Live Activity content, use the synchronous
/// ``ActivityKit/ActivityAuthorizationInfo/frequentPushesEnabled`` property or the
/// asynchronous ``ActivityKit/ActivityAuthorizationInfo/frequentPushEnablementUpdates-swift.property``
/// sequence.
///
/// > Note: To update a Live Activity with frequent ActivityKit push notifications, add the
/// `NSSupportsFrequentLiveActivityUpdates` key with a Boolean value of `YES` to your app's
/// `Info.plist` file. For additional information, see <doc:starting-and-updating-live-activities-with-activitykit-push-notifications>.
@available(iOS 16.1, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
final public class ActivityAuthorizationInfo {

    /// A structure that offers functionality to observe whether your app can start a Live Activity.
    public struct ActivityEnablementUpdates : AsyncSequence {

        /// The type of element this asynchronous sequence produces.
        public typealias Element = Bool

        /// Creates the asynchronous iterator that produces results from this asynchronous sequence.
        public func makeAsyncIterator() -> ActivityAuthorizationInfo.ActivityEnablementUpdates.Iterator

        /// An iterator for accessing individual data entries from the series.
        public struct Iterator : AsyncIteratorProtocol {

            /// Asynchronously advances to the next element and returns it, or ends the sequence if there is no next element.
            public mutating func next() async -> Bool?

            @available(iOS 16.1, *)
            @available(tvOS, unavailable)
            @available(watchOS, unavailable)
            @available(macOS, unavailable)
            @available(macCatalyst, unavailable)
            public typealias Element = Bool
        }

        /// The type of asynchronous iterator that produces elements of this
        /// asynchronous sequence.
        @available(iOS 16.1, *)
        @available(tvOS, unavailable)
        @available(watchOS, unavailable)
        @available(macOS, unavailable)
        @available(macCatalyst, unavailable)
        public typealias AsyncIterator = ActivityAuthorizationInfo.ActivityEnablementUpdates.Iterator
    }

    /// A structure that can observe whether you can update Live Activities with frequent
    /// ActivityKit push notifications.
    @available(iOS 16.2, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public struct FrequentPushEnablementUpdates : AsyncSequence {

        /// The type of element this asynchronous sequence produces.
        public typealias Element = Bool

        /// Creates the asynchronous iterator that produces results from this asynchronous sequence.
        public func makeAsyncIterator() -> ActivityAuthorizationInfo.FrequentPushEnablementUpdates.Iterator

        /// An iterator for accessing individual data entries from the series.
        public struct Iterator : AsyncIteratorProtocol {

            /// Asynchronously advances to the next element and returns it, or ends the sequence if there is no next element.
            public mutating func next() async -> Bool?

            @available(iOS 16.2, *)
            @available(tvOS, unavailable)
            @available(watchOS, unavailable)
            @available(macOS, unavailable)
            @available(macCatalyst, unavailable)
            public typealias Element = Bool
        }

        /// The type of asynchronous iterator that produces elements of this
        /// asynchronous sequence.
        @available(iOS 16.2, *)
        @available(tvOS, unavailable)
        @available(watchOS, unavailable)
        @available(macOS, unavailable)
        @available(macCatalyst, unavailable)
        public typealias AsyncIterator = ActivityAuthorizationInfo.FrequentPushEnablementUpdates.Iterator
    }

    /// A Boolean value that indicates whether a person permitted you to update Live Activities with frequent
    /// ActivityKit push notifications.
    @available(iOS 16.2, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    final public var frequentPushesEnabled: Bool { get }

    /// A Boolean value that indicates whether your app can start a Live Activity.
    final public var areActivitiesEnabled: Bool { get }

    /// An asynchronous sequence you use to observe whether your app can start a Live Activity.
    final public let activityEnablementUpdates: ActivityAuthorizationInfo.ActivityEnablementUpdates

    /// An asynchronous sequence you use to observe whether a person permitted you to update Live
    /// Activities with frequent ActivityKit push notifications.
    @available(iOS 16.2, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    final public let frequentPushEnablementUpdates: ActivityAuthorizationInfo.FrequentPushEnablementUpdates

    /// Creates an object you use to observe user authorizations for starting Live Activities and updating them
    /// with ActivityKit push notifications.
    public init()

    @objc deinit
}

/// A structure that describes the state and configuration of a Live Activity.
@available(iOS 16.2, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct ActivityContent<State> where State : Decodable, State : Encodable, State : Hashable {

    /// The current state of a Live Activity in its life cycle.
    ///
    /// This value is the same as ``ActivityKit/Activity/activityState``.
    public let state: State

    /// The date when the system considers the Live Activity to be
    /// out of date.
    ///
    /// When time reaches the configured stale date, the system considers the
    /// Live Activity out of date, and the ``ActivityKit/ActivityState`` of the
    /// Live Activity changes to ``ActivityKit/ActivityState/stale``.
    public let staleDate: Date?

    /// A score you assign that determines the order in which your Live Activities
    /// appear when you start several Live Activities for your app.
    ///
    /// If you start more than one Live Activity in your app, the Live Activity
    /// with the highest relevance score appears in the Dynamic Island. If Live Activities
    /// have the same relevance score, the system displays the Live Activity
    /// that started first. Additionally, the `relevanceScore`
    /// determines the order of your Live Activities on the Lock Screen.
    public let relevanceScore: Double

    /// Creates the object that describes the state and configuration of a Live Activity.
    public init(state: State, staleDate: Date?, relevanceScore: Double = 0.0)
}

@available(iOS 16.2, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension ActivityContent : Sendable where State : Sendable {
}

@available(iOS 16.2, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension ActivityContent : CustomStringConvertible {

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

/// The enum that describes the state of a Live Activity in its life cycle.
@available(iOS 16.1, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public enum ActivityState : Sendable, Codable, Hashable {

    /// The Live Activity is scheduled to start at a specified date but hasn't started yet.
    @available(iOS 26.0, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    case pending

    /// The Live Activity is active, visible, and can receive content updates.
    case active

    /// The Live Activity is visible, but a person, the app, or the system ended it, and it won't update its content
    /// anymore.
    case ended

    /// The Live Activity ended and is no longer visible because a person or the system removed it.
    case dismissed

    /// The Live Activity content is out of date and needs an update.
    ///
    /// The content of a Live Activity may become out of date before you can update it. For example, a person
    /// may be in an area without a network connection, causing the Live Activity to not receive updates.
    /// To tell people that they are looking at outdated Live Activity content, you can configure
    /// a ``ActivityKit/ActivityContent/staleDate`` for your Live Activity. At the specified
    /// date, the ``ActivityKit/Activity/activityState`` changes to `stale` and you can
    /// update the Live Activity to indicate that its content is out of date.
    @available(iOS 16.2, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    case stale

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (a: ActivityState, b: ActivityState) -> Bool

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

    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: any Decoder) throws
}

@available(iOS 16.1, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public enum ActivityStyle {

    case standard

    case transient

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (a: ActivityStyle, b: ActivityStyle) -> Bool

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

@available(iOS 16.1, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension ActivityStyle : Equatable {
}

@available(iOS 16.1, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension ActivityStyle : Hashable {
}

/// The structure that describes when the system should remove a Live Activity that ended.
@available(iOS 16.1, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct ActivityUIDismissalPolicy : Equatable, Sendable {

    /// The system's default dismissal policy for the Live Activity.
    ///
    /// With the default dismissal policy, the system keeps a Live Activity that ended on the Lock Screen for
    /// up to four hours after it ends or a person removes it. The ``ActivityKit/ActivityState``
    /// doesn't change to ``ActivityKit/ActivityState/dismissed`` until a person or the system
    /// removes the Live Activity user interface.
    public static let `default`: ActivityUIDismissalPolicy

    /// The system immediately removes the Live Activity that ended.
    ///
    /// With the `immediate` dismissal policy, the system immediately removes the ended Live Activity
    /// and the ``ActivityKit/ActivityState`` changes to
    /// ``ActivityKit/ActivityState/dismissed``.
    public static let immediate: ActivityUIDismissalPolicy

    /// The system removes the Live Activity that ended at the specified time within a four-hour window.
    /// 
    /// Provide a date to tell the system when it should remove a Live Activity that ended. While you can
    /// provide any date, the system removes a Live Activity that ended after the specified date or after four
    /// hours from the moment the Live Activity ended — whichever comes first. When the system
    /// removes the Live Activity,  the ``ActivityKit/ActivityState`` changes to ``ActivityKit/ActivityState/dismissed``.
    ///
    /// - Parameters:
    ///     - date: A date within a four-hour window from the moment the Live Activity ends.
    public static func after(_ date: Date) -> ActivityUIDismissalPolicy

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (a: ActivityUIDismissalPolicy, b: ActivityUIDismissalPolicy) -> Bool
}

/// A structure you use to configure an alert that appears when you update your Live Activity.
@available(iOS 16.1, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct AlertConfiguration : Equatable, Sendable {

    /// A short title that describes the purpose of the Live Activity update on Apple Watch.
    ///
    /// Apple Watch displays this string briefly as part of the alert that appears
    /// when you update a Live Activity and choose to alert people about the update.
    /// Choose text that's easy to read at a glance. For example, a pizza delivery app could use "On the way."
    public var title: LocalizedStringResource

    /// The main text that appears on the alert for a Live Activity update on Apple Watch.
    ///
    /// Apple Watch displays this string briefly as part of the alert that appears
    /// when you update a Live Activity and choose to alert people about the update.
    /// Choose text that's easy to read at a glance. For example, a pizza delivery app could use
    /// "Your order will arrive in 25 minutes."
    public var body: LocalizedStringResource

    /// The sound the system plays when the Live Activity alert appears on a person's device.
    public var sound: AlertConfiguration.AlertSound

    /// Initializes a new alert configuration for a Live Activity update.
    ///
    /// - Parameters:
    ///     - title: The short title that describes the purpose of the Live Activity update.
    ///     - body: The main text of the alert for a Live Activity update.
    ///     - sound: The sound that the system plays when the alert appears on a person's device.
    public init(title: LocalizedStringResource, body: LocalizedStringResource, sound: AlertConfiguration.AlertSound)

    /// An object that describes the sound to play for a Live Activity update alert.
    public struct AlertSound : Equatable, Sendable {

        /// A value that represents the system's default alert sound.
        public static var `default`: AlertConfiguration.AlertSound { get }

        /// A function you use to configure a custom sound for a Live Activity update alert.
        ///
        /// - Parameters:
        ///     - name: The name of the sound file to use for the alert. Choose a file that's in your app's main bundle
        ///     or the `Library/Sounds` folder of your app's data container.
        public static func named(_ name: String) -> AlertConfiguration.AlertSound

        /// Returns a Boolean value indicating whether two values are equal.
        ///
        /// Equality is the inverse of inequality. For any values `a` and `b`,
        /// `a == b` implies that `a != b` is `false`.
        ///
        /// - Parameters:
        ///   - lhs: A value to compare.
        ///   - rhs: Another value to compare.
        public static func == (a: AlertConfiguration.AlertSound, b: AlertConfiguration.AlertSound) -> Bool
    }

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (a: AlertConfiguration, b: AlertConfiguration) -> Bool
}

/// The structure that offers constants you use to configure a Live Activity to receive updates through ActivityKit
/// push notifications.
///
/// Pass the ``ActivityKit/PushType/token`` constant to the
/// ``ActivityKit/Activity/request(attributes:contentState:pushType:)`` function
/// to start a Live Activity that receives content updates with ActivityKit push notifications. Pass ``ActivityKit/PushType/channel(_:)`` to ``ActivityKit/Activity/request(attributes:contentState:pushType:)`` function to specify that you want to use a broadcast channel instead of a token. You can only specify one ``PushType``.
///
/// To learn more about using ActivityKit push notifications to update your Live Activity, see
/// <doc:starting-and-updating-live-activities-with-activitykit-push-notifications>.
@available(iOS 16.1, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct PushType : Equatable {

    /// A constant you use to configure a Live Activity that updates its dynamic content by receiving
    /// ActivityKit push notifications.
    public static var token: PushType { get }

    /// A constant to configure a Live Activity that updates its dynamic content for broadcast channels.
    ///
    /// The channel ID is a base64-encoded string.
    /// For information on creating a channel, refer to
    ///  <doc://com.apple.documentation/documentation/usernotifications/sending-channel-management-requests-to-apns>.
    ///  The code snippet below is an example of how to specify that you want to use a broadcast push channel.
    ///  
    ///```swift
    ///Activity.request(attributes: attributes, 
    ///content: content,
    ///pushType: .channel("c29tZUNoYW5uZWw="))
    ///```
    @available(iOS 18.0, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    public static func channel(_ name: String) -> PushType

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (a: PushType, b: PushType) -> Bool
}

