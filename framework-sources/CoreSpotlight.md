import CoreSpotlight.CSBase
import CoreSpotlight.CSImportExtension
import CoreSpotlight.CSIndexExtensionRequestHandler
import CoreSpotlight.CSPerson
import CoreSpotlight.CSSearchQuery
import CoreSpotlight.CSSearchableIndex
import CoreSpotlight.CSSearchableItem
import CoreSpotlight.CSSearchableItemAttributeSet
import CoreSpotlight.CSSearchableItemAttributeSet_Categories
import CoreSpotlight.CSSearchableItemAttributeSet_Documents
import CoreSpotlight.CSSearchableItemAttributeSet_Events
import CoreSpotlight.CSSearchableItemAttributeSet_General
import CoreSpotlight.CSSearchableItemAttributeSet_Images
import CoreSpotlight.CSSearchableItemAttributeSet_Media
import CoreSpotlight.CSSearchableItemAttributeSet_Messaging
import CoreSpotlight.CSSearchableItemAttributeSet_Places
import CoreSpotlight.CSSuggestion
import CoreSpotlight.CSUserQuery
import Foundation

//! Project version number for CoreSpotlight.
public var CoreSpotlightVersionNumber: Double

//! Project version string for CoreSpotlight.
public let CoreSpotlightVersionString: <<error type>>

public var CoreSpotlightAPIVersion: Int32 { get }

@available(macOS 13.0, iOS 16.0, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
extension CSSearchQuery {

    public struct Results : AsyncSequence, Sendable {

        public struct Item : Identifiable, Hashable, Equatable, Comparable, @unchecked Sendable {

            /// The stable identity of the entity associated with this instance.
            public var id: String { get }

            public var item: CSSearchableItem

            /// Returns a Boolean value indicating whether the value of the first
            /// argument is less than that of the second argument.
            ///
            /// This function is the only requirement of the `Comparable` protocol. The
            /// remainder of the relational operator functions are implemented by the
            /// standard library for any type that conforms to `Comparable`.
            ///
            /// - Parameters:
            ///   - lhs: A value to compare.
            ///   - rhs: Another value to compare.
            public static func < (lhs: CSSearchQuery.Results.Item, rhs: CSSearchQuery.Results.Item) -> Bool

            /// Returns a Boolean value indicating whether the value of the first
            /// argument is greater than that of the second argument.
            ///
            /// - Parameters:
            ///   - lhs: A value to compare.
            ///   - rhs: Another value to compare.
            public static func > (lhs: CSSearchQuery.Results.Item, rhs: CSSearchQuery.Results.Item) -> Bool

            /// Returns a Boolean value indicating whether two values are equal.
            ///
            /// Equality is the inverse of inequality. For any values `a` and `b`,
            /// `a == b` implies that `a != b` is `false`.
            ///
            /// - Parameters:
            ///   - lhs: A value to compare.
            ///   - rhs: Another value to compare.
            public static func == (lhs: CSSearchQuery.Results.Item, rhs: CSSearchQuery.Results.Item) -> Bool

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
            @available(iOS 16.0, macOS 13.0, *)
            @available(tvOS, unavailable)
            @available(watchOS, unavailable)
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

        /// The type of asynchronous iterator that produces elements of this
        /// asynchronous sequence.
        public typealias AsyncIterator = CSSearchQuery.Results.Iterator

        /// The type of element produced by this asynchronous sequence.
        public typealias Element = CSSearchQuery.Results.Item

        public struct Iterator : AsyncIteratorProtocol {

            /// Asynchronously advances to the next element and returns it, or ends the
            /// sequence if there is no next element.
            ///
            /// - Returns: The next element, if it exists, or `nil` to signal the end of
            ///   the sequence.
            public mutating func next() async throws -> CSSearchQuery.Results.Item?

            @available(iOS 16.0, macOS 13.0, *)
            @available(tvOS, unavailable)
            @available(watchOS, unavailable)
            public typealias Element = CSSearchQuery.Results.Item
        }

        /// Creates the asynchronous iterator that produces elements of this
        /// asynchronous sequence.
        ///
        /// - Returns: An instance of the `AsyncIterator` type used to produce
        /// elements of the asynchronous sequence.
        public func makeAsyncIterator() -> CSSearchQuery.Results.Iterator
    }

    public var results: CSSearchQuery.Results { get }
}

@available(macOS 13.0, iOS 16.0, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
extension CSUserQuery {

    public struct Item : Identifiable, Hashable, Equatable, Comparable, @unchecked Sendable {

        /// The stable identity of the entity associated with this instance.
        public var id: String { get }

        public var item: CSSearchableItem

        /// Returns a Boolean value indicating whether the value of the first
        /// argument is less than that of the second argument.
        ///
        /// This function is the only requirement of the `Comparable` protocol. The
        /// remainder of the relational operator functions are implemented by the
        /// standard library for any type that conforms to `Comparable`.
        ///
        /// - Parameters:
        ///   - lhs: A value to compare.
        ///   - rhs: Another value to compare.
        public static func < (lhs: CSUserQuery.Item, rhs: CSUserQuery.Item) -> Bool

        /// Returns a Boolean value indicating whether the value of the first
        /// argument is greater than that of the second argument.
        ///
        /// - Parameters:
        ///   - lhs: A value to compare.
        ///   - rhs: Another value to compare.
        public static func > (lhs: CSUserQuery.Item, rhs: CSUserQuery.Item) -> Bool

        /// Returns a Boolean value indicating whether two values are equal.
        ///
        /// Equality is the inverse of inequality. For any values `a` and `b`,
        /// `a == b` implies that `a != b` is `false`.
        ///
        /// - Parameters:
        ///   - lhs: A value to compare.
        ///   - rhs: Another value to compare.
        public static func == (lhs: CSUserQuery.Item, rhs: CSUserQuery.Item) -> Bool

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
        @available(iOS 16.0, macOS 13.0, *)
        @available(tvOS, unavailable)
        @available(watchOS, unavailable)
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

    public struct Suggestion : Identifiable, Hashable, Comparable, @unchecked Sendable {

        /// The stable identity of the entity associated with this instance.
        public var id: String { get }

        public var suggestion: CSSuggestion

        /// Returns a Boolean value indicating whether the value of the first
        /// argument is less than that of the second argument.
        ///
        /// This function is the only requirement of the `Comparable` protocol. The
        /// remainder of the relational operator functions are implemented by the
        /// standard library for any type that conforms to `Comparable`.
        ///
        /// - Parameters:
        ///   - lhs: A value to compare.
        ///   - rhs: Another value to compare.
        public static func < (lhs: CSUserQuery.Suggestion, rhs: CSUserQuery.Suggestion) -> Bool

        /// Returns a Boolean value indicating whether the value of the first
        /// argument is greater than that of the second argument.
        ///
        /// - Parameters:
        ///   - lhs: A value to compare.
        ///   - rhs: Another value to compare.
        public static func > (lhs: CSUserQuery.Suggestion, rhs: CSUserQuery.Suggestion) -> Bool

        /// Returns a Boolean value indicating whether two values are equal.
        ///
        /// Equality is the inverse of inequality. For any values `a` and `b`,
        /// `a == b` implies that `a != b` is `false`.
        ///
        /// - Parameters:
        ///   - lhs: A value to compare.
        ///   - rhs: Another value to compare.
        public static func == (lhs: CSUserQuery.Suggestion, rhs: CSUserQuery.Suggestion) -> Bool

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
        @available(iOS 16.0, macOS 13.0, *)
        @available(tvOS, unavailable)
        @available(watchOS, unavailable)
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

    public struct Responses : AsyncSequence, Sendable {

        public enum Response : Identifiable, Hashable, Equatable, @unchecked Sendable {

            case item(CSUserQuery.Item)

            case suggestion(CSUserQuery.Suggestion)

            /// The stable identity of the entity associated with this instance.
            public var id: String { get }

            /// Returns a Boolean value indicating whether two values are equal.
            ///
            /// Equality is the inverse of inequality. For any values `a` and `b`,
            /// `a == b` implies that `a != b` is `false`.
            ///
            /// - Parameters:
            ///   - lhs: A value to compare.
            ///   - rhs: Another value to compare.
            public static func == (a: CSUserQuery.Responses.Response, b: CSUserQuery.Responses.Response) -> Bool

            /// A type representing the stable identity of the entity associated with
            /// an instance.
            @available(iOS 16.0, macOS 13.0, *)
            @available(tvOS, unavailable)
            @available(watchOS, unavailable)
            public typealias ID = String

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

        /// The type of asynchronous iterator that produces elements of this
        /// asynchronous sequence.
        public typealias AsyncIterator = CSUserQuery.Responses.Iterator

        /// The type of element produced by this asynchronous sequence.
        public typealias Element = CSUserQuery.Responses.Response

        public struct Iterator : AsyncIteratorProtocol {

            /// Asynchronously advances to the next element and returns it, or ends the
            /// sequence if there is no next element.
            ///
            /// - Returns: The next element, if it exists, or `nil` to signal the end of
            ///   the sequence.
            public mutating func next() async throws -> CSUserQuery.Responses.Element?

            @available(iOS 16.0, macOS 13.0, *)
            @available(tvOS, unavailable)
            @available(watchOS, unavailable)
            public typealias Element = CSUserQuery.Responses.Element
        }

        /// Creates the asynchronous iterator that produces elements of this
        /// asynchronous sequence.
        ///
        /// - Returns: An instance of the `AsyncIterator` type used to produce
        /// elements of the asynchronous sequence.
        public func makeAsyncIterator() -> CSUserQuery.Responses.Iterator
    }

    public struct Suggestions : AsyncSequence, Sendable {

        /// The type of asynchronous iterator that produces elements of this
        /// asynchronous sequence.
        public typealias AsyncIterator = CSUserQuery.Suggestions.Iterator

        /// The type of element produced by this asynchronous sequence.
        public typealias Element = CSUserQuery.Suggestion

        public struct Iterator : AsyncIteratorProtocol {

            /// Asynchronously advances to the next element and returns it, or ends the
            /// sequence if there is no next element.
            ///
            /// - Returns: The next element, if it exists, or `nil` to signal the end of
            ///   the sequence.
            public mutating func next() async throws -> CSUserQuery.Suggestions.Element?

            @available(iOS 16.0, macOS 13.0, *)
            @available(tvOS, unavailable)
            @available(watchOS, unavailable)
            public typealias Element = CSUserQuery.Suggestions.Element
        }

        /// Creates the asynchronous iterator that produces elements of this
        /// asynchronous sequence.
        ///
        /// - Returns: An instance of the `AsyncIterator` type used to produce
        /// elements of the asynchronous sequence.
        public func makeAsyncIterator() -> CSUserQuery.Suggestions.Iterator
    }

    public var responses: CSUserQuery.Responses { get }

    public var suggestions: CSUserQuery.Suggestions { get }

    @available(macOS 15.0, iOS 18.0, *)
    public func userEngaged(_ item: CSUserQuery.Item, visibleItems: [CSUserQuery.Item], interaction: CSUserQuery.UserInteractionKind)

    @available(macOS 15.0, iOS 18.0, *)
    public func userEngaged(_ suggestion: CSUserQuery.Suggestion, visibleSuggestions: [CSUserQuery.Suggestion], interaction: CSUserQuery.UserInteractionKind)
}

@available(macOS 13.0, iOS 16.0, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
extension CSSuggestion {

    public var localizedAttributedSuggestion: AttributedString { get }
}

