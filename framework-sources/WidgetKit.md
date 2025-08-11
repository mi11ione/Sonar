import ActivityKit
import AppIntents
import DeveloperToolsSupport
import Intents
import SwiftUI
import WidgetKit.WGWidgetDefines

/// An adaptive background view that provides a standard appearance based on the
/// the widget's environment.
///
/// Use this view to provide a standardized background for your accessory
/// widgets. Place the view in
/// a <doc://com.apple.documentation/documentation/swiftui/ZStack> behind your
/// widget's content.
///
///
/// ``` Swift
/// ZStack {
///     AccessoryWidgetBackground()
///     VStack {
///         Text("MON")
///             .font(.caption)
///             .widgetAccented()
///         Text("6")
///             .font(.title)
///     }
/// }
/// ```
///
/// The system only displays this view inside a
/// ``WidgetKit/WidgetFamily/accessoryCircular``,
/// ``WidgetKit/WidgetFamily/accessoryCorner``, or
/// ``WidgetKit/WidgetFamily/accessoryRectangular`` widget. In any other
/// context, the system displays an empty view instead.
///
@available(iOS 16.0, watchOS 9.0, macOS 13.0, visionOS 26.0, *)
@available(tvOS, unavailable)
@MainActor @preconcurrency public struct AccessoryWidgetBackground : View {

    /// Creates an instance of an accessory widget background.
    @MainActor @preconcurrency public init()

    /// The content and behavior of the view.
    ///
    /// When you implement a custom view, you must implement a computed
    /// `body` property to provide the content for your view. Return a view
    /// that's composed of built-in views that SwiftUI provides, plus other
    /// composite views that you've already defined:
    ///
    ///     struct MyView: View {
    ///         var body: some View {
    ///             Text("Hello, World!")
    ///         }
    ///     }
    ///
    /// For more information about composing views and a view hierarchy,
    /// see <doc:Declaring-a-Custom-View>.
    @MainActor @preconcurrency public var body: some View { get }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    @available(iOS 16.0, watchOS 9.0, visionOS 26.0, macOS 13.0, *)
    @available(tvOS, unavailable)
    public typealias Body = some View
}

@available(iOS 16.0, watchOS 9.0, macOS 13.0, visionOS 26.0, *)
@available(tvOS, unavailable)
extension AccessoryWidgetBackground : Sendable {
}

/// An object that describes the content of a Live Activity.
///
/// To learn more about offering Live Activities for your app, see
/// <doc://com.apple.documentation/documentation/ActivityKit>.
@available(iOS 16.1, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
@MainActor @preconcurrency public struct ActivityConfiguration<Attributes> : WidgetConfiguration where Attributes : ActivityAttributes {

    /// Creates a configuration object for a Live Activity.
    ///
    /// - Parameters:
    ///   - attributesType: The type that describes the content of the Live Activity.
    ///   - content: A closure that creates the view for the Live Activity that appears on the Lock Screen.
    ///   This view also appears as a banner on the Home Screen of devices that don't support the
    ///   Dynamic Island when you alert a person about updated Live Activity content.
    ///   - dynamicIsland: A closure that builds the Live Activity that appears in the Dynamic Island.
    ///
    @MainActor @preconcurrency public init<Content>(for attributesType: Attributes.Type, @ViewBuilder content: @escaping (ActivityViewContext<Attributes>) -> Content, dynamicIsland: @escaping (ActivityViewContext<Attributes>) -> DynamicIsland) where Content : View

    /// The content and behavior of this widget.
    @MainActor @preconcurrency public var body: some WidgetConfiguration { get }

    /// The type of widget configuration representing the body of
    /// this configuration.
    ///
    /// When you create a custom widget, Swift infers this type from your
    /// implementation of the required `body` property.
    @available(iOS 16.1, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    public typealias Body = some WidgetConfiguration
}

@available(iOS 16.1, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension ActivityConfiguration : Sendable {
}

/// A family that defines the Live Activity's size.
///
/// Live Activities support one or more sizes, giving you the
/// flexibility to configure them for different devices. A Live Activity
/// renders for a specific family, depending on both the device and the
/// location in which it's displayed.
///
/// A Live Activity initiated on one device can be sent to a remote device
/// that renders the Live Activity at a different family size. For example,
/// if your Live Activity is running on an iOS or iPadOS device,
/// it natively renders with an ``ActivityFamily/medium`` family.
/// If you want to opt in to customize the rendering for a Live Activity
/// for the watchOS Smart Stack, use the ``ActivityFamily/small``
/// family modifier.
///
/// When you define your Live Activity's configuration,
/// specify the sizes your Live Activity supports using the
///  <doc://com.apple.documentation/documentation/swiftui/widgetconfiguration/supplementalactivityfamilies(_:)>
///  property modifier.
///
/// When you render the content of the Live Activity, use
///  <doc://com.apple.documentation/documentation/SwiftUI/EnvironmentValues/activityFamily>
///  to read the current family and lay out your
///  content appropriately.
/// The code below uses <doc://com.apple.documentation/documentation/swiftui/widgetconfiguration/supplementalactivityfamilies(_:)>
/// to specify the size of the Live Activity for devices on iOS and watchOS.
///
/// ```swift
/// // A RideSharingActivity that supports the watchOS Smart Stack and the iOS Lock Screen.
///struct RideSharingActivity: Widget {
///    var body: some WidgetConfiguration {
///        ActivityConfiguration(for: RideAttributes.self) { context in
///            RideSharingView(context: context)
///        } dynamicIsland: { context in
///            DynamicIsland {
///                DynamicIslandExpandedRegion(.bottom) {
///                    RideShareDetails()
///                }
///            } compactLeading: {
///                AppLogo()
///            } compactTrailing: {
///                ETAView()
///            } minimal: {
///                ETAView()
///            }
///        }
///        .supplementalActivityFamilies([.small, .medium])
///    }
///}
///```
@available(iOS 18.0, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public enum ActivityFamily : Equatable {

    /// A size family of a Live Activity on watchOS.
    case small

    /// A size family of a Live Activity on iOS and macOS.
    case medium
}

@available(iOS 18.0, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension ActivityFamily : Codable, CustomStringConvertible, RawRepresentable {

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    public typealias RawValue = Int

    /// Creates a new instance with the specified raw value.
    ///
    /// If there is no value of the type that corresponds with the specified raw
    /// value, this initializer returns `nil`. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     print(PaperSize(rawValue: "Legal"))
    ///     // Prints "Optional(PaperSize.Legal)"
    ///
    ///     print(PaperSize(rawValue: "Tabloid"))
    ///     // Prints "nil"
    ///
    /// - Parameter rawValue: The raw value to use for the new instance.
    public init?(rawValue: Int)

    /// The corresponding value of the raw type.
    ///
    /// A new instance initialized with `rawValue` will be equivalent to this
    /// instance. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     let selectedSize = PaperSize.Letter
    ///     print(selectedSize.rawValue)
    ///     // Prints "Letter"
    ///
    ///     print(selectedSize == PaperSize(rawValue: selectedSize.rawValue)!)
    ///     // Prints "true"
    public var rawValue: Int { get }

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

@available(iOS 18.0, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension ActivityFamily : Hashable {
}

/// Values that represent Live Activity presentations for use in Xcode previews.
@available(iOS 16.2, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
@preconcurrency public enum ActivityPreviewViewKind : Sendable {

    /// The Live Activity presentation that appears on the Lock Screen and as a banner on devices that
    /// don't support the Dynamic Island.
    case content

    /// The Live Activity presentation that appears in the Dynamic Island.
    case dynamicIsland(ActivityPreviewViewKind.DynamicIslandPreviewViewState)

    /// Values that represent the different presentations of a Live Activity in the Dynamic Island for use in
    /// Xcode previews.
    @preconcurrency public enum DynamicIslandPreviewViewState : Sendable {

        /// The presentation of a Live Activity in the Dynamic Island that shows both the
        /// ``WidgetKit/DynamicIslandMode/compactLeading`` and
        /// ``WidgetKit/DynamicIslandMode/compactTrailing`` views combined.
        case compact

        /// The minimal presentation of a Live Activity in the Dynamic Island.
        case minimal

        /// The expanded presentation of a Live Activity in the Dynamic Island.
        case expanded

        /// Returns a Boolean value indicating whether two values are equal.
        ///
        /// Equality is the inverse of inequality. For any values `a` and `b`,
        /// `a == b` implies that `a != b` is `false`.
        ///
        /// - Parameters:
        ///   - lhs: A value to compare.
        ///   - rhs: Another value to compare.
        public static func == (a: ActivityPreviewViewKind.DynamicIslandPreviewViewState, b: ActivityPreviewViewKind.DynamicIslandPreviewViewState) -> Bool

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

@available(iOS 16.2, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension ActivityPreviewViewKind.DynamicIslandPreviewViewState : Equatable {
}

@available(iOS 16.2, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension ActivityPreviewViewKind.DynamicIslandPreviewViewState : Hashable {
}

/// A structure that describes the view context for creating the views of a Live Activity.
@available(iOS 16.1, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct ActivityViewContext<Attributes> where Attributes : ActivityAttributes {

    /// A unique identifier for the Live Activity.
    public let activityID: String

    /// A set of attributes that describe a Live Activity and its content at the time of its creation.
    public let attributes: Attributes

    /// The dynamic content of a Live Activity at the time of its creation.
    public let state: Attributes.ContentState

    /// A Boolean value that describes whether the Live Activity is out of date.
    @available(iOS 16.2, macOS 26.0, macCatalyst 18.2, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    public let isStale: Bool
}

/// An object describing the content of a widget that uses a custom intent
/// to provide user-configurable options.
///
/// The following example shows the configuration for a game widget that
/// displays details about a chosen character.
///
///     struct CharacterDetailWidget: Widget {
///         var body: some WidgetConfiguration {
///             AppIntentConfiguration(
///                 kind: "com.mygame.character-detail",
///                 intent: SelectCharacterIntent.self,
///                 provider: CharacterDetailProvider(),
///             ) { entry in
///                 CharacterDetailView(entry: entry)
///             }
///             .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
///         }
///     }
///
/// Every widget has a unique `kind`, a string that you choose. You use this
/// string to identify your widget when reloading its timeline with
/// <doc:WidgetCenter>.
///
/// The `intent` is a custom App Intent containing user-editable
/// parameters.
///
/// The timeline provider is an object that determines the timeline for
/// refreshing your widget. Providing future dates for updating your widget
/// allows the system to optimize the refresh process.
///
/// The content closure contains the SwiftUI views that WidgetKit needs to
/// render the widget. When WidgetKit invokes the content closure, it passes a
/// timeline entry created by the widget provider's
/// <doc:WidgetKit/AppIntentTimelineProvider/snapshot(for:in:)> or
/// <doc:WidgetKit/AppIntentTimelineProvider/timeline(for:in:)>
/// method.
///
/// Modifiers let you specify the families your widget supports, and the
/// details shown when users add or edit their widgets.
@available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 26.0, *)
@available(tvOS, unavailable)
@MainActor @preconcurrency public struct AppIntentConfiguration<Intent, Content> : WidgetConfiguration where Intent : WidgetConfigurationIntent, Content : View {

    /// The content and behavior of this widget.
    @MainActor @preconcurrency public var body: some WidgetConfiguration { get }

    /// The type of widget configuration representing the body of
    /// this configuration.
    ///
    /// When you create a custom widget, Swift infers this type from your
    /// implementation of the required `body` property.
    @available(iOS 17.0, watchOS 10.0, visionOS 26.0, macOS 14.0, *)
    @available(tvOS, unavailable)
    public typealias Body = some WidgetConfiguration
}

@available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 26.0, *)
@available(tvOS, unavailable)
extension AppIntentConfiguration {

    /// Creates a configuration for a widget by using a custom intent
    /// to provide user-configurable options.
    /// - Parameters:
    ///   - kind: A unique string that you choose.
    ///   - intent: A custom intent containing user-editable
    ///     parameters.
    ///   - provider: An object that determines the timing of updates
    ///     to the widget's views.
    ///   - content: A view that renders the widget.
    @MainActor @preconcurrency public init<Provider>(kind: String, intent: Intent.Type = Intent.self, provider: Provider, @ViewBuilder content: @escaping (Provider.Entry) -> Content) where Intent == Provider.Intent, Provider : AppIntentTimelineProvider
}

@available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 26.0, *)
@available(tvOS, unavailable)
extension AppIntentConfiguration : Sendable {
}

/// The description of a control widget that uses a custom intent to provide
/// user-configurable options.
///
/// The following example shows the configuration for a door opener control able
/// to open a door specified by the user.
///
///     struct DoorOpener: ControlWidget {
///         var body: some ControlWidgetConfiguration {
///             AppIntentControlConfiguration(
///                 kind: "com.yourcompany.GarageDoorOpener",
///                 provider: DoorValueProvider()
///             ) { door in
///                 ControlWidgetToggle(
///                     door.name,
///                     isOn: door.isOpen,
///                     action: ToggleDoor(door)
///                 ) {
///                     Label(
///                         $0 ? "Open" : "Closed",
///                         systemImage: $0 ? "door.open" : "door.closed"
///                     )
///                 }
///             }
///         }
///     }
///
/// Every control has a unique `kind`, a string that you choose. You use this
/// string to identify your control when reloading its template with
/// ``ControlCenter``.
///
/// The value provider is an object that determines a value to use to render
/// your template. This provider receives an intent containing user-editable
/// parameters.
///
/// The content closure defines the template that WidgetKit needs to render the
/// control. If you create the configuration using a value provider, when
/// WidgetKit invokes the content closure, it passes a value created by the
/// provider's ``AppIntentControlValueProvider/previewValue`` property or
/// ``AppIntentControlValueProvider/currentValue()`` function.
@available(iOS 18.0, macOS 26.0, watchOS 26.0, *)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
@MainActor @preconcurrency public struct AppIntentControlConfiguration<Configuration, Content> : ControlWidgetConfiguration where Configuration : ControlConfigurationIntent, Content : ControlWidgetTemplate {

    /// The content and behavior of the control.
    @MainActor @preconcurrency public var body: some ControlWidgetConfiguration { get }

    /// The type of control widget configuration representing the body of this
    /// configuration.
    @available(iOS 18.0, watchOS 26.0, macOS 26.0, *)
    @available(tvOS, unavailable)
    @available(visionOS, unavailable)
    public typealias Body = some ControlWidgetConfiguration
}

@available(iOS 18.0, macOS 26.0, watchOS 26.0, *)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
extension AppIntentControlConfiguration {

    /// Creates a configuration for a control widget by using a custom intent to
    /// provide user-configurable options.
    ///
    /// - Parameters:
    ///   - kind: A string that uniquely identifies the type of control.
    ///   - provider: An object that provides a value to the control template.
    ///     The provider uses your custom intent to prepare this value.
    ///   - content: A template that renders the control.
    @MainActor @preconcurrency public init<Provider>(kind: String, provider: Provider, @ControlWidgetTemplateBuilder content: @escaping (Provider.Value) -> Content) where Configuration == Provider.Configuration, Provider : AppIntentControlValueProvider

    /// Creates a configuration for a control widget by using a custom intent to
    /// provide user-configurable options.
    ///
    /// - Parameters:
    ///   - kind: A string that uniquely identifies the type of control.
    ///   - intent: A custom intent containing user-editable parameters.
    ///   - content: A template that renders the control.
    @MainActor @preconcurrency public init(kind: String, intent: Configuration.Type = Configuration.self, @ControlWidgetTemplateBuilder content: @escaping (Configuration) -> Content)
}

@available(iOS 18.0, macOS 26.0, watchOS 26.0, *)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
extension AppIntentControlConfiguration : Sendable {
}

/// A type that uses a custom intent to provide a value to a control template.
///
/// The provider quickly and cheaply prepares a synchronous value to be shown
/// while previewing the control in the add sheet. When the actual control needs
/// to be rendered, the actual, current value will be fetched asynchronously.
///
/// The provider prepares these values using an intent containing user-editable
/// parameters.
///
/// For instance, a control that opens and closes various doors in a user's home
/// may show a preview of the door being closed. When the actual control is
/// rendered, the control may fetch the configured door's status from the cloud:
///
///     struct DoorValueProvider: AppIntentControlValueProvider {
///         func previewValue(configuration: SelectDoorIntent) -> Door {
///             Door(id: configuration.doorId, isOpen: false)
///         }
///
///         func currentValue(configuration: SelectDoorIntent) async -> Door {
///             let isOpen = await DoorManager.shared
///                 .status(doorId: configuration.doorId)
///             return Door(id: configuration.doorId, isOpen: isOpen)
///         }
///     }
///
@available(iOS 18.0, macOS 26.0, watchOS 26.0, *)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
public protocol AppIntentControlValueProvider {

    /// The type of value provided to the template.
    ///
    /// When you create a custom provider, Swift infers this type from your
    /// implementation of the required ``ValueProvider/previewValue(configuration:)``
    /// and ``ValueProvider/currentValue(configuration:)`` methods.
    associatedtype Value

    /// The type of intent used to prepare the value.
    ///
    /// When you create a custom provider, Swift infers this type from your
    /// implementation of the required ``ValueProvider/previewValue(configuration:)``
    /// and ``ValueProvider/currentValue(configuration:)`` methods.
    associatedtype Configuration : ControlConfigurationIntent

    /// A value to be shown while previewing the control in the add sheet.
    ///
    /// This value should be generated quickly and cheaply. Calculate more
    /// expensive and accurate values in ``currentValue(configuration:)``.
    ///
    /// - Parameters:
    ///     - configuration: The intent containing user-editable parameters.
    func previewValue(configuration: Self.Configuration) -> Self.Value

    /// The current value of the control.
    ///
    /// - Parameters:
    ///     - configuration: The intent containing user-editable parameters.
    func currentValue(configuration: Self.Configuration) async throws -> Self.Value
}

/// An object that describes a recommended intent configuration for a
/// user-customizable widget.
///
/// By adding a custom App Intent to your project and using an
/// <doc:AppIntentTimelineProvider>, you allow users to configure widgets to show
/// data that's most relevant to them. Some platforms don't have a dedicated
/// user interface to configure all of your intent parameters. For example,
/// watchOS doesn't offer a dedicated user interface to configure data that
/// appears on a complication. Use intent recommendations in watchOS to offer
/// preconfigured complications that show data that's most relevant to the
/// user.
///
/// > Note: On platforms that offer a dedicated user interface for configuring
///     widgets — for example, iOS or macOS — `AppIntentRecommendation` is
///     inactive.
///
/// For example, say you develop a game app that allows users to view their in-game character.
/// With intent recommendations, you can recommend an intent configuration for
/// a watch complication that displays character information.
///
/// The following example shows a function to create a list of recommended configurations for a game
/// widget that shows current energy levels for a game character.
///
///     public func recommendations() -> [AppIntentRecommendation<DynamicCharacterConfiguration>] {
///         CharacterDetail.availableCharacters.map { character in
///             let intent = DynamicCharacterConfiguration()
///             intent.hero = Hero(identifier: character.name, display: character.name)
///             return AppIntentRecommendation(intent: intent, description: Text(character.name))
///         }
///     }
///
@available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 26.0, *)
@available(tvOS, unavailable)
public struct AppIntentRecommendation<Intent> where Intent : WidgetConfigurationIntent {

    /// Creates a recommended configuration for a widget on platforms that
    /// don't offer a dedicated user interface to customize widgets.
    ///
    /// > Note: On platforms that offer a dedicated user interface for configuring
    ///     widgets — for example, iOS or macOS — `AppIntentRecommendation` is
    ///     inactive.
    ///
    /// - Parameter intent: The intent that represents the recommended
    /// configuration.
    /// - Parameter description: A description that helps the user
    ///  understand the value of the preconfigured configuration option.
    ///  For example, if the configuration represents a location in a weather
    ///  app, the description may be the name of one of the user's favorite
    ///  cities, such as `Cupertino`.
    public init(intent: Intent, description: Text)

    /// Creates a recommended configuration for a widget on platforms that
    /// don't offer a dedicated user interface to customize widgets with a localized description.
    ///
    /// > Note: On platforms that offer a dedicated user interface for configuring
    ///     widgets — for example, iOS or macOS — `AppIntentRecommendation` is
    ///     inactive.
    ///
    /// - Parameter intent: The intent that represents the recommended
    /// configuration.
    /// - Parameter description: A key for a localized string in your bundle
    ///  that helps the user understand the value of the preconfigured
    ///  configuration option. For example, if the configuration represents a
    ///  location in a weather app, the description may be the name of one
    ///  of the user's favorite cities, such as `Cupertino`.
    public init(intent: Intent, description: LocalizedStringKey)

    /// Creates a recommended configuration for a widget on platforms that
    /// don't offer a dedicated user interface to customize widgets with a
    /// localized description.
    ///
    /// > Note: On platforms that offer a dedicated user interface for configuring
    ///     widgets — for example, iOS or macOS — `AppIntentRecommendation` is
    ///     inactive.
    ///
    /// - Parameter intent: The intent that represents the recommended
    /// configuration.
    /// - Parameter description: A localized string in your bundle
    ///  that helps the user understand the value of the preconfigured
    ///  configuration option. For example, if the configuration represents a
    ///  location in a weather app, the description may be the name of one
    ///  of the user's favorite cities, such as `Cupertino`.
    public init(intent: Intent, description: LocalizedStringResource)

    /// Creates a recommended configuration for a widget on platforms that
    /// don't offer a dedicated user interface to customize widgets.
    ///
    /// > Note: On platforms that offer a dedicated user interface for configuring
    ///     widgets — for example, iOS or macOS — `AppIntentRecommendation` is
    ///     inactive.
    ///
    /// - Parameter intent: The intent that represents the recommended
    /// configuration.
    /// - Parameter description: A description that helps the user
    ///  understand the value of the preconfigured configuration option.
    ///  For example, if the configuration represents a location in a weather
    ///  app, the description may be the name of one of the user's favorite
    ///  cities, such as `Cupertino`.
    public init(intent: Intent, description: some StringProtocol)
}

/// A type that advises WidgetKit when to update a user-configurable
/// widget's display.
///
/// An App Intent timeline provider performs the same function as
/// <doc:TimelineProvider>, but it also incorporates user-configured details
/// into timeline entries.
///
/// For example, in a widget that displays the health status of a game
/// character the user has chosen, the provider receives a custom
/// intent specifying the character to display. In your app code,
/// you then define a custom App Intent. The intent
/// can include the character’s details such as its name,
/// avatar, strategic alliances, and so on.
///
///     struct CharacterConfiguration: WidgetConfigurationIntent {
///         static var title: LocalizedStringResource = "Character"
///
///         @Parameter(title: "Name")
///         var name: String
///
///         @Parameter(title: "Avatar", default: "Player 1")
///         var avatar: String
///
///         @Parameter(title: "Alliances", default: [])
///         var alliances: [String]
///
///         @Parameter(title: "Health", default: 100.0)
///         var healthLevel: Double
///     }
///
/// Because users can add multiple instances of a particular widget, your
/// provider needs a way to differentiate which instance WidgetKit is asking
/// about. When WidgetKit calls
/// <doc:AppIntentTimelineProvider/snapshot(for:in:)> or
/// <doc:AppIntentTimelineProvider/timeline(for:in:)>, it passes an
/// instance of your configuration intent, configured with the user-selected
/// details. The game widget provider accesses the properties of the intent and
/// includes them in the <doc:TimelineEntry>. WidgetKit then invokes the widget
/// configuration's content closure, passing the timeline entry to allow the
/// views to access the user-configured properties. For example, the provider
/// might implement a `TimelineEntry` with properties corresponding to those in
/// the custom intent:
///
///     struct CharacterDetailEntry: TimelineEntry {
///         var date: Date
///         var name: String
///         var avatar: String
///         var alliances: [String]
///         var healthLevel: Double
///     }
///
/// To generate a snapshot, the game widget provider initializes the character
/// detail entry using the properties from the intent.
///
///     struct CharacterDetailProvider: AppIntentTimelineProvider {
///         func snapshot(for configuration: CharacterConfiguration, in context: Context) async -> CharacterDetailEntry {
///             return CharacterDetailEntry(
///                 date: Date(),
///                 name: configuration.characterName,
///                 avatar: configuration.avatar,
///                 alliances: configuration.alliances,
///                 healthLevel: configuration.healthLevel?.doubleValue
///             )
///         }
///     }
///
@available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 26.0, *)
@available(tvOS, unavailable)
public protocol AppIntentTimelineProvider {

    /// A type that specifies the date to display a widget, and, optionally,
    /// indicates the current relevance of the widget's content.
    associatedtype Entry : TimelineEntry

    /// The intent that contains user-customized values.
    associatedtype Intent : WidgetConfigurationIntent

    /// An object that contains details about how a widget is rendered, including its size and whether it
    /// appears in the widget gallery.
    ///
    /// For more information, see <doc:TimelineProviderContext>.
    typealias Context = TimelineProviderContext

    /// Returns a set of intent recommendations you use to offer pre-configured
    /// widgets on platforms that don't offer a dedicated user interface for
    /// customizing widget intents.
    func recommendations() -> [AppIntentRecommendation<Self.Intent>]

    /// Provides a timeline entry representing a placeholder version of the
    /// widget.
    ///
    /// When WidgetKit displays your widget for the first time, it renders the widget's
    /// view as a placeholder. A placeholder view displays a generic representation of
    /// your widget, giving the user a general idea of what the widget shows. WidgetKit
    /// calls `placeholder(in:)` to request an entry representing
    /// the widget's placeholder configuration. For example, the game status widget
    /// would implement this method as follows:
    ///
    ///     struct GameStatusProvider: TimelineProvider {
    ///         func placeholder(in context: Context) -> SimpleEntry {
    ///            GameStatusEntry(date: Date(), gameStatus: "—")
    ///         }
    ///     }
    ///
    /// In addition, WidgetKit may render your widget as a placeholder if user’s choose to hide sensitive
    /// information on Apple Watch or the iPhone Lock Screen. To learn more about redacting sensitive
    /// data, see <doc:Creating-a-Widget-Extension>.
    ///
    /// > Important: `placeholder(in:)` is synchronous and returns a `TimelineEntry`
    ///   immediately. Return from `placeholder(in:)` as quickly as possible.
    ///
    /// - Parameter context: An object that describes the context in which to
    ///   show the widget.
    /// - Returns: A timeline entry that represents a placeholder version of the
    ///   widget.
    func placeholder(in context: Self.Context) -> Self.Entry

    /// Provides a timeline entry representing the current time and state of a
    /// widget.
    ///
    /// WidgetKit calls `snapshot(for:in:)` when the widget appears
    /// in transient situations. If context.isPreview is true, the
    /// widget appears in the widget gallery. In that case, return the `Entry`
    /// as quickly as possible, perhaps supplying sample data if it
    /// could take more than a few seconds to fetch or calculate the widget's
    /// current state.
    ///
    /// The `configuration` parameter provides user-customized values, as
    /// defined in your custom intent.
    ///
    /// - Parameters:
    ///   - configuration: The intent containing user-customized values.
    ///   - context: An object describing the context to show the widget in.
    /// - Returns: A timeline entry representing the current time and state of a widget
    func snapshot(for configuration: Self.Intent, in context: Self.Context) async -> Self.Entry

    /// Provides an array of timeline entries for the current time and,
    /// optionally, any future times to update a widget.
    ///
    /// The `configuration` parameter provides user-customized values, as
    /// defined in your custom intent.
    ///
    /// - Parameters:
    ///   - configuration: The intent containing user-customized values.
    ///   - context: An object describing the context to show the widget in.
    /// - Returns: An array of timeline entries for the current time and,
    /// optionally, any future times to update a widget.
    func timeline(for configuration: Self.Intent, in context: Self.Context) async -> Timeline<Self.Entry>

    /// Provides an object containing attributes that describe when a specific
    /// widget is relevant.
    ///
    /// The system can use the relevance to show this widget in the Smart Stack
    /// when the provided relevance matches a person's context. For example,
    /// if you indicate relevance at a specific location, the system could
    /// show the widget when a person is at or close to the location.
    ///
    /// By default, this method returns no relevances. Implement this
    /// requirement to tell the system that your widget is relevant.
    ///
    /// > Note: Smart Stacks are available in iOS, iPadOS, and watchOS.
    /// However, functionality provided by RelevanceKit API is only available
    /// in watchOS. Calling its API on other platforms doesn't have any effect.
    /// For more information, refer to <doc:Widget-Suggestions-In-Smart-Stacks>.
    ///
    /// - Returns: The object that contains attributes that describe when a specific
    /// widget is relevant.
    @available(iOS 18.0, macOS 15.0, watchOS 11.0, visionOS 26.0, *)
    @available(tvOS, unavailable)
    func relevance() async -> WidgetRelevance<Self.Intent>
}

extension AppIntentTimelineProvider {

    /// Provides an object containing attributes that describe when a specific
    /// widget is relevant.
    ///
    /// The system can use the relevance to show this widget in the Smart Stack
    /// when the provided relevance matches a person's context. For example,
    /// if you indicate relevance at a specific location, the system could
    /// show the widget when a person is at or close to the location.
    ///
    /// By default, this method returns no relevances. Implement this
    /// requirement to tell the system that your widget is relevant.
    ///
    /// > Note: Smart Stacks are available in iOS, iPadOS, and watchOS.
    /// However, functionality provided by RelevanceKit API is only available
    /// in watchOS. Calling its API on other platforms doesn't have any effect.
    /// For more information, refer to <doc:Widget-Suggestions-In-Smart-Stacks>.
    ///
    /// - Returns: The object that contains attributes that describe when a specific
    /// widget is relevant.
    @available(iOS 18.0, macOS 15.0, watchOS 11.0, visionOS 26.0, *)
    @available(tvOS, unavailable)
    public func relevance() async -> WidgetRelevance<Self.Intent>
}

extension AppIntentTimelineProvider {

    /// Returns a set of intent recommendations you use to offer pre-configured
    /// widgets on platforms that don't offer a dedicated user interface for
    /// customizing widget intents.
    @available(iOS 17.0, macOS 14.0, visionOS 26.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func recommendations() -> [AppIntentRecommendation<Self.Intent>]
}

/// An object that contains a list of user-configured controls and is used for
/// reloading controls.
///
/// ControlCenter provides information about user-configured controls, such as
/// their push information. For controls that use <doc:IntentConfigurableControl>,
/// you can retrieve the user-edited values.
///
/// ### Getting Configured Control Information
///
/// To get a list of user-configured controls, use
/// <doc:ControlCenter/currentControls()>. This property provides an
/// array of <doc:ControlInfo> objects containing the following information:
///
///     struct ControlInfo {
///         public let kind: String
///         public func configurationIntent<Intent: ControlConfigurationIntent>(of intentType: Intent.Type = Intent.self) -> Intent?
///         public var pushInfo: ControlPushInfo?
///     }
///
/// The `kind` string matches the parameter you use when defining the control
/// type. If your control uses <doc:IntentConfigurableControl>, the
/// `configurationIntent` function provides the custom intent containing the
/// user-customized values for each individual control. If your control
/// returns `true` for `supportsPushUpdates`, `pushInfo` will return the latest
/// push info for this individual control.
///
/// ### Requesting a Reload of Your Controls
///
/// Changes in your app’s state may affect a control's state. When this
/// happens, you can tell ControlCenter to reload the template for either a
/// specific kind of control or all controls. For example, your user might
/// press a button in your app that changes state shared by a control. The app
/// should reload that control for its display to reflect the new state.
///
/// You do not need to reload controls in response to push notifications. The
/// system will reload any controls configured for push notifications on your
/// behalf.
///
/// If you only need to reload a certain kind of control, you can request a
/// reload for only that kind. For example, in response to the user toggling an
/// appliance on or off, you could request a reload for only the appliance
/// widgets:
///
///     ControlCenter.shared.reloadControls(ofKind: "com.myhome.appliancepower")
///
/// To request a reload for all of your controls:
///
///     ControlCenter.shared.reloadAllControls()
@available(iOS 18.0, macOS 26.0, watchOS 26.0, *)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
public class ControlCenter {

    public static let shared: ControlCenter

    /// Retrieves information about user-configured controls.
    public func currentControls() async throws -> [ControlInfo]

    /// Reloads the templates for all controls of a particular kind.
    ///
    /// - Parameter kind: A string that identifies the control and matches the
    ///   value you used to define the control.
    public func reloadControls(ofKind kind: String)

    /// Reloads the templates for all configured controls belonging to the
    /// containing app.
    public func reloadAllControls()

    @objc deinit
}

/// A structure that contains information about user-configured controls.
@available(iOS 18.0, macOS 26.0, watchOS 26.0, *)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
public struct ControlInfo {

    /// Gets the associated App Intent.
    ///
    /// - Parameter intentType: The expected type for the App Intent.
    /// - Returns: An App Intent that contains the user-edited values or nil
    /// if there is no associated App Intent or the type does not match `intentType`.
    public func configurationIntent<Intent>(of intentType: Intent.Type = Intent.self) -> Intent? where Intent : ControlConfigurationIntent

    /// The string specified during creation of the control's configuration.
    public let kind: String

    /// Push information about a control, if present.
    public var pushInfo: ControlPushInfo?
}

@available(iOS 18.0, macOS 26.0, watchOS 26.0, *)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
extension ControlInfo : Identifiable, Hashable, Equatable {

    /// The stable identity of the control.
    public var id: String { get }

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: ControlInfo, rhs: ControlInfo) -> Bool

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

    /// A type representing the stable identity of the entity associated with
    /// an instance.
    @available(iOS 18.0, watchOS 26.0, macOS 26.0, *)
    @available(tvOS, unavailable)
    @available(visionOS, unavailable)
    public typealias ID = String

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

/// A type that can receive push information about user-configured controls.
///
/// Register a type conforming to this protocol to receive push information
/// using the <doc://com.apple.documentation/documentation/swiftui/ControlWidgetConfiguration/pushHandler(_:)> modifier on your
/// controls' configurations.
@available(iOS 18.0, macOS 26.0, watchOS 26.0, *)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
public protocol ControlPushHandler {

    /// Creates a push handler.
    init()

    /// Handle push tokens changing for configured controls.
    ///
    /// This function always provides information for all controls that support
    /// push updates even if only some of the tokens have changed.
    ///
    /// - Parameter controls: Information about controls that support push
    ///   updates.
    func pushTokensDidChange(controls: [ControlInfo])
}

/// A structure that contains information about the push token of a
/// user-configured control.
@available(iOS 18.0, macOS 26.0, watchOS 26.0, *)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
public struct ControlPushInfo {

    /// A unique push token that may be used to deliver updates for this
    /// control.
    ///
    /// This token is valid until told otherwise through the
    /// ``ControlPushHandler/pushTokensDidChange(controls:)`` method on your push
    /// handler.
    public let token: Data
}

/// A type that provides a value to a control widget template.
///
/// The provider quickly and cheaply prepares a synchronous value to be shown
/// while previewing the control in the add sheet. When the actual control needs
/// to be rendered, the actual, current value will be fetched asynchronously.
///
/// For instance, a control that opens and closes a garage door may show a
/// preview of the door being closed. When the actual control is rendered, the
/// control may fetch the door's status from the cloud:
///
///     struct GarageDoorValueProvider: ControlValueProvider {
///         var previewValue: Bool { false }
///
///         func currentValue() async -> Bool {
///             await GarageDoorManager.shared.doorStatus()
///         }
///     }
///
@available(iOS 18.0, macOS 26.0, watchOS 26.0, *)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
public protocol ControlValueProvider {

    /// The type of value provided to the template.
    ///
    /// When you create a custom provider, Swift infers this type from your
    /// implementation of the required ``ControlValueProvider/previewValue-swift.property``
    /// property and ``ControlValueProvider/currentValue()`` method.
    associatedtype Value

    /// A value to be shown while previewing the control in the add sheet.
    ///
    /// This value should be generated quickly and cheaply. Calculate more
    /// expensive and accurate values in ``currentValue()``.
    var previewValue: Self.Value { get }

    /// The current value of the control.
    func currentValue() async throws -> Self.Value
}

/// A control template representing a button.
///
/// Buttons do not have state and are used for fire-and-forget actions such as
/// playing a sound or launching an app.
@available(iOS 18.0, macOS 26.0, watchOS 26.0, *)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
@MainActor @preconcurrency public struct ControlWidgetButton<Label, ActionLabel, Action> : ControlWidgetTemplate where Label : View, ActionLabel : View {

    /// The content and behavior of this control widget.
    @MainActor @preconcurrency public var body: some ControlWidgetTemplate { get }

    /// The type of control widget template representing the body of this template.
    ///
    /// When you create a custom control widget, Swift infers this type from your
    /// implementation of the required ``ControlWidgetTemplate/body-swift.property``
    /// property.
    @available(iOS 18.0, watchOS 26.0, macOS 26.0, *)
    @available(tvOS, unavailable)
    @available(visionOS, unavailable)
    public typealias Body = some ControlWidgetTemplate
}

@available(iOS 18.0, macOS 26.0, watchOS 26.0, *)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
extension ControlWidgetButton {

    /// Creates a button template for a control.
    ///
    /// Use the action label to additionally customize the appearance of this
    /// control button while its action is performed
    ///
    ///     ControlWidgetButton(action: OpenTrunkIntent()) {
    ///         Label("Open Trunk", systemImage: "car.side.rear.open.crop")
    ///     } actionLabel: { isActive in
    ///         if isActive {
    ///             Text("Opening…")
    ///         }
    ///     }
    ///
    /// The example above produces a control button that in control center will
    /// display "Open Trunk" as its title and the provided SF symbol.
    /// While the control is performing its action it will show the
    /// "Opening…" subtitle.
    ///
    /// - Parameters:
    ///   - action: The action your button performs when pressed.
    ///   - label: A view that renders the button.
    ///   - actionLabel: A view that is rendered when the button's action is performed
    @MainActor @preconcurrency public init(action: Action, @ViewBuilder label: @escaping () -> Label, @ViewBuilder actionLabel: @escaping (Bool) -> ActionLabel) where Action : AppIntent

    /// Creates a button template for a control.
    ///
    /// - Parameters:
    ///   - action: The action your button performs when pressed.
    ///   - label: A view that renders the button.
    @MainActor @preconcurrency public init(action: Action, @ViewBuilder label: @escaping () -> Label) where ActionLabel == ControlWidgetButtonDefaultActionLabel, Action : AppIntent

    /// Creates a button template for a control that launches an app.
    ///
    /// - Parameters:
    ///   - action: The action your button performs when pressed.
    ///   - label: A view that renders the button.
    @MainActor @preconcurrency public init(action: Action, @ViewBuilder label: @escaping () -> Label) where ActionLabel == ControlWidgetButtonDefaultActionLabel, Action : OpenIntent
}

@available(iOS 18.0, macOS 26.0, watchOS 26.0, *)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
extension ControlWidgetButton where Label == Text {

    /// Creates a button template for a control.
    ///
    /// Use the action label to additionally customize the appearance of this
    /// control button while its action is performed
    ///
    ///     ControlWidgetButton(
    ///         "Open Trunk",
    ///         action: OpenTrunkIntent()
    ///     ) { isActive in
    ///         Image(systemName: "car.side.rear.open.crop")
    ///         if isActive {
    ///             Text("Opening...")
    ///         }
    ///     }
    ///
    /// The example above produces a control button that in control center will
    /// display "Open Trunk" as its title and the provided SF symbol.
    /// While the control is performing its action it will show the
    /// "Opening…" subtitle.
    ///
    /// - Parameters:
    ///   - titleKey: The key to a localized string to display as the title of
    ///   the button.
    ///   - action: The action your button performs when pressed.
    ///   - actionLabel: A view that is rendered when the button's action is performed.
    @MainActor @preconcurrency public init(_ titleKey: LocalizedStringKey, action: Action, @ViewBuilder actionLabel: @escaping (Bool) -> ActionLabel) where Action : AppIntent

    /// Creates a button template for a control.
    ///
    /// Use the action label to additionally customize the appearance of this
    /// control button while its action is performed
    ///
    ///     ControlWidgetButton(
    ///         "Open Trunk",
    ///         action: OpenTrunkIntent()
    ///     ) { isActive in
    ///         Image(systemName: "car.side.rear.open.crop")
    ///         if isActive {
    ///             Text("Opening...")
    ///         }
    ///     }
    ///
    /// The example above produces a control button that in control center will
    /// display "Open Trunk" as its title and the provided SF symbol.
    /// While the control is performing its action it will show the
    /// "Opening…" subtitle.
    ///
    /// - Parameters:
    ///   - titleResource: The localized string resource to display as the title
    ///     of the button.
    ///   - action: The action your button performs when pressed.
    ///   - actionLabel: A view that is rendered when the button's action is
    ///     performed.
    @MainActor @preconcurrency public init(_ titleResource: LocalizedStringResource, action: Action, @ViewBuilder actionLabel: @escaping (Bool) -> ActionLabel) where Action : AppIntent

    /// Creates a button template for a control.
    ///
    /// Use the action label to additionally customize the appearance of this
    /// control button while its action is performed
    ///
    ///     ControlWidgetButton(
    ///         configuration.actionName,
    ///         action: OpenTrunkIntent(configuration.id)
    ///     ) { isActive in
    ///         Image(systemName: "car.side.rear.open.crop")
    ///         if isActive {
    ///             Text("Opening...")
    ///         }
    ///     }
    ///
    /// The example above produces a control button that in control center will
    /// display the value of `actionName` as its title and the provided SF symbol.
    /// While the control is performing its action it will show the
    /// "Opening…" subtitle.
    ///
    /// - Parameters:
    ///   - title: A string to display as the title of the button.
    ///   - action: The action your button performs when pressed.
    ///   - actionLabel: A view that is rendered when the button's action is performed.
    @MainActor @preconcurrency public init(_ title: some StringProtocol, action: Action, @ViewBuilder actionLabel: @escaping (Bool) -> ActionLabel) where Action : AppIntent
}

/// A view representing the default action label for a `ControlWidgetButton` if none
/// is specified.
///
/// You don't initialize this type yourself. Instead WidgetKit will create this
/// type when using a `ControlWidgetButton` initializer that doesn't provide a label.
@available(iOS 18.0, macOS 26.0, watchOS 26.0, *)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
@MainActor @preconcurrency public struct ControlWidgetButtonDefaultActionLabel : View {

    /// The content and behavior of the view.
    ///
    /// When you implement a custom view, you must implement a computed
    /// `body` property to provide the content for your view. Return a view
    /// that's composed of built-in views that SwiftUI provides, plus other
    /// composite views that you've already defined:
    ///
    ///     struct MyView: View {
    ///         var body: some View {
    ///             Text("Hello, World!")
    ///         }
    ///     }
    ///
    /// For more information about composing views and a view hierarchy,
    /// see <doc:Declaring-a-Custom-View>.
    @MainActor @preconcurrency public var body: some View { get }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    @available(iOS 18.0, watchOS 26.0, macOS 26.0, *)
    @available(tvOS, unavailable)
    @available(visionOS, unavailable)
    public typealias Body = some View
}

/// A control template representing a toggle.
///
/// Toggles are controls that have two states, "off" and "on".
@available(iOS 18.0, macOS 26.0, watchOS 26.0, *)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
@MainActor @preconcurrency public struct ControlWidgetToggle<Label, ValueLabel, Action> : ControlWidgetTemplate where Label : View, ValueLabel : View {

    /// The content and behavior of this control widget.
    @MainActor @preconcurrency public var body: some ControlWidgetTemplate { get }

    /// The type of control widget template representing the body of this template.
    ///
    /// When you create a custom control widget, Swift infers this type from your
    /// implementation of the required ``ControlWidgetTemplate/body-swift.property``
    /// property.
    @available(iOS 18.0, watchOS 26.0, macOS 26.0, *)
    @available(tvOS, unavailable)
    @available(visionOS, unavailable)
    public typealias Body = some ControlWidgetTemplate
}

@available(iOS 18.0, macOS 26.0, watchOS 26.0, *)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
extension ControlWidgetToggle {

    /// Creates a toggle template for a control widget.
    ///
    /// - Parameters:
    ///   - isOn: A boolean value that describes the current value of the
    ///   toggle.
    ///   - action: The action the toggle performs when pressed.
    ///   - label: A view that renders the toggle's label.
    ///   - valueLabel: A view that renders the toggle's value. The boolean
    ///   parameter represents the value.
    @MainActor @preconcurrency public init(isOn: Bool, action: Action, @ViewBuilder label: @escaping () -> Label, @ViewBuilder valueLabel: @escaping (Bool) -> ValueLabel) where Action : SetValueIntent, Action.ValueType == Bool

    /// Creates a toggle template for a control widget.
    ///
    /// The toggle will use "On" and "Off" as default value label.
    ///
    /// - Parameters:
    ///   - isOn: A boolean value that describes the current value of the
    ///   toggle.
    ///   - action: The action the toggle performs when pressed.
    ///   - label: A view that renders the toggle's label.
    @MainActor @preconcurrency public init(isOn: Bool, action: Action, @ViewBuilder label: @escaping () -> Label) where ValueLabel == ControlWidgetToggleDefaultLabel, Action : SetValueIntent, Action.ValueType == Bool
}

@available(iOS 18.0, macOS 26.0, watchOS 26.0, *)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
extension ControlWidgetToggle where Label == Text {

    /// Creates a toggle template for a control widget.
    ///
    /// - Parameters:
    ///   - titleKey: The key to a localized string to display as the title of
    ///   the toggle.
    ///   - isOn: A boolean value that describes the current value of the
    ///   toggle.
    ///   - action: The action the toggle performs when pressed.
    ///   - valueLabel: A view that renders the toggle's value. The boolean
    ///   parameter represents the value.
    @MainActor @preconcurrency public init(_ titleKey: LocalizedStringKey, isOn: Bool, action: Action, @ViewBuilder valueLabel: @escaping (Bool) -> ValueLabel) where Action : SetValueIntent, Action.ValueType == Bool

    /// Creates a toggle template for a control widget.
    ///
    /// - Parameters:
    ///   - titleResource: The localized string resource to display as the title
    ///     of the toggle.
    ///   - isOn: A boolean value that describes the current value of the
    ///     toggle.
    ///   - action: The action the toggle performs when pressed.
    ///   - valueLabel: A view that renders the toggle's value. The boolean
    ///   parameter represents the value.
    @MainActor @preconcurrency public init(_ titleResource: LocalizedStringResource, isOn: Bool, action: Action, @ViewBuilder valueLabel: @escaping (Bool) -> ValueLabel) where Action : SetValueIntent, Action.ValueType == Bool

    /// Creates a toggle template for a control widget.
    ///
    /// - Parameters:
    ///   - title: A string to display as the title of the toggle.
    ///   - isOn: A boolean value that describes the current value of the
    ///   toggle.
    ///   - action: The action the toggle performs when pressed.
    ///   - valueLabel: A view that renders the toggle's value. The boolean
    ///   parameter represents the value.
    @MainActor @preconcurrency public init(_ title: some StringProtocol, isOn: Bool, action: Action, @ViewBuilder valueLabel: @escaping (Bool) -> ValueLabel) where Action : SetValueIntent, Action.ValueType == Bool
}

/// A view representing the default label for a `ControlWidgetToggle` if none
/// is specified.
///
/// You don't initialize this type yourself. Instead WidgetKit will create this
/// type when using a `ControlWidgetToggle` initializer that don't provide a label.
@available(iOS 18.0, macOS 26.0, watchOS 26.0, *)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
@MainActor @preconcurrency public struct ControlWidgetToggleDefaultLabel : View {

    /// The content and behavior of the view.
    ///
    /// When you implement a custom view, you must implement a computed
    /// `body` property to provide the content for your view. Return a view
    /// that's composed of built-in views that SwiftUI provides, plus other
    /// composite views that you've already defined:
    ///
    ///     struct MyView: View {
    ///         var body: some View {
    ///             Text("Hello, World!")
    ///         }
    ///     }
    ///
    /// For more information about composing views and a view hierarchy,
    /// see <doc:Declaring-a-Custom-View>.
    @MainActor @preconcurrency public var body: some View { get }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    @available(iOS 18.0, watchOS 26.0, macOS 26.0, *)
    @available(tvOS, unavailable)
    @available(visionOS, unavailable)
    public typealias Body = some View
}

/// The layout and configuration for a Live Activity that appears in the Dynamic Island.
@available(iOS 16.1, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct DynamicIsland {

    /// Creates a configuration object with views that appear in the Dynamic Island.
    ///
    /// - Parameters:
    ///   - expanded: A closure that builds the view for the expanded presentation of the Live Activity.
    ///   - compactLeading: A closure that builds the view for the compact leading presentation of the Live Activity.
    ///   - compactTrailing: A closure that builds the view for the compact trailing presentation of the Live Activity.
    ///   - minimal: A closure that builds the view for the minimal presentation of the Live Activity.
    ///
    public init<Expanded, CompactLeading, CompactTrailing, Minimal>(@DynamicIslandExpandedContentBuilder expanded: @escaping () -> DynamicIslandExpandedContent<Expanded>, @ViewBuilder compactLeading: @escaping () -> CompactLeading, @ViewBuilder compactTrailing: @escaping () -> CompactTrailing, @ViewBuilder minimal: @escaping () -> Minimal) where Expanded : View, CompactLeading : View, CompactTrailing : View, Minimal : View

    /// Sets the URL that opens the corresponding app of a Live Activity when a user taps on the Live Activity.
    ///
    /// By setting the URL with this function, it becomes the default URL for deep linking into the app
    /// for each view of the Live Activity. However, if you include a
    /// <doc://com.apple.documentation/documentation/swiftui/link> in the Live Activity,
    /// the link takes priority over the default URL. When a person taps on the `Link`, it takes them to the
    /// place in the app that corresponds to the URL of the `Link`.
    ///
    /// - Parameters:
    ///   - url: The URL that opens the app.
    ///
    /// - Returns: The configuration object for the Dynamic Island with the specified URL.
    public func widgetURL(_ url: URL?) -> DynamicIsland

    /// Applies a subtle tint color to the surrounding border of a Live Activity that appears in the Dynamic Island.
    ///
    /// - Parameters:
    ///   - color: The tint color to use.
    ///
    /// - Returns: The configuration object for the Dynamic Island with the specified keyline tint color.
    ///
    public func keylineTint(_ color: Color?) -> DynamicIsland

    /// Overrides default content margins for the provided content modes in the Dynamic Island.
    ///
    /// Use this modifier to customize the content margins for a content mode in the Dynamic Island. Avoid placing content
    /// too close to the edges of the Dynamic Island.
    ///
    /// The following example uses the default margin for the leading edge and sets a custom margin of 8 points
    /// for the top, bottom, and trailing edges of a Live Activity in the expanded presentation:
    ///
    /// ```swift
    /// dynamicIsland
    ///     .contentMargins([.top, .bottom, .trailing], 8, for:.expanded)
    /// ```
    ///
    /// When you apply multiple `contentMargins(_:_:for:)` modifiers, modifiers with the same
    /// placement override modifiers higher up in the view hierarchy. The following example results in a margin of
    /// 8 points for the trailing edge and 20 points for all other edges when the Live Activity appears in the
    /// expanded presentation:
    ///
    /// ```swift
    /// dynamicIsland
    ///     .contentMargins(.trailing, 8, for:.expanded)
    ///     .contentMargins(.all, 20, for:.expanded)
    /// ```
    ///
    /// - Parameters:
    ///   - edges: The edges that should use custom content margins.
    ///   - length: The value for the custom content margin for the specified `edges`.
    ///   - mode: The presentation of the Dynamic Island that the custom content margins apply to.
    ///
    /// - Returns: The Dynamic Island view with updated content margins.
    ///
    public func contentMargins(_ edges: Edge.Set = .all, _ length: Double, for mode: DynamicIslandMode) -> DynamicIsland
}

/// A view that describes the expanded presentation of a Live Activity that appears in the Dynamic Island.
///
/// This view holds the intermediate content for the ``DynamicIslandExpandedContentBuilder``.
@available(iOS 16.1, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct DynamicIslandExpandedContent<Content> where Content : View {
}

/// A result builder that constructs the content of an expanded Live Activity in the Dynamic Island.
@available(iOS 16.1, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
@resultBuilder public struct DynamicIslandExpandedContentBuilder {

    public static func buildPartialBlock<C>(first: DynamicIslandExpandedRegion<C>) -> DynamicIslandExpandedContent<some View> where C : View


    public static func buildPartialBlock<C>(first: DynamicIslandExpandedContent<C>) -> DynamicIslandExpandedContent<some View> where C : View


    public static func buildPartialBlock<C0, C1>(accumulated: DynamicIslandExpandedContent<C0>, next: DynamicIslandExpandedRegion<C1>) -> DynamicIslandExpandedContent<some View> where C0 : View, C1 : View


    public static func buildPartialBlock<C0, C1>(accumulated: DynamicIslandExpandedContent<C0>, next: DynamicIslandExpandedContent<C1>) -> DynamicIslandExpandedContent<some View> where C0 : View, C1 : View

}

/// A structure that defines and positions the content of an expanded Live Activity in the Dynamic Island.
///
/// The expanded presentation of a Live Activity in the Dynamic Island consists of four regions:
/// - ``DynamicIslandExpandedRegionPosition/center`` places content right below the TrueDepth camera.
/// - ``DynamicIslandExpandedRegionPosition/leading`` places content along the leading edge of the
/// expanded Live Activity next to the TrueDepth camera and wraps additional content below it.
/// - ``DynamicIslandExpandedRegionPosition/trailing`` places content along the trailing edge of
/// the expanded Live Activity next to the TrueDepth camera and wraps additional content below it.
/// - ``DynamicIslandExpandedRegionPosition/bottom`` places content below leading, trailing, and
/// center content.
@available(iOS 16.1, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct DynamicIslandExpandedRegion<Content> where Content : View {

    /// Creates the object that defines and positions the content of an expanded Live Activity in the
    /// Dynamic Island.
    ///
    /// - Parameters:
    ///   - position: The position for Live Activity content.
    ///   - priority: The priority that tells the system which content to prioritize when it sizes
    ///   the content of an expanded Live Activity in the Dynamic Island.
    ///   - content: The content of an expanded Live Activity.
    public init(_ position: DynamicIslandExpandedRegionPosition, priority: Double = 0, @ViewBuilder content: () -> Content)

    /// Overrides default content margins for the provided edges in the Dynamic Island.
    ///
    /// If you repeatedly use the `contentMargins(_:_:)` modifier, the system uses the
    /// innermost specified values. The following example results in a margin of 8 points for
    /// the trailing, top, and bottom edges, and uses the default margin for the leading edge:
    ///
    /// ```swift
    /// DynamicIslandContentRegion(.trailing) {
    ///     ContainerRelativeShape()
    ///     .aspectRatio(1, contentMode:.fit)
    /// }.contentMargins([.trailing, .top, .bottom], 8)
    ///```
    ///
    /// Note that the system applies the provided custom content margins to content that’s adjacent to the
    /// modified content margin edges.
    ///
    /// - Parameters:
    ///   - edges: The edges that use the custom content margins.
    ///   - length: The length of the custom margin for the given `edges`.
    ///
    /// - Returns: The view for the Dynamic Island expanded region with the updated content margins.
    ///
    @available(iOS 16.1, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    public func contentMargins(_ edges: Edge.Set = .all, _ length: Double) -> DynamicIslandExpandedRegion<Content>
}

/// View positions of an expanded Live Activity that appears in the Dynamic Island.
@available(iOS 16.1, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct DynamicIslandExpandedRegionPosition {

    /// The leading position in the Dynamic Island for views of an expanded Live Activity.
    @available(iOS 16.1, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    public static let leading: DynamicIslandExpandedRegionPosition

    /// The trailing position in the Dynamic Island for views of an expanded Live Activity.
    @available(iOS 16.1, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    public static let trailing: DynamicIslandExpandedRegionPosition

    /// The center position in the Dynamic Island for views of an expanded Live Activity.
    @available(iOS 16.1, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    public static let center: DynamicIslandExpandedRegionPosition

    /// The bottom position in the Dynamic Island for views of an expanded Live Activity.
    @available(iOS 16.1, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    public static let bottom: DynamicIslandExpandedRegionPosition
}

/// Vertical view positions of an expanded Live Activity that appears in the Dynamic Island.
@available(iOS 16.1, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct DynamicIslandExpandedRegionVerticalPlacement : Equatable {

    /// The system's default vertical placement.
    public static let `default`: DynamicIslandExpandedRegionVerticalPlacement

    /// Vertical placement below the default vertical position for content that's too wide to fit next to the
    /// TrueDepth camera.
    public static let belowIfTooWide: DynamicIslandExpandedRegionVerticalPlacement

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (a: DynamicIslandExpandedRegionVerticalPlacement, b: DynamicIslandExpandedRegionVerticalPlacement) -> Bool
}

/// A structure that offers values that describe the content mode for a Live Activity.
@available(iOS 16.1, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct DynamicIslandMode : Equatable {

    /// The expanded presentation of a Live Activity in the Dynamic Island.
    public static let expanded: DynamicIslandMode

    /// The compact leading presentation of a Live Activity in the Dynamic Island.
    public static let compactLeading: DynamicIslandMode

    /// The compact trailing presentation of a Live Activity in the Dynamic Island.
    public static let compactTrailing: DynamicIslandMode

    /// The minimal presentation of a Live Activity in the Dynamic Island.
    public static let minimal: DynamicIslandMode

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (a: DynamicIslandMode, b: DynamicIslandMode) -> Bool
}

/// An object describing the content of a widget that uses a custom intent
/// definition to provide user-configurable options.
///
/// The following example shows the configuration for a game widget that
/// displays details about a chosen character.
///
///     struct CharacterDetailWidget: Widget {
///         var body: some WidgetConfiguration {
///             IntentConfiguration(
///                 kind: "com.mygame.character-detail",
///                 intent: SelectCharacterIntent.self,
///                 provider: CharacterDetailProvider(),
///             ) { entry in
///                 CharacterDetailView(entry: entry)
///             }
///             .configurationDisplayName("Character Details")
///             .description("Displays a character's health and other details")
///             .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
///         }
///     }
///
/// Every widget has a unique `kind`, a string that you choose. You use this
/// string to identify your widget when reloading its timeline with
/// <doc:WidgetCenter>.
///
/// The `intent` is a custom SiriKit intent definition containing user-editable
/// parameters.
///
/// The timeline provider is an object that determines the timeline for
/// refreshing your widget. Providing future dates for updating your widget
/// allows the system to optimize the refresh process.
///
/// The content closure contains the SwiftUI views that WidgetKit needs to
/// render the widget. When WidgetKit invokes the content closure, it passes a
/// timeline entry created by the widget provider's
/// <doc:WidgetKit/IntentTimelineProvider/getSnapshot(for:in:completion:)> or
/// <doc:WidgetKit/IntentTimelineProvider/getTimeline(for:in:completion:)>
/// method.
///
/// Modifiers let you specify the families your widget supports, and the
/// details shown when users add or edit their widgets.
@available(iOS 14.0, macOS 11.0, watchOS 9.0, visionOS 26.0, *)
@available(tvOS, unavailable)
@MainActor @preconcurrency public struct IntentConfiguration<Intent, Content> : WidgetConfiguration where Intent : INIntent, Content : View {

    /// The content and behavior of this widget.
    @MainActor @preconcurrency public var body: some WidgetConfiguration { get }

    /// The type of widget configuration representing the body of
    /// this configuration.
    ///
    /// When you create a custom widget, Swift infers this type from your
    /// implementation of the required `body` property.
    @available(iOS 14.0, watchOS 9.0, visionOS 26.0, macOS 11.0, *)
    @available(tvOS, unavailable)
    public typealias Body = some WidgetConfiguration
}

@available(iOS 14.0, macOS 11.0, watchOS 9.0, visionOS 26.0, *)
@available(tvOS, unavailable)
extension IntentConfiguration {

    /// Creates a configuration for a widget by using a custom intent
    /// definition to provide user-configurable options.
    /// - Parameters:
    ///   - kind: A unique string that you choose.
    ///   - intent: A custom intent definition containing user-editable
    ///     parameters.
    ///   - provider: An object that determines the timing of updates
    ///     to the widget's views.
    ///   - content: A view that renders the widget.
    @MainActor @preconcurrency public init<Provider>(kind: String, intent: Intent.Type, provider: Provider, @ViewBuilder content: @escaping (Provider.Entry) -> Content) where Intent == Provider.Intent, Provider : IntentTimelineProvider
}

@available(iOS 14.0, macOS 11.0, watchOS 9.0, visionOS 26.0, *)
@available(tvOS, unavailable)
extension IntentConfiguration : Sendable {
}

/// An object that describes a recommended intent configuration for a
/// user-customizable widget.
///
/// By adding a custom SiriKit intent definition to your project and using an
/// <doc:IntentTimelineProvider>, you allow users to configure widgets to show
/// data that's most relevant to them. Some platforms don't have a dedicated
/// user interface to configure all of your intent parameters. For example,
/// watchOS doesn't offer a dedicated user interface to configure data that
/// appears on a complication. Use intent recommendations in watchOS to offer
/// preconfigured complications that show data that's most relevant to the
/// user.
///
/// > Note: On platforms that offer a dedicated user interface for configuring
///     widgets — for example, iOS or macOS — `IntentRecommendation` is
///     inactive.
///
/// For example, say you develop a game app that allows users to view their in-game character.
/// With intent recommendations, you can recommend an intent configuration for
/// a watch complication that displays character information.
///
/// The following example shows a function to create a list of recommended configurations for a game
/// widget that shows current energy levels for a game character.
///
///     public func recommendations() -> [IntentRecommendation<DynamicCharacterSelectionIntent>] {
///         return CharacterDetail.availableCharacters.
///             map { character in
///                 let hero = Hero(identifier: character.name, display: character.name)
///                 let intent = DynamicCharacterSelectionIntent()
///                 intent.hero = hero
///
///                 return IntentRecommendation(intent: intent, description: Text(character.name))
///             }
///         }
///
@available(iOS 16.0, macOS 13.0, watchOS 9.0, visionOS 26.0, *)
@available(tvOS, unavailable)
public struct IntentRecommendation<T> where T : INIntent {

    /// Creates a recommended configuration for a widget on platforms that
    /// don't offer a dedicated user interface to customize widgets.
    ///
    /// > Note: On platforms that offer a dedicated user interface for configuring
    ///     widgets — for example, iOS or macOS — `IntentRecommendation` is
    ///     inactive.
    ///
    /// - Parameter intent: The intent that represents the recommended
    /// configuration.
    /// - Parameter description: A description that helps the user
    ///  understand the value of the preconfigured configuration option.
    ///  For example, if the configuration represents a location in a weather
    ///  app, the description may be the name of one of the user's favorite
    ///  cities, such as `Cupertino`.
    public init(intent: T, description: Text)

    /// Creates a recommended configuration for a widget on platforms that
    /// don't offer a dedicated user interface to customize widgets with a localized description.
    ///
    /// > Note: On platforms that offer a dedicated user interface for configuring
    ///     widgets — for example, iOS or macOS — `IntentRecommendation` is
    ///     inactive.
    ///
    /// - Parameter intent: The intent that represents the recommended
    /// configuration.
    /// - Parameter description: A key for a localized string in your bundle
    ///  that helps the user understand the value of the preconfigured
    ///  configuration option. For example, if the configuration represents a
    ///  location in a weather app, the description may be the name of one
    ///  of the user's favorite cities, such as `Cupertino`.
    public init(intent: T, description: LocalizedStringKey)

    /// Creates a recommended configuration for a widget on platforms that
    /// don't offer a dedicated user interface to customize widgets with a
    /// localized description.
    ///
    /// > Note: On platforms that offer a dedicated user interface for configuring
    ///     widgets — for example, iOS or macOS — `IntentRecommendation` is
    ///     inactive.
    ///
    /// - Parameter intent: The intent that represents the recommended
    /// configuration.
    /// - Parameter description: A localized string in your bundle
    ///  that helps the user understand the value of the preconfigured
    ///  configuration option. For example, if the configuration represents a
    ///  location in a weather app, the description may be the name of one
    ///  of the user's favorite cities, such as `Cupertino`.
    public init(intent: T, description: LocalizedStringResource)

    /// Creates a recommended configuration for a widget on platforms that
    /// don't offer a dedicated user interface to customize widgets.
    ///
    /// > Note: On platforms that offer a dedicated user interface for configuring
    ///     widgets — for example, iOS or macOS — `IntentRecommendation` is
    ///     inactive.
    ///
    /// - Parameter intent: The intent that represents the recommended
    /// configuration.
    /// - Parameter description: A description that helps the user
    ///  understand the value of the preconfigured configuration option.
    ///  For example, if the configuration represents a location in a weather
    ///  app, the description may be the name of one of the user's favorite
    ///  cities, such as `Cupertino`.
    public init<S>(intent: T, description: S) where S : StringProtocol
}

/// A type that advises WidgetKit when to update a user-configurable
/// widget's display.
///
/// An Intent timeline provider performs the same function as
/// <doc:TimelineProvider>, but it also incorporates user-configured details
/// into timeline entries.
///
/// For example, in a widget that displays the health status of a game
/// character the user has chosen, the provider receives a custom
/// intent specifying the character to display. In your Xcode project,
/// you then define a custom SiriKit Intent Definition file. The intent
/// definition can include the character’s details such as its name,
/// avatar, strategic alliances, and so on.
///
/// ![A screenshot showing a custom intent definition file configured with an
///   intent named SelectCharacter with custom properties
///   defined.](IntentTimelineProvider-IntentDefinition.png)
///
/// Xcode generates the following
/// <doc://com.apple.documentation/documentation/Intents/INIntent> custom
/// intent:
///
///     public class SelectCharacterIntent: INIntent {
///         @NSManaged public var characterName: String?
///         @NSManaged public var avatar: String?
///         @NSManaged public var alliances: [String]?
///         @NSManaged public var healthLevel: NSNumber?
///     }
///
/// Because users can add multiple instances of a particular widget, your
/// provider needs a way to differentiate which instance WidgetKit is asking
/// about. When WidgetKit calls
/// <doc:IntentTimelineProvider/getSnapshot(for:in:completion:)> or
/// <doc:IntentTimelineProvider/getTimeline(for:in:completion:)>, it passes an
/// instance of your custom `INIntent`, configured with the user-selected
/// details. The game widget provider accesses the properties of the intent and
/// includes them in the <doc:TimelineEntry>. WidgetKit then invokes the widget
/// configuration's content closure, passing the timeline entry to allow the
/// views to access the user-configured properties. For example, the provider
/// might implement a `TimelineEntry` with properties corresponding to those in
/// the custom intent:
///
///     struct CharacterDetailEntry: TimelineEntry {
///         var date: Date
///         var name: String?
///         var avatar: String?
///         var alliances: [String]?
///         var healthLevel: Double?
///     }
///
/// To generate a snapshot, the game widget provider initializes the character
/// detail entry using the properties from the intent.
///
///     struct CharacterDetailProvider: IntentTimelineProvider {
///         func getSnapshot(for configuration: SelectCharacterIntent, in context: Context, completion: @escaping (CharacterDetailEntry) -> Void) {
///             let entry = CharacterDetailEntry(
///                 date: Date(),
///                 name: configuration.characterName,
///                 avatar: configuration.avatar,
///                 alliances: configuration.alliances,
///                 healthLevel: configuration.healthLevel?.doubleValue
///             )
///             completion(entry)
///         }
///     }
///
@available(iOS 14.0, macOS 11.0, watchOS 9.0, visionOS 26.0, *)
@available(tvOS, unavailable)
public protocol IntentTimelineProvider {

    /// A type that specifies the date to display a widget, and, optionally,
    /// indicates the current relevance of the widget's content.
    associatedtype Entry : TimelineEntry

    /// The intent that contains user-customized values.
    associatedtype Intent : INIntent

    /// An object that contains details about how a widget is rendered, including its size and whether it
    /// appears in the widget gallery.
    ///
    /// For more information, see <doc:TimelineProviderContext>.
    typealias Context = TimelineProviderContext

    /// Returns a set of intent recommendations you use to offer pre-configured
    /// widgets on platforms that don't offer a dedicated user interface for
    /// customizing widget intents.
    @available(iOS 16.0, macOS 13.0, watchOS 9.0, visionOS 26.0, *)
    @available(tvOS, unavailable)
    func recommendations() -> [IntentRecommendation<Self.Intent>]

    /// Provides a timeline entry representing a placeholder version of the
    /// widget.
    ///
    /// When WidgetKit displays your widget for the first time, it renders the widget's
    /// view as a placeholder. A placeholder view displays a generic representation of
    /// your widget, giving the user a general idea of what the widget shows. WidgetKit
    /// calls `placeholder(in:)` to request an entry representing
    /// the widget's placeholder configuration. For example, the  <doc://com.apple.documentation/documentation/widgetkit/emoji_rangers_supporting_live_activities_interactivity_and_animations>
    /// sample code project implements this method for its leaderboard widget as follows:
    ///
    ///     struct LeaderboardProvider: TimelineProvider {
    ///
    ///         public typealias Entry = LeaderboardEntry
    ///
    ///         func placeholder(in context: Context) -> LeaderboardEntry {
    ///             return LeaderboardEntry(date: Date(), heros: EmojiRanger.availableHeros)
    ///         }
    ///     }
    ///
    /// In addition, WidgetKit may render your widget as a placeholder if user’s choose to hide sensitive
    /// information on Apple Watch or the iPhone Lock Screen. To learn more about redacting sensitive
    /// data, see <doc:Creating-a-Widget-Extension>.
    ///
    /// > Important: `placeholder(in:)` is synchronous and returns a `TimelineEntry`
    ///   immediately. Return from `placeholder(in:)` as quickly as possible.
    ///
    /// - Parameter context: An object that describes the context in which to
    ///   show the widget.
    /// - Returns: A timeline entry that represents a placeholder version of the
    ///   widget.
    func placeholder(in context: Self.Context) -> Self.Entry

    /// Provides a timeline entry representing the current time and state of a
    /// widget.
    ///
    /// WidgetKit calls `getSnapshot(for:in:completion:)` when the widget
    /// appears in transient situations. If context.isPreview is true, the
    /// widget appears in the widget gallery. In that case, call the completion
    /// handler as quickly as possible, perhaps supplying sample data if it
    /// could take more than a few seconds to fetch or calculate the widget's
    /// current state.
    ///
    /// The `configuration` parameter provides user-customized values, as
    /// defined in your custom intent definition.
    ///
    /// - Parameters:
    ///   - configuration: The intent containing user-customized values.
    ///   - context: An object describing the context to show the widget in.
    ///   - completion: The completion handler to call after you create the
    ///     snapshot entry.
    @preconcurrency func getSnapshot(for configuration: Self.Intent, in context: Self.Context, completion: @escaping @Sendable (Self.Entry) -> Void)

    /// Provides an array of timeline entries for the current time and,
    /// optionally, any future times to update a widget.
    ///
    /// The `configuration` parameter provides user-customized values, as
    /// defined in your custom intent definition.
    ///
    /// - Parameters:
    ///   - configuration: The intent containing user-customized values.
    ///   - context: An object describing the context to show the widget in.
    ///   - completion: The completion handler to call after you create the
    ///     timeline.
    @preconcurrency func getTimeline(for configuration: Self.Intent, in context: Self.Context, completion: @escaping @Sendable (Timeline<Self.Entry>) -> Void)

    /// Provides an object containing attributes that describe when a specific
    /// widget is relevant.
    ///
    /// The system can use the relevance to show this widget in the Smart Stack
    /// when the provided relevance matches a person's context. For example,
    /// if you indicate relevance at a specific location, the system could
    /// show the widget when a person is at or close to the location.
    ///
    /// By default, this method returns no relevances. Implement this
    /// requirement to tell the system that your widget is relevant.
    ///
    /// > Note: Smart Stacks are available in iOS, iPadOS, and watchOS.
    /// However, functionality provided by RelevanceKit API is only available
    /// in watchOS. Calling its API on other platforms doesn't have any effect.
    /// For more information, refer to <doc:Widget-Suggestions-In-Smart-Stacks>.
    ///
    /// - Returns: The object that contains attributes that describe when a specific
    /// widget is relevant.
    @available(iOS 18.0, macOS 15.0, watchOS 11.0, visionOS 26.0, *)
    @available(tvOS, unavailable)
    func relevance() async -> WidgetRelevance<Self.Intent>
}

@available(iOS 16.0, macOS 13.0, visionOS 26.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension IntentTimelineProvider {

    /// Returns a set of intent recommendations you use to offer pre-configured
    /// widgets on platforms that don't offer a dedicated user interface for
    /// customizing widget intents.
    public func recommendations() -> [IntentRecommendation<Self.Intent>]
}

extension IntentTimelineProvider {

    /// Provides an object containing attributes that describe when a specific
    /// widget is relevant.
    ///
    /// The system can use the relevance to show this widget in the Smart Stack
    /// when the provided relevance matches a person's context. For example,
    /// if you indicate relevance at a specific location, the system could
    /// show the widget when a person is at or close to the location.
    ///
    /// By default, this method returns no relevances. Implement this
    /// requirement to tell the system that your widget is relevant.
    ///
    /// > Note: Smart Stacks are available in iOS, iPadOS, and watchOS.
    /// However, functionality provided by RelevanceKit API is only available
    /// in watchOS. Calling its API on other platforms doesn't have any effect.
    /// For more information, refer to <doc:Widget-Suggestions-In-Smart-Stacks>.
    ///
    /// - Returns: The object that contains attributes that describe when a specific
    /// widget is relevant.
    @available(iOS 18.0, macOS 15.0, watchOS 11.0, visionOS 26.0, *)
    @available(tvOS, unavailable)
    public func relevance() async -> WidgetRelevance<Self.Intent>
}

/// The level of detail the view is recommended to have.
///
/// The system can update the levelOfDetail value based on user proximity or other
/// system specific factors and allow content customization adapting to show
/// different levels of details.
///
/// > Note: The `levelOfDetail` can be determined by different factors depending
/// on the platforms. On visionOS, it would be user proximity.
/// On all non-visionOS platforms this will always be `default` LevelOfDetail
///
@available(iOS 26.0, *)
@available(tvOS, unavailable)
@available(macOS, unavailable)
@available(watchOS, unavailable)
public struct LevelOfDetail : Equatable {

    /// The default level of details.
    ///
    /// This suggests the app should lay out its content and show a default amount of information.
    public static let `default`: LevelOfDetail

    /// The level of detail should be simplified.
    ///
    /// This suggests the app should lay out its content and show a simplified version of its content.
    /// On visionOS specifically, this signals that the user is at a further distance.
    public static let simplified: LevelOfDetail

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (a: LevelOfDetail, b: LevelOfDetail) -> Bool
}

/// Preview a timeline-style widget.
///
/// - Parameters:
///   - name: An optional display name for the preview, which will appear in the canvas.
///   - family: The widget family to display.
///   - widget: A closure producing the widget to be previewed.
///   - timeline: A closure building the timeline of entries to be previewed.
///
/// The preview will allow you to step through your timeline and test out the transitions between entries. (The dates of the entries will be ignored.)
/// - Note: The timeline entries must be of the type expected by the widget. (This will be enforced at run-time.)
@available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 26.0, *)
@available(tvOS, unavailable)
@freestanding(declaration) public macro Preview<Widget>(_ name: String? = nil, as family: WidgetFamily, widget: @escaping () -> Widget, @PreviewTimelineBuilder timeline: @escaping @MainActor () async -> [any TimelineEntry]) = #externalMacro(module: "PreviewsMacros", type: "Common") where Widget : Widget

/// Preview a widget with a static configuration, using the specified timeline provider.
///
/// - Parameters:
///   - name: An optional display name for the preview, which will appear in the canvas.
///   - family: The widget family to display.
///   - widget: A closure producing the widget to be previewed.
///   - timelineProvider: A closure producing the timeline provider that will generate the preview's timeline.
///
/// The preview will allow you to step through the timeline generated by the provider. It might be helpful to instantiate your timeline provider with sample data.
/// - Note: The timeline provider must be of the type expected by the widget. (This will be enforced at run-time.)
@available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 26.0, *)
@available(tvOS, unavailable)
@freestanding(declaration) public macro Preview<Widget, Provider>(_ name: String? = nil, as family: WidgetFamily, widget: @escaping () -> Widget, timelineProvider: @escaping () -> Provider) = #externalMacro(module: "PreviewsMacros", type: "Common") where Widget : Widget, Provider : TimelineProvider

/// Preview a widget with an intent configuration, using the specified timeline provider.
///
/// - Parameters:
///   - name: An optional display name for the preview, which will appear in the canvas.
///   - family: The widget family to display.
///   - intent: The intent with which to configure the widget.
///   - widget: A closure producing the widget to be previewed.
///   - timelineProvider: A closure producing the timeline provider that will generate the preview's timeline.
///
/// The preview will allow you to step through the timeline generated by the provider. It might be helpful to instantiate your timeline provider with sample data.
/// - Note: The timeline provider must be of the type expected by the widget. (This will be enforced at run-time.)
@available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 26.0, *)
@available(tvOS, unavailable)
@freestanding(declaration) public macro Preview<Widget, Provider>(_ name: String? = nil, as family: WidgetFamily, using intent: Provider.Intent, widget: @escaping () -> Widget, timelineProvider: @escaping () -> Provider) = #externalMacro(module: "PreviewsMacros", type: "Common") where Widget : Widget, Provider : IntentTimelineProvider

/// Preview a widget with an app intent configuration, using the specified timeline provider.
///
/// - Parameters:
///   - name: An optional display name for the preview, which will appear in the canvas.
///   - family: The widget family to display.
///   - intent: The intent with which to configure the widget.
///   - widget: A closure producing the widget to be previewed.
///   - timelineProvider: A closure producing the timeline provider that will generate the preview's timeline.
///
/// The preview will allow you to step through the timeline generated by the provider. It might be helpful to instantiate your timeline provider with sample data.
/// - Note: The timeline provider must be of the type expected by the widget. (This will be enforced at run-time.)
@available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 26.0, *)
@available(tvOS, unavailable)
@freestanding(declaration) public macro Preview<Widget, Provider>(_ name: String? = nil, as family: WidgetFamily, using intent: Provider.Intent, widget: @escaping () -> Widget, timelineProvider: @escaping () -> Provider) = #externalMacro(module: "PreviewsMacros", type: "Common") where Widget : Widget, Provider : AppIntentTimelineProvider

/// Preview a widget with an activity configuration, using the specified attributes and content states.
///
/// - Parameters:
///   - name: An optional display name for the preview, which will appear in the canvas.
///   - viewKind: The kind of widget view to display.
///   - attributes: The attributes with which to configure the widget.
///   - widget: A closure producing the widget to be previewed.
///   - contentStates: A closure building the content states to be previewed.
///
/// The preview will allow you to step through the specified content states and test out the transitions between states.
/// - Note: The attributes must be of the type expected by the widget. (This will be enforced at run-time.)
@available(iOS 17.0, *)
@available(macOS, unavailable)
@available(visionOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
@freestanding(declaration) public macro Preview<Widget, Attributes>(_ name: String? = nil, as viewKind: ActivityPreviewViewKind, using attributes: Attributes, widget: @escaping () -> Widget, @PreviewActivityBuilder<Attributes> contentStates: @escaping @MainActor () async -> [Attributes.ContentState]) = #externalMacro(module: "PreviewsMacros", type: "Common") where Widget : Widget, Attributes : ActivityAttributes

@available(iOS 17.0, *)
@available(macOS, unavailable)
@available(visionOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
@resultBuilder public struct PreviewActivityBuilder<A> where A : ActivityAttributes {

    public static func buildExpression(_ contentState: A.ContentState) -> [A.ContentState]

    public static func buildPartialBlock(first: [A.ContentState]) -> [A.ContentState]

    public static func buildPartialBlock(accumulated: [A.ContentState], next: [A.ContentState]) -> [A.ContentState]

    public static func buildArray(_ components: [[A.ContentState]]) -> [A.ContentState]
}

@available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 26.0, *)
@available(tvOS, unavailable)
@resultBuilder public struct PreviewTimelineBuilder {

    public static func buildExpression(_ entry: some TimelineEntry) -> [any TimelineEntry]

    public static func buildPartialBlock(first: [any TimelineEntry]) -> [any TimelineEntry]

    public static func buildPartialBlock(accumulated: [any TimelineEntry], next: [any TimelineEntry]) -> [any TimelineEntry]

    public static func buildArray(_ components: [[any TimelineEntry]]) -> [any TimelineEntry]
}

/// An object describing the content of a widget that has no user-configurable
/// options.
///
/// The following example shows the configuration for the leaderboard widget of
/// the <doc://com.apple.documentation/documentation/widgetkit/emoji_rangers_supporting_live_activities_interactivity_and_animations>
/// sample code project.
///
///     struct LeaderboardWidget: Widget {
///
///         public var body: some WidgetConfiguration {
///             StaticConfiguration(kind: EmojiRanger.LeaderboardWidgetKind, provider: LeaderboardProvider()) { entry in
///                 LeaderboardWidgetEntryView(entry: entry)
///             }
///             .configurationDisplayName("Ranger Leaderboard")
///             .description("See all the rangers.")
///             .supportedFamilies(LeaderboardWidget.supportedFamilies)
///         }
///     }
///
/// Every widget has a unique `kind`, a string that you choose. You use this
/// string to identify your widget when reloading its timeline with
/// <doc:WidgetCenter>.
///
/// The timeline provider is an object that determines the timeline for
/// refreshing your widget. Providing future dates for updating your widget
/// allows the system to optimize the refresh process.
///
/// The content closure contains the SwiftUI views that WidgetKit needs to
/// render the widget. When WidgetKit invokes the content closure, it passes a
/// timeline entry created by the widget provider's
/// <doc:TimelineProvider/getSnapshot(in:completion:)> or
/// <doc:TimelineProvider/getTimeline(in:completion:)>
/// method.
///
/// Modifiers let you specify the families your widget supports, and the
/// details shown when users add or edit their widgets.
@available(iOS 14.0, macOS 11.0, watchOS 9.0, visionOS 26.0, *)
@available(tvOS, unavailable)
@MainActor @preconcurrency public struct StaticConfiguration<Content> : WidgetConfiguration where Content : View {

    /// The content and behavior of this widget.
    @MainActor @preconcurrency public var body: some WidgetConfiguration { get }

    /// The type of widget configuration representing the body of
    /// this configuration.
    ///
    /// When you create a custom widget, Swift infers this type from your
    /// implementation of the required `body` property.
    @available(iOS 14.0, watchOS 9.0, visionOS 26.0, macOS 11.0, *)
    @available(tvOS, unavailable)
    public typealias Body = some WidgetConfiguration
}

@available(iOS 14.0, macOS 11.0, watchOS 9.0, visionOS 26.0, *)
@available(tvOS, unavailable)
extension StaticConfiguration {

    /// Creates a configuration for a widget, with no user-configurable
    /// options.
    /// - Parameters:
    ///   - kind: A unique string that you choose.
    ///   - provider: An object that determines the timing of updates
    ///     to the widget's views.
    ///   - content: A view that renders the widget.
    @MainActor @preconcurrency public init<Provider>(kind: String, provider: Provider, @ViewBuilder content: @escaping (Provider.Entry) -> Content) where Provider : TimelineProvider
}

@available(iOS 14.0, macOS 11.0, watchOS 9.0, visionOS 26.0, *)
@available(tvOS, unavailable)
extension StaticConfiguration : Sendable {
}

/// The description of a control widget that has no user-configurable options.
///
/// The following example shows the configuration for a garage door opener
/// control.
///
///     struct GarageDoorOpener: ControlWidget {
///         var body: some ControlWidgetConfiguration {
///             StaticControlConfiguration(
///                 kind: "com.yourcompany.GarageDoorOpener",
///                 provider: GarageDoorValueProvider()
///             ) { isOpen in
///                 ControlWidgetToggle(
///                     "Garage Door",
///                     isOn: isOpen,
///                     action: ToggleGarageDoor()
///                 ) {
///                     Label(
///                         $0 ? "Open" : "Closed",
///                         systemImage: $0 ? "door.garage.open" : "door.garage.closed"
///                     )
///                 }
///             }
///         }
///     }
///
/// Every control has a unique `kind`, a string that you choose to uniquely
/// identify the type of control. You use this string to identify your control
/// when reloading its template with ``ControlCenter``.
///
/// The value provider is an object that determines a value to use to render
/// your template.
///
/// The content closure defines the template that WidgetKit needs to render the
/// control. If you create the configuration using a value provider, when
/// WidgetKit invokes the content closure, it passes a value created by the
/// provider's ``ControlValueProvider/previewValue`` property or
/// ``ControlValueProvider/currentValue()`` function.
@available(iOS 18.0, macOS 26.0, watchOS 26.0, *)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
@MainActor @preconcurrency public struct StaticControlConfiguration<Content> : ControlWidgetConfiguration where Content : ControlWidgetTemplate {

    /// The content and behavior of the control.
    @MainActor @preconcurrency public var body: some ControlWidgetConfiguration { get }

    /// The type of control widget configuration representing the body of this
    /// configuration.
    @available(iOS 18.0, watchOS 26.0, macOS 26.0, *)
    @available(tvOS, unavailable)
    @available(visionOS, unavailable)
    public typealias Body = some ControlWidgetConfiguration
}

@available(iOS 18.0, macOS 26.0, watchOS 26.0, *)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
extension StaticControlConfiguration {

    /// Creates a configuration for a control, with no user-configurable options.
    ///
    /// - Parameters:
    ///   - kind: A string that uniquely identifies the type of control.
    ///   - content: A template that renders the control.
    @MainActor @preconcurrency public init(kind: String, @ControlWidgetTemplateBuilder content: @escaping () -> Content)

    /// Creates a configuration for a control, with no user-configurable options.
    ///
    /// - Parameters:
    ///   - kind: A string that uniquely identifies the type of control.
    ///   - provider: An object that provides a value to the control template.
    ///   - content: A template that renders the control.
    @MainActor @preconcurrency public init<Provider>(kind: String, provider: Provider, @ControlWidgetTemplateBuilder content: @escaping (Provider.Value) -> Content) where Provider : ControlValueProvider
}

@available(iOS 18.0, macOS 26.0, watchOS 26.0, *)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
extension StaticControlConfiguration : Sendable {
}

/// An environment key for the size of a rendered Live Activity.
///
/// To detect the currently rendered activity family size, use the <doc://com.apple.documentation/documentation/swiftui/environmentvalues/activityfamily>
/// environment variable.
@available(iOS 18.0, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct SupportedActivityFamiliesEnvironmentKey : EnvironmentKey {

    /// The default value for the environment key.
    public static var defaultValue: Set<ActivityFamily> { get }

    /// The associated type representing the type of the environment key's
    /// value.
    @available(iOS 18.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    public typealias Value = Set<ActivityFamily>
}

/// An object that specifies a date for WidgetKit to update a widget's view.
///
/// To tell WidgetKit when to update a widget’s view, <doc:TimelineProvider>
/// generates a timeline. The timeline contains an array of timeline entry
/// objects and a refresh policy.
///
/// To create timeline entries, declare a custom type that conforms to
/// `TimelineEntry`. Each entry specifies the date you would like WidgetKit to
/// update the widget's view, and any additional information that your widget
/// needs to render the view. Timeline entries may also include information
/// about their relevance compared to other entries in timelines for the same
/// widget kind. WidgetKit uses this relevance information when considering
/// whether a widget should be promoted in a stack. For more about supplying
/// relevance information, see <doc:TimelineEntryRelevance>.
///
/// The timeline's refresh policy specifies the earliest date for WidgetKit to
/// request a new timeline from the provider. The default refresh policy,
/// ``WidgetKit/TimelineReloadPolicy/atEnd``, tells WidgetKit to request a new timeline after the last date in
/// the array of timeline entries you provide. However, you can use
/// ``WidgetKit/TimelineReloadPolicy/after(_:)`` to indicate a different date either earlier or later than the
/// default date. Specify an earlier date if you know there's a point in time
/// before the end of your timeline entries that may alter the timeline.
/// Conversely, specify a later date if you know that after the last date, your
/// timeline won't change for some period of time. Alternatively, use ``WidgetKit/TimelineReloadPolicy/never``
/// to tell WidgetKit not to request a new timeline at all. In that case, your
/// app uses <doc:WidgetCenter> to prompt WidgetKit to request a new timeline.
///
/// > Note: WidgetKit may not update the widget's view exactly at a timeline
///   entry's date. The update may occur at a later date.
///
/// For more information about generating timelines, see <doc:TimelineProvider>.
@available(iOS 14.0, macOS 11.0, watchOS 9.0, visionOS 26.0, *)
@available(tvOS, unavailable)
public struct Timeline<EntryType> where EntryType : TimelineEntry {

    /// An array of timeline entries.
    public let entries: [EntryType]

    /// The policy that determines the earliest date and time WidgetKit
    /// requests a new timeline from a timeline provider.
    public let policy: TimelineReloadPolicy

    /// Creates a timeline for when you want WidgetKit to update a widget's
    /// view.
    ///
    /// Set the date and time of the first entry in a timeline to the current
    /// date and time. Add entries for future dates and times when you want
    /// WidgetKit to update the widget's view. Note that the widget's view
    /// might not be updated precisely at a timeline entry's date and time; the
    /// update might occur later.
    ///
    /// - Parameters:
    ///   - entries: An array of timeline entries.
    ///   - policy: The policy that determines the earliest date and time
    ///     WidgetKit requests a new timeline from a timeline provider.
    public init(entries: [EntryType], policy: TimelineReloadPolicy)
}

/// A type that specifies the date to display a widget, and, optionally,
/// indicates the current relevance of the widget's content.
///
/// A <doc:TimelineProvider> creates one or more timeline entries with
/// dates that tell WidgetKit when to display a widget. To render a
/// widget, WidgetKit executes the `content` block of the widget's
/// configuration, passing the corresponding timeline entry.
///
/// When you declare a structure conforming to `TimelineEntry`, include any
/// additional information that the configuration’s content block requires to
/// render the widget. The following code shows a timeline entry structure for
/// a widget that displays a game character's health level.
///
///     struct CharacterDetailEntry: TimelineEntry {
///         var date: Date
///         var healthLevel: Double
///     }
///
/// The content block of the widget's configuration receives the entry as a
/// parameter and then passes the relevant information to the view that
/// renders your widget.
///
///     struct CharacterDetailWidget: Widget {
///         var body: some WidgetConfiguration {
///             StaticConfiguration(
///                 kind: "com.mygame.character-detail",
///                 provider: CharacterDetailProvider()) { entry in
///                 CharacterDetailView(entry: entry)
///             }
///             .configurationDisplayName("Character Details")
///             .description("Displays a character's health and other details")
///             .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
///         }
///     }
///
@available(iOS 14.0, macOS 11.0, watchOS 9.0, visionOS 26.0, *)
@available(tvOS, unavailable)
public protocol TimelineEntry {

    /// The date for WidgetKit to render a widget.
    var date: Date { get }

    /// The relevance of a widget’s content to the user.
    var relevance: TimelineEntryRelevance? { get }
}

@available(iOS 14.0, macOS 11.0, watchOS 9.0, visionOS 26.0, *)
@available(tvOS, unavailable)
extension TimelineEntry {

    /// The relevance of a widget’s content to the user.
    public var relevance: TimelineEntryRelevance? { get }
}

/// An object that describes the relative importance of a timeline entry
/// compared to other entries in the current and past timelines.
///
/// When users put widgets into a Smart Stack, WidgetKit uses the
/// <doc:TimelineEntry/relevance-2oovl> property of the entries your timeline
/// provider generates to determine how relevant they are to the user. For
/// each timeline entry that your provider creates, you may assign relevance
/// that contains a <doc:TimelineEntryRelevance/score> and a
/// <doc:TimelineEntryRelevance/duration>. The score is a value you choose that
/// indicates the relevance of the widget, relative to entries across timelines
/// that the provider creates. When the date of an entry arrives, and for the
/// duration you specify, WidgetKit may rotate your widget to the top of the
/// stack so it becomes visible.
///
/// A timeline entry's assigned relevance isn't the only factor that determines
/// whether WidgetKit rotates your widget to the top of the
/// Smart Stack. For more information, see <doc:Widget-Suggestions-In-Smart-Stacks>.
@available(iOS 14.0, macOS 11.0, watchOS 9.0, visionOS 26.0, *)
@available(tvOS, unavailable)
public struct TimelineEntryRelevance : Codable, Hashable {

    /// A value that indicates the relevance of an entry compared to other
    /// entries in the current and past timelines.
    public var score: Float

    /// The number of seconds, following an entry's date, that WidgetKit considers
    /// the widget for rotation to the top of the stack.
    public var duration: TimeInterval

    /// Creates an object that represents the importance of a widget and the
    /// length of time for WidgetKit to consider it for rotation to the top of
    /// the stack.
    /// - Parameters:
    ///   - score: A value on a scale of your choosing, indicating the
    ///     importance of an entry compared to other entries in the same
    ///     timeline.
    ///   - duration: The number of seconds following an entry's date that
    ///     WidgetKit may rotate the widget to the top of the stack.
    public init(score: Float, duration: TimeInterval = 0.0)

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (a: TimelineEntryRelevance, b: TimelineEntryRelevance) -> Bool

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

/// A type that advises WidgetKit when to update a widget's display.
///
/// At various times, WidgetKit requests a _timeline_ from the provider. A
/// timeline is an array of objects conforming to <doc:TimelineEntry>. Each
/// timeline entry has a date, and you can specify additional properties
/// for displaying the widget.
///
/// For example, consider a widget that displays the health level of a game
/// character. In the game, when the character's health level is below 100
/// percent, it recovers at a rate of 25 percent per hour. If the character's
/// health level is 25 percent, the provider creates a timeline consisting of
/// the following entries:
///
/// ![A diagram showing a timeline with four entries, starting with the current time at 25 percent health, and hourly entries for the next three hours at 50, 75, and 100 percent health](TimelineProvider-TimelineEntries.png)
///
/// The following code shows the structure encapsulating this information.
///
///     struct CharacterDetailEntry: TimelineEntry {
///         var date: Date
///         var healthLevel: Double
///     }
///
/// WidgetKit asks for timeline entries in one of two ways:
///
/// * A single immediate snapshot, representing the widget’s current state.
/// * An array of entries, including the current moment and, if known, any
///    future dates when the widget’s state will change.
///
/// WidgetKit makes the snapshot request when displaying the widget in
/// transient situations, such as when the user is adding a widget. WidgetKit
/// provides a `context` parameter that includes details about how to use the
/// entry, including whether it’s a preview for the widget gallery, and the
/// family, or size, of the widget to display. If `context.isPreview` is
/// `true`, the widget appears in the widget gallery and requires a quick
/// response from your provider. If the information you need to generate the
/// snapshot is not readily available, or requires additional time to load, use
/// sample data instead. For example, if determining the character's health
/// level requires fetching data from a server, the widget could show the
/// health level at 75 percent. The following code shows how the game widget
/// might implement its snapshot method.
///
///     struct CharacterDetailProvider: TimelineProvider {
///         func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
///             let date = Date()
///             let entry: CharacterDetailEntry
///
///             if context.isPreview && !hasHealthLevel {
///                 entry = CharacterDetailEntry(date: date, healthLevel: 0.75)
///             } else {
///                 entry = CharacterDetailEntry(date: date, healthLevel: currentHealthLevel)
///             }
///             completion(entry)
///         }
///     }
///
/// WidgetKit makes the timeline request after the user adds your widget from
/// the widget gallery. Because your widget extension is not always running,
/// WidgetKit needs to know when to activate it to update the
/// widget. The timeline your provider generates informs WidgetKit when you
/// would like to update the widget. The following example shows how the
/// <doc://com.apple.documentation/documentation/widgetkit/emoji_rangers_supporting_live_activities_interactivity_and_animations>
/// sample code project creates a timeline for its leaderboard widget.
///
///     func getTimeline(in context: Context, completion: @escaping (Timeline<LeaderboardEntry>) -> Void) {
///         EmojiRanger.loadLeaderboardData { (heros, error) in
///             guard let heros else {
///                 let timeline = Timeline(entries: [LeaderboardEntry(date: Date(), heros: EmojiRanger.availableHeros)], policy: .atEnd)
///
///                 completion(timeline)
///
///                 return
///             }
///             let timeline = Timeline(entries: [LeaderboardEntry(date: Date(), heros: heros)], policy: .atEnd)
///             completion(timeline)
///         }
///     }
///
/// If your provider needs to do asynchronous work to generate the timeline,
/// such as fetching data from a server, store a reference to the
/// `completion` handler and call it when you are done with your asynchronous
/// work.
///
/// ### Determine a refresh policy
///
/// When creating the timeline, the provider specifies a refresh policy that
/// controls when WidgetKit requests a new timeline. The default
/// behavior is to use ``WidgetKit/TimelineReloadPolicy/atEnd`` to request a new timeline after the last date
/// specified by the entries in a timeline. However, if there is a different
/// date when WidgetKit should request a new timeline, you can specify a
/// refresh policy of ``WidgetKit/TimelineReloadPolicy/after(_:)``. For example, a dragon will appear in
/// 2.5 hours and might engage in battle with the game character. Because the
/// outcome of this battle may change the character's health level, the
/// provider can tell WidgetKit to request a new timeline after the battle.
///
///     // Request a timeline refresh after 2.5 hours.
///     let date = Calendar.current.date(byAdding: .minute, value: 150, to: Date())!
///     let timeline = Timeline(entries: entries, policy: .after(date))
///     completion(timeline)
///
/// Other examples of when it makes sense to use a different date include:
///
/// * In a widget displaying stock market details, you might specify the next
///   market opening or closing date because information typically doesn't
///   change overnight or during weekends.
/// * A flight tracking widget might continue showing a “flight
///   landed” indication after the flight lands. In this case, you could
///   specify a date later than when the flight lands so that its status
///   remains visible for a while before being cleared.
///
/// Alternatively, if future events are unpredictable, you can tell WidgetKit
/// to not request a new timeline at all by specifying ``WidgetKit/TimelineReloadPolicy/never`` for the
/// policy. In that case, your app calls the <doc:WidgetCenter> function
/// <doc:WidgetCenter/reloadTimelines(ofKind:)> when a new timeline is
/// available. Some examples of when using ``WidgetKit/TimelineReloadPolicy/never`` makes sense include:
///
/// * When the user has a widget configured to display the health of a
///   character, but that character is no longer actively engaging in battle
///   and its health level won't change.
/// * When a widget’s content is dependent on the user being logged into an
///   account and they aren’t currently logged in.
///
/// In both examples, when your app determines that the status has changed, it
/// calls the <doc:WidgetCenter> function
/// <doc:WidgetKit/WidgetCenter/reloadTimelines(ofKind:)> and WidgetKit
/// requests a new timeline.
///
/// ### Refresh widgets efficiently
///
/// Each configured widget receives a limited number of refreshes every day. Several
/// factors affect how many refreshes a widget receives, such as
/// whether the containing app is running in the foreground or background, how
/// frequently the widget is shown onscreen, and what types of activities the
/// containing app engages in.
///
/// - Note: WidgetKit does not impose this limit when debugging your widget in
///   Xcode. To verify that your widget behaves correctly, test your app and
///   widget's behavior outside of Xcode's debugger.
///
/// Use the following approaches to optimize your widget refreshes:
///
/// * Have the containing app prepare data for the widget in advance of when the
///   widget needs it. Use a shared group container to store the data.
/// * Use background processing time in your app to keep shared data up to date.
///   For more information, see
///   <doc://com.apple.documentation/documentation/uikit/app_and_environment/scenes/preparing_your_ui_to_run_in_the_background/updating_your_app_with_background_app_refresh>.
/// * Choose the most appropriate refresh policy for the information being shown,
///   as described in the preceding section.
/// * Call <doc:WidgetCenter/reloadTimelines(ofKind:)> only when information
///   the widget is currently displaying changes.
///
/// When your app is in the foreground, has an active media session, or
/// is using the standard location service, refreshes don't count against the
/// widget's daily limit. For more information about media sessions and location
/// services, see
/// <doc://com.apple.documentation/documentation/avfaudio/avaudiosession>
/// and
/// <doc://com.apple.documentation/documentation/corelocation/configuring_your_app_to_use_location_services>.
@available(iOS 14.0, macOS 11.0, watchOS 9.0, visionOS 26.0, *)
@available(tvOS, unavailable)
public protocol TimelineProvider {

    /// A type that specifies the date to display a widget, and, optionally,
    /// indicates the current relevance of the widget's content.
    associatedtype Entry : TimelineEntry

    /// An object that contains details about how a widget is rendered, including its size and whether it
    /// appears in the widget gallery.
    ///
    /// For more information, see <doc:TimelineProviderContext>.
    typealias Context = TimelineProviderContext

    /// Provides a timeline entry representing a placeholder version of the
    /// widget.
    ///
    /// When WidgetKit displays your widget for the first time, it renders the widget's
    /// view as a placeholder. A placeholder view displays a generic representation of
    /// your widget, giving the user a general idea of what the widget shows. WidgetKit
    /// calls `placeholder(in:)` to request an entry representing
    /// the widget's placeholder configuration. For example, the game status widget
    /// would implement this method as follows:
    ///
    ///     struct GameStatusProvider: TimelineProvider {
    ///         func placeholder(in context: Context) -> SimpleEntry {
    ///            GameStatusEntry(date: Date(), gameStatus: "—")
    ///         }
    ///     }
    ///
    /// In addition, WidgetKit may render your widget as a placeholder if users choose to hide sensitive
    /// information on Apple Watch or the iPhone Lock Screen. To learn more about redacting sensitive
    /// data, see <doc:Creating-a-Widget-Extension>.
    ///
    /// > Important: `placeholder(in:)` is synchronous and returns
    /// a `TimelineEntry` immediately. Return from `placeholder(in:)` as quickly
    /// as possible.
    ///
    /// - Parameter context: An object that describes the context in which to
    ///   show the widget.
    /// - Returns: A timeline entry that represents a placeholder version of the
    ///   widget.
    func placeholder(in context: Self.Context) -> Self.Entry

    /// Provides a timeline entry that represents the current time and state of a
    /// widget.
    ///
    /// WidgetKit calls `getSnapshot(in:completion:)` when the widget
    /// appears in transient situations. If `context.isPreview` is `true`, the
    /// widget appears in the widget gallery. In that case, call the
    /// `completion` handler as quickly as possible, perhaps supplying sample
    /// data if it could take more than a few seconds to fetch or calculate the
    /// widget's current state.
    /// - Parameters:
    ///   - context: An object describing the context to show the widget in.
    ///   - completion: The completion handler to call after you create the
    ///     snapshot entry.
    @preconcurrency func getSnapshot(in context: Self.Context, completion: @escaping @Sendable (Self.Entry) -> Void)

    /// Provides an array of timeline entries for the current time and,
    /// optionally, any future times to update a widget.
    /// - Parameters:
    ///   - context: An object describing the context to show the widget in.
    ///   - completion: The completion handler to call after you create the
    ///     timeline.
    @preconcurrency func getTimeline(in context: Self.Context, completion: @escaping @Sendable (Timeline<Self.Entry>) -> Void)

    /// Provides an object containing attributes that describe when a specific
    /// widget is relevant.
    ///
    /// The system can use the relevance to show this widget in the Smart Stack
    /// when the provided relevance matches a person's context. For example,
    /// if you indicate relevance at a specific location, the system could
    /// show the widget when a person is at or close to the location.
    ///
    /// By default, this method returns no relevances. Implement this
    /// requirement to tell the system that your widget is relevant.
    ///
    /// > Note: Smart Stacks are available in iOS, iPadOS, and watchOS.
    /// However, functionality provided by RelevanceKit API is only available
    /// in watchOS. Calling its API on other platforms doesn't have any effect.
    /// For more information, refer to <doc:Widget-Suggestions-In-Smart-Stacks>.
    ///
    /// - Returns: The object that contains attributes that describe when a specific
    /// widget is relevant.
    @available(iOS 18.0, macOS 15.0, watchOS 11.0, visionOS 26.0, *)
    @available(tvOS, unavailable)
    func relevance() async -> WidgetRelevance<Void>
}

extension TimelineProvider {

    /// Provides an object containing attributes that describe when a specific
    /// widget is relevant.
    ///
    /// The system can use the relevance to show this widget in the Smart Stack
    /// when the provided relevance matches a person's context. For example,
    /// if you indicate relevance at a specific location, the system could
    /// show the widget when a person is at or close to the location.
    ///
    /// By default, this method returns no relevances. Implement this
    /// requirement to tell the system that your widget is relevant.
    ///
    /// > Note: Smart Stacks are available in iOS, iPadOS, and watchOS.
    /// However, functionality provided by RelevanceKit API is only available
    /// in watchOS. Calling its API on other platforms doesn't have any effect.
    /// For more information, refer to <doc:Widget-Suggestions-In-Smart-Stacks>.
    ///
    /// - Returns: The object that contains attributes that describe when a specific
    /// widget is relevant.
    @available(iOS 18.0, macOS 15.0, watchOS 11.0, visionOS 26.0, *)
    @available(tvOS, unavailable)
    public func relevance() async -> WidgetRelevance<Void>
}

///
/// An object that contains details about how a widget is rendered, including
/// its size and whether it appears in the widget gallery.
///
/// When requesting timelines for a widget, WidgetKit passes the
/// <doc:TimelineProvider> a context object that includes details about how
/// the widget appears. These details include:
///
/// * The <doc:WidgetKit/WidgetFamily>; for example, <doc:WidgetKit/WidgetFamily/systemSmall> and  <doc:WidgetKit/WidgetFamily/systemMedium>.
/// * The size, in points, of the widget.
/// * Variants of the environments where the widget might appear.
/// * Whether the widget appears as a preview in the widget gallery.
///
/// If your widget uses assets that take time to generate or depend on the specific
/// environment they're rendered in, you can use the environment variants to
/// generate those assets in advance. Some of the common environment properties
/// to consider include:
///
/// * <doc://com.apple.documentation/swiftui/environmentvalues/colorscheme/>, where you use different assets for light and dark schemes.
/// * <doc://com.apple.documentation/documentation/swiftui/environmentvalues/displayscale>, where your widget might appear in both @1x and @2x
///   displays on macOS devices.
///
/// To be responsive when the environment changes, WidgetKit may render the
/// widget's view in advance. For example, WidgetKit renders both light and
/// dark versions of the widget so that if the color scheme changes, the correct
/// version is immediately available.
@available(iOS 14.0, macOS 11.0, watchOS 9.0, visionOS 26.0, *)
@available(tvOS, unavailable)
public struct TimelineProviderContext {

    /// A structure containing all varieties of environments where a widget
    /// could appear.
    ///
    /// When changes occur in environment values that affect display, like <doc://com.apple.documentation/swiftui/environmentvalues/colorscheme/>,
    /// WidgetKit renders your widget's views. If your widget
    /// uses assets that take time to generate or depend on the specific
    /// environment they're rendered in, you can generate those assets in
    /// advance based on the new environment values.
    ///
    /// For example, in macOS, if the user has a mixture of @1x and @2x
    /// displays, the value for <doc://com.apple.documentation/documentation/swiftui/environmentvalues/displayscale>
    /// includes both scales. With these values, you can prepare your content in advance, if needed, to
    /// handle either type of display.
    @dynamicMemberLookup public struct EnvironmentVariants {

        /// Returns the widget environment variants for a key path to an
        /// environment values instance.
        public subscript<T>(dynamicMember keyPath: WritableKeyPath<EnvironmentValues, T>) -> [T]? { get }

        /// Returns the widget environment variants for a key path to an
        /// environment values instance.
        public subscript<T>(keyPath: WritableKeyPath<EnvironmentValues, T>) -> [T]? { get }
    }

    /// All environment values that might be set when a widget appears.
    public let environmentVariants: TimelineProviderContext.EnvironmentVariants

    /// The user-configured family of the widget: small, medium, or large.
    public let family: WidgetFamily

    /// A Boolean value that indicates when the widget appears in the widget gallery.
    public let isPreview: Bool

    /// The size, in points, of the widget.
    public let displaySize: CGSize
}

/// A type that indicates the earliest date WidgetKit requests a new timeline
/// from the widget's provider.
@available(iOS 14.0, macOS 11.0, watchOS 9.0, visionOS 26.0, *)
@available(tvOS, unavailable)
public struct TimelineReloadPolicy : Equatable {

    /// A policy that specifies that WidgetKit requests a new timeline after
    /// the last date in a timeline passes.
    public static let atEnd: TimelineReloadPolicy

    /// A policy that specifies that the app prompts WidgetKit when a new
    /// timeline is available.
    public static let never: TimelineReloadPolicy

    /// A policy that specifies a future date for WidgetKit to request a new
    /// timeline.
    public static func after(_ date: Date) -> TimelineReloadPolicy

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (a: TimelineReloadPolicy, b: TimelineReloadPolicy) -> Bool
}

/// Constants that indicate the rendering mode for an `Image` in when displayed in a widget
/// in ``WidgetKit/WidgetRenderingMode/accented`` mode.
@available(iOS 18.0, watchOS 11.0, macOS 15.0, visionOS 26.0, *)
@available(tvOS, unavailable)
public struct WidgetAccentedRenderingMode : Hashable {

    /// Specifies that the `Image` should be included as part of the accented widget group.
    ///
    /// It is equivalent to applying the `.widgetAccentable()` modifier to the `Image`.
    public static let accented: WidgetAccentedRenderingMode

    /// Maps the luminance of the `Image` in to the alpha channel, replacing color
    /// channels with the color applied to the default group.
    public static let desaturated: WidgetAccentedRenderingMode

    /// Maps the luminance of the `Image` in to the alpha channel, replacing color
    /// channels with the color applied to the accent group.
    public static let accentedDesaturated: WidgetAccentedRenderingMode

    /// Specifies that the `Image` should be rendered at full color with no other
    /// color modifications. Only applies to iOS.
    public static let fullColor: WidgetAccentedRenderingMode

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (a: WidgetAccentedRenderingMode, b: WidgetAccentedRenderingMode) -> Bool

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

/// An object that contains a list of user-configured widgets and is used for
/// reloading widget timelines.
///
/// WidgetCenter provides information about user-configured widgets, such as
/// their family. For widgets that use <doc:IntentConfiguration>, you can
/// retrieve the user-edited values.
///
/// ### Getting Configured Widget Information
///
/// To get a list of user-configured widgets, use
/// <doc:WidgetCenter/getCurrentConfigurations(_:)>. This property provides an
/// array of <doc:WidgetInfo> objects containing the following information:
///
///     struct WidgetInfo {
///         public let configuration: INIntent?
///         public let family: WidgetFamily
///         public let kind: String
///     }
///
/// The `kind` string matches the parameter you use when creating the widget's
/// <doc:StaticConfiguration> or <doc:IntentConfiguration>. The `family`
/// property matches one of the options specified in the
/// <doc://com.apple.documentation/documentation/SwiftUI/WidgetConfiguration/supportedFamilies(_:)>
/// property of the widget’s configuration. If your widget is based on
/// <doc:IntentConfiguration>, the `configuration` property provides the
/// custom intent containing the user-customized values for each individual
/// widget.
///
/// ### Requesting a Reload of Your Widget's Timeline
///
/// Changes in your app’s state may affect a widget's timeline. When this
/// happens, you can tell WidgetKit to reload the timeline for either a
/// specific kind of widget or all widgets. For example, your app might
/// register for push notifications based on the widgets the user has configured.
/// When your app receives a push notification that changes the state for one
/// or more of your widgets, requesting a reload of their timelines updates
/// their display.
///
/// If you only need to reload a certain kind of widget, you can
/// request a reload for only that kind. For example, in response to a push
/// notification about a change in a game’s status, you could request a reload
/// for only the game status widgets:
///
///     WidgetCenter.shared.reloadTimelines(ofKind: "com.mygame.gamestatus")
///
/// To request a reload for all of your widgets:
///
///     WidgetCenter.shared.reloadAllTimelines()
@available(iOS 14.0, macOS 11.0, watchOS 9.0, visionOS 26.0, *)
@available(tvOS, unavailable)
public class WidgetCenter {

    /// The shared widget center.
    public static let shared: WidgetCenter

    /// An object that defines keys for accessing information in a user info dictionary.
    ///
    /// - Note: In Objective-C, use ``WGWidgetUserInfoKeyFamily`` and
    ///         ``WGWidgetUserInfoKeyKind`` instead.
    public struct UserInfoKey {

        /// A key you use to access the widget's kind. The value matches the `kind`
        /// property specified in the widget's configuration.
        public static let kind: String

        /// A key you use to access the widget's family.
        public static let family: String

        /// A key you use to access the activity ID if the widget represents a
        /// Live Activity.
        public static let activityID: String
    }

    /// Invalidates and refreshes the preconfigured intent configurations for
    /// user-customizable widgets.
    ///
    /// In watchOS, call this function when your app receives new data for
    /// preconfigured widgets you'd like to appear in the list of available
    /// watch complications.
    /// 
    /// > Note: On platforms that offer a dedicated user interface for configuring
    ///     widgets — for example, iOS or macOS —
    ///     `invalidateConfigurationRecommendations()` is inactive.
    @available(iOS 16.0, macOS 13.0, watchOS 9.0, visionOS 26.0, *)
    @available(tvOS, unavailable)
    public func invalidateConfigurationRecommendations()

    /// Retrieves information about user-configured widgets.
    ///
    /// - Parameter completion: A completion handler called when the widget
    ///   information is available.
    @preconcurrency public func getCurrentConfigurations(_ completion: @escaping @Sendable (Result<[WidgetInfo], any Error>) -> Void)

    /// Retrieves information about user-configured widgets.    
    @available(iOS 18.0, macOS 15.0, watchOS 11.0, visionOS 26.0, *)
    @available(tvOS, unavailable)
    public func currentConfigurations() async throws -> [WidgetInfo]

    /// Reloads the timelines for all widgets of a particular kind.
    /// - Parameter kind: A string that identifies the widget and matches the
    ///   value you used when you created the widget's configuration.
    public func reloadTimelines(ofKind kind: String)

    /// Reloads the timelines for all configured widgets belonging to the
    /// containing app.
    public func reloadAllTimelines()

    @objc deinit
}

@available(iOS 18.0, macOS 15.0, watchOS 11.0, visionOS 26.0, *)
@available(tvOS, unavailable)
extension WidgetCenter {

    /// Mark the relevance for a kind as invalid.
    ///
    /// Call this function when the relevance returned for a widget has
    /// changed and needs to be reloaded.
    ///
    /// Marking relevance as invalid will cause the system to call, at a later time,
    /// the `relevance` function on the timeline provider that match the specified kind.
    ///
    /// - Parameter kind: A string that identifies the widget and matches the
    ///   value you used when you created the widget's configuration.
    public func invalidateRelevance(ofKind kind: String)
}

@available(iOS 26.0, macOS 26.0, watchOS 26.0, *)
@available(tvOS, unavailable)
extension WidgetCenter {

    /// Provides the current push information for widget reloads and
    /// relevance refreshes.
    ///
    /// May be nil if the token has not completed
    /// generation, or if no widgets have been configured for push.
    public var currentPushInfo: WidgetPushInfo? { get async }
}

/// Values that define the widget's size and shape.
///
/// Widgets can support one or more sizes, giving users the flexibility to
/// configure their widgets however they like. Each widget size provides a
/// different amount of space for detail, so consider which sizes work best for
/// the type of information the widget displays. For more information about
/// designing widgets, see 
/// [Widgets](https://developer.apple.com/design/human-interface-guidelines/widgets/overview/introduction/) 
/// or [Complications](https://developer.apple.com/design/human-interface-guidelines/watchos/overview/complications/).
///
/// > Note: The sizes of widgets may vary across devices. Your widget content
///   should be flexible and avoid using fixed values.
///
/// You specify the sizes your widget supports using the <doc://com.apple.documentation/documentation/swiftui/widgetconfiguration/supportedFamilies(_:)>
/// property modifier when defining your widget’s configuration.
///
///     struct GameStatusWidget: Widget {
///         var body: some WidgetConfiguration {
///             StaticConfiguration(
///                 kind: "com.mygame.game-status",
///                 provider: GameStatusProvider(),
///                 placeholder: GameStatusPlaceholderView()
///             ) { entry in
///                 GameStatusView(entry.gameStatus)
///             }
///             .configurationDisplayName("Game Status")
///             .description("Shows an overview of your game status")
///             .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
///         }
///     }
///
/// When WidgetKit needs to load a widget's timeline, it calls the 
/// ``WidgetKit/TimelineProvider`` class's 
/// ``WidgetKit/TimelineProvider/getTimeline(in:completion:)`` method. The system
/// passes a ``WidgetKit/TimelineProviderContext`` instance to the method's 
/// `context` parameter. Use the context's 
/// ``WidgetKit/TimelineProviderContext/family`` property to determine the 
/// widget's size and shape. For example, the 
/// ``WidgetKit/WidgetFamily/systemSmall`` family represents a small, square 
/// widget on the Home Screen or Today View in iOS or iPadOS, while, in watchOS
/// the``WidgetKit/WidgetFamily/accessoryCorner`` family appears as 
/// a widget-based complication in the corner of a watch face. 
///
/// Use the ``WidgetKit/WidgetFamily`` value to return the appropriate content 
/// given the widget's size. For example, 
/// a ``WidgetKit/WidgetFamily/systemSmall`` widget may focus on showing only 
/// the most critical data, such as a single image or a simple gauge, while 
/// a ``WidgetKit/WidgetFamily/systemLarge`` widget can contain additional 
/// details, more-complex graphs, and even small blocks of text.
@available(iOS 14.0, macOS 11.0, watchOS 9.0, visionOS 26.0, *)
@available(tvOS, unavailable)
@preconcurrency public enum WidgetFamily : Int, RawRepresentable, CustomDebugStringConvertible, CustomStringConvertible, Sendable {

    /// A small widget.
    ///
    /// The small system widget can appear on the Home Screen or in the Today
    /// View in iOS and iPadOS. Starting with iPadOS 17, it also appears on the
    /// iPad Lock Screen. In macOS, the small system widget can appear on the
    /// desktop or in Notification Center.
    @available(iOS 14.0, macOS 11.0, visionOS 26.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    case systemSmall

    /// A medium-sized widget.
    ///
    /// The medium system widget can appear on the Home Screen or in the Today
    /// View in iOS and iPadOS. In macOS, the medium system widget can appear
    /// on the desktop or in Notification Center.
    @available(iOS 14.0, macOS 11.0, visionOS 26.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    case systemMedium

    /// A large widget.
    ///
    /// The large system widget can appear on the Home Screen or in the Today
    /// View in iOS and iPadOS. In macOS, the large system widget can appear
    /// on the desktop or in Notification Center.
    @available(iOS 14.0, macOS 11.0, visionOS 26.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    case systemLarge

    /// An extra-large widget.
    ///
    /// Extra-large widgets are available in iPadOS and macOS.
    /// To add an extra-large widget to your visionOS app, use
    /// ``WidgetFamily/systemExtraLargePortrait``. To add an
    /// extra-large visionOS widget to a compatible iOS and iPadOS app,
    /// use the `systemExtraLarge` widget family. The extra-large widget
    /// appears in a portrait orientation, similar to the
    /// ``WidgetFamily/systemExtraLargePortrait`` widget of a visionOS app.
    @available(iOS 15.0, macOS 14.0, visionOS 26.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    case systemExtraLarge

    /// A circular widget.
    /// 
    /// The accessory circular widget can appear as a complication in watchOS, 
    /// or on the Lock Screen in iOS and iPadOS.
    ///
    /// > Note: Widgets on the iPad Lock Screen require iPadOS 17 or later.
    @available(iOS 16.0, watchOS 9.0, *)
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(visionOS, unavailable)
    case accessoryCircular

    /// A rectangular widget.
    ///
    /// In watchOS, the accessory rectangular widget can appear as a widget in
    /// the Smart Stack or as a complication on a watch face. In iOS and iPadOS,
    /// it can appear on the Lock Screen.
    ///
    /// > Note: Widgets on the iPad Lock Screen require iPadOS 17 or later.
    @available(iOS 16.0, watchOS 9.0, *)
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(visionOS, unavailable)
    case accessoryRectangular

    /// A flat widget that contains a single row of text and an optional image.
    ///
    /// The accessory inline widget can appear as a complication in watchOS, or 
    /// on the Lock Screen in iOS and iPadOS. On some watch faces, the system
    /// renders the complication along a curve.
    ///
    /// > Note: Widgets on the iPad Lock Screen require iPadOS 17 or later.
    @available(iOS 16.0, watchOS 9.0, *)
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(visionOS, unavailable)
    case accessoryInline

    /// A textual representation of this instance, suitable for debugging.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(reflecting:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `debugDescription` property for types that conform to
    /// `CustomDebugStringConvertible`:
    ///
    ///     struct Point: CustomDebugStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var debugDescription: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(reflecting: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `debugDescription` property.
    public var debugDescription: String { get }

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

    /// Creates a new instance with the specified raw value.
    ///
    /// If there is no value of the type that corresponds with the specified raw
    /// value, this initializer returns `nil`. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     print(PaperSize(rawValue: "Legal"))
    ///     // Prints "Optional(PaperSize.Legal)"
    ///
    ///     print(PaperSize(rawValue: "Tabloid"))
    ///     // Prints "nil"
    ///
    /// - Parameter rawValue: The raw value to use for the new instance.
    public init?(rawValue: Int)

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    @available(iOS 14.0, watchOS 9.0, visionOS 26.0, macOS 11.0, *)
    @available(tvOS, unavailable)
    public typealias RawValue = Int

    /// The corresponding value of the raw type.
    ///
    /// A new instance initialized with `rawValue` will be equivalent to this
    /// instance. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     let selectedSize = PaperSize.Letter
    ///     print(selectedSize.rawValue)
    ///     // Prints "Letter"
    ///
    ///     print(selectedSize == PaperSize(rawValue: selectedSize.rawValue)!)
    ///     // Prints "true"
    public var rawValue: Int { get }
}

@available(iOS 14.0, macOS 11.0, watchOS 9.0, visionOS 26.0, *)
@available(tvOS, unavailable)
extension WidgetFamily : Hashable {
}

/// A structure that contains information about user-configured widgets.
@available(iOS 14.0, macOS 11.0, watchOS 9.0, visionOS 26.0, *)
@available(tvOS, unavailable)
@preconcurrency public struct WidgetInfo : Sendable {

    /// A SiriKit intent that contains user-edited values.
    public let configuration: INIntent?

    /// Gets the associated App Intent.
    /// - Parameter intentType: The expected type for the App Intent.
    /// - Returns: An App Intent that contains the user-edited values or nil
    /// if there is no associated App Intent or the type does not match `intentType`.
    @available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 26.0, *)
    @available(tvOS, unavailable)
    public func widgetConfigurationIntent<Intent>(of intentType: Intent.Type = Intent.self) -> Intent? where Intent : WidgetConfigurationIntent

    /// The size of the widget: small, medium, or large.
    public let family: WidgetFamily

    /// The string specified during creation of the widget's configuration.
    public let kind: String
}

@available(iOS 14.0, macOS 11.0, watchOS 9.0, visionOS 26.0, *)
@available(tvOS, unavailable)
extension WidgetInfo : Identifiable, Hashable, Equatable {

    /// The stable identity of the widget.
    public var id: WidgetInfo { get }

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (a: WidgetInfo, b: WidgetInfo) -> Bool

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

    /// A type representing the stable identity of the entity associated with
    /// an instance.
    @available(iOS 14.0, watchOS 9.0, visionOS 26.0, macOS 11.0, *)
    @available(tvOS, unavailable)
    public typealias ID = WidgetInfo

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

@available(iOS 14.0, macOS 11.0, watchOS 9.0, visionOS 26.0, *)
@available(tvOS, unavailable)
extension WidgetInfo : CustomDebugStringConvertible {

    /// A textual representation of this instance, suitable for debugging.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(reflecting:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `debugDescription` property for types that conform to
    /// `CustomDebugStringConvertible`:
    ///
    ///     struct Point: CustomDebugStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var debugDescription: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(reflecting: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `debugDescription` property.
    public var debugDescription: String { get }
}

/// Values that indicate different widget locations.
@available(iOS 17.0, watchOS 26.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
public struct WidgetLocation : Sendable, Hashable {

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (a: WidgetLocation, b: WidgetLocation) -> Bool

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

@available(iOS 17.0, watchOS 26.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
extension WidgetLocation {

    /// The widget appears on the Home Screen or in Today View.
    @available(iOS 17.0, *)
    @available(watchOS, unavailable)
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(visionOS, unavailable)
    public static let homeScreen: WidgetLocation

    /// The widget appears on the Lock Screen.
    @available(iOS 17.0, *)
    @available(watchOS, unavailable)
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(visionOS, unavailable)
    public static let lockScreen: WidgetLocation

    /// The widget appears in StandBy.
    @available(iOS 17.0, *)
    @available(watchOS, unavailable)
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(visionOS, unavailable)
    public static let standBy: WidgetLocation

    /// The widget originates from another device and appears on the Mac.
    @available(iOS 17.0, *)
    @available(watchOS, unavailable)
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(visionOS, unavailable)
    public static let iPhoneWidgetsOnMac: WidgetLocation

    /// The CarPlay location for a widget.
    @available(iOS 26.0, *)
    @available(watchOS, unavailable)
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(visionOS, unavailable)
    public static let carPlay: WidgetLocation
}

/// Values that define the widget’s supported mounting style.
@available(iOS 26.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
public struct WidgetMountingStyle : Sendable, Hashable {

    /// Mounting style surrounding the widget with a composite material
    public static let elevated: WidgetMountingStyle

    /// Mounting style where a widget is displayed within a recessed portal
    public static let recessed: WidgetMountingStyle

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (a: WidgetMountingStyle, b: WidgetMountingStyle) -> Bool

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

/// A specification for the context of a widget preview.
///
/// To create a preview for a widget in Xcode, use
/// <doc://com.apple.documentation/documentation/swiftui/view/previewcontext(_:)>
/// and pass `WidgetPreviewContext` initialized with the appropriate
/// `WidgetFamily`.
///
///     struct Widget_Previews: PreviewProvider {
///         static var previews: some View {
///             Group {
///                 MyWidgetView()
///                     .previewContext(WidgetPreviewContext(family: .systemSmall))
///             }
///         }
///     }
@available(iOS 14.0, macOS 11.0, watchOS 9.0, visionOS 26.0, *)
@available(tvOS, unavailable)
public struct WidgetPreviewContext : PreviewContext {

    /// Returns the context's value for a key, or a the key's default value
    /// if the context doesn't define a value for the key.
    public subscript<Key>(key: Key.Type) -> Key.Value where Key : PreviewContextKey { get }

    /// Creates a context for previewing a widget or a widget's view.
    ///
    /// - Parameter family: The template the widget preview uses: small, medium, or large.
    public init(family: WidgetFamily)
}

/// A type that can receive push information about widget refreshes and
/// relevance refreshes.
///
/// Register a type conforming to this protocol to receive push information
/// using the <doc://com.apple.documentation/documentation/SwiftUI/WidgetConfiguration/pushHandler(_:widgets:)>
/// modifier on your widgets' configurations.
@available(iOS 26.0, macOS 26.0, watchOS 26.0, *)
@available(tvOS, unavailable)
public protocol WidgetPushHandler {

    /// Creates a push handler.
    init()

    /// Handle push tokens changing for widgets reloads and relevance refreshes.
    ///
    /// - Parameter pushInfo: Provides information containing your push token to use.
    /// - Parameter widgets: Information about widgets that support push
    ///   updates.
    func pushTokenDidChange(_ pushInfo: WidgetPushInfo, widgets: [WidgetInfo])
}

/// A structure that contains information about the push token for
/// updating widgets and widget relevances.
@available(iOS 26.0, macOS 26.0, watchOS 26.0, *)
@available(tvOS, unavailable)
public struct WidgetPushInfo : Sendable {

    /// A unique push token that may be used to deliver updates for widgets
    /// and widget relevances.
    ///
    /// This token is valid until told otherwise through the
    /// ``WidgetPushHandler/pushTokenDidChange(_:widgets:)`` method on your push
    /// handler.
    public let token: Data
}

/// A type collecting the relevances for a widget kind.
///
/// Return this type from the `relevance()` requirement of your ``TimelineProvider``,
/// ``AppIntentTimelineProvider``, or ``IntentTimelineProvider`` to inform the
/// system of when a widget might be relevant and in which configuration.
///
/// Make sure to return the relevances ordered by priority because the system might
/// decide to utilize only a subset of the provided relevances.
@available(iOS 18.0, macOS 15.0, watchOS 11.0, visionOS 26.0, *)
@available(tvOS, unavailable)
public struct WidgetRelevance<Configuration> {

    /// Creates a type collecting the relevances for a widget kind.
    ///
    /// - Parameters:
    ///   - attributes: a collection of `WidgetRelevanceAttribute` describing when this
    ///   type of widget could be relevant.
    public init(_ attributes: [WidgetRelevanceAttribute<Configuration>])
}

/// A type describing when a specific widget could be relevant.
///
/// You use ``RelevantContext`` as way to describe when a specific widget can be relevant.
@available(iOS 18.0, macOS 15.0, watchOS 11.0, visionOS 26.0, *)
@available(tvOS, unavailable)
public struct WidgetRelevanceAttribute<Configuration> {
}

@available(iOS 18.0, macOS 15.0, watchOS 11.0, visionOS 26.0, *)
@available(tvOS, unavailable)
extension WidgetRelevanceAttribute where Configuration == () {

    /// Creates a new widget relevance that is relevant in a specific context.
    ///
    /// - Parameters:
    ///   - context: the relevant context where this widget is relevant.
    public init(context: RelevantContext)

    /// Associates the widget kind with a group. When multiple widgets are in
    /// the same group, the system will only suggest one member of the group
    /// simultaneously. Widgets in the same group are interpreted to contain
    /// redundant information, and therefore should not be presented together.
    ///
    /// Multiple groups can be associated with the same widget by providing
    /// multiple `WidgetRelevanceAttribute` instances with different
    /// groups.
    ///
    /// - Parameters:
    ///   - group: the group to associate the widget with
    public init(group: WidgetRelevanceGroup)
}

@available(iOS 18.0, macOS 15.0, watchOS 11.0, visionOS 26.0, *)
@available(tvOS, unavailable)
extension WidgetRelevanceAttribute where Configuration : WidgetConfigurationIntent {

    /// Creates a new widget relevance for a specific configuration that is
    /// relevant in a specific context.
    ///
    /// For example, a weather widget could specify that a configuration for
    /// a specific location is relevant for a the relevant context at that
    /// specific location.
    ///
    /// - Parameters:
    ///   - configuration: The specific configuration
    ///   - context: the relevant context where this widget is relevant.
    public init(configuration: Configuration, context: RelevantContext)

    /// Associates the widget kind with a group. When multiple widgets are in
    /// the same group, the system will only suggest one member of the group
    /// simultaneously. Widgets in the same group are interpreted to contain
    /// redundant information, and therefore should not be presented together.
    ///
    /// Multiple groups can be associated with the same widget by providing
    /// multiple `WidgetRelevanceAttribute` instances with different
    /// groups.
    ///
    /// - Parameters:
    ///   - configuration: The specific configuration
    ///   - group: the group to associate the widget with
    public init(configuration: Configuration, group: WidgetRelevanceGroup)
}

@available(iOS 18.0, macOS 15.0, watchOS 11.0, visionOS 26.0, *)
@available(tvOS, unavailable)
extension WidgetRelevanceAttribute where Configuration : INIntent {

    /// Creates a new widget relevance for a specific configuration that is
    /// relevant in a specific context.
    ///
    /// For example, a weather widget could specify that a configuration for
    /// a specific location is relevant for a the relevant context at that
    /// specific location.
    ///
    /// - Parameters:
    ///   - configuration: The specific configuration
    ///   - context: the relevant context where this widget is relevant.
    public init(configuration: Configuration, context: RelevantContext)

    /// Associates the widget kind with a group. When multiple widgets are in
    /// the same group, the system will only suggest one member of the group
    /// simultaneously. Widgets in the same group are interpreted to contain
    /// redundant information, and therefore should not be presented together.
    ///
    /// Multiple groups can be associated with the same widget by providing
    /// multiple `WidgetRelevanceAttribute` instances with different
    /// groups.
    ///
    /// - Parameters:
    ///   - configuration: The specific configuration
    ///   - group: the group to associate the widget with
    public init(configuration: Configuration, group: WidgetRelevanceGroup)
}

/// A type for configuring widget behavior in the watchOS Smart Stack.
///
/// Use `WidgetRelevanceGroup` alongside ``WidgetRelevanceAttribute``
/// to tell the system how it should group your widgets
/// in the watchOS Smart Stack. The system may provide a default grouping mechanism
/// for widgets in the Smart Stack; for example, per-app grouping. Creating a
/// relevance group and choosing the `.ungrouped` option opts out of
/// default grouping behavior. For additional information about widgets in Smart
/// Stacks, refer to <doc:Widget-Suggestions-In-Smart-Stacks>.
@available(iOS 18.0, macOS 15.0, watchOS 11.0, visionOS 26.0, *)
@available(tvOS, unavailable)
public struct WidgetRelevanceGroup {
}

@available(iOS 18.0, macOS 15.0, watchOS 11.0, visionOS 26.0, *)
@available(tvOS, unavailable)
extension WidgetRelevanceGroup {

    /// Creates a group with the provided name.
    ///
    /// The system won't show more than one relevant widget if they are in the same.
    /// A widget group doesn't affect widgets by other apps.
    public static func named(_ name: String) -> WidgetRelevanceGroup

    /// Don't use the system's default behavior for grouping widgets.
    public static let ungrouped: WidgetRelevanceGroup

    /// Specifies that the widget group should use the automatic grouping behavior
    /// provided the system.
    public static let automatic: WidgetRelevanceGroup
}

/// Constants that indicate the rendering mode for a widget.
///
/// The system can modify the appearance of accessory family widgets. For 
/// example, it renders widgets on the Lock Screen on iPhone using the 
/// ``WidgetKit/WidgetRenderingMode/vibrant`` mode, while it renders 
/// widget-based complications in watchOS using either the 
/// ``WidgetKit/WidgetRenderingMode/fullColor`` or
/// ``WidgetKit/WidgetRenderingMode/accented`` modes, depending on the watch 
/// face and the user's settings.
///
/// You can read the rendering mode from the environment values using the 
/// `.widgetRenderingMode` key.
///
/// ``` swift
/// @Environment(\.widgetRenderingMode) var widgetRenderingMode
/// ```
///
/// You can then customize your widget's design based on the rendering mode.
@available(iOS 16.0, watchOS 9.0, macOS 13.0, visionOS 26.0, *)
@available(tvOS, unavailable)
public struct WidgetRenderingMode : Equatable, CustomStringConvertible {

    /// The system renders the widget in full color.
    ///
    /// In this mode, the system doesn't alter or filter the widget's colors. 
    /// 
    /// The system displays full-color widget-based complications on some watch 
    /// faces, such as the Infograph face, on the Home Screen or Today View in 
    /// iOS or iPadOS, and in Notification Center on macOS. 
    ///
    /// > Note: The Infograph face only uses full-color rendering when the user
    /// sets the face to multicolor. If the user selects an accent color, the 
    /// system uses ``WidgetKit/WidgetRenderingMode/accented`` instead.
    public static let fullColor: WidgetRenderingMode

    /// The system divides the widget's view hierarchy into an accent group and 
    /// a default group, applying a different color to each group.
    ///
    /// In watchOS, the system displays accented widget-based complications on 
    /// many watch faces. For example, when the user selects a color, the 
    /// Infograph watch face uses white for the default group, and the 
    /// user-selected color for the accent. However, these colors can change 
    /// from face to face. In the X-Large watch face, the system applies the 
    /// selected color to the default group, and colors the accent group white. 
    /// Other faces use system-defined colors for both groups; for example, the 
    /// Solar Dial face defines both an accent and a default color, and changes 
    /// these colors based on the time of day.
    ///
    /// When applying the colors, the system treats the widget's views as if 
    /// they were template images. It replaces the view's color --- rendering 
    /// the new colors while preserving the view's alpha channel.
    /// 
    /// To control your view's appearance, add the 
    /// <doc://com.apple.documentation/documentation/swiftui/View/widgetAccentable(_:)> 
    /// modifier to part of your view's hierarchy. The system adds that view and 
    /// all of its subviews to the accent group. It puts all other views in the 
    /// default group.
    ///
    /// ``` swift
    /// var body: some View {
    ///     VStack {
    ///         Text("MON")
    ///             .font(.caption)
    ///             .widgetAccentable()
    ///         Text("6")
    ///             .font(.title)
    ///         }
    ///     }
    /// }
    /// ```
    public static let accented: WidgetRenderingMode

    /// The system desaturates the widget, making a monochrome version that it 
    /// uses to create an adaptive, vibrant effect.
    ///
    /// The system displays vibrant widgets on the Lock Screen on iPhone.
    public static let vibrant: WidgetRenderingMode

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
    public static func == (a: WidgetRenderingMode, b: WidgetRenderingMode) -> Bool
}

extension EnvironmentValues {

    /// A Boolean value that indicates whether the Live Activity update
    /// synchronization rate is reduced.
    ///
    /// When rendering an Activity on a remote device such as Apple Watch,
    /// content updates may sometimes be limited to only alerting updates,
    /// depending on system conditions. When a live activity is being shown and
    /// only alerting updates are being synchronized to the remote device, the
    /// value of `isActivityUpdateReduced` will be `true`.
    ///
    /// For example, `isActivityUpdateReduced` may be `true` for Live
    /// Activities displayed on watchOS when out of range of the paired iPhone.
    @available(iOS 18.0, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    public var isActivityUpdateReduced: Bool
}

@available(iOS 18.0, watchOS 11.0, macOS 15.0, visionOS 26.0, *)
@available(tvOS, unavailable)
extension Image {

    /// Specifies the how to render an `Image` when using the
    /// ``WidgetKit/WidgetRenderingMode/accented`` mode.
    ///
    /// ``` swift
    /// var body: some View {
    ///     VStack {
    ///         Image("cat_full")
    ///             .resizable()
    ///             .widgetAccentedRenderingMode(.fullColor)
    ///     }
    /// }
    /// ```
    ///
    /// > Important: If the `Image` is a subview for a group that has
    /// `widgetAccentable(true)` applied, this modifier may conflict.
    ///
    /// - Parameter renderingMode: A constant describing how the `Image`
    /// should be rendered.
    public func widgetAccentedRenderingMode(_ renderingMode: WidgetAccentedRenderingMode?) -> some View

}

@available(iOS 14.0, macOS 11.0, watchOS 9.0, visionOS 26.0, *)
@available(tvOS, unavailable)
extension EnvironmentValues {

    /// The template of the widget --- small, medium, or large.
    ///
    /// Use this value to retrieve the widget size that the user chose for a widget.
    public var widgetFamily: WidgetFamily { get }
}

@available(iOS 26.0, *)
@available(tvOS, unavailable)
@available(macOS, unavailable)
@available(watchOS, unavailable)
extension EnvironmentValues {

    /// The level of detail the view is recommended to have.
    ///
    /// Read from the environment with
    ///
    ///     @Environment(\.levelOfDetail) var levelOfDetail
    ///
    /// To customize your view based on recommended level of detail, read the environment value
    /// using the `.levelOfDetail` key and apply that to change your view.
    ///
    /// ``` swift
    /// var body: some View {
    ///      switch levelOfDetail {
    ///      case .default:
    ///          VStack {
    ///             NewsTitleView()
    ///             NewsBodyView()
    ///          }
    ///      case .simplified:
    ///          NewsImageOverview()
    ///      }
    /// }
    ///```
    /// > Note: The levelOfDetail can be determined by different factors depending
    /// on the platforms.
    ///
    public var levelOfDetail: LevelOfDetail
}

@available(iOS 16.1, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension EnvironmentValues {

    /// A Boolean value that indicates whether the Live Activity appears in a
    /// full-screen presentation.
    ///
    /// When a Live Activity fills the entire screen, the system extends the background
    /// tint color you set with the <doc://com.apple.documentation/documentation/SwiftUI/View/activityBackgroundTint(_:)>
    /// modifier to fill the screen.
    ///
    /// Note that this environment variable is always `false` in iOS 16.
    @available(iOS 16.1, *)
    @backDeployed(before: iOS 17.0)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    public var isActivityFullscreen: Bool { get }
}

@available(iOS 18.0, macOS 26.0, watchOS 26.0, *)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
extension ControlWidgetTemplate {

    /// Sets the tint color within this control widget template.
    ///
    /// Controls do not respect the ``View/tint(_:)`` modifier when applied to
    /// control labels, nor do controls support arbitrary tint shape styles.
    /// Instead, define a tint color for your control by applying this modifier
    /// to its template:
    ///
    ///     struct GarageDoorOpener: ControlWidget {
    ///         var body: some ControlWidgetConfiguration {
    ///             StaticControlConfiguration(...) {
    ///                 ControlWidgetToggle(...) {
    ///                     Label(
    ///                         $0 ? "Open" : "Closed",
    ///                         systemImage: $0 ? "door.open" : "door.closed"
    ///                     )
    ///                 }
    ///                 .tint(.orange)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameter tint: The tint ``Color`` to apply.
    @MainActor @preconcurrency public func tint(_ tint: Color?) -> some ControlWidgetTemplate


    /// Marks the control template as containing sensitive, private user data.
    ///
    /// The system redacts controls marked with this modifier when those
    /// controls are displayed on the Lock Screen and the device is locked.
    ///
    /// Controls also respect the ``View/privacySensitive(_:)`` modifier
    /// applied to the control's label. That modifier only redacts the
    /// control content, however. To redact the content _and_ the state of the
    /// control, apply this modifier to the control template:
    ///
    ///     struct GarageDoorOpener: ControlWidget {
    ///         var body: some ControlWidgetConfiguration {
    ///             StaticControlConfiguration(...) {
    ///                 ControlWidgetToggle(...) {
    ///                     Label(
    ///                         $0 ? "Open" : "Closed",
    ///                         systemImage: $0 ? "door.open" : "door.closed"
    ///                     )
    ///                 }
    ///                 .privacySensitive()
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameter sensitive: A Boolean value that determines whether this
    ///   control is sensitive.
    @MainActor @preconcurrency public func privacySensitive(_ sensitive: Bool = true) -> some ControlWidgetTemplate


    /// Determines whether users can interact with this control widget.
    ///
    /// Controls also respect the ``View/disabled(_:)`` modifier applied to the
    /// control's label. That modifier only disables the label, however. To
    /// disable the control overall, apply this modifier to the control template:
    ///
    ///     struct GarageDoorOpener: ControlWidget {
    ///         var body: some ControlWidgetConfiguration {
    ///             StaticControlConfiguration(
    ///                 kind: "com.myapp.garagedooropener",
    ///                 provider: DoorValueProvider()
    ///             ) { door in
    ///                 ControlWidgetToggle(...) {
    ///                     Label(
    ///                         $0 ? "Open" : "Closed",
    ///                         systemImage: $0 ? "door.open" : "door.closed"
    ///                     )
    ///                 }
    ///                 .disabled(door.isSafetyLockEngaged)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameter disabled: A Boolean value that determines whether users can
    ///   interact with this control.
    @available(iOS 18.0, macOS 26.0, watchOS 26.0, *)
    @available(tvOS, unavailable)
    @available(visionOS, unavailable)
    @MainActor @preconcurrency public func disabled(_ disabled: Bool) -> some ControlWidgetTemplate

}

@available(iOS 18.0, macOS 26.0, watchOS 26.0, *)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
extension View {

    /// The status of the control described by the modified label.
    ///
    /// This text will appear in Control Center when your control's state
    /// changes. You can customize the text by applying this modifier to the
    /// control's value label:
    ///
    ///     // Status Text: "Do Not Disturb Until This Evening" / "Do Not Disturb Disabled"
    ///     ControlWidgetToggle("Do Not Disturb", ...) { isOn in
    ///         Image(systemName: "moon")
    ///             .controlWidgetStatus(isOn ? "Do Not Disturb Until This Evening" : "Do Not Disturb Disabled")
    ///     }
    ///
    /// - Parameter status: The status to display.
    @MainActor @preconcurrency public func controlWidgetStatus(_ status: Text) -> some View


    /// The status of the control described by the modified label.
    ///
    /// This text will appear in Control Center when your control's state
    /// changes. You can customize the text by applying this modifier to the
    /// control's value label:
    ///
    ///     // Status Text: "Do Not Disturb Until This Evening" / "Do Not Disturb Disabled"
    ///     ControlWidgetToggle("Do Not Disturb", ...) { isOn in
    ///         Image(systemName: "moon")
    ///             .controlWidgetStatus(isOn ? "Do Not Disturb Until This Evening" : "Do Not Disturb Disabled")
    ///     }
    ///
    /// - Parameter statusKey: The key to a localized string to display.
    @MainActor @preconcurrency public func controlWidgetStatus(_ statusKey: LocalizedStringKey) -> some View


    /// The status of the control described by the modified label.
    ///
    /// This text will appear in Control Center when your control's state
    /// changes. You can customize the text by applying this modifier to the
    /// control's value label:
    ///
    ///     // Status Text: "Do Not Disturb Until This Evening" / "Do Not Disturb Disabled"
    ///     ControlWidgetToggle("Do Not Disturb", ...) { isOn in
    ///         Image(systemName: "moon")
    ///             .controlWidgetStatus(isOn ? "Do Not Disturb Until This Evening" : "Do Not Disturb Disabled")
    ///     }
    ///
    /// - Parameter status: The localized string resource to display.
    @MainActor @preconcurrency public func controlWidgetStatus(_ status: LocalizedStringResource) -> some View


    /// The status of the control described by the modified label.
    ///
    /// This text will appear in Control Center when your control's state
    /// changes. You can customize the text by applying this modifier to the
    /// control's value label:
    ///
    ///     // Status Text: "Do Not Disturb Until This Evening" / "Do Not Disturb Disabled"
    ///     ControlWidgetToggle("Do Not Disturb", ...) { isOn in
    ///         Image(systemName: "moon")
    ///             .controlWidgetStatus(isOn ? "Do Not Disturb Until This Evening" : "Do Not Disturb Disabled")
    ///     }
    ///
    /// - Parameter status: The status to display.
    @MainActor @preconcurrency public func controlWidgetStatus<S>(_ status: S) -> some View where S : StringProtocol

}

@available(iOS 18.0, macOS 26.0, watchOS 26.0, *)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
extension View {

    /// The action hint of the control described by the modified label.
    ///
    /// This text will appear next to the Action Button to describe what your
    /// control will do when activated. By default, a control's action hint is
    /// derived from its display name, the type of control, and value text, if
    /// any:
    ///
    ///    // Action Hint: "Hold for 'Ping My Watch'"
    ///    struct PingMyWatchButton: Control {
    ///        static let displayName: LocalizedStringResource = "Ping My Watch"
    ///        ...
    ///    }
    ///
    ///    // When this button's action conforms to `OpenIntent`:
    ///    // Action Hint: "Hold to Open Notes"
    ///    struct NotesLauncher: Control {
    ///        static let displayName: LocalizedStringResource = "Notes"
    ///        ...
    ///    }
    ///
    ///    // Action Hint: "Hold to Turn On 'Silent Mode'" / "Hold to Turn Off 'Silent Mode'"
    ///    struct SilentModeToggle: Control {
    ///        static let displayName: LocalizedStringResource = "Silent Mode"
    ///        ...
    ///    }
    ///
    ///    // Action Hint: "Hold for Silent" / "Hold for Ring"
    ///    ControlWidgetToggle(...) { isOn in
    ///        Label(
    ///            isOn ? "Silent" : "Ring",
    ///            systemImage: isOn ? "bell.slash" : "bell"
    ///        )
    ///    }
    ///
    /// When the default action hint is insufficiently descriptive, you can
    /// customize the hint by applying this modifier to the control's label.
    /// For instance, we can describe what the user will use our
    /// `NotesLauncher` control to do, "Compose a Note", instead of the default
    /// "Hold to Open Notes" hint, like this:
    ///
    ///    ControlWidgetButton(...) {
    ///        Image(systemName: "note.text")
    ///            .controlWidgetActionHint("Compose a Note")
    ///    }
    ///
    /// - Parameter hint: The hint to display.
    @MainActor @preconcurrency public func controlWidgetActionHint(_ hint: Text) -> some View


    /// The action hint of the control described by the modified label.
    ///
    /// This text will appear next to the Action Button to describe what your
    /// control will do when activated. By default, a control's action hint is
    /// derived from its display name, the type of control, and value text, if
    /// any:
    ///
    ///    // Action Hint: "Hold for 'Ping My Watch'"
    ///    struct PingMyWatchButton: Control {
    ///        static let displayName: LocalizedStringResource = "Ping My Watch"
    ///        ...
    ///    }
    ///
    ///    // When this button's action conforms to `OpenIntent`:
    ///    // Action Hint: "Hold to Open Notes"
    ///    struct NotesLauncher: Control {
    ///        static let displayName: LocalizedStringResource = "Notes"
    ///        ...
    ///    }
    ///
    ///    // Action Hint: "Hold to Turn On 'Silent Mode'" / "Hold to Turn Off 'Silent Mode'"
    ///    struct SilentModeToggle: Control {
    ///        static let displayName: LocalizedStringResource = "Silent Mode"
    ///        ...
    ///    }
    ///
    ///    // Action Hint: "Hold for Silent" / "Hold for Ring"
    ///    ControlWidgetToggle(...) { isOn in
    ///        Label(
    ///            isOn ? "Silent" : "Ring",
    ///            systemImage: isOn ? "bell.slash" : "bell"
    ///        )
    ///    }
    ///
    /// When the default action hint is insufficiently descriptive, you can
    /// customize the hint by applying this modifier to the control's label.
    /// For instance, we can describe what the user will use our
    /// `NotesLauncher` control to do, "Compose a Note", instead of the default
    /// "Hold to Open Notes" hint, like this:
    ///
    ///    ControlWidgetButton(...) {
    ///        Image(systemName: "note.text")
    ///            .controlWidgetActionHint("Compose a Note")
    ///    }
    ///
    /// - Parameter hintKey: The key to a localized string to display.
    @MainActor @preconcurrency public func controlWidgetActionHint(_ hintKey: LocalizedStringKey) -> some View


    /// The action hint of the control described by the modified label.
    ///
    /// This text will appear next to the Action Button to describe what your
    /// control will do when activated. By default, a control's action hint is
    /// derived from its display name, the type of control, and value text, if
    /// any:
    ///
    ///    // Action Hint: "Hold for 'Ping My Watch'"
    ///    struct PingMyWatchButton: Control {
    ///        static let displayName: LocalizedStringResource = "Ping My Watch"
    ///        ...
    ///    }
    ///
    ///    // When this button's action conforms to `OpenIntent`:
    ///    // Action Hint: "Hold to Open Notes"
    ///    struct NotesLauncher: Control {
    ///        static let displayName: LocalizedStringResource = "Notes"
    ///        ...
    ///    }
    ///
    ///    // Action Hint: "Hold to Turn On 'Silent Mode'" / "Hold to Turn Off 'Silent Mode'"
    ///    struct SilentModeToggle: Control {
    ///        static let displayName: LocalizedStringResource = "Silent Mode"
    ///        ...
    ///    }
    ///
    ///    // Action Hint: "Hold for Silent" / "Hold for Ring"
    ///    ControlWidgetToggle(...) { isOn in
    ///        Label(
    ///            isOn ? "Silent" : "Ring",
    ///            systemImage: isOn ? "bell.slash" : "bell"
    ///        )
    ///    }
    ///
    /// When the default action hint is insufficiently descriptive, you can
    /// customize the hint by applying this modifier to the control's label.
    /// For instance, we can describe what the user will use our
    /// `NotesLauncher` control to do, "Compose a Note", instead of the default
    /// "Hold to Open Notes" hint, like this:
    ///
    ///    ControlWidgetButton(...) {
    ///        Image(systemName: "note.text")
    ///            .controlWidgetActionHint("Compose a Note")
    ///    }
    ///
    /// - Parameter hint: The localized string resource to display.
    @MainActor @preconcurrency public func controlWidgetActionHint(_ hint: LocalizedStringResource) -> some View


    /// The action hint of the control described by the modified label.
    ///
    /// This text will appear next to the Action Button to describe what your
    /// control will do when activated. By default, a control's action hint is
    /// derived from its display name, the type of control, and value text, if
    /// any:
    ///
    ///    // Action Hint: "Hold for 'Ping My Watch'"
    ///    struct PingMyWatchButton: Control {
    ///        static let displayName: LocalizedStringResource = "Ping My Watch"
    ///        ...
    ///    }
    ///
    ///    // When this button's action conforms to `OpenIntent`:
    ///    // Action Hint: "Hold to Open Notes"
    ///    struct NotesLauncher: Control {
    ///        static let displayName: LocalizedStringResource = "Notes"
    ///        ...
    ///    }
    ///
    ///    // Action Hint: "Hold to Turn On 'Silent Mode'" / "Hold to Turn Off 'Silent Mode'"
    ///    struct SilentModeToggle: Control {
    ///        static let displayName: LocalizedStringResource = "Silent Mode"
    ///        ...
    ///    }
    ///
    ///    // Action Hint: "Hold for Silent" / "Hold for Ring"
    ///    ControlWidgetToggle(...) { isOn in
    ///        Label(
    ///            isOn ? "Silent" : "Ring",
    ///            systemImage: isOn ? "bell.slash" : "bell"
    ///        )
    ///    }
    ///
    /// When the default action hint is insufficiently descriptive, you can
    /// customize the hint by applying this modifier to the control's label.
    /// For instance, we can describe what the user will use our
    /// `NotesLauncher` control to do, "Compose a Note", instead of the default
    /// "Hold to Open Notes" hint, like this:
    ///
    ///    ControlWidgetButton(...) {
    ///        Image(systemName: "note.text")
    ///            .controlWidgetActionHint("Compose a Note")
    ///    }
    ///
    /// - Parameter hint: The hint to display.
    @MainActor @preconcurrency public func controlWidgetActionHint<S>(_ hint: S) -> some View where S : StringProtocol

}

@available(iOS 14.0, macOS 11.0, watchOS 9.0, visionOS 26.0, *)
@available(tvOS, unavailable)
extension View {

    /// Sets the URL to open in the containing app when the user clicks the widget.
    /// - Parameter url: The URL to open in the containing app.
    /// - Returns: A view that opens the specified URL when the user clicks
    ///   the widget.
    ///
    /// Widgets support one `widgetURL` modifier in their view hierarchy.
    /// If multiple views have `widgetURL` modifiers, the behavior is
    /// undefined.
    @MainActor @preconcurrency public func widgetURL(_ url: URL?) -> some View

}

extension EnvironmentValues {

    /// A property that identifies the content margins of a widget.
    ///
    /// The content margins of a widget depend on the context in which it appears. The
    /// system applies default content margins. However, if you disable automatic application of
    /// default content margins with <doc://com.apple.documentation/swiftui/WidgetConfiguration/contentMarginsDisabled()>, the
    /// system uses the `widgetContentMargins` property in combination with <doc://com.apple.documentation/documentation/swiftui/view/padding(_:)>
    /// to selectively apply default content margins.
    ///
    /// - Returns: Returns the content margins for the current widget presentation
    ///   context.
    @available(iOS 17.0, watchOS 10.0, macOS 14.0, visionOS 26.0, *)
    @available(tvOS, unavailable)
    public var widgetContentMargins: EdgeInsets { get }
}

@available(iOS 15.0, macOS 12.0, watchOS 9.0, visionOS 26.0, *)
@available(tvOS, unavailable)
extension WidgetConfiguration {

    /// Disable default content margins.
    ///
    /// When you disable content margins for a widget, the system doesn't automatically add margins
    /// around the widget's content, and you are responsible for specifying margins and padding around your
    /// widget content for each context. To specify custom margins, use <doc://com.apple.documentation/swiftui/EnvironmentValues/widgetContentMargins>
    /// in combination with <doc://com.apple.documentation/swiftui/View/padding(_)> to selectively or partially apply the default content margins.
    ///
    /// - Returns: A modified widget configuration that doesn't use default content margins.
    ///
    ///  This modifier has no effect on operation system versions prior to iOS 17, watchOS 10, or macOS 14.
    @MainActor @preconcurrency public func contentMarginsDisabled() -> some WidgetConfiguration

}

@available(iOS 17.0, macOS 14.0, watchOS 10.0, visionOS 26.0, *)
@available(tvOS, unavailable)
extension Preview {

    /// Creates a preview of a timeline-style widget.
    ///
    /// The `#Preview` macro expands into a declaration that calls this initializer. To create a preview
    /// that appears in the canvas, you must use the macro, not instantiate a Preview directly.
    @MainActor public init(_ name: String? = nil, as family: WidgetFamily, widget: @escaping () -> some Widget, @PreviewTimelineBuilder timeline: @escaping @MainActor () async -> [any TimelineEntry])

    /// Creates a preview of a widget with a static configuration.
    ///
    /// The `#Preview` macro expands into a declaration that calls this initializer. To create a preview
    /// that appears in the canvas, you must use the macro, not instantiate a Preview directly.
    @MainActor public init(_ name: String? = nil, as family: WidgetFamily, widget: @escaping () -> some Widget, timelineProvider: @escaping () -> some TimelineProvider)

    /// Creates a preview of a widget with an `INIntent` configuration.
    ///
    /// The `#Preview` macro expands into a declaration that calls this initializer. To create a preview
    /// that appears in the canvas, you must use the macro, not instantiate a Preview directly.
    @available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 18.0, visionOS 26.0, *)
    @MainActor public init<Provider>(_ name: String? = nil, as family: WidgetFamily, using intent: Provider.Intent, widget: @escaping () -> some Widget, timelineProvider: @escaping () -> Provider) where Provider : IntentTimelineProvider

    /// Creates a preview of a widget with an `AppIntent` configuration.
    ///
    /// The `#Preview` macro expands into a declaration that calls this initializer. To create a preview
    /// that appears in the canvas, you must use the macro, not instantiate a Preview directly.
    @MainActor public init<Provider>(_ name: String? = nil, as family: WidgetFamily, using intent: Provider.Intent, widget: @escaping () -> some Widget, timelineProvider: @escaping () -> Provider) where Provider : AppIntentTimelineProvider
}

@available(iOS 18.0, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension WidgetConfiguration {

    /// Sets the sizes that a Live Activity supports.
    ///
    /// For more information, refer to ``WidgetKit/ActivityFamily``
    /// - Parameters:
    ///     - families: The supplemental families supported by this live activity.
    @MainActor @preconcurrency public func supplementalActivityFamilies(_ families: [ActivityFamily]) -> some WidgetConfiguration

}

extension EnvironmentValues {

    /// The size family of the current Live Activity.
    ///
    /// A Live Activity you initiate on one device can also appear on a remote device
    /// that renders the Live Activity in a different family size. As a result, it renders for a specific family, depending on both
    /// the device and the location in which it appears. For example, when rendering on the iOS or iPadOS Lock Screen,
    /// the current family is <doc://com.apple.comdumentation/documentation/WidgetKit/ActivityFamily/medium>.
    ///
    /// Use <doc://com.apple.documentation/documentation/swiftui/widgetconfiguration/supplementalactivityfamilies(_:)>
    /// to opt in and allow your Live Activity to render with additional families.
    @available(iOS 18.0, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    public var activityFamily: ActivityFamily
}

extension EnvironmentValues {

    /// An environment value that that indicates potential rendered family for a Live Activity.
    ///
    /// To detect the currently rendered activity family size, use the <doc://com.apple.documentation/documentation/swiftui/environmentvalues/activityfamily> environment
    /// variable. The `supportedActivityFamilies` environment value might only be useful if your make
    /// you make your Live Activity views available in a Swift package.
    @available(iOS 18.0, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    public var supportedActivityFamilies: Set<ActivityFamily>
}

extension View {

    /// Specifies the vertical placement for a view of an expanded Live Activity that appears in the Dynamic
    /// Island.
    ///
    /// - Parameters:
    ///   - verticalPlacement: The vertical placement for a view that's part of an expanded Live
    ///   Activity in the Dynamic Island.
    ///
    /// - Returns: A view with the specified vertical placement.
    @available(iOS 16.1, *)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    @MainActor @preconcurrency public func dynamicIsland(verticalPlacement: DynamicIslandExpandedRegionVerticalPlacement) -> some View

}

@available(iOS 17.0, watchOS 10.0, visionOS 26.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
extension View {

    /// Displays the widget's content along a curve if the context allows it.
    ///
    /// The system positions the widget's content along a curve that follows the
    /// corner of the watch face when displaying a <doc://com.apple.documentation/documentation/widgetkit/widgetfamily/accessorycorner>
    /// complication. The widget must use  a  <doc://com.apple.documentation/documentation/swiftui/view/widgetlabel(_:)-7wguh>
    /// modifier, and the curving effect modifies only text, SF Symbols, and images.
    ///
    /// When displaying an `.accessoryCorner` complication, the system places 
    /// the widget label on the inside of the curve, and the widget's content on 
    /// the outside, as shown below.
    ///
    /// ```swift
    /// var body: some View {
    ///     Text("Hi")
    ///         .widgetCurvesContent()
    ///         .widgetLabel("World!")
    /// }
    /// ```
    ///
    ///  ![A screenshot of an Apple Watch face, showing a complication in the 
    ///  upper-left corner with the words HI and WORLD curved around the 
    ///  corner.](WidgetCurveContent-Text)
    /// 
    /// The system can also curve text, SF symbols, and image content from 
    /// a <doc://com.apple.documentation/documentation/swiftui/viewthatfits> 
    /// view.
    ///
    /// ```swift
    /// var body: some View {
    ///     ViewThatFits {
    ///         Text("Hello")
    ///         Text("Hi")
    ///     }
    ///     .widgetCurvesContent()
    ///     .widgetLabel("World!")
    /// }
    /// ```
    ///
    ///  ![A screenshot of an Apple Watch face, showing a complication in the 
    ///  upper-left corner with the words HELLO and WORLD curved around the
    ///  corner.](WidgetCurveContent-ViewThatFits)
    ///
    ///
    /// - Parameter curvesContent: A Boolean value that indicates whether the 
    /// system curves the widget label's content, if the context allows.
    /// 
    @MainActor @preconcurrency public func widgetCurvesContent(_ curvesContent: Bool = true) -> some View

}

@available(iOS 14.0, macOS 11.0, watchOS 9.0, *)
@available(tvOS, unavailable)
extension Widget {

    @MainActor @preconcurrency public static func main()
}

@available(iOS 18.0, macOS 26.0, watchOS 26.0, *)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
extension ControlWidget {

    @MainActor @preconcurrency public static func main()
}

@available(iOS 14.0, macOS 11.0, watchOS 9.0, visionOS 26.0, *)
@available(tvOS, unavailable)
extension WidgetBundle {

    @MainActor @preconcurrency public static func main()
}

@available(iOS 15.0, watchOS 9.0, macOS 12.0, visionOS 26.0, *)
@available(tvOS, unavailable)
extension WidgetConfiguration {

    /// A modifier that marks the background of a widget as removable.
    ///
    /// In most cases, mark the background container of a widget as removable to
    /// allow people to place the widget in as many contexts as possible. If you mark the
    /// background as nonremovable, the widget becomes ineligible in various contexts that require a
    /// removable background. For example, a small widget without a removable background doesn't
    /// appear in the widget gallery on the iPad Lock Screen.
    ///
    ///  If you mark a background as nonremovable, the system always displays the background
    ///  container of the widget. Note that the background may render differently; for example, it can
    ///  appear faded or desaturated.
    ///
    ///  This modifier has no effect on operation system versions prior to iOS 17, watchOS 10, or macOS 14.
    ///
    /// - Parameters:
    ///   - isRemovable: If `true`, the widget supports removal of the container background in
    ///     contexts that prefer no backgrounds. If `false`, the system doesn't remove the background.
    ///
    /// - Returns: A modified widget configuration.
    ///
    @MainActor @preconcurrency public func containerBackgroundRemovable(_ isRemovable: Bool = true) -> some WidgetConfiguration

}

extension ContainerBackgroundPlacement {

    /// The container background placement for a widget.
    ///
    /// Pass the container background placement to the <doc://com.apple.documentation/documentation/swiftui/view/containerbackground(_:for:)>
    /// function to configure the background of your widgets.
    @available(iOS 17.0, watchOS 10.0, macOS 14.0, visionOS 26.0, *)
    @available(tvOS, unavailable)
    public static let widget: ContainerBackgroundPlacement
}

extension EnvironmentValues {

    /// An environment variable that indicates whether the background of a widget appears.
    ///
    /// In iOS 16 and earlier, this environment variable is always `true` for system widgets and `false`
    /// for accessory widgets. In macOS 13 and earlier, and in watchOS 9 and earlier, it always evaluates
    /// to `true`.
    ///
    /// If you pass `false` to <doc://com.apple.documentation/documentation/swiftui/widgetconfiguration/containerbackgroundremovable(_:)>
    /// to always show the widget background, the system shows the widget background even if `showsWidgetContainerBackground` evaluates to `true`.
    ///
    /// - Returns: `true` if, by default, the background appears in this context;
    ///   `false` otherwise.
    ///
    @available(iOS 15.0, macOS 12.0, watchOS 8.0, visionOS 26.0, *)
    @available(tvOS, unavailable)
    public var showsWidgetContainerBackground: Bool { get }
}

@available(iOS 16.0, watchOS 9.0, macOS 13.0, visionOS 26.0, *)
@available(tvOS, unavailable)
extension EnvironmentValues {

    /// The widget's rendering mode, based on where the system is displaying it.
    ///
    /// You can read the rendering mode from the environment values using this 
    /// key.
    ///
    /// ``` swift
    /// @Environment(\.widgetRenderingMode) var widgetRenderingMode
    /// ```
    ///
    /// Then modify the widget's appearance based on the mode.
    ///
    /// ``` swift
    /// var body: some View {
    ///     ZStack {
    ///        switch renderingMode {
    ///         case .fullColor:
    ///            Text("Full color")
    ///         case .accented:
    ///            ZStack {
    ///                Circle(...)
    ///                VStack {
    ///                    Text("Accented")
    ///                        .widgetAccentable()
    ///                    Text("Normal")
    ///                }
    ///            }
    ///         case .vibrant:
    ///            Text("Full color")
    ///         default:
    ///            ...
    ///         }
    ///     }
    /// }
    /// ```
    public var widgetRenderingMode: WidgetRenderingMode
}

@available(iOS 16.0, watchOS 9.0, macOS 13.0, visionOS 26.0, *)
@available(tvOS, unavailable)
extension View {

    /// Adds the view and all of its subviews to the accented group.
    ///
    /// When the system renders the widget using the
    /// ``WidgetKit/WidgetRenderingMode/accented`` mode, it divides the widget's
    /// view hierarchy into two groups: the accented group and the default
    /// group. It then applies a different color to each group.
    ///
    /// When applying the colors, the system treats the widget's views as if
    /// they were template images. It ignores the view's color --- rendering the
    /// new colors based on the view's alpha channel.
    ///
    /// To control your view's appearance, add the `widgetAccentable(_:)`
    /// modifier to part of your view's hierarchy. If the `accentable` parameter
    /// is `true`, the system adds that view and all of its subviews to the
    /// accent group. It puts all other views in the default group.
    ///
    /// ``` swift
    /// var body: some View {
    ///     VStack {
    ///         Text("MON")
    ///             .font(.caption)
    ///             .widgetAccentable()
    ///         Text("6")
    ///             .font(.title)
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// > Important: After you call `widgetAccentable(true)` on a view moving it
    /// into the accented group, calling `widgetAccentable(false)` on its
    /// subviews doesn't move the subviews back into the default group.
    ///
    /// - Parameter accentable: A Boolean value that indicates whether to add
    /// the view and its subviews to the accented group.
    @MainActor @preconcurrency public func widgetAccentable(_ accentable: Bool = true) -> some View

}

@available(iOS 16.0, watchOS 9.0, visionOS 26.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
extension View {

    /// Creates a label for displaying additional content outside an accessory 
    /// family widget's main SwiftUI view. 
    ///
    /// The system only displays labels on widget-based complications in 
    /// watchOS. The system ignores any labels attached to widgets on the Lock 
    /// Screen on iPhone. Therefore, you can use the same code to display an 
    /// accessory family widget on both iPhone and Apple Watch. 
    ///
    /// To create the widget label, call `widgetLabel(label:)`on 
    /// a complication's main SwiftUI view. Pass the desired content as the 
    /// `label` parameter. The label can be 
    /// a <doc://com.apple.documentation/documentation/swiftui/Gauge>, 
    /// <doc://com.apple.documentation/documentation/swiftui/ProgressView>,
    /// <doc://com.apple.documentation/documentation/swiftui/Text>, or 
    /// <doc://com.apple.documentation/documentation/swiftui/Image>. To provide 
    /// multiple views, wrap your views in a container, such as
    /// a <doc://com.apple.documentation/documentation/swiftui/VStack>. 
    /// WidgetKit determines whether it can use any of the label's content. If 
    /// it can't, it ignores the label.
    ///
    ///  ```swift
    ///
    ///    struct Complication: View {
    ///        @Environment(\.widgetFamily) var widgetFamily
    ///
    ///        var body: some View {
    ///            switch widgetFamily {
    ///            case .accessoryCorner:
    ///                Text("Hi")
    ///                    .widgetLabel {
    ///                        Gauge(value: 0.8)
    ///                    }
    ///            case .accessoryCircular:
    ///                VStack {
    ///                    Image(systemName: "emoji.globe")
    ///                    Text("Hi")
    ///                }
    ///                .widgetLabel("World!")
    ///            case .accessoryInline:
    ///                Text("\(Image(systemName: "emoji.globe.face")) World!")
    ///        }
    ///    }
    ///
    ///  ```
    ///
    /// WidgetKit configures the label so that the watch face
    /// presents a unified look. For example, it sets the size for an image, the 
    /// font for text, and can even render text and gauges along a curve.
    ///
    /// The following widget families support widget labels:
    ///
    /// - term <doc://com.apple.documentation/documentation/widgetkit/widgetfamily/accessoryCorner>: In watchOS, this
    /// widget-based complication can display
    /// a <doc://com.apple.documentation/documentation/swiftui/Gauge>, 
    /// a <doc://com.apple.documentation/documentation/swiftui/ProgressView>, or
    /// a <doc://com.apple.documentation/documentation/swiftui/Text>. Adding 
    /// a label to an accessory corner causes the main SwiftUI view to shrink to 
    /// make space for the label. If you pass a view containing multiple, valid 
    /// subviews, the system picks which view to display as the
    /// widget label.
    ///
    /// - term <doc://com.apple.documentation/documentation/widgetkit/widgetfamily/accessoryCircular>: In watchOS, the
    /// widget-based complication can display either an
    /// <doc://com.apple.documentation/documentation/swiftui/Image> or 
    /// a <doc://com.apple.documentation/documentation/swiftui/Text>. To pass 
    /// both an image and text, wrap those views in a container.
    ///
    /// However, WidgetKit only renders the label along the bezel on the 
    /// Infograph watch face (the top circular complication). On all other 
    /// circular complications — including widgets on all other platforms 
    /// — WidgetKit ignores the label.
    ///
    /// - Parameter label: A view that WidgetKit can display alongside the 
    /// accessory family widget's main SwiftUI view. You can use a
    /// <doc://com.apple.documentation/documentation/swiftui/Image>, 
    /// <doc://com.apple.documentation/documentation/swiftui/Text>, 
    /// <doc://com.apple.documentation/documentation/swiftui/Gauge>, 
    /// <doc://com.apple.documentation/documentation/swiftui/ProgressView>, or 
    /// a container with multiple subviews.
    @MainActor @preconcurrency public func widgetLabel<Label>(@ViewBuilder label: () -> Label) -> some View where Label : View


    /// Returns a localized text label that displays additional content outside 
    /// the accessory family widget's main SwiftUI view.  
    ///
    /// To add a text label to an accessory family widget, call this method on 
    /// the widget's main SwiftUI view, and pass in a supported 
    /// <doc://com.apple.documentation/documentation/swiftui/LocalizedStringKey>. 
    /// The system determines whether it can use the text label. If it can't, it 
    /// ignores the label. The system also sets the label's size, placement, and 
    /// style based on the clock face. For example, setting the font and 
    /// rendering the text along a curve.
    ///
    /// The following widget families support text accessory labels:
    ///
    /// - The <doc://com.apple.documentation/documentation/WidgetKit/WidgetFamily/accessoryCorner> widget-based
    /// complication can display a curved text label on the inside edge of the
    /// corner. Adding a label to an accessory corner complication causes the 
    /// main SwiftUI view to shrink to make space for the label.
    ///
    /// - The <doc://com.apple.documentation/documentation/WidgetKit/WidgetFamily/accessoryCircular> widget can display
    /// a text label in watchOS; however, WidgetKit only renders the label along
    /// the bezel on the Infograph watch face (the top circular complication).    
    /// 
    /// - Parameter labelKey: A label generated from a localized string.
    @MainActor @preconcurrency public func widgetLabel(_ labelKey: LocalizedStringKey) -> some View


    /// Returns a localized text label that displays additional content outside 
    /// the accessory family widget's main SwiftUI view.  
    ///
    /// To add a text label to an accessory family widget, call this method on 
    /// the widget's main SwiftUI view, and pass in a supported 
    /// `LocalizedStringResource`.
    /// The system determines whether it can use the text label. If it can't, it
    /// ignores the label. The system also sets the label's size, placement, and 
    /// style based on the clock face. For example, setting the font and 
    /// rendering the text along a curve.
    ///
    /// The following widget families support text accessory labels:
    ///
    /// - The <doc://com.apple.documentation/documentation/WidgetKit/WidgetFamily/accessoryCorner> widget-based
    /// complication can display a curved text label on the inside edge of the
    /// corner. Adding a label to an accessory corner complication causes the 
    /// main SwiftUI view to shrink to make space for the label.
    ///
    /// - The <doc://com.apple.documentation/documentation/WidgetKit/WidgetFamily/accessoryCircular> widget can display
    /// a text label in watchOS; however, WidgetKit only renders the label along
    /// the bezel on the Infograph watch face (the top circular complication).    
    /// 
    /// - Parameter label: A label generated from a localized string.
    @MainActor @preconcurrency public func widgetLabel(_ label: LocalizedStringResource) -> some View


    /// Returns a text label that displays additional content outside the 
    /// accessory family widget's main SwiftUI view.  
    ///
    /// To add a text label to an accessory family widget, call this method on 
    /// the widget's main SwiftUI view, and pass in a supported 
    /// <doc://com.apple.documentation/documentation/swiftui/LocalizedStringKey>. 
    /// The system determines whether it can use the text label. If it can't, it 
    /// ignores the label. The system also sets the label's size, placement, and 
    /// style. For example, setting the font and rendering the text along 
    /// a curve.
    ///
    /// The following widget families support text accessory labels:
    ///
    /// - The <doc://com.apple.documentation/documentation/WidgetKit/WidgetFamily/accessoryCorner> widget-based
    /// complication can display a curved text label on the inside edge of the
    /// corner. Adding a label to an accessory corner complication causes the
    /// main SwiftUI view to shrink to make space for the label.
    ///
    /// - The <doc://com.apple.documentation/documentation/WidgetKit/WidgetFamily/accessoryCircular> widget can display
    /// a text label in watchOS; however, WidgetKit only renders the label along
    /// the bezel on the Infograph watch face (the top circular complication).
    ///
    /// - Parameter label: A string that contains the text which WidgetKit 
    /// displays alongside the complication.
    @MainActor @preconcurrency public func widgetLabel<S>(_ label: S) -> some View where S : StringProtocol

}

@available(iOS 16.0, watchOS 9.0, visionOS 26.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
extension EnvironmentValues {

    /// A Boolean value that indicates whether an accessory family widget can 
    /// display an accessory label.
    ///
    /// Use this value to determine if you can provide additional content, or 
    /// possibly move some of the widget's content out of the main view and into 
    /// the widget label.
    ///
    /// ```swift
    ///
    /// @Environment(\.widgetFamily) var widgetFamily
    /// @Environment(\.showsWidgetLabel) var showsWidgetLabel
    ///
    /// var body: some View {
    ///    switch widgetFamily {
    ///    case .accessoryCircular:
    ///        if showsWidgetLabel {
    ///            Image("cat_full")
    ///                .widgetLabel(label: Text("Cats"))
    ///        }
    ///        else {
    ///            VStack {
    ///                Image("cat_small")
    ///                Text("Cats")
    ///            }
    ///        }
    ///    }
    /// }
    ///
    /// ```
    ///
    /// This environment value is most useful when defining the appearance for 
    /// the <doc://com.apple.documentation/documentation/widgetkit/widgetfamily/accessoryCircular> widget family, because 
    /// it's value can change depending on where the widget appears. For 
    /// example, if the widget is the top circular complication on the Infograph 
    /// watch face, the value is `true`. Otherwise it is `false`. The 
    /// environment variable is always `false` in iOS.
    ///
    /// Other families always have the same value, regardless of where the 
    /// widget appears. For the <doc://com.apple.documentation/documentation/widgetkit/widgetfamily/accessoryCorner>
    /// widget family, the
    /// value is always `true`. For other families, it is `false`.
    public var showsWidgetLabel: Bool
}

@available(iOS 16.2, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension ActivityAttributes {

    /// Generates a preview for a Live Activity.
    /// - Parameters:
    ///   - contentState: The dynamic content of the Live Activity.
    ///   - isStale: A Boolean that indicates whether the content of a Live Activity is out of date.
    ///   - viewKind: A value that determines which Live Activity presentation to render for this preview.
    public func previewContext(_ contentState: Self.ContentState, isStale: Bool = false, viewKind: ActivityPreviewViewKind) -> some View

}

@available(iOS 18.0, macOS 26.0, watchOS 26.0, *)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
extension ControlWidgetConfiguration {

    /// Sets the name shown for the control when a user adds or edits it, using
    /// the specified string.
    @MainActor @preconcurrency public func displayName(_ displayName: LocalizedStringResource) -> some ControlWidgetConfiguration


    /// Sets the description shown for the control when a user adds or edits it,
    /// using the specified string.
    @MainActor @preconcurrency public func description(_ description: LocalizedStringResource) -> some ControlWidgetConfiguration


    /// Specifies that a control's configuration UI should be automatically presented after the widget is added.
    ///
    /// - Returns: A control configuration that knows whether the presentation of a configuration UI is preferred.
    @MainActor @preconcurrency public func promptsForUserConfiguration() -> some ControlWidgetConfiguration


    /// Register a type that can handle push tokens changing for controls of
    /// this type.
    ///
    /// Use this to opt your control into using push notifications.
    ///
    /// If you have multiple control types, you can choose to use the same push
    /// handler type for those control types.
    ///
    /// When the push configuration of your controls changes, each handler type
    /// will be instantiated and <doc://com.apple.documentation/documentation/widgetKit/ControlPushHandler/pushTokensDidChange(controls:)>
    /// will be called.
    ///
    /// - Parameter pushHandlerType: The type of the object that can handle push tokens you use to update the control with push notifications.
    @MainActor @preconcurrency public func pushHandler(_ pushHandlerType: any ControlPushHandler.Type) -> some ControlWidgetConfiguration

}

@available(iOS 16.0, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension View {

    /// Sets the tint color for the background of a Live Activity that appears on the Lock Screen.
    ///
    /// When you set a custom background tint color, consider setting a custom text color for the auxiliary
    /// button people use to end a Live Activity on the Lock Screen. To set a custom
    /// text color, use the
    /// <doc://com.apple.documentation/documentation/swiftui/view/activitySystemActionForegroundColor(_:)>
    /// view modifier.
    ///
    /// - Parameters:
    ///   - color: The background tint color to apply. To use the system's default background material,
    ///   pass `nil`.
    ///
    @MainActor @preconcurrency public func activityBackgroundTint(_ color: Color?) -> some View

}

@available(iOS 16.1, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension View {

    /// The text color for the auxiliary action button that the system shows next to a Live Activity on the
    /// Lock Screen.
    ///
    /// - Parameters:
    ///     - color: The text color to use. Pass `nil` to use the system's default color.
    @MainActor @preconcurrency public func activitySystemActionForegroundColor(_ color: Color?) -> some View

}

@available(iOS 17.0, *)
@available(macOS, unavailable)
@available(visionOS, unavailable)
@available(macCatalyst, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension Preview {

    /// Creates a preview of a live activity widget.
    ///
    /// The `#Preview` macro expands into a declaration that calls this initializer. To create a preview
    /// that appears in the canvas, you must use the macro, not instantiate a Preview directly.
    @MainActor public init<Attributes>(_ name: String? = nil, as viewKind: ActivityPreviewViewKind, using attributes: Attributes, widget: @escaping () -> some Widget, @PreviewActivityBuilder<Attributes> contentStates: @escaping @MainActor () async -> [Attributes.ContentState]) where Attributes : ActivityAttributes
}

@available(iOS 14.0, macOS 11.0, watchOS 9.0, visionOS 26.0, *)
@available(tvOS, unavailable)
extension WidgetConfiguration {

    /// Sets the name shown for a widget when a user adds or edits it using the
    /// contents of a text view.
    ///
    /// - Parameter displayName: A text view containing a localized string to
    ///   display.
    /// - Returns: A widget configuration with a descriptive name for the widget.
    @MainActor @preconcurrency public func configurationDisplayName(_ displayName: Text) -> some WidgetConfiguration


    /// Sets the localized name shown for a widget when a user adds or edits
    /// the widget.
    ///
    /// - Parameter displayNameKey: The key for the localized name to display.
    /// - Returns: A widget configuration that includes a descriptive name for
    ///   the widget.
    @MainActor @preconcurrency public func configurationDisplayName(_ displayNameKey: LocalizedStringKey) -> some WidgetConfiguration


    /// Sets the localized name shown for a widget when a user adds or edits
    /// the widget.
    ///
    /// - Parameter displayName: Text resource for the localized name to display.
    /// - Returns: A widget configuration that includes a descriptive name for
    ///   the widget.
    @available(iOS 16.0, macOS 13.0, watchOS 9.0, visionOS 26.0, *)
    @available(tvOS, unavailable)
    @MainActor @preconcurrency public func configurationDisplayName(_ displayName: LocalizedStringResource) -> some WidgetConfiguration


    /// Sets the name shown for a widget when a user adds or edits it using the
    /// specified string.
    ///
    /// - Parameter displayName: A string describing the widget.
    /// - Returns: A widget configuration that includes a descriptive name for
    ///   the widget.
    @MainActor @preconcurrency public func configurationDisplayName<S>(_ displayName: S) -> some WidgetConfiguration where S : StringProtocol


    /// Sets the description shown for a widget when a user adds or edits it using the
    /// contents of a text view.
    ///
    /// - Parameters:
    ///   - description: A text view containing a localized string to display.
    /// - Returns: A widget configuration with a description of the widget.
    @MainActor @preconcurrency public func description(_ description: Text) -> some WidgetConfiguration


    /// Sets the localized description shown for a widget when a user adds or
    /// edits the widget.
    ///
    /// - Parameters:
    ///   - descriptionKey: The key for the localized description to display.
    /// - Returns: A widget configuration with a description of the widget.
    @MainActor @preconcurrency public func description(_ descriptionKey: LocalizedStringKey) -> some WidgetConfiguration


    /// Sets the localized description shown for a widget when a user adds or
    /// edits the widget.
    ///
    /// - Parameters:
    ///   - descriptionResource: Text resource for the localized description to
    ///     display.
    /// - Returns: A widget configuration with a description of the widget.
    @available(iOS 16.0, macOS 13.0, watchOS 9.0, visionOS 26.0, *)
    @available(tvOS, unavailable)
    @MainActor @preconcurrency public func description(_ descriptionResource: LocalizedStringResource) -> some WidgetConfiguration


    /// Sets the description shown for a widget when a user adds or edits it using the
    /// specified string.
    ///
    /// - Parameters:
    ///     - description: A string describing the widget.
    /// - Returns: A widget configuration with a description of the widget.
    @MainActor @preconcurrency public func description<S>(_ description: S) -> some WidgetConfiguration where S : StringProtocol


    /// Sets the sizes that a widget supports.
    /// - Parameter families: The set of sizes the widget supports.
    /// - Returns: A widget configuration that supports the sizes you specify.
    @MainActor @preconcurrency public func supportedFamilies(_ families: [WidgetFamily]) -> some WidgetConfiguration


    /// Adds an action to perform when events related to a URL session with a matching
    /// identifier are waiting to be processed.
    /// - Parameters:
    ///   - matchingString: The identifier of a URL session to monitor for
    ///     events.
    ///   - urlSessionEvent: A closure that takes a string identifier and a
    ///     closure called `completion` as parameters.
    /// - Returns: A widget that triggers `urlSessionEvent` when events are
    ///   generated for a `URLSession` with the specified identifier.
    ///
    /// When a widget initiates a background network request, the system
    /// delivers events related to the request directly to the widget extension
    /// instead of the containing app. To process the events, do the following:
    ///
    /// 1. Use the `matching` parameter to determine if a corresponding
    ///   `URLSession` object exists. If the system hasn't terminated your
    ///   widget extension, maintain a reference to the same `URLSession`
    ///   object you used for the original background network request. If the
    ///   system terminated your widget extension, use the identifier to
    ///   create a new `URLSession` object so it can receive the events. You
    ///   might consider lazily initializing, and caching, the `URLSession`
    ///   objects in a central location so that your code works regardless of
    ///   whether your extension remains active, is suspended, or is
    ///   terminated.
    /// 2. Store a reference to the `completion` closure of `urlSessionEvent`
    ///   to invoke it after the system delivers all events.
    /// 3. After the system calls the `URLSession` delegate's
    ///   <doc://com.apple.documentation/documentation/Foundation/URLSessionDelegate/1617185-urlsessiondidfinishevents>
    ///   method, invoke the `completion` closure.
    @MainActor @preconcurrency public func onBackgroundURLSessionEvents(matching matchingString: String, _ urlSessionEvent: @escaping (_ identifier: String, _ completion: @escaping () -> Void) -> Void) -> some WidgetConfiguration


    /// Adds an action to perform when events related to a URL session identified by a
    /// closure are waiting to be processed.
    /// - Parameters:
    ///   - matching: A closure that takes a string identifier and
    ///     returns a Boolean value indicating whether to perform the action.
    ///   - urlSessionEvent: A closure that takes a string parameter called
    ///     `identifier` and a closure called `completion`.
    /// - Returns: A widget that triggers `urlSessionEvent` when events are
    ///   generated for a `URLSession` with the specified identifier.
    ///
    /// When a widget initiates a background network request, the system
    /// delivers events related to the request directly to the widget extension
    /// instead of the containing app. To process the events, do the
    /// following:
    ///
    /// 1. Use the `identifier` parameter to determine if a corresponding
    ///   `URLSession` object exists. If the system hasn't terminated your
    ///   widget extension, maintain a reference to the same `URLSession`
    ///   object you used for the original background network request. If the
    ///   system terminated your widget extension, use the identifier to
    ///   create a new `URLSession` object so it can receive the events. You
    ///   might consider lazily initializing, and caching, the `URLSession`
    ///   objects in a central location so that your code works regardless of
    ///   whether your extension remains active, is suspended, or is
    ///   terminated.
    /// 2. Store a reference to the `completion` closure to invoke it after the
    ///   system delivers all events.
    /// 3. After the system calls the `URLSession` delegate's
    ///   <doc://com.apple.documentation/documentation/Foundation/URLSessionDelegate/1617185-urlsessiondidfinishevents>
    ///   method, invoke the `completion` closure.
    @MainActor @preconcurrency public func onBackgroundURLSessionEvents(matching matchingBlock: ((_ identifier: String) -> Bool)? = nil, _ urlSessionEvent: @escaping (_ identifier: String, _ completion: @escaping () -> Void) -> Void) -> some WidgetConfiguration


    /// Specifies that a widget's configuration UI should be automatically presented after the widget is added.
    ///
    /// - Returns: A widget configuration that knows whether the presentation of a configuration UI is preferred..
    @available(iOS 18.0, macOS 15.0, visionOS 26.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @MainActor @preconcurrency public func promptsForUserConfiguration() -> some WidgetConfiguration

}

@available(iOS 17.0, watchOS 26.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
extension WidgetConfiguration {

    /// Sets the disfavored locations for a widget.
    ///
    /// A widget can appear in different contexts on different platforms. For example, a small system widget
    /// appears by default on the Home Screen and in Today View on iPhone, on the iPad Lock Screen,
    /// and so on. This gives more people opportunity to view data and
    /// functionality that your widget provides. However, some widgets may not work well in a location.
    /// For example, a widget that heavily relies on high-resolution photos and background colors for its
    /// functionality may not work well on the Lock Screen, where the system applies a vibrant treatment
    /// to the widget. To tell the system that the widget gallery should show a widget in the "Other"
    /// section of the widget gallery for a specific context, use the `.disfavoredLocations` modifier.
    ///
    /// The following code snippet tells the system to show the small system family widget in the "Other"
    /// section of the widget gallery for the disfavored ``WidgetLocation/lockScreen``
    /// and ``WidgetLocation/homeScreen`` locations.
    ///
    ///     lockScreenOnlyConfig
    ///         .disfavoredLocations([.lockScreen, .homeScreen], for: [.systemSmall])
    ///
    /// You can use subsequent calls to `disfavoredLocations(_:families:)` to join them and
    /// set disfavored locations for different families:
    ///
    ///     widgetConfig
    ///         .disfavoredLocations([.lockScreen, .homeScreen], for: [.systemSmall])
    ///         .disfavoredLocations([.homescreen], for: [.systemMedium])
    ///
    /// - Parameter locations: An array of disfavored locations for a widget.
    /// - Parameter families: The families you want to mark as disfavored in the given locations.
    @MainActor @preconcurrency public func disfavoredLocations(_ locations: [WidgetLocation], for families: [WidgetFamily]) -> some WidgetConfiguration

}

@available(iOS 26.0, macOS 26.0, watchOS 26.0, *)
@available(tvOS, unavailable)
extension WidgetConfiguration {

    /// Register a type that can handle push tokens changing for widgets.
    ///
    /// Use this to opt this widget into supporting updates via push notifications.
    ///
    /// If you have multiple widget configurations, you can choose to use the same
    /// push handler type for those widget configurations.
    ///
    /// When the push configuration of your widgets changes, each unique handler type
    /// will be instantiated and <doc://com.apple.documentation/documentation/widgetkit/widgetpushhandler/pushtokendidchange(_:widgets:)>
    /// will be called.
    ///
    /// - Parameter pushHandlerType: The type of the object that can handle push tokens you use to update the widget with push notifications.
    @MainActor @preconcurrency public func pushHandler(_ pushHandlerType: any WidgetPushHandler.Type) -> some WidgetConfiguration

}

/// Sets the mounting styles that a widget supports.
@available(iOS 26.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
extension WidgetConfiguration {

    /// Specifies the mounting style for this widget.
    ///
    /// The mounting style view modifier only has an effect to widgets in visionOS,
    /// including widgets of compatible widgets of compatible
    /// iOS or iPadOS apps.
    ///
    /// ```swift
    /// struct MySpatialWidget: Widget {
    ///      let kind: String = "MySpatialWidget"
    ///
    ///      var body: some WidgetConfiguration {
    ///          AppIntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
    ///              EntryView(entry: entry)
    ///                 .containerBackground(.fill.tertiary, for: .widget)
    ///          }
    ///          .supportedFamilies([.systemSmall, .systemLarge])
    ///          .supportedMountingStyles([.recessed])
    ///      }
    /// }
    /// ```
    ///
    /// The above code defines a widget that only supports the recessed mounting style.
    ///
    /// The mounting style view modifier only has an effect to widgets in visionOS, including widgets of compatible widgets of compatible
    /// iOS or iPadOS apps.
    ///
    /// - Parameter styles: The set of mounting styles that the widget supports.
    ///
    /// - Returns: A widget configuration that supports the specified mounting styles.
    @MainActor @preconcurrency public func supportedMountingStyles(_ styles: [WidgetMountingStyle]) -> some WidgetConfiguration

}