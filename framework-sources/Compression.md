import Darwin
import Foundation
import _Builtin_stdint

/**
 @enum compression_algorithm
 
 @abstract Tag used to select a compression algorithm.
 
 @discussion libcompression supports a number of different compression
 algorithms, but we have only implemented algorithms that we believe are the
 best choice in some set of circumstances; there are many, many compression
 algorithms that we do not provide because using one of the algorithms we
 do provide is [almost] always a better choice.
 
 There are four commonly-known encoders implemented: LZ4, zlib (level 5),
 LZMA (level 6) and Brotli (level 2). If you require that your compression be interoperable
 with non-Apple devices, you should use one of these three schemes:
 
    - Use LZ4 if speed is critical, and you are willing to sacrifice
    compression ratio to achieve it.
 
    - Use LZMA if compression ratio is critical, and you are willing to
    sacrifice speed to achieve it.  (Note: the performance impact of making
    this choice cannot be overstated.  LZMA is an order of magnitude slower
    for both compression and decompression than other schemes).
 
    - Use zlib otherwise.
 
 If you do not require interoperability with non-Apple devices, use LZFSE
 in the place of zlib in the hierarchy above.  It is an Apple-developed
 algorithm that is faster than, and generally compresses better than zlib.
 It is slower than LZ4 and does not compress as well as LZMA, however, so
 you will still want to use those algorithms in the situations described.

 Brotli is a widely adopted content-encoding-method for the web. Thus, Brotli
 is included in libcompression especially to provide decoding capabilities.
 In many other use-cases, one of the above mentioned algorithms is probably a
 better choice.

 Further details on the supported public formats, and their implementation
 in the compression library:
 
 - LZ4 is an extremely high-performance compressor.  The open source version
   is already one of the fastest compressors of which we are aware, and we
   have optimized it still further in our implementation.  The encoded format
   we produce and consume is compatible with the open source version, except
   that we add a very simple frame to the raw stream to allow some additional
   validation and functionality.
 
   The frame is documented here so that you can easily wrap another LZ4
   encoder/decoder to produce/consume the same data stream if necessary.  An
   LZ4 encoded buffer is a sequence of blocks, each of which begins with a
   header.  There are three possible headers:
 
        a "compressed block header" is (hex) 62 76 34 31, followed by the
        size in bytes of the decoded (plaintext) data represented by the
        block and the size (in bytes) of the encoded data stored in the
        block.  Both size fields are stored as (possibly unaligned) 32-bit
        little-endian values.  The compressed block header is followed
        immediately by the actual lz4-encoded data stream.
 
        an "uncompressed block header" is (hex) 62 76 34 2d, followed by the
        size of the data stored in the uncompressed block as a (possibly
        unaligned) 32-bit little-endian value.  The uncompressed block header
        is followed immediately by the uncompressed data buffer of the
        specified size.
 
        an "end of stream header" is (hex) 62 76 34 24, and marks the end
        of the lz4 frame.  No further data may be written or read beyond 
        this header.
 
   If you are implementing a wrapper for a raw LZ4 decoder, keep in mind that
   a compressed block may reference data from the previous block, so the
   (decoded) previous block must be available to the decoder.
 
 - We implement the LZMA level 6 encoder only.  This is the default compression
   level for open source LZMA, and provides excellent compression.  The LZMA
   decoder supports decoding data compressed with any compression level.
 
 - We implement the zlib level 5 encoder only.  This compression level provides
   a good balance between compression speed and compression ratio.  The zlib
   decoder supports decoding data compressed with any compression level.

   The encoded format is the raw DEFLATE format as described in IETF RFC 1951.
   Using the ZLIB library, the equivalent configuration of the encoder would be
   obtained with a call to:

        deflateInit2(zstream,5,Z_DEFLATED,-15,8,Z_DEFAULT_STRATEGY)

 - LZ4_RAW is supported by the buffer APIs only, and encodes/decodes payloads
   compatible with the LZ4 library, without the frame headers described above.

 - We implement Brotli level 2 encoder only. This compression level provides
   a good balance between compression speed and compression ratio. The Brotli
   decoder supports decoding data compressed with any compression level.
 
*/
public struct compression_algorithm : Hashable, Equatable, RawRepresentable {

    public init(_ rawValue: UInt32)

    public init(rawValue: UInt32)

    public var rawValue: UInt32
}

public var COMPRESSION_LZ4: compression_algorithm { get }

public var COMPRESSION_ZLIB: compression_algorithm { get }

public var COMPRESSION_LZMA: compression_algorithm { get }

public var COMPRESSION_LZ4_RAW: compression_algorithm { get }

public var COMPRESSION_BROTLI: compression_algorithm { get }

public var COMPRESSION_LZFSE: compression_algorithm { get }

public var COMPRESSION_LZBITMAP: compression_algorithm { get }

/**

 @function compression_encode_scratch_buffer_size

 @abstract
 Get the minimum scratch buffer size for the specified compression algorithm encoder.

 @param algorithm
 The compression algorithm for which the scratch space will be used.

 @return
 The number of bytes to allocate as a scratch buffer for use to encode with the specified
 compression algorithm. This number may be 0.

*/
@available(iOS 9.0, *)
public func compression_encode_scratch_buffer_size(_ algorithm: compression_algorithm) -> Int

/**

 @function compression_encode_buffer

 @abstract
 Compresses a buffer.

 @param dst_buffer
 Pointer to the first byte of the destination buffer.

 @param dst_size
 Size of the destination buffer in bytes.

 @param src_buffer
 Pointer to the first byte of the source buffer.

 @param src_size
 Size of the source buffer in bytes.

 @param scratch_buffer
 If non-null, a pointer to scratch space that the routine can use for temporary
 storage during compression.  To determine how much space to allocate for this
 scratch space, call compression_encode_scratch_buffer_size(algorithm).  Scratch space
 may be re-used across multiple (serial) calls to _encode and _decode.
 If NULL, the routine will allocate and destroy its own scratch space
 internally; this makes the function simpler to use, but may introduce a small
 amount of performance overhead.

 @param algorithm
 The compression algorithm to be used.

 @return
 The number of bytes written to the destination buffer if the input is
 is successfully compressed.  If the entire input cannot be compressed to fit
 into the provided destination buffer, or an error occurs, 0 is returned.

*/
@available(iOS 9.0, *)
public func compression_encode_buffer(_ dst_buffer: UnsafeMutablePointer<UInt8>, _ dst_size: Int, _ src_buffer: UnsafePointer<UInt8>, _ src_size: Int, _ scratch_buffer: UnsafeMutableRawPointer?, _ algorithm: compression_algorithm) -> Int

/**

 @function compression_decode_scratch_buffer_size

 @abstract
 Get the minimum scratch buffer size for the specified compression algorithm decoder.

 @param algorithm
 The compression algorithm for which the scratch space will be used.

 @return
 The number of bytes to allocate as a scratch buffer for use to decode with the specified
 compression algorithm. This number may be 0.

*/
@available(iOS 9.0, *)
public func compression_decode_scratch_buffer_size(_ algorithm: compression_algorithm) -> Int

/**

 @function compression_decode_buffer
 
 @abstract
 Decompresses a buffer.
 
 @param dst_buffer
 Pointer to the first byte of the destination buffer.
 
 @param dst_size
 Size of the destination buffer in bytes.

 @param src_buffer
 Pointer to the first byte of the source buffer.

 @param src_size
 Size of the source buffer in bytes.

 @param scratch_buffer
 If non-null, a pointer to scratch space that the routine can use for temporary
 storage during decompression.  To determine how much space to allocate for this
 scratch space, call compression_decode_scratch_buffer_size(algorithm).  Scratch space
 may be re-used across multiple (serial) calls to _encode and _decode.
 If NULL, the routine will allocate and destroy its own scratch space
 internally; this makes the function simpler to use, but may introduce a small
 amount of performance overhead.

 @param algorithm
 The compression algorithm to be used.

 @return
 The number of bytes written to the destination buffer if the input is
 is successfully decompressed.  If there is not enough space in the destination
 buffer to hold the entire expanded output, only the first dst_size bytes will
 be written to the buffer and dst_size is returned.   Note that this behavior
 differs from that of compression_encode.  If an error occurs, 0 is returned.
 
*/
@available(iOS 9.0, *)
public func compression_decode_buffer(_ dst_buffer: UnsafeMutablePointer<UInt8>, _ dst_size: Int, _ src_buffer: UnsafePointer<UInt8>, _ src_size: Int, _ scratch_buffer: UnsafeMutableRawPointer?, _ algorithm: compression_algorithm) -> Int

public struct compression_stream {

    public init(dst_ptr: UnsafeMutablePointer<UInt8>, dst_size: Int, src_ptr: UnsafePointer<UInt8>, src_size: Int, state: UnsafeMutableRawPointer?)

    public var dst_ptr: UnsafeMutablePointer<UInt8>

    public var dst_size: Int

    public var src_ptr: UnsafePointer<UInt8>

    public var src_size: Int

    public var state: UnsafeMutableRawPointer?
}

public struct compression_stream_operation : Hashable, Equatable, RawRepresentable {

    public init(_ rawValue: UInt32)

    public init(rawValue: UInt32)

    public var rawValue: UInt32
}

public var COMPRESSION_STREAM_ENCODE: compression_stream_operation { get }

public var COMPRESSION_STREAM_DECODE: compression_stream_operation { get }

public struct compression_stream_flags : Hashable, Equatable, RawRepresentable {

    public init(_ rawValue: UInt32)

    public init(rawValue: UInt32)

    public var rawValue: UInt32
}

public var COMPRESSION_STREAM_FINALIZE: compression_stream_flags { get }

public struct compression_status : Hashable, Equatable, RawRepresentable {

    public init(_ rawValue: Int32)

    public init(rawValue: Int32)

    public var rawValue: Int32
}

public var COMPRESSION_STATUS_OK: compression_status { get }

public var COMPRESSION_STATUS_ERROR: compression_status { get }

public var COMPRESSION_STATUS_END: compression_status { get }

/**

 @function compression_stream_init

 @abstract
 Initialize a compression_stream for encoding (if operation is
 COMPRESSION_STREAM_ENCODE) or decoding (if operation is 
 COMPRESSION_STREAM_DECODE).

 @param stream
 Pointer to the compression_stream object to be initialized.

 @param operation
 Specifies whether the stream is to initialized for encoding or decoding.
 Must be either COMPRESSION_STREAM_ENCODE or COMPRESSION_STREAM_DECODE.

 @param algorithm
 The compression algorithm to be used.  Must be one of the values specified
 in the compression_algorithm enum.

 @discussion
 This call initializes all fields of the compression_stream to zero, except
 for state; this routine allocates storage to capture the internal state
 of the encoding or decoding process so that it may be resumed.  This
 storage is tracked via the state parameter.

 @return
 COMPRESSION_STATUS_OK if the stream was successfully initialized, or
 COMPRESSION_STATUS_ERROR if an error occurred.

*/
@available(iOS 9.0, *)
public func compression_stream_init(_ stream: UnsafeMutablePointer<compression_stream>, _ operation: compression_stream_operation, _ algorithm: compression_algorithm) -> compression_status

/**

 @function compression_stream_process

 @abstract
 Encodes or decodes a block of the stream.

 @param stream
 Pointer to the compression_stream object to be operated on.  Before calling
 this function, you must initialize the stream object by calling
 compression_stream_init, and setting the user-managed fields to describe your
 input and output buffers. When compression_stream_process returns, those
 fields will have been updated to account for the bytes that were successfully
 encoded or decoded in the course of its operation.

 @param flags
 Binary OR of zero or more compression_stream_flags:
 
 COMPRESSION_STREAM_FINALIZE
 If set, indicates that no further input will be added to the stream, and
 thus that the end of stream should be indicated if the input block is
 completely processed.

 @discussion
 Processes the buffers described by the stream object until the source buffer
 becomes empty, or the destination buffer becomes full, or the entire stream is
 processed, or an error is encountered.

 @return
 When encoding COMPRESSION_STATUS_END is returned only if all input has been
 read from the source, all output (including an end-of-stream marker) has been
 written to the destination, and COMPRESSION_STREAM_FINALIZE bit is set.
 
 When decoding COMPRESSION_STATUS_END is returned only if all input (including
 and end-of-stream marker) has been read from the source, and all output has
 been written to the destination.
 
 COMPRESSION_STATUS_OK is returned if all data in the source buffer is consumed,
 or all space in the destination buffer is used. In that case, further calls
 to compression_stream_process are expected, providing more data in the source
 buffer, or more space in the destination buffer.
 
 COMPRESSION_STATUS_ERROR is returned if an error is encountered (if the
 encoded data is corrupted, for example).

 When decoding a valid stream, the end of stream will be detected from the contents
 of the input, and COMPRESSION_STATUS_END will be returned in that case, even if
 COMPRESSION_STREAM_FINALIZE is not set, or more input is provided.

 When decoding a corrupted or truncated stream, if COMPRESSION_STREAM_FINALIZE is not
 set to notify the decoder that no more input is coming, the decoder will not consume
 or produce any data, and return COMPRESSION_STATUS_OK.  In that case, the client code
 will call compression_stream_process again with the same state, entering an infinite loop.
 To avoid this, it is strongly advised to always set COMPRESSION_STREAM_FINALIZE when
 no more input is expected, for both encoding and decoding.

*/
@available(iOS 9.0, *)
public func compression_stream_process(_ stream: UnsafeMutablePointer<compression_stream>, _ flags: Int32) -> compression_status

/**

 @function compression_stream_destroy

 @abstract
 Cleans up state information stored in a compression_stream object.

 @discussion
 Use this to free memory allocated by compression_stream_init.  After calling
 this function, you will need to re-init the compression_stream object before
 using it again.

*/
@available(iOS 9.0, *)
public func compression_stream_destroy(_ stream: UnsafeMutablePointer<compression_stream>) -> compression_status

/// Compression algorithms, wraps the C API constants.
@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
public enum Algorithm : CaseIterable, RawRepresentable {

    /// LZFSE
    case lzfse

    /// Deflate (conforming to RFC 1951)
    case zlib

    /// LZ4 with simple frame encapsulation
    case lz4

    /// LZMA in a XZ container
    case lzma

    /// LZBITMAP
    case lzbitmap

    /// BROTLI
    case brotli

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
    public init?(rawValue: compression_algorithm)

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
    public var rawValue: compression_algorithm { get }

    /// A type that can represent a collection of all values of this type.
    @available(iOS 13, tvOS 13, watchOS 6, macOS 10.15, *)
    public typealias AllCases = [Algorithm]

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    @available(iOS 13, tvOS 13, watchOS 6, macOS 10.15, *)
    public typealias RawValue = compression_algorithm

    /// A collection of all values of this type.
    nonisolated public static var allCases: [Algorithm] { get }
}

@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
extension Algorithm : Equatable {
}

@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
extension Algorithm : Hashable {
}

/// Compression errors
@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
public enum FilterError : Error {

    /// Filter failed to initialize,
    /// or invalid internal state,
    /// or invalid parameters
    case invalidState

    /// Invalid data in a call to compression_stream_process,
    /// or non-empty write after an output filter has been finalized
    case invalidData

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (a: FilterError, b: FilterError) -> Bool

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

@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
extension FilterError : Equatable {
}

@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
extension FilterError : Hashable {
}

/// Compression filter direction of operation, compress/decompress
@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
public enum FilterOperation : RawRepresentable {

    /// Compress raw data to a compressed payload
    case compress

    /// Decompress a compressed payload to raw data
    case decompress

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
    public init?(rawValue: compression_stream_operation)

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
    public var rawValue: compression_stream_operation { get }

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    @available(iOS 13, tvOS 13, watchOS 6, macOS 10.15, *)
    public typealias RawValue = compression_stream_operation
}

@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
extension FilterOperation : Equatable {
}

@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
extension FilterOperation : Hashable {
}

@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
public class InputFilter<D> where D : DataProtocol {

    /// Initialize an input filter
    ///
    /// - Parameters:
    /// - operation: direction of operation
    /// - algorithm: compression algorithm
    /// - bufferCapacity: capacity of the internal data buffer
    /// - readFunc: called to read the input data
    ///
    /// - Throws: `FilterError.invalidState` if filter initialization failed
    public init(_ operation: FilterOperation, using algorithm: Algorithm, bufferCapacity: Int = 65536, readingFrom readFunc: @escaping (Int) throws -> D?) throws

    /// Read processed data from the filter
    ///
    /// Input data, when needed, is obtained from the input closure
    /// When the input closure returns a nil or empty Data object, the filter will be
    /// finalized, and after all processed data has been read, readData will return nil
    /// to signal end of input
    ///
    /// - Parameter count: max number of bytes to read from the filter
    ///
    /// - Returns: a new Data object containing at most `count` output bytes, or nil if no more data is available
    ///
    /// - Throws:
    /// `FilterError.invalidData` if an error occurs during processing
    public func readData(ofLength count: Int) throws -> Data?

    @objc deinit
}

@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
public class OutputFilter {

    /// Initialize an output filter
    ///
    /// - Parameters:
    /// - operation: direction of operation
    /// - algorithm: compression algorithm
    /// - bufferCapacity: capacity of the internal data buffer
    /// - writeFunc: called to write the processed data
    ///
    /// - Throws: `FilterError.invalidState` if stream initialization failed
    public init(_ operation: FilterOperation, using algorithm: Algorithm, bufferCapacity: Int = 65536, writingTo writeFunc: @escaping (Data?) throws -> Void) throws

    /// Send data to output filter
    ///
    /// Processed output will be sent to the output closure.
    /// A call with empty/nil data is interpreted as finalize().
    /// Writing non empty/nil data to a finalized stream is an error.
    ///
    /// - Parameter data: data to process
    ///
    /// - Throws:
    /// `FilterError.invalidData` if an error occurs during processing,
    /// or if `data` is not empty/nil, and the filter is the finalized state
    public func write<D>(_ data: D?) throws where D : DataProtocol

    /// Finalize the stream, i.e. flush all data remaining in the stream
    ///
    /// Processed output will be sent to the output closure.
    /// When all output has been sent, the writingTo closure is called one last time with nil data.
    /// Once the stream is finalized, writing non empty/nil data to the stream will throw an exception.
    ///
    /// - Throws: `FilterError.invalidData` if an error occurs during processing
    public func finalize() throws

    @objc deinit
}

