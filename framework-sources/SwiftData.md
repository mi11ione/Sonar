import Foundation
import Observation

/// Specifies the custom behavior that SwiftData applies to the annotated property when managing the
/// owning class.
@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
@attached(peer) public macro Attribute(_ options: Schema.Attribute.Option..., originalName: String? = nil, hashModifier: String? = nil) = #externalMacro(module: "SwiftDataMacros", type: "AttributePropertyMacro")

/// An interface for providing in-memory storage for a persistent model.
@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
public protocol BackingData<Model> {

    associatedtype Model : PersistentModel

    init(for modelType: Self.Model.Type)

    var persistentModelID: PersistentIdentifier? { get set }

    var metadata: Any { get }

    func getValue<Value>(forKey: KeyPath<Self.Model, Value>) -> Value where Value : Decodable

    func getValue<Value>(forKey: KeyPath<Self.Model, Value>) -> Value where Value : PersistentModel

    func getValue<Value>(forKey: KeyPath<Self.Model, Value?>) -> Value? where Value : PersistentModel

    func getValue<Value, OtherModel>(forKey: KeyPath<Self.Model, Value>) -> Value where Value : RelationshipCollection, OtherModel == Value.PersistentElement

    func getValue<Value, OtherModel>(forKey: KeyPath<Self.Model, Value>) -> Value where Value : Decodable, Value : RelationshipCollection, OtherModel == Value.PersistentElement

    func getTransformableValue<Value>(forKey: KeyPath<Self.Model, Value>) -> Value

    func setValue<Value>(forKey: KeyPath<Self.Model, Value>, to newValue: Value) where Value : Encodable

    func setValue<Value>(forKey: KeyPath<Self.Model, Value>, to newValue: Value) where Value : PersistentModel

    func setValue<Value>(forKey: KeyPath<Self.Model, Value?>, to newValue: Value?) where Value : PersistentModel

    func setValue<Value, OtherModel>(forKey: KeyPath<Self.Model, Value>, to newValue: Value) where Value : RelationshipCollection, OtherModel == Value.PersistentElement

    func setValue<Value, OtherModel>(forKey: KeyPath<Self.Model, Value>, to newValue: Value) where Value : Encodable, Value : RelationshipCollection, OtherModel == Value.PersistentElement

    func setTransformableValue<Value>(forKey: KeyPath<Self.Model, Value>, to newValue: Value)
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
public protocol DataStore : AnyObject {

    associatedtype Configuration : DataStoreConfiguration where Self == Self.Configuration.Store

    associatedtype Snapshot : DataStoreSnapshot

    var identifier: String { get }

    var schema: Schema { get }

    var configuration: Self.Configuration { get }

    init(_ configuration: Self.Configuration, migrationPlan: (any SchemaMigrationPlan.Type)?) throws

    func erase() throws

    func fetch<T>(_ request: DataStoreFetchRequest<T>) throws -> DataStoreFetchResult<T, Self.Snapshot> where T : PersistentModel

    func fetchCount<T>(_ request: DataStoreFetchRequest<T>) throws -> Int where T : PersistentModel

    func fetchIdentifiers<T>(_ request: DataStoreFetchRequest<T>) throws -> [PersistentIdentifier] where T : PersistentModel

    func save(_ request: DataStoreSaveChangesRequest<Self.Snapshot>) throws -> DataStoreSaveChangesResult<Self.Snapshot>

    func initializeState(for editingState: EditingState)

    func invalidateState(for editingState: EditingState)

    func cachedSnapshots(for persistentIdentifiers: [PersistentIdentifier], editingState: EditingState) throws -> [PersistentIdentifier : Self.Snapshot]
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
extension DataStore {

    public func fetchCount<T>(_ request: DataStoreFetchRequest<T>) throws -> Int where T : PersistentModel

    public func fetchIdentifiers<T>(_ request: DataStoreFetchRequest<T>) throws -> [PersistentIdentifier] where T : PersistentModel

    public func erase() throws

    public func initializeState(for editingState: EditingState)

    public func invalidateState(for editingState: EditingState)

    public func cachedSnapshots(for persistentIdentifiers: [PersistentIdentifier], editingState: EditingState) throws -> [PersistentIdentifier : Self.Snapshot]
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
public struct DataStoreBatchDeleteRequest<T> : Sendable where T : PersistentModel {

    public let editingState: EditingState

    public let predicate: Predicate<T>?

    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
    public let includeSubclasses: Bool
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
public protocol DataStoreBatching : DataStore {

    func delete<T>(_ request: DataStoreBatchDeleteRequest<T>) throws where T : PersistentModel
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
public protocol DataStoreConfiguration : Hashable {

    associatedtype Store : DataStore where Self == Self.Store.Configuration

    var name: String { get }

    var schema: Schema? { get set }

    func validate() throws
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
extension DataStoreConfiguration {

    public func validate() throws
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 10, visionOS 2, *)
public enum DataStoreError : Error {

    case unsupportedFeature

    case preferInMemoryFilter

    case preferInMemorySort

    case invalidPredicate

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (a: DataStoreError, b: DataStoreError) -> Bool

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

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 10, visionOS 2, *)
extension DataStoreError : Equatable {
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 10, visionOS 2, *)
extension DataStoreError : Hashable {
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
public struct DataStoreFetchRequest<T> : Sendable where T : PersistentModel {

    public let editingState: EditingState

    public let descriptor: FetchDescriptor<T>
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
public struct DataStoreFetchResult<ModelType, SnapshotType> : Sendable where ModelType : PersistentModel, SnapshotType : DataStoreSnapshot {

    public let descriptor: FetchDescriptor<ModelType>

    public let fetchedSnapshots: [SnapshotType]

    public let relatedSnapshots: [PersistentIdentifier : SnapshotType]

    public init(descriptor: FetchDescriptor<ModelType>, fetchedSnapshots: [SnapshotType], relatedSnapshots: [PersistentIdentifier : SnapshotType] = [:])
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
public struct DataStoreSaveChangesRequest<SnapshotType> : Sendable where SnapshotType : DataStoreSnapshot {

    public let inserted: [SnapshotType]

    public let updated: [SnapshotType]

    public let deleted: [SnapshotType]

    public let editingState: EditingState
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
final public class DataStoreSaveChangesResult<T> : Sendable where T : DataStoreSnapshot {

    final public let remappedIdentifiers: [PersistentIdentifier : PersistentIdentifier]

    final public let storeIdentifier: String

    final public let snapshotsToReregister: [PersistentIdentifier : T]

    public init(for storeIdentifier: String, remappedIdentifiers: [PersistentIdentifier : PersistentIdentifier] = [:], snapshotsToReregister: [PersistentIdentifier : T] = [:])

    @objc deinit
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
public protocol DataStoreSnapshot : Decodable, Encodable, Sendable {

    var persistentIdentifier: PersistentIdentifier { get }

    init(from: any BackingData, relatedBackingDatas: inout [PersistentIdentifier : any BackingData])

    func copy(persistentIdentifier: PersistentIdentifier, remappedIdentifiers: [PersistentIdentifier : PersistentIdentifier]?) -> Self
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
public enum DataStoreSnapshotCodingKey : CodingKey {

    case persistentIdentifier

    case modeledProperty(String)

    /// The string to use in a named collection (e.g. a string-keyed dictionary).
    public var stringValue: String { get }

    /// Creates a new instance from the given string.
    ///
    /// If the string passed as `stringValue` does not correspond to any instance
    /// of this type, the result is `nil`.
    ///
    /// - parameter stringValue: The string value of the desired key.
    public init?(stringValue: String)

    /// The value to use in an integer-indexed collection (e.g. an int-keyed
    /// dictionary).
    public var intValue: Int? { get }

    /// Creates a new instance from the specified integer.
    ///
    /// If the value passed as `intValue` does not correspond to any instance of
    /// this type, the result is `nil`.
    ///
    /// - parameter intValue: The integer value of the desired key.
    public init?(intValue: Int)
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
public typealias DataStoreSnapshotValue = Codable & Sendable

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
public struct DefaultHistoryDelete<Model> : HistoryDelete where Model : PersistentModel {

    public typealias TransactionIdentifier = Int64

    public typealias ChangeIdentifier = Int64

    public let changeIdentifier: DefaultHistoryDelete<Model>.ChangeIdentifier

    public let transactionIdentifier: DefaultHistoryDelete<Model>.TransactionIdentifier

    public let changedPersistentIdentifier: PersistentIdentifier

    public let tombstone: HistoryTombstone<Model>

    public static func == (lhs: DefaultHistoryDelete<Model>, rhs: DefaultHistoryDelete<Model>) -> Bool

    public func hash(into hasher: inout Hasher)
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
public struct DefaultHistoryInsert<Model> : HistoryInsert where Model : PersistentModel {

    public typealias TransactionIdentifier = Int64

    public typealias ChangeIdentifier = Int64

    public let changeIdentifier: DefaultHistoryInsert<Model>.ChangeIdentifier

    public let transactionIdentifier: DefaultHistoryInsert<Model>.TransactionIdentifier

    public let changedPersistentIdentifier: PersistentIdentifier

    public static func == (lhs: DefaultHistoryInsert<Model>, rhs: DefaultHistoryInsert<Model>) -> Bool

    public func hash(into hasher: inout Hasher)
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
public struct DefaultHistoryToken : HistoryToken, Comparable & Hashable & Identifiable & Sendable, Codable {

    public typealias TokenType = [String : Int64]

    /// The stable identity of the entity associated with this instance.
    public var id: Int { get }

    public var tokenValue: DefaultHistoryToken.TokenType? { get }

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: DefaultHistoryToken, rhs: DefaultHistoryToken) -> Bool

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
    public static func < (lhs: DefaultHistoryToken, rhs: DefaultHistoryToken) -> Bool

    /// A type representing the stable identity of the entity associated with
    /// an instance.
    @available(swift 5.9)
    @available(iOS 18, tvOS 18, watchOS 11, visionOS 2, macOS 15, *)
    public typealias ID = Int

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

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
public struct DefaultHistoryTransaction : HistoryTransaction {

    public typealias TransactionIdentifier = Int64

    public typealias TokenType = DefaultHistoryToken

    /// The stable identity of the entity associated with this instance.
    public var id: Int64 { get }

    public let timestamp: Date

    public let changes: [HistoryChange]

    public let token: DefaultHistoryTransaction.TokenType

    public let transactionIdentifier: DefaultHistoryTransaction.TransactionIdentifier

    public let storeIdentifier: String

    public let bundleIdentifier: String

    public let processIdentifier: String

    public let author: String?

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: DefaultHistoryTransaction, rhs: DefaultHistoryTransaction) -> Bool

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
    @available(swift 5.9)
    @available(iOS 18, tvOS 18, watchOS 11, visionOS 2, macOS 15, *)
    public typealias ID = Int64

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

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
public struct DefaultHistoryUpdate<Model> : HistoryUpdate where Model : PersistentModel {

    public typealias TransactionIdentifier = Int64

    public typealias ChangeIdentifier = Int64

    public typealias PropertyUpdate = PartialKeyPath<Model> & Sendable

    public let changeIdentifier: DefaultHistoryUpdate<Model>.ChangeIdentifier

    public let transactionIdentifier: DefaultHistoryUpdate<Model>.TransactionIdentifier

    public let changedPersistentIdentifier: PersistentIdentifier

    public let updatedAttributes: [any PartialKeyPath<Model> & Sendable]

    public static func == (lhs: DefaultHistoryUpdate<Model>, rhs: DefaultHistoryUpdate<Model>) -> Bool

    public func hash(into hasher: inout Hasher)
}

/// An object that safely performs storage-related tasks using an isolated model context.
@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
public class DefaultSerialModelExecutor : @unchecked Sendable, SerialModelExecutor {

    final public let modelContext: ModelContext

    public init(modelContext: ModelContext)

    @objc deinit
}

@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
extension DefaultSerialModelExecutor : SerialExecutor {

    public func enqueue(_ job: ExecutorJob)

    /// Convert this executor value to the optimized form of borrowed
    /// executor references.
    public func asUnownedSerialExecutor() -> UnownedSerialExecutor
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
public struct DefaultSnapshot : DataStoreSnapshot {

    public let persistentIdentifier: PersistentIdentifier

    public init(from backingData: any BackingData, relatedBackingDatas: inout [PersistentIdentifier : any BackingData])

    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: any Decoder) throws

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

    public func copy(persistentIdentifier: PersistentIdentifier, remappedIdentifiers: [PersistentIdentifier : PersistentIdentifier]? = [:]) -> DefaultSnapshot
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
final public class DefaultStore : DataStore, DataStoreBatching {

    public typealias Configuration = ModelConfiguration

    public typealias Snapshot = DefaultSnapshot

    public convenience init(_ configuration: ModelConfiguration, migrationPlan: (any SchemaMigrationPlan.Type)? = nil) throws

    final public let name: String

    final public let schema: Schema

    final public var identifier: String { get }

    final public let configuration: ModelConfiguration

    final public func erase() throws

    final public func initializeState(for editingState: EditingState)

    final public func invalidateState(for editingState: EditingState)

    final public func fetch<T>(_ request: DataStoreFetchRequest<T>) throws -> DataStoreFetchResult<T, DefaultStore.Snapshot> where T : PersistentModel

    final public func fetchCount<T>(_ request: DataStoreFetchRequest<T>) throws -> Int where T : PersistentModel

    final public func fetchIdentifiers<T>(_ request: DataStoreFetchRequest<T>) throws -> [PersistentIdentifier] where T : PersistentModel

    final public func delete<T>(_ request: DataStoreBatchDeleteRequest<T>) throws where T : PersistentModel

    final public func save(_ request: DataStoreSaveChangesRequest<DefaultStore.Snapshot>) throws -> DataStoreSaveChangesResult<DefaultStore.Snapshot>

    final public func cachedSnapshots(for persistentIdentifiers: [PersistentIdentifier], editingState: EditingState) throws -> [PersistentIdentifier : DefaultStore.Snapshot]

    @objc deinit
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
extension DefaultStore : HistoryProviding {

    public static var historyType: DefaultHistoryTransaction.Type { get }

    public typealias HistoryType = DefaultHistoryTransaction

    public typealias TokenType = DefaultHistoryToken

    final public func fetchHistory(_ descriptor: HistoryDescriptor<DefaultHistoryTransaction>) throws -> [DefaultHistoryTransaction]

    final public func deleteHistory(_ descriptor: HistoryDescriptor<DefaultHistoryTransaction>) throws
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
public struct EditingState : Identifiable, Sendable {

    /// A type representing the stable identity of the entity associated with
    /// an instance.
    public typealias ID = UUID

    /// The stable identity of the entity associated with this instance.
    public let id: UUID

    public var author: String?
}

/// A type that describes the criteria, sort order, and any additional configuration to use when performing a
/// fetch.
@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
public struct FetchDescriptor<T> where T : PersistentModel {

    public var predicate: Predicate<T>?

    public var sortBy: [SortDescriptor<T>]

    public var fetchLimit: Int?

    public var fetchOffset: Int?

    public var includePendingChanges: Bool

    public var propertiesToFetch: [PartialKeyPath<T>]

    public var relationshipKeyPathsForPrefetching: [PartialKeyPath<T>]

    public init(predicate: Predicate<T>? = nil, sortBy: [SortDescriptor<T>] = [])
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, watchOS 26.0, *)
extension FetchDescriptor : Equatable {

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, watchOS 26.0, *)
    public static func == (lhs: FetchDescriptor<T>, rhs: FetchDescriptor<T>) -> Bool
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
extension FetchDescriptor : @unchecked Sendable {
}

/// A collection that efficiently provides the results of a completed fetch.
@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
public struct FetchResultsCollection<Element> : RandomAccessCollection {

    /// The position of the first element in a nonempty collection.
    ///
    /// If the collection is empty, `startIndex` is equal to `endIndex`.
    public var startIndex: Int { get }

    /// The collection's "past the end" position---that is, the position one
    /// greater than the last valid subscript argument.
    ///
    /// When you need a range that includes the last element of a collection, use
    /// the half-open range operator (`..<`) with `endIndex`. The `..<` operator
    /// creates a range that doesn't include the upper bound, so it's always
    /// safe to use with `endIndex`. For example:
    ///
    ///     let numbers = [10, 20, 30, 40, 50]
    ///     if let index = numbers.firstIndex(of: 30) {
    ///         print(numbers[index ..< numbers.endIndex])
    ///     }
    ///     // Prints "[30, 40, 50]"
    ///
    /// If the collection is empty, `endIndex` is equal to `startIndex`.
    public var endIndex: Int { get }

    /// Accesses the element at the specified position.
    ///
    /// The following example accesses an element of an array through its
    /// subscript to print its value:
    ///
    ///     var streets = ["Adams", "Bryant", "Channing", "Douglas", "Evarts"]
    ///     print(streets[1])
    ///     // Prints "Bryant"
    ///
    /// You can subscript a collection with any valid index other than the
    /// collection's end index. The end index refers to the position one past
    /// the last element of a collection, so it doesn't correspond with an
    /// element.
    ///
    /// - Parameter position: The position of the element to access. `position`
    ///   must be a valid index of the collection that is not equal to the
    ///   `endIndex` property.
    ///
    /// - Complexity: O(1)
    public subscript(position: Int) -> Element { get }

    /// A type that represents a position in the collection.
    ///
    /// Valid indices consist of the position of every element and a
    /// "past the end" position that's not valid for use as a subscript
    /// argument.
    @available(swift 5.9)
    @available(iOS 17, tvOS 17, watchOS 10, macOS 14, *)
    public typealias Index = Int

    /// A type that represents the indices that are valid for subscripting the
    /// collection, in ascending order.
    @available(swift 5.9)
    @available(iOS 17, tvOS 17, watchOS 10, macOS 14, *)
    public typealias Indices = Range<Int>

    /// A type that provides the collection's iteration interface and
    /// encapsulates its iteration state.
    ///
    /// By default, a collection conforms to the `Sequence` protocol by
    /// supplying `IndexingIterator` as its associated `Iterator`
    /// type.
    @available(swift 5.9)
    @available(iOS 17, tvOS 17, watchOS 10, macOS 14, *)
    public typealias Iterator = IndexingIterator<FetchResultsCollection<Element>>

    /// A collection representing a contiguous subrange of this collection's
    /// elements. The subsequence shares indices with the original collection.
    ///
    /// The default subsequence type for collections that don't define their own
    /// is `Slice`.
    @available(swift 5.9)
    @available(iOS 17, tvOS 17, watchOS 10, macOS 14, *)
    public typealias SubSequence = Slice<FetchResultsCollection<Element>>
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
public enum HistoryChange : Sendable {

    public var changedPersistentIdentifier: PersistentIdentifier { get }

    case insert(any HistoryInsert)

    case update(any HistoryUpdate)

    case delete(any HistoryDelete)
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
public protocol HistoryDelete<Model> : Sendable {

    associatedtype Model : PersistentModel

    associatedtype TransactionIdentifier : Comparable, Hashable, Sendable

    associatedtype ChangeIdentifier : Comparable, Hashable, Sendable

    var changeIdentifier: Self.ChangeIdentifier { get }

    var transactionIdentifier: Self.TransactionIdentifier { get }

    var changedPersistentIdentifier: PersistentIdentifier { get }

    var tombstone: HistoryTombstone<Self.Model> { get }
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
public struct HistoryDescriptor<TransactionType> where TransactionType : HistoryTransaction {

    public var predicate: Predicate<TransactionType>?

    public var fetchLimit: UInt64

    @available(macOS 26.0, iOS 26.0, tvOS 26.0, watchOS 26.0, *)
    public var sortBy: [SortDescriptor<TransactionType>]

    public init(predicate: Predicate<TransactionType>? = nil)

    @available(macOS 26.0, iOS 26.0, tvOS 26.0, watchOS 26.0, *)
    public init(predicate: Predicate<TransactionType>? = nil, sortBy: [SortDescriptor<TransactionType>] = [])
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
public protocol HistoryInsert<Model> : Sendable {

    associatedtype Model : PersistentModel

    associatedtype TransactionIdentifier : Comparable, Hashable, Sendable

    associatedtype ChangeIdentifier : Comparable, Hashable, Sendable

    var changeIdentifier: Self.ChangeIdentifier { get }

    var transactionIdentifier: Self.TransactionIdentifier { get }

    var changedPersistentIdentifier: PersistentIdentifier { get }
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
public protocol HistoryProviding {

    associatedtype HistoryType : HistoryTransaction

    static var historyType: Self.HistoryType.Type { get }

    func fetchHistory(_ descriptor: HistoryDescriptor<Self.HistoryType>) throws -> [Self.HistoryType]

    func deleteHistory(_ descriptor: HistoryDescriptor<Self.HistoryType>) throws
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
public protocol HistoryToken : Comparable, Decodable, Encodable, Hashable, Identifiable, Sendable {

    associatedtype TokenType : Decodable, Encodable, Hashable, Sendable

    var tokenValue: Self.TokenType? { get }
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
public struct HistoryTombstone<Model> : Sequence, @unchecked Sendable where Model : PersistentModel {

    /// A type that provides the sequence's iteration interface and
    /// encapsulates its iteration state.
    @available(swift 5.9)
    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
    public struct Iterator : IteratorProtocol {

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
        public mutating func next() -> Any?

        /// The type of element traversed by the iterator.
        @available(swift 5.9)
        @available(iOS 18, tvOS 18, watchOS 11, visionOS 2, macOS 15, *)
        public typealias Element = Any
    }

    public subscript(keyPath: PartialKeyPath<Model>) -> (any Sendable)? { get }

    /// Returns an iterator over the elements of this sequence.
    public func makeIterator() -> HistoryTombstone<Model>.Iterator

    /// A type representing the sequence's elements.
    @available(swift 5.9)
    @available(iOS 18, tvOS 18, watchOS 11, visionOS 2, macOS 15, *)
    public typealias Element = Any
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
public protocol HistoryTransaction : Hashable, Identifiable, Sendable {

    associatedtype TokenType : Comparable, Hashable, Identifiable, Sendable

    associatedtype TransactionIdentifier : Comparable, Hashable, Sendable

    var timestamp: Date { get }

    var changes: [HistoryChange] { get }

    var token: Self.TokenType { get }

    var transactionIdentifier: Self.TransactionIdentifier { get }

    var storeIdentifier: String { get }

    var author: String? { get }
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
public protocol HistoryUpdate<Model> : Sendable {

    associatedtype Model : PersistentModel

    associatedtype TransactionIdentifier : Comparable, Hashable, Sendable

    associatedtype ChangeIdentifier : Comparable, Hashable, Sendable

    typealias PropertyUpdate = PartialKeyPath<Self.Model> & Sendable

    var changeIdentifier: Self.ChangeIdentifier { get }

    var transactionIdentifier: Self.TransactionIdentifier { get }

    var changedPersistentIdentifier: PersistentIdentifier { get }

    var updatedAttributes: [any PartialKeyPath<Self.Model> & Sendable] { get }
}

/// Specifies the indices that the schema should apply for this model.
@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, *)
@freestanding(declaration) public macro Index<T>(_ indices: Schema.Index<T>.Types<T>...) = #externalMacro(module: "SwiftDataMacros", type: "IndexMacro") where T : PersistentModel

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, *)
@freestanding(declaration) public macro Index<T>(_ indices: [PartialKeyPath<T>]...) = #externalMacro(module: "SwiftDataMacros", type: "IndexMacro") where T : PersistentModel

/// Describes a migration between two versions of the same schema.
@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
public enum MigrationStage {

    case lightweight(fromVersion: any VersionedSchema.Type, toVersion: any VersionedSchema.Type)

    case custom(fromVersion: any VersionedSchema.Type, toVersion: any VersionedSchema.Type, willMigrate: ((_ context: ModelContext) throws -> Void)?, didMigrate: ((_ context: ModelContext) throws -> Void)?)
}

/// Converts a Swift class into a stored model that's managed by SwiftData.
@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
@attached(member, conformances: Observable, PersistentModel, Sendable, names: named(_$backingData), named(persistentBackingData), named(schemaMetadata), named(init), named(_$observationRegistrar), named(_SwiftDataNoType), named(access), named(withMutation)) @attached(memberAttribute) @attached(extension, conformances: Observable, PersistentModel, Sendable) public macro Model() = #externalMacro(module: "SwiftDataMacros", type: "PersistentModelMacro")

/// An interface for providing mutually-exclusive access to the attributes of a conforming model.
@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
public protocol ModelActor : Actor {

    /// The ModelContainer for the ModelActor
    /// The container that manages the app’s schema and model storage configuration
    nonisolated var modelContainer: ModelContainer { get }

    /// The executor that coordinates access to the model actor.
    ///
    /// - Important: Don't use the executor to access the model context. Instead, use the
    /// ``modelContext`` property.
    nonisolated var modelExecutor: any ModelExecutor { get }
}

@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
extension ModelActor {

    /// The optimized, unonwned reference to the model actor's executor.
    nonisolated public var unownedExecutor: UnownedSerialExecutor { get }

    /// The context that serializes any code running on the model actor.
    public var modelContext: ModelContext { get }
}

@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
extension ModelActor {

    /// Returns the model for the specified identifier, downcast to the appropriate class.
    public subscript<T>(id: PersistentIdentifier, as as: T.Type) -> T? where T : PersistentModel { get }
}

/// Converts a Swift class into a stored model that's managed by SwiftData.
@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
@attached(member, names: named(modelExecutor), named(modelContainer), named(init)) @attached(extension, conformances: ModelActor) public macro ModelActor() = #externalMacro(module: "SwiftDataMacros", type: "PersistentModelActorMacro")

/// A type that describes the configuration of an app's schema or specific group of models.
@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
public struct ModelConfiguration : Identifiable, Hashable {

    public let url: URL

    public let name: String

    public let groupAppContainerIdentifier: String?

    public let cloudKitContainerIdentifier: String?

    public let groupContainer: ModelConfiguration.GroupContainer

    public let cloudKitDatabase: ModelConfiguration.CloudKitDatabase

    public var schema: Schema?

    public let allowsSave: Bool

    public let isStoredInMemoryOnly: Bool

    /// A type that describes the possible CloudKit discovery approaches.
    @available(swift 5.9)
    @available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
    public struct CloudKitDatabase {

        public static var automatic: ModelConfiguration.CloudKitDatabase { get }

        public static var none: ModelConfiguration.CloudKitDatabase { get }

        public static func `private`(_ privateDBName: String) -> ModelConfiguration.CloudKitDatabase
    }

    /// A type that describes the possible Group Container discovery approaches.
    @available(swift 5.9)
    @available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
    public struct GroupContainer {

        public static var automatic: ModelConfiguration.GroupContainer { get }

        public static var none: ModelConfiguration.GroupContainer { get }

        public static func identifier(_ groupName: String) -> ModelConfiguration.GroupContainer
    }

    public init(isStoredInMemoryOnly: Bool = false)

    public init(for forTypes: any PersistentModel.Type..., isStoredInMemoryOnly: Bool = false)

    public init(_ name: String? = nil, schema: Schema? = nil, isStoredInMemoryOnly: Bool = false, allowsSave: Bool = true, groupContainer: ModelConfiguration.GroupContainer = .automatic, cloudKitDatabase: ModelConfiguration.CloudKitDatabase = .automatic)

    public init(_ name: String? = nil, schema: Schema? = nil, url: URL, allowsSave: Bool = true, cloudKitDatabase: ModelConfiguration.CloudKitDatabase = .automatic)

    /// The stable identity of the entity associated with this instance.
    public var id: URL { get }

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

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: ModelConfiguration, rhs: ModelConfiguration) -> Bool

    /// A type representing the stable identity of the entity associated with
    /// an instance.
    @available(swift 5.9)
    @available(iOS 17, tvOS 17, watchOS 10, macOS 14, *)
    public typealias ID = URL

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

@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
extension ModelConfiguration : CustomDebugStringConvertible {

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

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
extension ModelConfiguration : DataStoreConfiguration {

    public typealias Store = DefaultStore

    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
    public func validate() throws
}

@available(macOS 14, iOS 17, tvOS 17, watchOS 10, visionOS 1, *)
extension ModelConfiguration : Sendable {
}

@available(macOS 14, iOS 17, tvOS 17, watchOS 10, visionOS 1, *)
extension ModelConfiguration.CloudKitDatabase : Sendable {
}

@available(macOS 14, iOS 17, tvOS 17, watchOS 10, visionOS 1, *)
extension ModelConfiguration.GroupContainer : Sendable {
}

/// An object that manages an app's schema and model storage configuration.
@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
public class ModelContainer : Equatable, @unchecked Sendable {

    final public let schema: Schema

    final public let migrationPlan: (any SchemaMigrationPlan.Type)?

    public var configurations: Set<ModelConfiguration>

    @MainActor public var mainContext: ModelContext { get }

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: ModelContainer, rhs: ModelContainer) -> Bool

    public convenience init(for forTypes: any PersistentModel.Type..., migrationPlan: (any SchemaMigrationPlan.Type)? = nil, configurations: ModelConfiguration...) throws

    public convenience init(for givenSchema: Schema, migrationPlan: (any SchemaMigrationPlan.Type)? = nil, configurations: ModelConfiguration...) throws

    public init(for givenSchema: Schema, migrationPlan: (any SchemaMigrationPlan.Type)? = nil, configurations: [ModelConfiguration]) throws

    @available(swift 5.9)
    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
    public convenience init(for forTypes: any PersistentModel.Type..., configurations: any DataStoreConfiguration...) throws

    @available(swift 5.9)
    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
    public init(for givenSchema: Schema, configurations: [any DataStoreConfiguration]) throws

    @objc deinit

    @available(macOS, introduced: 14.0, deprecated: 100000.0, renamed: "erase", message: "deleteAllData has been replaced by `erase`. Use `erase` to completely remove all of the data from a store.")
    @available(iOS, introduced: 17.0, deprecated: 100000.0, renamed: "erase", message: "deleteAllData has been replaced by `erase`. Use `erase` to completely remove all of the data from a store.")
    @available(watchOS, introduced: 10.0, deprecated: 100000.0, renamed: "erase", message: "deleteAllData has been replaced by `erase`. Use `erase` to completely remove all of the data from a store.")
    @available(tvOS, introduced: 17.0, deprecated: 100000.0, renamed: "erase", message: "deleteAllData has been replaced by `erase`. Use `erase` to completely remove all of the data from a store.")
    @available(visionOS, introduced: 1.0, deprecated: 100000.0, renamed: "erase", message: "deleteAllData has been replaced by `erase`. Use `erase` to completely remove all of the data from a store.")
    public func deleteAllData()

    @available(swift 5.9)
    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
    public func erase() throws
}

/// An object that enables you to fetch, insert, and delete models, and save any changes to disk.
@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
public class ModelContext : Equatable, SendableMetatype {

    @available(swift 5.9)
    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
    public var author: String?

    public var undoManager: UndoManager?

    public var insertedModelsArray: [any PersistentModel] { get }

    public var changedModelsArray: [any PersistentModel] { get }

    public var deletedModelsArray: [any PersistentModel] { get }

    @available(swift 5.9)
    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
    public var editingState: EditingState

    public var container: ModelContainer { get }

    public var autosaveEnabled: Bool

    public init(_ container: ModelContainer)

    @objc deinit

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: ModelContext, rhs: ModelContext) -> Bool

    public var hasChanges: Bool { get }

    public func model(for persistentModelID: PersistentIdentifier) -> any PersistentModel

    public func registeredModel<T>(for persistentModelID: PersistentIdentifier) -> T? where T : PersistentModel

    public func insert<T>(_ model: T) where T : PersistentModel

    public func rollback()

    public func processPendingChanges()

    public func delete<T>(model: T.Type, where predicate: Predicate<T>? = nil, includeSubclasses: Bool = true) throws where T : PersistentModel

    public func delete<T>(_ model: T) where T : PersistentModel

    public func transaction(block: () throws -> Void) throws

    public func save() throws

    public func enumerate<T>(_ fetch: FetchDescriptor<T>, batchSize: Int = 5000, allowEscapingMutations: Bool = false, block: (_ model: T) throws -> Void) throws where T : PersistentModel

    public func fetch<T>(_ descriptor: FetchDescriptor<T>) throws -> [T] where T : PersistentModel

    public func fetchCount<T>(_ descriptor: FetchDescriptor<T>) throws -> Int where T : PersistentModel

    public func fetch<T>(_ descriptor: FetchDescriptor<T>, batchSize: Int) throws -> FetchResultsCollection<T> where T : PersistentModel

    public func fetchIdentifiers<T>(_ descriptor: FetchDescriptor<T>) throws -> [PersistentIdentifier] where T : PersistentModel

    public func fetchIdentifiers<T>(_ descriptor: FetchDescriptor<T>, batchSize: Int) throws -> FetchResultsCollection<PersistentIdentifier> where T : PersistentModel

    public static let willSave: Notification.Name

    public static let didSave: Notification.Name

    /// Describes the data in the user info dictionary of a notification sent by a model context.
    public enum NotificationKey : String {

        /// A token that indicates which generation of the model store SwiftData is using.
        case queryGeneration

        /// A set of values identifying the context's invalidated models.
        case invalidatedAllIdentifiers

        /// A set of values identifying the context's inserted models.
        case insertedIdentifiers

        /// A set of values identifying the context's updated models.
        case updatedIdentifiers

        /// A set of values identifying the context's deleted models.
        case deletedIdentifiers

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
        public init?(rawValue: String)

        /// The raw type that can be used to represent all values of the conforming
        /// type.
        ///
        /// Every distinct value of the conforming type has a corresponding unique
        /// value of the `RawValue` type, but there may be values of the `RawValue`
        /// type that don't have a corresponding value of the conforming type.
        @available(swift 5.9)
        @available(iOS 17, tvOS 17, watchOS 10, macOS 14, *)
        public typealias RawValue = String

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
        public var rawValue: String { get }
    }

    @available(swift 5.9)
    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
    public func fetchHistory<T>(_ descriptor: HistoryDescriptor<T>) throws -> [T] where T : HistoryTransaction

    @available(swift 5.9)
    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
    public func deleteHistory<T>(_ descriptor: HistoryDescriptor<T>) throws where T : HistoryTransaction
}

@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
extension ModelContext.NotificationKey : Equatable {
}

@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
extension ModelContext.NotificationKey : Hashable {
}

@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
extension ModelContext.NotificationKey : RawRepresentable {
}

/// An interface for performing storage-related tasks using an isolated model context.
@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
public protocol ModelExecutor : Executor {

    var modelContext: ModelContext { get }
}

/// A type that describes the aggregate identity of a SwiftData model.
///
/// > Note: Decoded ``PersistentIdentifier`` and identifiers created by the ``DefaultStore`` are not considered equivalent.
@available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
public struct PersistentIdentifier : Hashable, Identifiable, Equatable, Comparable, Codable, Sendable {

    /// The value that uniquely identifies the associated model within the containing store.
    public let id: PersistentIdentifier.ID

    /// The entity name for the associated model.
    public var entityName: String { get }

    /// The identifier of the store that contains the associated model.
    public var storeIdentifier: String? { get }

    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: any Decoder) throws

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: PersistentIdentifier, rhs: PersistentIdentifier) -> Bool

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
    public static func < (lhs: PersistentIdentifier, rhs: PersistentIdentifier) -> Bool

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

    /// A type that represents the stable identity of a SwiftData model.
    public struct ID : Hashable, Equatable, Sendable {

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

        /// Returns a Boolean value indicating whether two values are equal.
        ///
        /// Equality is the inverse of inequality. For any values `a` and `b`,
        /// `a == b` implies that `a != b` is `false`.
        ///
        /// - Parameters:
        ///   - lhs: A value to compare.
        ///   - rhs: Another value to compare.
        public static func == (lhs: PersistentIdentifier.ID, rhs: PersistentIdentifier.ID) -> Bool

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

    @available(swift 5.9)
    @available(macOS 15, iOS 18, tvOS 18, watchOS 10, visionOS 2, *)
    public static func identifier<T>(for storeIdentifier: String, entityName: String, primaryKey: T) throws -> PersistentIdentifier where T : Comparable, T : CustomStringConvertible, T : Decodable, T : Encodable, T : Hashable

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

/// An interface that enables SwiftData to manage a Swift class as a stored model.
@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
public protocol PersistentModel : AnyObject, Observable, Hashable, Identifiable, SendableMetatype {

    init(backingData: any BackingData<Self>)

    var persistentBackingData: any BackingData<Self> { get set }

    static var schemaMetadata: [Schema.PropertyMetadata] { get }

    @available(macOS 26.0, iOS 26.0, tvOS 26.0, watchOS 26.0, *)
    associatedtype Root : PersistentModel = Self
}

@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
extension PersistentModel {

    public static func createBackingData<P>() -> some BackingData<P> where P : PersistentModel


    public func getValue<Value>(forKey: KeyPath<Self, Value>) -> Value where Value : Decodable

    public func getValue<Value>(forKey: KeyPath<Self, Value>) -> Value where Value : PersistentModel

    public func getValue<Value>(forKey: KeyPath<Self, Value?>) -> Value? where Value : PersistentModel

    public func getValue<Value, OtherModel>(forKey: KeyPath<Self, Value>) -> Value where Value : RelationshipCollection, OtherModel == Value.PersistentElement

    public func getValue<Value, OtherModel>(forKey: KeyPath<Self, Value>) -> Value where Value : Decodable, Value : RelationshipCollection, OtherModel == Value.PersistentElement

    public func getTransformableValue<Value>(forKey: KeyPath<Self, Value>) -> Value

    public func setValue<Value>(forKey: KeyPath<Self, Value>, to newValue: Value) where Value : Encodable

    public func setValue<Value>(forKey: KeyPath<Self, Value>, to newValue: Value) where Value : PersistentModel

    public func setValue<Value>(forKey: KeyPath<Self, Value?>, to newValue: Value?) where Value : PersistentModel

    public func setValue<Value, OtherModel>(forKey: KeyPath<Self, Value>, to newValue: Value) where Value : RelationshipCollection, OtherModel == Value.PersistentElement

    public func setValue<Value, OtherModel>(forKey: KeyPath<Self, Value>, to newValue: Value) where Value : Encodable, Value : RelationshipCollection, OtherModel == Value.PersistentElement

    public func setTransformableValue<Value>(forKey: KeyPath<Self, Value>, to newValue: Value)

    public var modelContext: ModelContext? { get }

    public var persistentModelID: PersistentIdentifier { get }

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: Self, rhs: Self) -> Bool

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

    public var id: PersistentIdentifier { get }

    public var hasChanges: Bool { get }

    public var isDeleted: Bool { get }
}

/// Specifies the options that SwiftData needs to manage the annotated property as a relationship between
/// two models.
@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
@attached(peer) public macro Relationship(_ options: Schema.Relationship.Option..., deleteRule: Schema.Relationship.DeleteRule = .nullify, minimumModelCount: Int? = 0, maximumModelCount: Int? = 0, originalName: String? = nil, inverse: AnyKeyPath? = nil, hashModifier: String? = nil) = #externalMacro(module: "SwiftDataMacros", type: "RelationshipPropertyMacro")

@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
public protocol RelationshipCollection {

    associatedtype PersistentElement : PersistentModel
}

/// An object that maps model classes to data in the model store, and helps with the migration of that data
/// between releases.
@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
final public class Schema : Codable, Hashable {

    public static let schemaEncodingVersion: Schema.Version

    final public let encodingVersion: Schema.Version

    final public let version: Schema.Version

    final public let entities: [Schema.Entity]

    final public let entitiesByName: [String : Schema.Entity]

    public init()

    public init(_ entities: Schema.Entity..., version: Schema.Version = Version(1, 0, 0))

    @available(macOS 26.0, iOS 26.0, tvOS 26.0, watchOS 26.0, *)
    public convenience init(_ types: any PersistentModel.Type..., version: Schema.Version = Version(1, 0, 0))

    public init(_ types: [any PersistentModel.Type], version: Schema.Version = Version(1, 0, 0))

    public convenience init(versionedSchema: any VersionedSchema.Type)

    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: any Decoder) throws

    /// Encodes this value into the given encoder.
    ///
    /// If the value fails to encode anything, `encoder` will encode an empty
    /// keyed container in its place.
    ///
    /// This function throws an error if any values are invalid for the given
    /// encoder's format.
    ///
    /// - Parameter encoder: The encoder to write data to.
    final public func encode(to encoder: any Encoder) throws

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: Schema, rhs: Schema) -> Bool

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
    final public func hash(into hasher: inout Hasher)

    final public func save(to toURL: URL) throws

    public static func load(from fromURL: URL) throws -> Schema

    @available(swift 5.9)
    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
    final public func entity<T>(for type: T.Type) -> Schema.Entity? where T : PersistentModel

    @available(swift 5.9)
    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
    public static func entityName<T>(for type: T.Type) -> String where T : PersistentModel

    public struct Version : Codable, Comparable, CustomStringConvertible, Hashable {

        /// The major version according to the semantic versioning standard.
        public let major: Int

        /// The minor version according to the semantic versioning standard.
        public let minor: Int

        /// The patch version according to the semantic versioning standard.
        public let patch: Int

        /// Initializes a version struct with the provided components of a semantic version.
        ///
        /// - Parameters:
        ///   - major: The major version number.
        ///   - minor: The minor version number.
        ///   - patch: The patch version number.
        ///
        /// - Precondition: `major >= 0 && minor >= 0 && patch >= 0`.
        public init(_ major: Int, _ minor: Int, _ patch: Int)

        /// Returns a Boolean value indicating whether two values are equal.
        ///
        /// Equality is the inverse of inequality. For any values `a` and `b`, `a ==
        /// b` implies that `a != b` is `false`.
        ///
        /// - Parameters:
        ///   - lhs: A value to compare.
        ///   - rhs: Another value to compare.
        ///
        /// - Returns: A boolean value indicating the result of the equality test.
        @inlinable public static func == (lhs: Schema.Version, rhs: Schema.Version) -> Bool

        /// Returns a Boolean value indicating whether the value of the first
        /// argument is less than that of the second argument.
        ///
        /// The precedence is determined according to rules described in the [Semantic Versioning 2.0.0](https://semver.org) standard, paragraph 11.
        ///
        /// - Parameters:
        ///   - lhs: A value to compare.
        ///   - rhs: Another value to compare.
        public static func < (lhs: Schema.Version, rhs: Schema.Version) -> Bool

        /// A textual description of the version object.
        public var description: String { get }

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

    @available(swift 5.9)
    @available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
    public struct PropertyMetadata {

        public init(name: String, keypath: AnyKeyPath, defaultValue: Any? = nil, metadata: (any SchemaProperty)? = nil)
    }

    @objc deinit

    /// The hash value.
    ///
    /// Hash values are not guaranteed to be equal across different executions of
    /// your program. Do not save hash values to use during a future execution.
    ///
    /// - Important: `hashValue` is deprecated as a `Hashable` requirement. To
    ///   conform to `Hashable`, implement the `hash(into:)` requirement instead.
    ///   The compiler provides an implementation for `hashValue` for you.
    final public var hashValue: Int { get }
}

extension Schema {

    /// An object that describes the configuration and behavior of a specific property of a model class.
    @available(swift 5.9)
    @available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
    public class Attribute : SchemaProperty, CustomDebugStringConvertible {

        public var name: String

        public var originalName: String

        public var options: [Schema.Attribute.Option]

        public var valueType: any Any.Type

        public var defaultValue: Any?

        public var isOptional: Bool

        public var hashModifier: String?

        @available(swift 5.9)
        @available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
        public struct Option {

            /// Ensures the property's value is unique across all models of the same type.
            public static var unique: Schema.Attribute.Option { get }

            /// Transforms the property's value between an in-memory form and a persisted form.
            public static func transformable(by transformerType: ValueTransformer.Type) -> Schema.Attribute.Option

            public static func transformable(by transformerName: String) -> Schema.Attribute.Option

            /// Stores the property's value as binary data adjacent to the model storage.
            public static var externalStorage: Schema.Attribute.Option { get }

            /// Stores the property's value in an encrypted form.
            public static var allowsCloudEncryption: Schema.Attribute.Option { get }

            /// Preserves the property's value in the persistent history when the context deletes the owning model.
            public static var preserveValueOnDeletion: Schema.Attribute.Option { get }

            /// Track changes to this property but do not persist
            public static var ephemeral: Schema.Attribute.Option { get }

            /// Indexes the property's value so it can appear in Spotlight search results.
            public static var spotlight: Schema.Attribute.Option { get }
        }

        public init(_ options: Schema.Attribute.Option..., originalName: String? = nil, hashModifier: String? = nil)

        public init(name: String, originalName: String? = nil, options: [Schema.Attribute.Option] = [], valueType: any Any.Type, defaultValue: Any? = nil, hashModifier: String? = nil)

        /// Creates a new instance by decoding from the given decoder.
        ///
        /// This initializer throws an error if reading from the decoder fails, or
        /// if the data read is corrupted or otherwise invalid.
        ///
        /// - Parameter decoder: The decoder to read data from.
        required public init(from decoder: any Decoder) throws

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

        /// Returns a Boolean value indicating whether two values are equal.
        ///
        /// Equality is the inverse of inequality. For any values `a` and `b`,
        /// `a == b` implies that `a != b` is `false`.
        ///
        /// - Parameters:
        ///   - lhs: A value to compare.
        ///   - rhs: Another value to compare.
        public static func == (lhs: Schema.Attribute, rhs: Schema.Attribute) -> Bool

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

        public var isAttribute: Bool { get }

        public var isRelationship: Bool { get }

        public var isTransient: Bool { get }

        public var isUnique: Bool { get }

        public var isTransformable: Bool { get }

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

        @objc deinit

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

    /// An object that describes an attribute that derives its value by composing other attributes.
    @available(swift 5.9)
    @available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
    final public class CompositeAttribute : Schema.Attribute {

        final public var properties: [Schema.Attribute]

        override public init(name: String, originalName: String? = nil, options: [Schema.Attribute.Option] = [], valueType: any Any.Type, defaultValue: Any? = nil, hashModifier: String? = nil)

        required public init(from decoder: any Decoder) throws

        /// Encodes this value into the given encoder.
        ///
        /// If the value fails to encode anything, `encoder` will encode an empty
        /// keyed container in its place.
        ///
        /// This function throws an error if any values are invalid for the given
        /// encoder's format.
        ///
        /// - Parameter encoder: The encoder to write data to.
        override final public func encode(to encoder: any Encoder) throws

        @available(macOS 26.0, iOS 26.0, tvOS 26.0, watchOS 26.0, *)
        public static func == (lhs: Schema.CompositeAttribute, rhs: Schema.CompositeAttribute) -> Bool

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
        override final public var debugDescription: String { get }

        @objc deinit
    }

    /// An object that describes the configuration and behavior of a relationship between two model classes.
    @available(swift 5.9)
    @available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
    final public class Relationship : SchemaProperty, CustomDebugStringConvertible {

        final public var name: String

        final public var originalName: String

        final public var keypath: AnyKeyPath?

        final public var options: [Schema.Relationship.Option]

        final public var valueType: any Any.Type

        final public var destination: String

        final public var deleteRule: Schema.Relationship.DeleteRule

        final public var inverseName: String?

        final public var inverseKeyPath: AnyKeyPath?

        final public var minimumModelCount: Int?

        final public var maximumModelCount: Int?

        final public var hashModifier: String?

        final public var isToOneRelationship: Bool { get }

        /// Describes the rule to apply when deleting a model containing references to other models.
        @available(swift 5.9)
        @available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
        public enum DeleteRule : String, Codable {

            /// A rule that doesn't make changes to any related models.
            ///
            /// Ensure that you take the appropriate action on any related models when using this delete rule,
            /// such as deleting them or nullifying their references to the deleted model. Otherwise, your data will
            /// be in an inconsistent state and may reference models that don't exist.
            case noAction

            /// A rule that nullifies the related model's reference to the deleted model.
            case nullify

            /// A rule that deletes any related models.
            case cascade

            /// A rule that prevents the deletion of a model because it contains one or more references to other
            /// models.
            case deny

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
            public init?(rawValue: String)

            /// The raw type that can be used to represent all values of the conforming
            /// type.
            ///
            /// Every distinct value of the conforming type has a corresponding unique
            /// value of the `RawValue` type, but there may be values of the `RawValue`
            /// type that don't have a corresponding value of the conforming type.
            @available(swift 5.9)
            @available(iOS 17, tvOS 17, watchOS 10, macOS 14, *)
            public typealias RawValue = String

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
            public var rawValue: String { get }
        }

        @available(swift 5.9)
        @available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
        public struct Option : Codable, Hashable, CustomDebugStringConvertible {

            /// Ensures the property's value is unique across all models of the same type.
            public static var unique: Schema.Relationship.Option { get }

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

            /// Returns a Boolean value indicating whether two values are equal.
            ///
            /// Equality is the inverse of inequality. For any values `a` and `b`,
            /// `a == b` implies that `a != b` is `false`.
            ///
            /// - Parameters:
            ///   - lhs: A value to compare.
            ///   - rhs: Another value to compare.
            public static func == (a: Schema.Relationship.Option, b: Schema.Relationship.Option) -> Bool

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

        public init(_ options: Schema.Relationship.Option..., deleteRule: Schema.Relationship.DeleteRule = .nullify, minimumModelCount: Int? = 0, maximumModelCount: Int? = 0, originalName: String? = nil, inverse: AnyKeyPath? = nil, hashModifier: String? = nil)

        /// Creates a new instance by decoding from the given decoder.
        ///
        /// This initializer throws an error if reading from the decoder fails, or
        /// if the data read is corrupted or otherwise invalid.
        ///
        /// - Parameter decoder: The decoder to read data from.
        public init(from decoder: any Decoder) throws

        /// Encodes this value into the given encoder.
        ///
        /// If the value fails to encode anything, `encoder` will encode an empty
        /// keyed container in its place.
        ///
        /// This function throws an error if any values are invalid for the given
        /// encoder's format.
        ///
        /// - Parameter encoder: The encoder to write data to.
        final public func encode(to encoder: any Encoder) throws

        final public var isUnique: Bool { get }

        final public var isAttribute: Bool { get }

        final public var isTransient: Bool { get }

        /// Returns a Boolean value indicating whether two values are equal.
        ///
        /// Equality is the inverse of inequality. For any values `a` and `b`,
        /// `a == b` implies that `a != b` is `false`.
        ///
        /// - Parameters:
        ///   - lhs: A value to compare.
        ///   - rhs: Another value to compare.
        public static func == (lhs: Schema.Relationship, rhs: Schema.Relationship) -> Bool

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
        final public func hash(into hasher: inout Hasher)

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
        final public var debugDescription: String { get }

        @objc deinit

        /// The hash value.
        ///
        /// Hash values are not guaranteed to be equal across different executions of
        /// your program. Do not save hash values to use during a future execution.
        ///
        /// - Important: `hashValue` is deprecated as a `Hashable` requirement. To
        ///   conform to `Hashable`, implement the `hash(into:)` requirement instead.
        ///   The compiler provides an implementation for `hashValue` for you.
        final public var hashValue: Int { get }
    }

    @available(swift 5.9)
    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, *)
    final public class Index<T> : SchemaProperty, CustomDebugStringConvertible, Hashable, Codable where T : PersistentModel {

        public enum Types<P> where P : PersistentModel {

            case binary([PartialKeyPath<P>])

            case rtree([PartialKeyPath<P>])
        }

        final public var name: String

        final public var originalName: String

        final public var valueType: any Any.Type

        final public var isUnique: Bool { get }

        /// Returns a Boolean value indicating whether two values are equal.
        ///
        /// Equality is the inverse of inequality. For any values `a` and `b`,
        /// `a == b` implies that `a != b` is `false`.
        ///
        /// - Parameters:
        ///   - lhs: A value to compare.
        ///   - rhs: Another value to compare.
        public static func == (lhs: Schema.Index<T>, rhs: Schema.Index<T>) -> Bool

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
        final public func hash(into hasher: inout Hasher)

        final public let indices: [Schema.Index<T>.Types<T>]

        public init(_ indices: Schema.Index<T>.Types<T>...)

        public init(_ binaryIndices: [PartialKeyPath<T>]...)

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
        final public var debugDescription: String { get }

        public enum CodingKeys : CodingKey {

            case indices

            /// Creates a new instance from the given string.
            ///
            /// If the string passed as `stringValue` does not correspond to any instance
            /// of this type, the result is `nil`.
            ///
            /// - parameter stringValue: The string value of the desired key.
            public init?(stringValue: String)

            /// Creates a new instance from the specified integer.
            ///
            /// If the value passed as `intValue` does not correspond to any instance of
            /// this type, the result is `nil`.
            ///
            /// - parameter intValue: The integer value of the desired key.
            public init?(intValue: Int)

            /// Returns a Boolean value indicating whether two values are equal.
            ///
            /// Equality is the inverse of inequality. For any values `a` and `b`,
            /// `a == b` implies that `a != b` is `false`.
            ///
            /// - Parameters:
            ///   - lhs: A value to compare.
            ///   - rhs: Another value to compare.
            public static func == (a: Schema.Index<T>.CodingKeys, b: Schema.Index<T>.CodingKeys) -> Bool

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

            /// The value to use in an integer-indexed collection (e.g. an int-keyed
            /// dictionary).
            public var intValue: Int? { get }

            /// The string to use in a named collection (e.g. a string-keyed dictionary).
            public var stringValue: String { get }
        }

        /// Encodes this value into the given encoder.
        ///
        /// If the value fails to encode anything, `encoder` will encode an empty
        /// keyed container in its place.
        ///
        /// This function throws an error if any values are invalid for the given
        /// encoder's format.
        ///
        /// - Parameter encoder: The encoder to write data to.
        final public func encode(to encoder: any Encoder) throws

        /// Creates a new instance by decoding from the given decoder.
        ///
        /// This initializer throws an error if reading from the decoder fails, or
        /// if the data read is corrupted or otherwise invalid.
        ///
        /// - Parameter decoder: The decoder to read data from.
        public init(from decoder: any Decoder) throws

        @objc deinit

        /// The hash value.
        ///
        /// Hash values are not guaranteed to be equal across different executions of
        /// your program. Do not save hash values to use during a future execution.
        ///
        /// - Important: `hashValue` is deprecated as a `Hashable` requirement. To
        ///   conform to `Hashable`, implement the `hash(into:)` requirement instead.
        ///   The compiler provides an implementation for `hashValue` for you.
        final public var hashValue: Int { get }
    }

    @available(swift 5.9)
    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, *)
    final public class Unique<T> : SchemaProperty, CustomDebugStringConvertible, Hashable, Codable where T : PersistentModel {

        final public var name: String

        final public var originalName: String

        final public var valueType: any Any.Type

        final public var isUnique: Bool { get }

        /// Returns a Boolean value indicating whether two values are equal.
        ///
        /// Equality is the inverse of inequality. For any values `a` and `b`,
        /// `a == b` implies that `a != b` is `false`.
        ///
        /// - Parameters:
        ///   - lhs: A value to compare.
        ///   - rhs: Another value to compare.
        public static func == (lhs: Schema.Unique<T>, rhs: Schema.Unique<T>) -> Bool

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
        final public func hash(into hasher: inout Hasher)

        final public let constraints: [[PartialKeyPath<T>]]

        public init(_ constraints: [PartialKeyPath<T>]...)

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
        final public var debugDescription: String { get }

        public enum CodingKeys : CodingKey {

            case constraints

            /// Creates a new instance from the given string.
            ///
            /// If the string passed as `stringValue` does not correspond to any instance
            /// of this type, the result is `nil`.
            ///
            /// - parameter stringValue: The string value of the desired key.
            public init?(stringValue: String)

            /// Creates a new instance from the specified integer.
            ///
            /// If the value passed as `intValue` does not correspond to any instance of
            /// this type, the result is `nil`.
            ///
            /// - parameter intValue: The integer value of the desired key.
            public init?(intValue: Int)

            /// Returns a Boolean value indicating whether two values are equal.
            ///
            /// Equality is the inverse of inequality. For any values `a` and `b`,
            /// `a == b` implies that `a != b` is `false`.
            ///
            /// - Parameters:
            ///   - lhs: A value to compare.
            ///   - rhs: Another value to compare.
            public static func == (a: Schema.Unique<T>.CodingKeys, b: Schema.Unique<T>.CodingKeys) -> Bool

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

            /// The value to use in an integer-indexed collection (e.g. an int-keyed
            /// dictionary).
            public var intValue: Int? { get }

            /// The string to use in a named collection (e.g. a string-keyed dictionary).
            public var stringValue: String { get }
        }

        /// Encodes this value into the given encoder.
        ///
        /// If the value fails to encode anything, `encoder` will encode an empty
        /// keyed container in its place.
        ///
        /// This function throws an error if any values are invalid for the given
        /// encoder's format.
        ///
        /// - Parameter encoder: The encoder to write data to.
        final public func encode(to encoder: any Encoder) throws

        /// Creates a new instance by decoding from the given decoder.
        ///
        /// This initializer throws an error if reading from the decoder fails, or
        /// if the data read is corrupted or otherwise invalid.
        ///
        /// - Parameter decoder: The decoder to read data from.
        public init(from decoder: any Decoder) throws

        @objc deinit

        /// The hash value.
        ///
        /// Hash values are not guaranteed to be equal across different executions of
        /// your program. Do not save hash values to use during a future execution.
        ///
        /// - Important: `hashValue` is deprecated as a `Hashable` requirement. To
        ///   conform to `Hashable`, implement the `hash(into:)` requirement instead.
        ///   The compiler provides an implementation for `hashValue` for you.
        final public var hashValue: Int { get }
    }
}

@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
extension Schema : CustomDebugStringConvertible {

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
    final public var debugDescription: String { get }
}

@available(macOS 14, iOS 17, tvOS 17, watchOS 10, visionOS 1, *)
extension Schema : Sendable {
}

extension Schema {

    /// An object that provides a blueprint for the associated model class.
    @available(swift 5.9)
    @available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
    final public class Entity : Codable, Hashable, CustomDebugStringConvertible {

        final public var name: String

        final public var subentities: Set<Schema.Entity>

        final public var superentityName: String?

        final public var superentity: Schema.Entity?

        final public var storedProperties: [any SchemaProperty]

        final public var inheritedProperties: [any SchemaProperty]

        final public var properties: [any SchemaProperty] { get }

        final public var attributes: Set<Schema.Attribute>

        final public var relationships: Set<Schema.Relationship>

        final public var attributesByName: [String : Schema.Attribute]

        final public var relationshipsByName: [String : Schema.Relationship]

        final public var storedPropertiesByName: [String : any SchemaProperty]

        final public var inheritedPropertiesByName: [String : any SchemaProperty]

        final public var uniquenessConstraints: [[String]]

        @available(swift 5.9)
        @available(macOS 15, iOS 18, tvOS 18, watchOS 11, *)
        final public var indices: [[String]]

        public init(_ name: String)

        public init(_ name: String, subentities: Schema.Entity..., properties: any SchemaProperty...)

        public init(_ name: String, properties: any SchemaProperty...)

        /// Creates a new instance by decoding from the given decoder.
        ///
        /// This initializer throws an error if reading from the decoder fails, or
        /// if the data read is corrupted or otherwise invalid.
        ///
        /// - Parameter decoder: The decoder to read data from.
        public init(from decoder: any Decoder) throws

        /// Encodes this value into the given encoder.
        ///
        /// If the value fails to encode anything, `encoder` will encode an empty
        /// keyed container in its place.
        ///
        /// This function throws an error if any values are invalid for the given
        /// encoder's format.
        ///
        /// - Parameter encoder: The encoder to write data to.
        final public func encode(to encoder: any Encoder) throws

        /// Returns a Boolean value indicating whether two values are equal.
        ///
        /// Equality is the inverse of inequality. For any values `a` and `b`,
        /// `a == b` implies that `a != b` is `false`.
        ///
        /// - Parameters:
        ///   - lhs: A value to compare.
        ///   - rhs: Another value to compare.
        public static func == (lhs: Schema.Entity, rhs: Schema.Entity) -> Bool

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
        final public func hash(into hasher: inout Hasher)

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
        final public var debugDescription: String { get }

        @objc deinit

        /// The hash value.
        ///
        /// Hash values are not guaranteed to be equal across different executions of
        /// your program. Do not save hash values to use during a future execution.
        ///
        /// - Important: `hashValue` is deprecated as a `Hashable` requirement. To
        ///   conform to `Hashable`, implement the `hash(into:)` requirement instead.
        ///   The compiler provides an implementation for `hashValue` for you.
        final public var hashValue: Int { get }
    }
}

@available(macOS 14, iOS 17, tvOS 17, watchOS 10, visionOS 1, *)
extension Schema.Version : Sendable {
}

@available(macOS 14, iOS 17, tvOS 17, watchOS 10, visionOS 1, *)
extension Schema.Attribute : @unchecked Sendable {
}

@available(macOS 14, iOS 17, tvOS 17, watchOS 10, visionOS 1, *)
extension Schema.CompositeAttribute : @unchecked Sendable {
}

@available(macOS 14, iOS 17, tvOS 17, watchOS 10, visionOS 1, *)
extension Schema.Relationship : @unchecked Sendable {
}

@available(macOS 14, iOS 17, tvOS 17, watchOS 10, visionOS 1, *)
extension Schema.Entity : @unchecked Sendable {
}

@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
extension Schema.Attribute.Option : Codable {

    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: any Decoder) throws

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
}

@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
extension Schema.Attribute.Option : Hashable {

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: Schema.Attribute.Option, rhs: Schema.Attribute.Option) -> Bool

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

@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
extension Schema.Attribute.Option : CustomDebugStringConvertible {

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

@available(macOS 14, iOS 17, tvOS 17, watchOS 10, visionOS 1, *)
extension Schema.Attribute.Option : Sendable {
}

@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
extension Schema.Relationship.DeleteRule : Equatable {
}

@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
extension Schema.Relationship.DeleteRule : Hashable {
}

@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
extension Schema.Relationship.DeleteRule : RawRepresentable {
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, *)
extension Schema.Index.CodingKeys : Equatable {
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, *)
extension Schema.Index.CodingKeys : Hashable {
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, *)
extension Schema.Unique.CodingKeys : Equatable {
}

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, *)
extension Schema.Unique.CodingKeys : Hashable {
}

/// An interface for describing the evolution of a schema and how to migrate between specific versions.
@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
public protocol SchemaMigrationPlan {

    static var schemas: [any VersionedSchema.Type] { get }

    static var stages: [MigrationStage] { get }
}

/// An interface for describing a property.
@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
public protocol SchemaProperty : Decodable, Encodable, Hashable {

    var name: String { get set }

    var originalName: String { get set }

    var valueType: any Any.Type { get set }

    var isAttribute: Bool { get }

    var isRelationship: Bool { get }

    var isTransient: Bool { get }

    var isOptional: Bool { get }

    var isUnique: Bool { get }
}

@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
extension SchemaProperty {

    public var isAttribute: Bool { get }

    public var isRelationship: Bool { get }

    public var isTransient: Bool { get }

    public var isOptional: Bool { get }
}

/// An interface for performing serial storage-related tasks using an isolated model context.
@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
public protocol SerialModelExecutor : ModelExecutor, SerialExecutor {
}

/// A type that describes a SwiftData error.
@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
public struct SwiftDataError : Error, Hashable {

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: SwiftDataError, rhs: SwiftDataError) -> Bool

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

    public static let includePendingChangesWithBatchSize: SwiftDataError

    public static let unsupportedPredicate: SwiftDataError

    public static let unsupportedKeyPath: SwiftDataError

    public static let sortingPendingChangesWithIdentifiers: SwiftDataError

    public static let unsupportedSortDescriptor: SwiftDataError

    public static let duplicateConfiguration: SwiftDataError

    public static let configurationFileNameTooLong: SwiftDataError

    public static let configurationFileNameContainsInvalidCharacters: SwiftDataError

    public static let configurationSchemaNotFoundInContainerSchema: SwiftDataError

    public static let loadIssueModelContainer: SwiftDataError

    public static let modelValidationFailure: SwiftDataError

    public static let missingModelContext: SwiftDataError

    public static let backwardMigration: SwiftDataError

    public static let unknownSchema: SwiftDataError

    @available(swift 5.9)
    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
    public static let historyTokenExpired: SwiftDataError

    @available(swift 5.9)
    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
    public static let invalidTransactionFetchRequest: SwiftDataError

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

@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
extension SwiftDataError {

    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
    public static func ~= (lhs: SwiftDataError, rhs: any Error) -> Bool
}

/// Tells SwiftData not to persist the annotated property when managing the owning class.
@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
@attached(peer) public macro Transient() = #externalMacro(module: "SwiftDataMacros", type: "TransientPropertyMacro")

/// Specifies the key-paths that SwiftData uses to enforce the uniqueness of model instances.
///
/// If a model class contains attributes that you require to be unique across all persisted instances of that
/// model, add the `Unique` macro to that model's definition. You can specify a constraint on a single
/// attribute, a compound constraint across multiple attributes, or any combination of the two.
///
/// > Important: For relationship attributes, SwiftData only supports unique constraints on those that
/// reference a single persistent model, rather than an array of persistent models.
///
/// The following example declares that every instance of `Person` has a unique `id`, and that no
/// two instances of `Person` have the same `givenName` and `familyName`:
///
/// ```swift
/// @Model
/// final class Person {
///    // Declare any unique constraints as part of the model definition.
///    #Unique<Person>([\.id], [\.givenName, \.familyName])
///
///    var id: UUID
///    var givenName: String
///    var familyName: String
///
///    init(id: UUID, givenName: String, familyName: String) {
///        self.id = id
///        self.givenName = givenName
///        self.familyName = familyName
///    }
/// }
/// ```
///
/// - Parameters:
///     - constraints: Arrays of model key-paths that form the unique constraints to apply to the enclosing
///     model.
///
@available(swift 5.9)
@available(macOS 15, iOS 18, tvOS 18, watchOS 11, *)
@freestanding(declaration) public macro Unique<T>(_ constraints: [PartialKeyPath<T>]...) = #externalMacro(module: "SwiftDataMacros", type: "UniqueConstraintsMacro") where T : PersistentModel

/// An interface for describing a specific version of a schema, including the models it contains.
@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
public protocol VersionedSchema {

    /// The models to include in this version of the schema.
    static var models: [any PersistentModel.Type] { get }

    /// The textual description of the migration’s version or purpose.
    static var versionIdentifier: Schema.Version { get }
}

@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
extension Array : RelationshipCollection where Element : PersistentModel {

    public typealias PersistentElement = Element
}

@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
extension Optional : RelationshipCollection where Wrapped : Sequence, Wrapped.Element : PersistentModel {

    public typealias PersistentElement = Wrapped.Element
}


// MARK: - CoreData Additions

import CoreData

// Available when CoreData is imported with SwiftData
@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
extension NSManagedObjectModel {

    @available(macOS, introduced: 14.0, deprecated: 26.0, message: "Utilize static `makeManagedObjectModel` instead")
    @available(iOS, introduced: 17.0, deprecated: 26.0, message: "Utilize static `makeManagedObjectModel` instead")
    @available(tvOS, introduced: 17.0, deprecated: 26.0, message: "Utilize static `makeManagedObjectModel` instead")
    @available(watchOS, introduced: 10.0, deprecated: 26.0, message: "Utilize static `makeManagedObjectModel` instead")
    @available(visionOS, introduced: 1.0, deprecated: 26.0, message: "Utilize static `makeManagedObjectModel` instead")
    @available(*, deprecated, message: "Utilize static `makeManagedObjectModel` instead")
    public func makeManagedObjectModel(for schema: Schema, mergedWith managedObjectModel: NSManagedObjectModel? = nil) -> NSManagedObjectModel?

    public static func makeManagedObjectModel(for entityTypes: [any PersistentModel.Type], mergedWith managedObjectModel: NSManagedObjectModel? = nil) -> NSManagedObjectModel?

    @available(macOS 26.0, iOS 26.0, tvOS 26.0, watchOS 26.0, *)
    public static func makeManagedObjectModel(for entityTypes: any PersistentModel.Type..., mergedWith managedObjectModel: NSManagedObjectModel? = nil) -> NSManagedObjectModel?

    @available(macOS 26.0, iOS 26.0, tvOS 26.0, watchOS 26.0, *)
    public static func makeManagedObjectModel(for schema: Schema, mergedWith managedObjectModel: NSManagedObjectModel? = nil) -> NSManagedObjectModel?
}


// MARK: - SwiftUI Additions

import SwiftUI
import UniformTypeIdentifiers

// Available when SwiftUI is imported with SwiftData
/// A document type that uses SwiftData to manage its storage.
///
/// - Important: Don't create instances of this type. Instead, use one of the initializers on
/// <doc://com.apple.documentation/documentation/SwiftUI/DocumentGroup>.
@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct ModelDocument {
}

// Available when SwiftUI is imported with SwiftData
/// A property wrapper that fetches a set of models and keeps those models in sync with the underlying
/// data.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@MainActor @preconcurrency public struct Query<Element, Result> : DynamicProperty where Element : PersistentModel {

    /// Current model context `Query` interacts with.
    ///
    /// Access this value from `Query` property wrapper's stored property:
    ///
    ///     struct RecipeList: View {
    ///         @Query var recipes: [Recipe]
    ///         var body: some View {
    ///             ChangesIndicator(
    ///                 hasChanges: _recipes.modelContext.hasChanges)
    ///         }
    ///     }
    ///
    /// Only access this property within of a view's `body` property, otherwise
    /// its value may be invalid.
    @MainActor @preconcurrency public var modelContext: ModelContext { get }

    /// An error encountered during the most recent attempt to fetch data.
    ///
    /// This value is `nil` unless an fetch attempt failed. It contains the
    /// latest error from SwiftData. Access it from Query's stored property:
    ///
    ///     struct RecipeList: View {
    ///         @Query var recipes: [Recipe]
    ///         var body: some View {
    ///             ErrorIndicatorView(_recipes.fetchError)
    ///         }
    ///     }
    ///
    /// > Note: Only access this property within of a view's `body` property,
    /// otherwise its value may be invalid.
    ///
    /// > Note: When an fetch error occurs, `wrappedValue` retains results from
    /// the last successful fetch. Its value will update once a new fetch
    /// succeeds.
    @MainActor @preconcurrency public var fetchError: (any Error)? { get }

    /// The most recent fetched result from the Query.
    ///
    /// > Note: When an fetch error occurs, `wrappedValue` retains results from
    /// the last successful fetch. Its value will update once a new fetch
    /// succeeds.
    @MainActor @preconcurrency public var wrappedValue: Result { get }

    /// Updates the underlying value of the stored value.
    ///
    /// SwiftUI calls this function before rendering a view's
    /// ``View/body-swift.property`` to ensure the view has the most recent
    /// value.
    nonisolated public func update()

    /// Creates a query with a predicate, a key path to a property for sorting,
    /// and the order to sort by.
    ///
    /// Use `Query` within a view by wrapping the variable for the query's
    /// result:
    ///
    ///     struct RecipeList: View {
    ///         // Recipes sorted by date of creation
    ///         @Query(sort: \.dateCreated)
    ///         var favoriteRecipes: [Recipe]
    ///
    ///         var body: some View {
    ///             List(favoriteRecipes) { RecipeDetails($0) }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - filter: A predicate on `Element`
    ///   - sort: Key path to property used for sorting.
    ///   - order: Whether to sort in forward or reverse order.
    ///   - animation: The animation to use for user interface changes that
    ///                result from changes to the fetched results.
    @MainActor @preconcurrency public init<Value>(filter: Predicate<Element>? = nil, sort keyPath: KeyPath<Element, Value>, order: SortOrder = .forward, animation: Animation) where Result == [Element], Value : Comparable

    /// Creates a query with a predicate, a key path to a property for sorting,
    /// and the order to sort by.
    ///
    /// Use `Query` within a view by wrapping the variable for the query's
    /// result:
    ///
    ///     struct RecipeList: View {
    ///         // Recipes sorted by date of creation
    ///         @Query(sort: \.dateCreated)
    ///         var favoriteRecipes: [Recipe]
    ///
    ///         var body: some View {
    ///             List(favoriteRecipes) { RecipeDetails($0) }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - filter: A predicate on `Element`
    ///   - sort: Key path to property used for sorting.
    ///   - order: Whether to sort in forward or reverse order.
    ///   - animation: The animation to use for user interface changes that
    ///                result from changes to the fetched results.
    @MainActor @preconcurrency public init<Value>(filter: Predicate<Element>? = nil, sort keyPath: KeyPath<Element, Value?>, order: SortOrder = .forward, animation: Animation) where Result == [Element], Value : Comparable

    /// Create a query with a predicate, a key path to a property for sorting,
    /// and the order to sort by.
    ///
    /// Use `Query` within a view by wrapping the variable for the query's
    /// result:
    ///
    ///     struct RecipeList: View {
    ///         // Recipes sorted by date of creation
    ///         @Query(sort: \.dateCreated)
    ///         var favoriteRecipes: [Recipe]
    ///
    ///         var body: some View {
    ///             List(favoriteRecipes) { RecipeDetails($0) }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - filter: A predicate on `Element`
    ///   - sort: Key path to property used for sorting.
    ///   - order: Whether to sort in forward or reverse order.
    ///   - transaction: A transaction to use for user interface changes that
    ///                  result from changes to the fetched results.
    @MainActor @preconcurrency public init<Value>(filter: Predicate<Element>? = nil, sort keyPath: KeyPath<Element, Value>, order: SortOrder = .forward, transaction: Transaction? = nil) where Result == [Element], Value : Comparable

    /// Create a query with a predicate, a key path to a property for sorting,
    /// and the order to sort by.
    ///
    /// Use `Query` within a view by wrapping the variable for the query's
    /// result:
    ///
    ///     struct RecipeList: View {
    ///         // Recipes sorted by date of creation
    ///         @Query(sort: \.dateCreated)
    ///         var favoriteRecipes: [Recipe]
    ///
    ///         var body: some View {
    ///             List(favoriteRecipes) { RecipeDetails($0) }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - filter: A predicate on `Element`
    ///   - sort: Key path to property used for sorting.
    ///   - order: Whether to sort in forward or reverse order.
    ///   - transaction: A transaction to use for user interface changes that
    ///                  result from changes to the fetched results.
    @MainActor @preconcurrency public init<Value>(filter: Predicate<Element>? = nil, sort keyPath: KeyPath<Element, Value?>, order: SortOrder = .forward, transaction: Transaction? = nil) where Result == [Element], Value : Comparable

    /// Create a query with a predicate, and a list of sort descriptors.
    ///
    /// Use `Query` within a view by wrapping the variable for the query's
    /// result:
    ///
    ///     struct RecipeList: View {
    ///         // Favorite recipes sorted by date of creation
    ///         @Query(
    ///             filter: #Predicate { $0.isFavorite == true },
    ///             sort: [SortDescriptor(\.dateCreated)]
    ///         )
    ///         var favoriteRecipes: [Recipe]
    ///
    ///         var body: some View {
    ///             List(favoriteRecipes) { RecipeDetails($0) }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - filter: A predicate on `Element`
    ///   - descriptors: Sort orders for the result.
    ///   - animation: The animation to use for user interface changes that
    ///                result from changes to the fetched results.
    @MainActor @preconcurrency public init(filter: Predicate<Element>? = nil, sort descriptors: [SortDescriptor<Element>] = [], animation: Animation) where Result == [Element]

    /// Create a query with a predicate, and a list of sort descriptors.
    ///
    /// Use `Query` within a view by wrapping the variable for the query's
    /// result:
    ///
    ///     struct RecipeList: View {
    ///         // Favorite recipes sorted by date of creation
    ///         @Query(
    ///             filter: #Predicate { $0.isFavorite == true },
    ///             sort: [SortDescriptor(\.dateCreated)]
    ///         )
    ///         var favoriteRecipes: [Recipe]
    ///
    ///         var body: some View {
    ///             List(favoriteRecipes) { RecipeDetails($0) }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - filter: A predicate on `Element`
    ///   - descriptors: Sort orders for the result.
    ///   - transaction: A transaction to use for user interface changes that
    ///                  result from changes to the fetched results.
    @MainActor @preconcurrency public init(filter: Predicate<Element>? = nil, sort descriptors: [SortDescriptor<Element>] = [], transaction: Transaction? = nil) where Result == [Element]

    /// Create a query with a SwiftData fetch descriptor.
    ///
    /// - Parameters:
    ///   - descriptor: a `SwiftData.FetchDescriptor`.
    ///   - transaction: A transaction to use for user interface changes that
    ///                  result from changes to the fetched results.
    @MainActor @preconcurrency public init(_ descriptor: FetchDescriptor<Element>, transaction: Transaction? = nil) where Result == [Element]

    /// Create a query with a SwiftData fetch descriptor.
    ///
    /// - Parameters:
    ///   - descriptor: a `SwiftData.FetchDescriptor`.
    ///   - animation: The animation to use for user interface changes that
    ///                result from changes to the fetched results.
    @MainActor @preconcurrency public init(_ descriptor: FetchDescriptor<Element>, animation: Animation) where Result == [Element]
}

// Available when SwiftUI is imported with SwiftData
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Query : Sendable {
}

// Available when SwiftUI is imported with SwiftData
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@attached(accessor) @attached(peer, names: prefixed(`_`)) public macro Query<Value, Element>(filter: Predicate<Element>? = nil, sort keyPath: KeyPath<Element, Value?>, order: SortOrder = .forward, transaction: Transaction? = nil) = #externalMacro(module: "SwiftDataMacros", type: "QueryMacro") where Value : Comparable, Element : PersistentModel

// Available when SwiftUI is imported with SwiftData
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@attached(accessor) @attached(peer, names: prefixed(`_`)) public macro Query(transaction: Transaction) = #externalMacro(module: "SwiftDataMacros", type: "QueryMacro")

// Available when SwiftUI is imported with SwiftData
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@attached(accessor) @attached(peer, names: prefixed(`_`)) public macro Query(animation: Animation) = #externalMacro(module: "SwiftDataMacros", type: "QueryMacro")

// Available when SwiftUI is imported with SwiftData
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@attached(accessor) @attached(peer, names: prefixed(`_`)) public macro Query<Element>(_ descriptor: FetchDescriptor<Element>, animation: Animation) = #externalMacro(module: "SwiftDataMacros", type: "QueryMacro") where Element : PersistentModel

// Available when SwiftUI is imported with SwiftData
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@attached(accessor) @attached(peer, names: prefixed(`_`)) public macro Query<Element>(_ descriptor: FetchDescriptor<Element>, transaction: Transaction? = nil) = #externalMacro(module: "SwiftDataMacros", type: "QueryMacro") where Element : PersistentModel

// Available when SwiftUI is imported with SwiftData
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@attached(accessor) @attached(peer, names: prefixed(`_`)) public macro Query<Element>(filter: Predicate<Element>? = nil, sort descriptors: [SortDescriptor<Element>] = [], transaction: Transaction? = nil) = #externalMacro(module: "SwiftDataMacros", type: "QueryMacro") where Element : PersistentModel

// Available when SwiftUI is imported with SwiftData
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@attached(accessor) @attached(peer, names: prefixed(`_`)) public macro Query<Value, Element>(filter: Predicate<Element>? = nil, sort keyPath: KeyPath<Element, Value?>, order: SortOrder = .forward, animation: Animation) = #externalMacro(module: "SwiftDataMacros", type: "QueryMacro") where Value : Comparable, Element : PersistentModel

// Available when SwiftUI is imported with SwiftData
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@attached(accessor) @attached(peer, names: prefixed(`_`)) public macro Query<Value, Element>(filter: Predicate<Element>? = nil, sort keyPath: KeyPath<Element, Value>, order: SortOrder = .forward, animation: Animation) = #externalMacro(module: "SwiftDataMacros", type: "QueryMacro") where Value : Comparable, Element : PersistentModel

// Available when SwiftUI is imported with SwiftData
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@attached(accessor) @attached(peer, names: prefixed(`_`)) public macro Query<Element>(filter: Predicate<Element>? = nil, sort descriptors: [SortDescriptor<Element>] = [], animation: Animation) = #externalMacro(module: "SwiftDataMacros", type: "QueryMacro") where Element : PersistentModel

// Available when SwiftUI is imported with SwiftData
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@attached(accessor) @attached(peer, names: prefixed(`_`)) public macro Query() = #externalMacro(module: "SwiftDataMacros", type: "QueryMacro")

// Available when SwiftUI is imported with SwiftData
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@attached(accessor) @attached(peer, names: prefixed(`_`)) public macro Query<Value, Element>(filter: Predicate<Element>? = nil, sort keyPath: KeyPath<Element, Value>, order: SortOrder = .forward, transaction: Transaction? = nil) = #externalMacro(module: "SwiftDataMacros", type: "QueryMacro") where Value : Comparable, Element : PersistentModel

// Available when SwiftUI is imported with SwiftData
extension EnvironmentValues {

    /// The SwiftData model context that will be used for queries and other
    /// model operations within this environment.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public var modelContext: ModelContext
}

// Available when SwiftUI is imported with SwiftData
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Scene {

    /// Sets the model context in this scene's environment.
    ///
    /// In this example, `RecipesApp` sets a shared model context to use for
    /// all of its windows:
    ///
    ///     @Model class Recipe { ... }
    ///
    ///     @main
    ///     struct RecipesApp: App {
    ///         var body: some Scene {
    ///             WindowGroup {
    ///                 RecipesList()
    ///             }
    ///             .modelContext(myContext)
    ///         }
    ///     }
    ///
    /// The environment's ``EnvironmentValues/modelContext`` property will be
    /// assigned a `myContext`. All implicit model context operations in this
    /// scene, such as `Query` properties, will use the environment's context.
    ///
    /// - Parameters:
    ///   - modelContext: The model context to set in this scene's environment.
    @MainActor @preconcurrency public func modelContext(_ modelContext: ModelContext) -> some Scene

}

// Available when SwiftUI is imported with SwiftData
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension View {

    /// Sets the model context in this view's environment.
    ///
    /// In this example, the `RecipesList` view sets a model context to use
    /// for all of its content:
    ///
    ///     @Model class Recipe { ... }
    ///     ...
    ///     RecipesList()
    ///         .modelContext(myContext)
    ///
    /// The environment's ``EnvironmentValues/modelContext`` property will be
    /// assigned `myContext`. All implicit model context operations in this
    /// view, such as `Query` properties, will use the environment's context.
    ///
    /// - Parameters:
    ///   - modelContext: The model context to set in this view's environment.
    @MainActor @preconcurrency public func modelContext(_ modelContext: ModelContext) -> some View

}

// Available when SwiftUI is imported with SwiftData
extension SceneStorage {

    /// Creates a property that can save and restore a ``PersistentIdentifier``.
    ///
    ///     @Model class Recipe { ... }
    ///     struct RecipeList: View {
    ///         @Query var recipes: [Recipe]
    ///         @SceneStorage("selectedID")
    ///         var selectedRecipeID: Recipe.ID = RecipeStore.recipes[0].id
    ///
    ///         var body: some View {
    ///             List(recipes, selection: $selectedRecipeID) { recipe in
    ///                 RecipeDetail(recipe)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value when there is no saved value for
    ///   the given key.
    ///   - key: a key used to save and restore the value.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public init(wrappedValue: Value, _ key: String) where Value == PersistentIdentifier

    /// Creates a property that can read and write an Optional data user
    /// default via ``PersistentIdentifier``.
    ///
    /// Defaults to `nil` if there is no restored value.
    ///
    ///     @Model class Recipe { ... }
    ///     struct RecipeList: View {
    ///         @Query var recipes: [Recipe]
    ///         @SceneStorage("selectedID") var selectedRecipeID: Recipe.ID?
    ///
    ///         var body: some View {
    ///             List(recipes, selection: $selectedRecipeID) { recipe in
    ///                 RecipeDetail(recipe)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - key: The key to read and write the value to in the scene storage.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public init(_ key: String) where Value == PersistentIdentifier?
}

// Available when SwiftUI is imported with SwiftData
extension AppStorage {

    /// Creates a property that can read and write to a user default as data via
    /// ``PersistentIdentifier``.
    ///
    /// Use this property wrapper when the wrapped persistent identifier is
    /// known to always be non-optional. For storing optional persistent
    /// identifiers, use ``AppStorage/init(_:store:)`` instead.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value if a data value is not specified for
    ///    the given key.
    ///   - key: The key to read and write the value to in the user defaults
    ///     store.
    ///   - store: The user defaults store to read and write to. A value
    ///     of `nil` will use the user default store from the environment.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value == PersistentIdentifier

    /// Creates a property that can read and write an Optional data user
    /// default via ``PersistentIdentifier``.
    ///
    /// Defaults to `nil` if there is no restored value.
    ///
    ///     @Model class Recipe { ... }
    ///     struct RecipeList: View {
    ///         @Query var recipes: [Recipe]
    ///         @SceneStorage("selectedID") var selectedRecipeID: Recipe.ID?
    ///
    ///         var body: some View {
    ///             List(recipes, selection: $selectedRecipeID) { recipe in
    ///                 RecipeDetail(recipe)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - key: The key to read and write the value to in the user defaults
    ///     store.
    ///   - store: The user defaults store to read and write to. A value
    ///     of `nil` will use the user default store from the environment.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public init(_ key: String, store: UserDefaults? = nil) where Value == PersistentIdentifier?
}

// Available when SwiftUI is imported with SwiftData
@available(swift 5.9)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
extension ModelContext {

    public var debugDescription: String { get }
}

// Available when SwiftUI is imported with SwiftData
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension View {

    /// Sets the model container in this view for storing the provided
    /// model type, creating a new container if necessary, and also sets a model
    /// context for that container in this view's environment.
    ///
    /// In this example, the `RecipesList` view sets a model container to use
    /// for all of its contents, configured to store instances of `Recipe`:
    ///
    ///     @Model class Recipe { ... }
    ///     ...
    ///     RecipesList()
    ///         .modelContainer(for: Recipe.self)
    ///
    /// The environment's ``EnvironmentValues/modelContext`` property will be
    /// assigned a new context associated with this container. All implicit
    /// model context operations in this view, such as `Query`
    /// properties, will use the environment's context.
    ///
    /// By default, the container stores its model data persistently on disk.
    /// To only store data in memory for the lifetime of the app's process, pass
    /// `true` to the `inMemory:` parameter.
    ///
    /// The container will only be created once. New values that are passed to
    /// the `modelType` and `inMemory` parameters after the view is first
    /// created will be ignored.
    ///
    /// - Parameters:
    ///   - modelType: The model type defining the schema used to create the
    ///     model container.
    ///   - inMemory: Whether the container should store data only in memory.
    ///   - isAutosaveEnabled: `true` if autosave is enabled.
    ///   - isUndoEnabled: use `undoManager` in the environment to manage undo
    ///     operations for the model container.
    ///   - onSetup: A callback that will be invoked when the creation of the
    ///     container has has succeeded or failed.
    @MainActor @preconcurrency public func modelContainer(for modelType: any PersistentModel.Type, inMemory: Bool = false, isAutosaveEnabled: Bool = true, isUndoEnabled: Bool = false, onSetup: @escaping (Result<ModelContainer, any Error>) -> Void = { _ in }) -> some View


    /// Sets the model container in this view for storing the provided
    /// model types, creating a new container if necessary, and also sets a
    /// model context for that container in this view's environment.
    ///
    /// In this example, the `RecipesList` view sets a model container to use
    /// for all of its contents, configured to store instances of `Recipe` and
    /// `Ingredient`:
    ///
    ///     @Model class Recipe { ... }
    ///     @Model class Ingredient { ... }
    ///     ...
    ///     RecipesList()
    ///         .modelContainer(for: [Recipe.self, Ingredient.self])
    ///
    /// The environment's ``EnvironmentValues/modelContext`` property will be
    /// assigned a new context associated with this container. All implicit
    /// model context operations in this view, such as `Query`
    /// properties, will use the environment's context.
    ///
    /// By default, the container stores its model data persistently on disk.
    /// To only store data in memory for the lifetime of the app's process, pass
    /// `true` to the `inMemory:` parameter.
    ///
    /// The container will only be created once. New values that are passed to
    /// the `modelTypes` and `inMemory` parameters after the view is first
    /// created will be ignored.
    ///
    /// - Parameters:
    ///   - modelTypes: The model types defining the schema used to create the
    ///     model container.
    ///   - inMemory: Whether the container should store data only in memory.
    ///   - isAutosaveEnabled: `true` if autosave is enabled.
    ///   - isUndoEnabled: use `undoManager` in the view's environment to
    ///     manage undo operations for the model container.
    ///   - onSetup: A callback that will be invoked when the creation of the
    ///     container has has succeeded or failed.
    @MainActor @preconcurrency public func modelContainer(for modelTypes: [any PersistentModel.Type], inMemory: Bool = false, isAutosaveEnabled: Bool = true, isUndoEnabled: Bool = false, onSetup: @escaping (Result<ModelContainer, any Error>) -> Void = { _ in }) -> some View


    /// Sets the model container and associated model context in this
    /// view's environment.
    ///
    /// In this example, `ContentView` sets a model container to use for
    /// `RecipesList`:
    ///
    ///     struct ContentView: View {
    ///         @State private var container = ModelContainer(...)
    ///
    ///         var body: some Scene {
    ///             RecipesList()
    ///                 .modelContainer(container)
    ///         }
    ///     }
    ///
    /// The environment's ``EnvironmentValues/modelContext`` property will be
    /// assigned a new context associated with this container. All implicit
    /// model context operations in this view, such as `Query`
    /// properties, will use the environment's context.
    ///
    /// - Parameters:
    ///   - container: The model container to use for this view.
    @MainActor @preconcurrency public func modelContainer(_ container: ModelContainer) -> some View

}

// Available when SwiftUI is imported with SwiftData
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Scene {

    /// Sets the model container in this scene for storing the provided
    /// model type, creating a new container if necessary, and also sets a model
    /// context for that container in this scene's environment.
    ///
    /// In this example, `RecipesApp` sets a shared model container to use for
    /// all of its windows, configured to store instances of `Recipe`:
    ///
    ///     @Model class Recipe { ... }
    ///
    ///     @main
    ///     struct RecipesApp: App {
    ///         var body: some Scene {
    ///             WindowGroup {
    ///                 RecipesList()
    ///             }
    ///             .modelContainer(for: Recipe.self)
    ///         }
    ///     }
    ///
    /// The environment's ``EnvironmentValues/modelContext`` property will be
    /// assigned a new context associated with this container. All implicit
    /// model context operations in this scene, such as `Query`
    /// properties, will use the environment's context.
    ///
    /// By default, the container stores its model data persistently on disk.
    /// To only store data in memory for the lifetime of the app's process, pass
    /// `true` to the `inMemory:` parameter.
    ///
    /// The container will only be created once. New values that are passed to
    /// the `modelType` and `inMemory` parameters after the view is first
    /// created will be ignored.
    ///
    /// - Parameters:
    ///   - modelType: The model type defining the schema used to create the
    ///     model container.
    ///   - inMemory: Whether the container should store data only in memory.
    ///   - isAutosaveEnabled: `true` if autosave is enabled.
    ///   - isUndoEnabled: use `undoManager` in the scene's environment to
    ///     manage undo operations for the model container.
    ///   - onSetup: A callback that will be invoked when the creation of the
    ///     container has has succeeded or failed.
    @MainActor @preconcurrency public func modelContainer(for modelType: any PersistentModel.Type, inMemory: Bool = false, isAutosaveEnabled: Bool = true, isUndoEnabled: Bool = false, onSetup: @escaping (Result<ModelContainer, any Error>) -> Void = { _ in }) -> some Scene


    /// Sets the model container in this scene for storing the provided
    /// model types, creating a new container if necessary, and also sets a
    /// model context for that container in this scene's environment.
    ///
    /// In this example, `RecipesApp` sets a shared model container to use for
    /// all of its windows, configured to store instances of `Recipe` and
    /// `Ingredient`:
    ///
    ///     @Model class Recipe { ... }
    ///     @Model class Ingredient { ... }
    ///
    ///     @main
    ///     struct RecipesApp: App {
    ///         var body: some Scene {
    ///             WindowGroup {
    ///                 RecipesList()
    ///             }
    ///             .modelContainer(for: [Recipe.self, Ingredient.self])
    ///         }
    ///     }
    ///
    /// The environment's ``EnvironmentValues/modelContext`` property will be
    /// assigned a new context associated with this container. All implicit
    /// model context operations in this scene, such as `Query`
    /// properties, will use the environment's context.
    ///
    /// By default, the container stores its model data persistently on disk.
    /// To only store data in memory for the lifetime of the app's process, pass
    /// `true` to the `inMemory:` parameter.
    ///
    /// The container will only be created once. New values that are passed to
    /// the `modelTypes` and `inMemory` parameters after the view is first
    /// created will be ignored.
    ///
    /// - Parameters:
    ///   - modelTypes: The model types defining the schema used to create the
    ///     model container.
    ///   - inMemory: Whether the container should store data only in memory.
    ///   - isAutosaveEnabled: `true` if autosave is enabled.
    ///   - isUndoEnabled: use `undoManager` in the scene's environment to
    ///     manage undo operations for the model container.
    ///   - onSetup: A callback that will be invoked when the creation of the
    ///     container has has succeeded or failed.
    @MainActor @preconcurrency public func modelContainer(for modelTypes: [any PersistentModel.Type], inMemory: Bool = false, isAutosaveEnabled: Bool = true, isUndoEnabled: Bool = false, onSetup: @escaping (Result<ModelContainer, any Error>) -> Void = { _ in }) -> some Scene


    /// Sets the model container and associated model context in this
    /// scene's environment.
    ///
    /// In this example, `RecipesApp` sets a shared model container to use for
    /// all of its windows:
    ///
    ///     @main
    ///     struct RecipesApp: App {
    ///         @State private var container = ModelContainer(...)
    ///
    ///         var body: some Scene {
    ///             WindowGroup {
    ///                 RecipesList()
    ///             }
    ///             .modelContainer(container)
    ///         }
    ///     }
    ///
    /// The environment's ``EnvironmentValues/modelContext`` property will be
    /// assigned a new context associated with this container. All implicit
    /// model context operations in this scene, such as `Query`
    /// properties, will use the environment's context.
    ///
    /// - Parameters:
    ///   - container: The model container to use for this scene.
    @MainActor @preconcurrency public func modelContainer(_ container: ModelContainer) -> some Scene

}

// Available when SwiftUI is imported with SwiftData
@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension DocumentGroup where Document == ModelDocument {

    /// Instantiates a document group for creating and editing documents
    /// described by the last `Schema` in the migration plan.
    /// - Parameters:
    ///   - editing: The content type of the document. It should conform to `UTType.package`.
    ///   - migrationPlan: The description of steps required to migrate older document
    ///   versions so that they can be opened and edited.
    ///   The last `VersionedSchema` in the plan is considered to be
    ///   the current application schema.
    ///   - editor: The editing UI for the provided document.
    public init(editing contentType: UTType, migrationPlan: any SchemaMigrationPlan.Type, editor: @escaping () -> Content, prepareDocument: @escaping (ModelContext) -> Void = { _ in })

    /// Instantiates a document group for viewing documents
    /// described by the last `Schema` in the migration plan.
    /// - Parameters:
    ///   - viewing: The content type of the document. It should conform to `UTType.package`.
    ///   - migrationPlan: The description of steps required to migrate older document
    ///   versions so that they can be opened.
    ///   The last `VersionedSchema` in the plan is considered to be
    ///   the current application schema.
    ///   - viewer: The viewing UI for the provided document.
    public init(viewing contentType: UTType, migrationPlan: any SchemaMigrationPlan.Type, viewer: @escaping () -> Content)

    /// Instantiates a document group for creating and editing
    /// documents that store a specific model type.
    ///
    ///      @main
    ///      struct Todo: App {
    ///          var body: some Scene {
    ///              DocumentGroup(editing: TodoItem.self, contentType: .todoItem) {
    ///                  ContentView()
    ///              }
    ///          }
    ///      }
    ///
    ///      struct ContentView: View {
    ///          @Query var items: [TodoItem]
    ///
    ///              var body: some View {
    ///                  List {
    ///                      ForEach(items) { item in
    ///                          @Bindable var item = item
    ///                          Toggle(item.text, isOn: $item.isDone)
    ///                      }
    ///                   }
    ///              }
    ///      }
    ///
    ///      @Model
    ///      final class TodoItem {
    ///          var created: Date
    ///          var text: String
    ///          var isDone = false
    ///      }
    ///
    ///      extension UTType {
    ///          static var todoItem = UTType(exportedAs: "com.myApp.todoItem")
    ///      }
    ///
    /// > Important: If your app declares custom uniform type identifiers,
    /// include corresponding entries in the app's `Info.plist`.
    /// For more information, see <doc://com.apple.documentation/documentation/uniformtypeidentifiers/defining_file_and_data_types_for_your_app>.
    /// Also, remember to specify the supported Document types in the Info.plist as well.
    ///
    /// - Parameters:
    ///   - modelType: The model type defining the schema used for each document.
    ///   - contentType: The content type of the document.
    ///     It should conform to ``UTType.package``.
    ///   - editor: The editing UI for the provided document.
    ///   - prepareDocument: The optional closure that accepts
    ///     `ModelContext` associated with the new document.
    ///     Use this closure to set the document's initial contents
    ///     before it is displayed: insert preconfigured models
    ///     in the provided `ModelContext`.
    public init(editing modelType: any PersistentModel.Type, contentType: UTType, editor: @escaping () -> Content, prepareDocument: @escaping (ModelContext) -> Void = { _ in })

    /// Instantiates a document group for creating and editing
    /// documents that store several model types.
    ///
    ///      @main
    ///      struct Todo: App {
    ///          var body: some Scene {
    ///              DocumentGroup(editing: [TodoItem.self, CalendarEvent.self], contentType: .tasks) {
    ///                  ContentView()
    ///              }
    ///          }
    ///      }
    ///
    ///      struct ContentView: View {
    ///          @Query var items: [TodoItem]
    ///          @Query var events: [CalendarEvent]
    ///
    ///          var body: some View {
    ///              Form {
    ///                  Section("Todo") {
    ///                      ForEach(items) { item in
    ///                          @Bindable var item = item
    ///                          Toggle(item.text, isOn: $item.isDone)
    ///                      }
    ///                  }
    ///                  Section("Events") {
    ///                      ForEach(events) { event in
    ///                          LabeledContent(event.title, value: event.date.formatted())
    ///                       }
    ///                   }
    ///              }
    ///              .formStyle(.grouped)
    ///              .padding()
    ///          }
    ///      }
    ///
    ///      @Model
    ///      final class TodoItem {
    ///          var created: Date
    ///          var text: String
    ///          var isDone = false
    ///      }
    ///
    ///      @Model
    ///      final class CalendarEvent {
    ///          var title: String
    ///          var date: Date
    ///     }
    ///
    ///
    ///      extension UTType {
    ///          static var tasks = UTType(exportedAs: "com.myApp.tasks")
    ///      }
    ///
    /// > Important: If your app declares custom uniform type identifiers,
    /// include corresponding entries in the app's `Info.plist`.
    /// For more information, see <doc://com.apple.documentation/documentation/uniformtypeidentifiers/defining_file_and_data_types_for_your_app>.
    /// Also, remember to specify the supported Document types in the Info.plist as well.
    ///
    /// - Parameters:
    ///   - modelTypes: The array of model types defining the schema used for each document.
    ///   - contentType: The content type of the document.
    ///     It should conform to ``UTType.package``.
    ///   - editor: The editing UI for the provided document.
    ///   - prepareDocument: The optional closure that accepts
    ///     `ModelContext` associated with the new document.
    ///     Use this closure to set the document's initial contents
    ///     before it is displayed: insert preconfigured models
    ///     in the provided `ModelContext`.
    public init(editing modelTypes: [any PersistentModel.Type], contentType: UTType, editor: @escaping () -> Content, prepareDocument: @escaping (ModelContext) -> Void = { _ in })

    /// Instantiates a document group for viewing
    /// documents that store a specific model type.
    ///
    ///      @main
    ///      struct Todo: App {
    ///          var body: some Scene {
    ///              DocumentGroup(viewing: TodoItem.self, contentType: .todoItem) {
    ///                  ContentView()
    ///              }
    ///          }
    ///      }
    ///
    ///      extension UTType {
    ///          static var todoItem = UTType(exportedAs: "com.myApp.todoItem")
    ///      }
    ///
    /// > Important: If your app declares custom uniform type identifiers,
    /// include corresponding entries in the app's `Info.plist`.
    /// For more information, see <doc://com.apple.documentation/documentation/uniformtypeidentifiers/defining_file_and_data_types_for_your_app>.
    /// Also, remember to specify the supported Document types in the `Info.plist` as well.
    ///
    /// - Parameters:
    ///   - modelType: The model type defining the schema used for each document.
    ///   - contentType: The content type of document your app can view.
    ///     It should conform to ``UTType.package``.
    ///   - viewer: The viewing UI for the provided document.
    public init(viewing modelType: any PersistentModel.Type, contentType: UTType, viewer: @escaping () -> Content)

    /// Instantiates a document group for viewing
    /// documents that store several model types.
    ///
    ///      @main
    ///      struct Todo: App {
    ///          var body: some Scene {
    ///              DocumentGroup(viewing: [TodoItem.self, CalendarEvent.self], contentType: .tasks) {
    ///                  ContentView()
    ///              }
    ///          }
    ///      }
    ///
    ///      struct ContentView: View {
    ///          @Query var items: [TodoItem]
    ///          @Query var events: [CalendarEvent]
    ///
    ///          var body: some View {
    ///              Form {
    ///                  Section("Todo") {
    ///                      ForEach(items) { item in
    ///                          Image(systemName: item.isDone ? "checkmark.square" : "square")
    ///                      }
    ///                  }
    ///                  Section("Events") {
    ///                      ForEach(events) { event in
    ///                          LabeledContent(event.title, value: event.date.formatted())
    ///                       }
    ///                   }
    ///              }
    ///              .formStyle(.grouped)
    ///              .padding()
    ///          }
    ///      }
    ///
    ///      @Model
    ///      final class TodoItem {
    ///          var created: Date
    ///          var text: String
    ///          var isDone = false
    ///      }
    ///
    ///      @Model
    ///      final class CalendarEvent {
    ///          var title: String
    ///          var date: Date
    ///     }
    ///
    ///
    ///      extension UTType {
    ///          static var tasks = UTType(exportedAs: "com.myApp.tasks")
    ///      }
    ///
    /// > Important: If your app declares custom uniform type identifiers,
    /// include corresponding entries in the app's `Info.plist`.
    /// For more information, see <doc://com.apple.documentation/documentation/uniformtypeidentifiers/defining_file_and_data_types_for_your_app>.
    /// Also, remember to specify the supported Document types in the `Info.plist` as well.
    ///
    /// - Parameters:
    ///   - modelTypes: The model types defining the schema used for each document.
    ///   - contentType: The content type of document your app can view.
    ///     It should conform to ``UTType.package``.
    ///   - viewer: The viewing UI for the provided document.
    public init(viewing modelTypes: [any PersistentModel.Type], contentType: UTType, viewer: @escaping () -> Content)
}

