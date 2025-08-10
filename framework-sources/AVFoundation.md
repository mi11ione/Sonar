import AVFAudio
import AVFAudio.AVAudioSession
import AVFoundation.AVAnimation
import AVFoundation.AVAsset
import AVFoundation.AVAssetCache
import AVFoundation.AVAssetDownloadStorageManager
import AVFoundation.AVAssetDownloadTask
import AVFoundation.AVAssetExportSession
import AVFoundation.AVAssetImageGenerator
import AVFoundation.AVAssetPlaybackAssistant
import AVFoundation.AVAssetReader
import AVFoundation.AVAssetReaderOutput
import AVFoundation.AVAssetResourceLoader
import AVFoundation.AVAssetSegmentReport
import AVFoundation.AVAssetTrack
import AVFoundation.AVAssetTrackGroup
import AVFoundation.AVAssetTrackSegment
import AVFoundation.AVAssetVariant
import AVFoundation.AVAssetWriter
import AVFoundation.AVAssetWriterInput
import AVFoundation.AVAsynchronousKeyValueLoading
import AVFoundation.AVAudioBuffer
import AVFoundation.AVAudioChannelLayout
import AVFoundation.AVAudioConnectionPoint
import AVFoundation.AVAudioConverter
import AVFoundation.AVAudioEngine
import AVFoundation.AVAudioEnvironmentNode
import AVFoundation.AVAudioFile
import AVFoundation.AVAudioFormat
import AVFoundation.AVAudioIONode
import AVFoundation.AVAudioMix
import AVFoundation.AVAudioMixerNode
import AVFoundation.AVAudioMixing
import AVFoundation.AVAudioNode
import AVFoundation.AVAudioPlayer
import AVFoundation.AVAudioPlayerNode
import AVFoundation.AVAudioProcessingSettings
import AVFoundation.AVAudioRecorder
import AVFoundation.AVAudioSequencer
import AVFoundation.AVAudioSession
import AVFoundation.AVAudioSessionDeprecated
import AVFoundation.AVAudioSessionRoute
import AVFoundation.AVAudioSessionTypes
import AVFoundation.AVAudioSettings
import AVFoundation.AVAudioTime
import AVFoundation.AVAudioTypes
import AVFoundation.AVAudioUnit
import AVFoundation.AVAudioUnitComponent
import AVFoundation.AVAudioUnitDelay
import AVFoundation.AVAudioUnitDistortion
import AVFoundation.AVAudioUnitEQ
import AVFoundation.AVAudioUnitEffect
import AVFoundation.AVAudioUnitGenerator
import AVFoundation.AVAudioUnitMIDIInstrument
import AVFoundation.AVAudioUnitReverb
import AVFoundation.AVAudioUnitSampler
import AVFoundation.AVAudioUnitTimeEffect
import AVFoundation.AVAudioUnitTimePitch
import AVFoundation.AVAudioUnitVarispeed
import AVFoundation.AVBase
import AVFoundation.AVCameraCalibrationData
import AVFoundation.AVCaption
import AVFoundation.AVCaptionConversionValidator
import AVFoundation.AVCaptionFormatConformer
import AVFoundation.AVCaptionGroup
import AVFoundation.AVCaptionGrouper
import AVFoundation.AVCaptionRenderer
import AVFoundation.AVCaptionSettings
import AVFoundation.AVCaptureAudioDataOutput
import AVFoundation.AVCaptureAudioPreviewOutput
import AVFoundation.AVCaptureControl
import AVFoundation.AVCaptureDataOutputSynchronizer
import AVFoundation.AVCaptureDepthDataOutput
import AVFoundation.AVCaptureDeskViewApplication
import AVFoundation.AVCaptureDevice
import AVFoundation.AVCaptureFileOutput
import AVFoundation.AVCaptureIndexPicker
import AVFoundation.AVCaptureInput
import AVFoundation.AVCaptureMetadataOutput
import AVFoundation.AVCaptureOutput
import AVFoundation.AVCaptureOutputBase
import AVFoundation.AVCapturePhotoOutput
import AVFoundation.AVCaptureReactions
import AVFoundation.AVCaptureSession
import AVFoundation.AVCaptureSessionPreset
import AVFoundation.AVCaptureSlider
import AVFoundation.AVCaptureSpatialAudioMetadataSampleGenerator
import AVFoundation.AVCaptureStillImageOutput
import AVFoundation.AVCaptureSystemExposureBiasSlider
import AVFoundation.AVCaptureSystemPressure
import AVFoundation.AVCaptureSystemZoomSlider
import AVFoundation.AVCaptureVideoDataOutput
import AVFoundation.AVCaptureVideoPreviewLayer
import AVFoundation.AVComposition
import AVFoundation.AVCompositionTrack
import AVFoundation.AVCompositionTrackSegment
import AVFoundation.AVContentKeySession
import AVFoundation.AVContinuityDevice
import AVFoundation.AVDepthData
import AVFoundation.AVDisplayCriteria
import AVFoundation.AVError
import AVFoundation.AVExternalStorageDevice
import AVFoundation.AVFAudio
import AVFoundation.AVFCapture
import AVFoundation.AVFCore
import AVFoundation.AVGeometry
import AVFoundation.AVMIDIPlayer
import AVFoundation.AVMediaFormat
import AVFoundation.AVMediaSelection
import AVFoundation.AVMediaSelectionGroup
import AVFoundation.AVMetadataFormat
import AVFoundation.AVMetadataIdentifiers
import AVFoundation.AVMetadataItem
import AVFoundation.AVMetadataObject
import AVFoundation.AVMetrics
import AVFoundation.AVMovie
import AVFoundation.AVMovieTrack
import AVFoundation.AVOutputSettingsAssistant
import AVFoundation.AVPlaybackCoordinationMedium
import AVFoundation.AVPlaybackCoordinator
import AVFoundation.AVPlayer
import AVFoundation.AVPlayerInterstitialEventController
import AVFoundation.AVPlayerItem
import AVFoundation.AVPlayerItemIntegratedTimeline
import AVFoundation.AVPlayerItemMediaDataCollector
import AVFoundation.AVPlayerItemOutput
import AVFoundation.AVPlayerItemTrack
import AVFoundation.AVPlayerLayer
import AVFoundation.AVPlayerLooper
import AVFoundation.AVPlayerMediaSelectionCriteria
import AVFoundation.AVPlayerOutput
import AVFoundation.AVPortraitEffectsMatte
import AVFoundation.AVQueuedSampleBufferRendering
import AVFoundation.AVRenderedCaptionImage
import AVFoundation.AVRouteDetector
import AVFoundation.AVSampleBufferAudioRenderer
import AVFoundation.AVSampleBufferDisplayLayer
import AVFoundation.AVSampleBufferGenerator
import AVFoundation.AVSampleBufferRenderSynchronizer
import AVFoundation.AVSampleBufferVideoRenderer
import AVFoundation.AVSampleCursor
import AVFoundation.AVSemanticSegmentationMatte
import AVFoundation.AVSpatialVideoConfiguration
import AVFoundation.AVSpeechSynthesis
import AVFoundation.AVSynchronizedLayer
import AVFoundation.AVTextStyleRule
import AVFoundation.AVTime
import AVFoundation.AVTimedMetadataGroup
import AVFoundation.AVUtilities
import AVFoundation.AVVideoCompositing
import AVFoundation.AVVideoComposition
import AVFoundation.AVVideoPerformanceMetrics
import AVFoundation.AVVideoSettings
import CoreGraphics
import CoreImage
import CoreMedia
import Dispatch
import Foundation
import Synchronization

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
public class AVAnyAsyncProperty : CustomStringConvertible, @unchecked Sendable {

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

    @objc deinit
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
public class AVAsyncProperty<Root, Value> : AVPartialAsyncProperty<Root> {

    @objc deinit
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVAsyncProperty {

    @frozen public enum Status {

        /// property has not been loaded
        case notYetLoaded

        /// property is being loaded
        case loading

        /// property already loaded, value is included
        case loaded(Value)

        /// property failed to load, error is included
        case failed(NSError)
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVAsyncProperty.Status : Equatable where Value : Equatable {

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: AVAsyncProperty<Root, Value>.Status, rhs: AVAsyncProperty<Root, Value>.Status) -> Bool
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVAsyncProperty.Status : Sendable where Value : Sendable {
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVAsyncProperty.Status : CustomStringConvertible {

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

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
@available(watchOS, unavailable)
public struct AVCIImageFilteringParameters {

    /// The current video frame image.
    public let sourceImage: CIImage

    /// The time in the video composition corresponding to the frame being processed.
    public let compositionTime: CMTime

    /// The width and height, in pixels, of the frame being processed.
    public let renderSize: CGSize
}

/// An output video frame processed with Core Image filtering.
@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
@available(watchOS, unavailable)
public struct AVCIImageFilteringResult {

    /// Provides the filtered video frame image to AVFoundation for further processing or display.
    public let resultImage: CIImage

    /// The core image context used to render the image
    public let ciContext: CIContext?

    public init(resultImage: CIImage, ciContext: CIContext? = nil)
}

@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
public struct AVMergedMetrics<MetricEvent1, MetricEvent2, each MetricEventPack> : AsyncSequence where MetricEvent1 : AVMetricEvent, MetricEvent2 : AVMetricEvent, repeat each MetricEventPack : AVMetricEvent {

    /// Creates the asynchronous iterator that produces elements of this
    /// asynchronous sequence.
    ///
    /// - Returns: An instance of the `AsyncIterator` type used to produce
    /// elements of the asynchronous sequence.
    public func makeAsyncIterator() -> AVMergedMetrics<MetricEvent1, MetricEvent2, repeat each MetricEventPack>.AsyncIterator

    /// The type of element produced by this asynchronous sequence.
    public typealias Element = (AVMetricEvent, any AVMetricEventStreamPublisher)

    /// The type of asynchronous iterator that produces elements of this
    /// asynchronous sequence.
    public struct AsyncIterator : AsyncIteratorProtocol {

        /// Asynchronously advances to the next element and returns it, or ends the
        /// sequence if there is no next element.
        ///
        /// - Returns: The next element, if it exists, or `nil` to signal the end of
        ///   the sequence.
        public mutating func next() async throws -> (AVMetricEvent, any AVMetricEventStreamPublisher)?

        @available(iOS 18, tvOS 18, watchOS 11, visionOS 2, macOS 15, *)
        public typealias Element = (AVMetricEvent, any AVMetricEventStreamPublisher)
    }
}

@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
public struct AVMetrics<MetricEvent> : AsyncSequence, @unchecked Sendable where MetricEvent : AVMetricEvent {

    /// Creates the asynchronous iterator that produces elements of this
    /// asynchronous sequence.
    ///
    /// - Returns: An instance of the `AsyncIterator` type used to produce
    /// elements of the asynchronous sequence.
    public func makeAsyncIterator() -> AVMetrics<MetricEvent>.AsyncIterator

    /// The type of element produced by this asynchronous sequence.
    public typealias Element = MetricEvent

    /// The type of asynchronous iterator that produces elements of this
    /// asynchronous sequence.
    public struct AsyncIterator : AsyncIteratorProtocol {

        /// Asynchronously advances to the next element and returns it, or ends the
        /// sequence if there is no next element.
        ///
        /// - Returns: The next element, if it exists, or `nil` to signal the end of
        ///   the sequence.
        public mutating func next() async throws -> MetricEvent?

        @available(iOS 18, tvOS 18, watchOS 11, visionOS 2, macOS 15, *)
        public typealias Element = MetricEvent
    }

    public func chronologicalMerge<OtherSecondMetric, each MetricEventPack>(with secondMetric: AVMetrics<OtherSecondMetric>, _ metrics: repeat AVMetrics<each MetricEventPack>) -> AVMergedMetrics<MetricEvent, OtherSecondMetric, repeat each MetricEventPack> where OtherSecondMetric : AVMetricEvent, repeat each MetricEventPack : AVMetricEvent
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
public class AVPartialAsyncProperty<Root> : AVAnyAsyncProperty {

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
    override public var description: String { get }

    @objc deinit
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVPartialAsyncProperty where Root : AVMetadataItem {

    /**
     Provides a dictionary of the additional attributes.
     */
    public static var extraAttributes: AVAsyncProperty<Root, [AVMetadataExtraAttributeKey : Any]?> { get }

    /**
     Provides the value of the metadata item.
     */
    public static var value: AVAsyncProperty<Root, (any NSCopying & NSObjectProtocol)?> { get }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVPartialAsyncProperty where Root : AVMetadataItem {

    /**
         Provides the value of the metadata item as a string.
    
         Will be nil if the value cannot be represented as a string.
         */
    public static var stringValue: AVAsyncProperty<Root, String?> { get }

    /**
         Provides the value of the metadata item as an NSNumber.
    
         Will be nil if the value cannot be represented as a number.
         */
    public static var numberValue: AVAsyncProperty<Root, NSNumber?> { get }

    /**
         Provides the value of the metadata item as an Date.
    
         Will be nil if the value cannot be represented as a date.
         */
    public static var dateValue: AVAsyncProperty<Root, Date?> { get }

    /**
     Provides the raw bytes of the value of the metadata item.
     */
    public static var dataValue: AVAsyncProperty<Root, Data?> { get }
}

@available(macOS 12, iOS 15, watchOS 8, visionOS 1, *)
@available(tvOS, unavailable)
extension AVPartialAsyncProperty where Root : AVMutableMovie {

    /**
     Provides the array of AVMutableMovieTracks contained by the mutable movie.
     */
    public static var tracks: AVAsyncProperty<Root, [AVMutableMovieTrack]> { get }
}

@available(macOS 12, iOS 15, watchOS 8, visionOS 1, *)
@available(tvOS, unavailable)
extension AVPartialAsyncProperty where Root : AVFragmentedMovie {

    /**
     Provides the array of AVFragmentedMovieTracks contained by the fragmented movie.
     */
    public static var tracks: AVAsyncProperty<Root, [AVFragmentedMovieTrack]> { get }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVPartialAsyncProperty where Root : AVComposition {

    /**
     Provides the array of AVCompositionTracks contained by the composition.
     */
    public static var tracks: AVAsyncProperty<Root, [AVCompositionTrack]> { get }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVPartialAsyncProperty where Root : AVAsset {

    /**
     Indicates the duration of the asset.
     
     If `providesPreciseDurationAndTiming` is false, a best-available estimate of the duration is returned.
     The degree of precision preferred for timing-related properties can be set at initialization time for assets initialized with URLs.
     See `AVURLAssetPreferPreciseDurationAndTimingKey` for AVURLAsset.
    */
    public static var duration: AVAsyncProperty<Root, CMTime> { get }

    /**
     Indicates the natural rate at which the asset is to be played; often but not always 1.0
    */
    public static var preferredRate: AVAsyncProperty<Root, Float> { get }

    /**
     Indicates the preferred volume at which the audible media of an asset is to be played; often but not always 1.0
    */
    public static var preferredVolume: AVAsyncProperty<Root, Float> { get }

    /**
     Indicates the preferred transform to apply to the visual content of the asset for presentation or processing; the value is often but not always the identity transform
    */
    public static var preferredTransform: AVAsyncProperty<Root, CGAffineTransform> { get }

    /**
     Indicates how close to the latest content in a live stream playback can be sustained.
     
     For non-live assets this value is kCMTimeInvalid.
     */
    public static var minimumTimeOffsetFromLive: AVAsyncProperty<Root, CMTime> { get }

    /**
     Indicates that the asset provides precise timing. See `duration` and AVURLAssetPreferPreciseDurationAndTimingKey.
    */
    public static var providesPreciseDurationAndTiming: AVAsyncProperty<Root, Bool> { get }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVPartialAsyncProperty where Root : AVAsset {

    /**
     Provides the array of AVAssetTracks contained by the asset.
     */
    public static var tracks: AVAsyncProperty<Root, [AVAssetTrack]> { get }

    /**
     All track groups in the asset.
    */
    public static var trackGroups: AVAsyncProperty<Root, [AVAssetTrackGroup]> { get }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVPartialAsyncProperty where Root : AVAsset {

    /**
     Indicates the creation date of the asset as an AVMetadataItem. May be nil.
     
     If a creation date has been stored by the asset in a form that can be converted to a Date, the dateValue property of the AVMetadataItem will provide an instance of NSDate. Otherwise the creation date is available only as a string value, via stringValue property of AVMetadataItem.
     */
    public static var creationDate: AVAsyncProperty<Root, AVMetadataItem?> { get }

    /**
     Provides access to the lyrics of the asset suitable for the current locale.
     */
    public static var lyrics: AVAsyncProperty<Root, String?> { get }

    /**
     Provides access to an array of AVMetadataItems for each common metadata key for which a value is available
     
     Items can be filtered according to language via `AVMetadataItem.metadataItems(from:filteredAndSortedAccordingToPreferredLanguages:)` and according to identifier via `AVMetadataItem.metadataItems(from:filteredByIdentifier:)`.
     */
    public static var commonMetadata: AVAsyncProperty<Root, [AVMetadataItem]> { get }

    /**
     Provides access to an array of AVMetadataItems for all metadata identifiers for which a value is available
     
     Items can be filtered according to language via `AVMetadataItem.metadataItems(from:filteredAndSortedAccordingToPreferredLanguages:)` and according to identifier via `AVMetadataItem.metadataItems(from:filteredByIdentifier:)`.
     */
    public static var metadata: AVAsyncProperty<Root, [AVMetadataItem]> { get }

    /**
     Provides an array containing metadata format that's available to the asset (e.g. ID3, iTunes metadata, etc.)
    */
    public static var availableMetadataFormats: AVAsyncProperty<Root, [AVMetadataFormat]> { get }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVPartialAsyncProperty where Root : AVAsset {

    /**
     Indicates the locales for which chapter metadata items are available
     */
    public static var availableChapterLocales: AVAsyncProperty<Root, [Locale]> { get }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVPartialAsyncProperty where Root : AVURLAsset {

    /**
         Provides an array of AVAssetVariants contained in the asset.
    
         Some variants may not be playable according to the current device configuration.
    	 */
    public static var variants: AVAsyncProperty<Root, [AVAssetVariant]> { get }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVPartialAsyncProperty where Root : AVAsset {

    /**
     Provides an array with elements indicating media characteristic for which a media selection option is available.
    */
    public static var availableMediaCharacteristicsWithMediaSelectionOptions: AVAsyncProperty<Root, [AVMediaCharacteristic]> { get }

    /**
     Provides an instance of AVMediaSelection with default selections for each of the receiver's media selection groups.
     */
    public static var preferredMediaSelection: AVAsyncProperty<Root, AVMediaSelection> { get }

    /**
     Provides an array of all permutations of AVMediaSelection for this asset.
     */
    public static var allMediaSelections: AVAsyncProperty<Root, [AVMediaSelection]> { get }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVPartialAsyncProperty where Root : AVAsset {

    /**
     Indicates whether or not the asset has protected content.
     
     Assets containing protected content may not be playable without successful authorization, even if the value of the `playable` property is true. See the properties in the AVAssetUsability category for details on how such an asset may be used. On macOS, clients can use the interfaces in AVPlayerItemProtectedContentAdditions.h to request authorization to play the asset.
     */
    @available(macOS 12, iOS 15, tvOS 15, visionOS 1, *)
    @available(watchOS, unavailable)
    public static var hasProtectedContent: AVAsyncProperty<Root, Bool> { get }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVPartialAsyncProperty where Root : AVAsset {

    /**
     Indicates whether the asset is capable of being extended by fragments.
     
     For QuickTime movie files and MPEG-4 files, the value of canContainFragments is true if an 'mvex' box is present in the 'moov' box. For those types, the 'mvex' box signals the possible presence of later 'moof' boxes.
     */
    @available(macOS 12, iOS 15, tvOS 15, visionOS 1, *)
    @available(watchOS, unavailable)
    public static var canContainFragments: AVAsyncProperty<Root, Bool> { get }

    /**
     Indicates whether the asset is extended by at least one fragment.
     
     For QuickTime movie files and MPEG-4 files, the value of this property is true if canContainFragments is true and at least one 'moof' box is present after the 'moov' box.
     */
    @available(macOS 12, iOS 15, tvOS 15, visionOS 1, *)
    @available(watchOS, unavailable)
    public static var containsFragments: AVAsyncProperty<Root, Bool> { get }

    /**
     Indicates the total duration of fragments that either exist now or may be appended in the future in order to extend the duration of the asset.
     
     For QuickTime movie files and MPEG-4 files, the value of this property is obtained from the 'mehd' box of the 'mvex' box, if present. If no total fragment duration hint is available, the value of this property is kCMTimeInvalid.
     */
    public static var overallDurationHint: AVAsyncProperty<Root, CMTime> { get }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVPartialAsyncProperty where Root : AVAsset {

    /**
     Indicates whether an AVPlayer can play the contents of the asset in a manner that meets user expectations.
     
     A client can attempt playback when playable is false, this however may lead to a substandard playback experience.
     */
    public static var isPlayable: AVAsyncProperty<Root, Bool> { get }

    /**
     Indicates whether an AVAssetExportSession can be used with the receiver for export.
     */
    @available(macOS 12, iOS 15, tvOS 15, visionOS 1, *)
    @available(watchOS, unavailable)
    public static var isExportable: AVAsyncProperty<Root, Bool> { get }

    /**
     Indicates whether an AVAssetReader can be used with the receiver for extracting media data.
     */
    @available(macOS 12, iOS 15, tvOS 15, visionOS 1, *)
    @available(watchOS, unavailable)
    public static var isReadable: AVAsyncProperty<Root, Bool> { get }

    /**
     Indicates whether the receiver can be used to build an AVMutableComposition.
     */
    public static var isComposable: AVAsyncProperty<Root, Bool> { get }

    /**
     Indicates whether the receiver can be written to the saved photos album.
     */
    @available(iOS 15, tvOS 15, visionOS 1, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    public static var isCompatibleWithSavedPhotosAlbum: AVAsyncProperty<Root, Bool> { get }

    /**
         Indicates whether the asset is compatible with AirPlay Video.
    
         true if an AVPlayerItem initialized with the receiver can be played by an external device via AirPlay Video.
         */
    @available(macOS 12, iOS 15, tvOS 15, visionOS 1, *)
    @available(watchOS, unavailable)
    public static var isCompatibleWithAirPlayVideo: AVAsyncProperty<Root, Bool> { get }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVPartialAsyncProperty where Root : AVMutableComposition {

    /**
    	 Provides the array of AVMutableCompositionTracks contained by the mutable composition.
    	 */
    public static var tracks: AVAsyncProperty<Root, [AVMutableCompositionTrack]> { get }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVPartialAsyncProperty where Root : AVAssetTrack {

    /**
     Provides an array of CMFormatDescriptions each of which indicates the format of media samples referenced by the track.
     
     A track that presents uniform media, e.g. encoded according to the same encoding settings, will provide an array with a count of 1
     */
    public static var formatDescriptions: AVAsyncProperty<Root, [CMFormatDescription]> { get }

    /**
     Indicates whether the receiver is playable in the current environment.
     
     If `true`, an AVPlayerItemTrack of an AVPlayerItem initialized with the receiver's asset can be enabled for playback.
     */
    public static var isPlayable: AVAsyncProperty<Root, Bool> { get }

    /**
     Indicates whether the receiver is decodable in the current environment.
     
     If `true`, the track can be decoded even though decoding may be too slow for real time playback.
     */
    public static var isDecodable: AVAsyncProperty<Root, Bool> { get }

    /**
     Indicates whether the track is enabled according to state stored in its container or construct.
     
     Note that its presentation state can be changed from this default via AVPlayerItemTrack
     */
    public static var isEnabled: AVAsyncProperty<Root, Bool> { get }

    /**
     Indicates whether the track references sample data only within its storage container.
     */
    public static var isSelfContained: AVAsyncProperty<Root, Bool> { get }

    /**
     Indicates the total number of bytes of sample data required by the track.
     */
    public static var totalSampleDataLength: AVAsyncProperty<Root, Int64> { get }

    /**
     Indicates all available media characteristics for the track.
     
     Media characteristics values are `.visual`, `.audible`, `.legible` etc.
     */
    public static var mediaCharacteristics: AVAsyncProperty<Root, [AVMediaCharacteristic]> { get }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVPartialAsyncProperty where Root : AVAssetTrack {

    /**
     Indicates the timeRange of the track within the overall timeline of the asset.
     
     A track with `timeRange.start > .zero` will initially present an empty interval.
     */
    public static var timeRange: AVAsyncProperty<Root, CMTimeRange> { get }

    /**
     Indicates a timescale in which time values for the track can be operated upon without extraneous numerical conversion.
     */
    public static var naturalTimeScale: AVAsyncProperty<Root, CMTimeScale> { get }

    /**
     Indicates the estimated data rate of the media data referenced by the track, in units of bits per second
     */
    public static var estimatedDataRate: AVAsyncProperty<Root, Float> { get }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVPartialAsyncProperty where Root : AVAssetTrack {

    /**
     Indicates the language associated with the track, as an ISO 639-2/T language code
     
     May be nil if no language is indicated
     */
    public static var languageCode: AVAsyncProperty<Root, String?> { get }

    /**
     Indicates the language tag associated with the track, as an IETF BCP 47 (RFC 4646) language identifier
     
     May be nil if no language tag is indicated
     */
    public static var extendedLanguageTag: AVAsyncProperty<Root, String?> { get }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVPartialAsyncProperty where Root : AVAssetTrack {

    /**
     Indicates the natural dimensions of the media data referenced by the track as a CGSize.
     */
    public static var naturalSize: AVAsyncProperty<Root, CGSize> { get }

    /**
     Indicates the transform specified in the track's storage container as the preferred transformation of the visual media data for display purposes
     
     Value returned is often but not always `.identity`
     */
    public static var preferredTransform: AVAsyncProperty<Root, CGAffineTransform> { get }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVPartialAsyncProperty where Root : AVAssetTrack {

    /**
     Indicates the volume specified in the track's storage container as the preferred volume of the audible media data.
     */
    public static var preferredVolume: AVAsyncProperty<Root, Float> { get }

    /**
     Indicates whether this audio track has dependencies (e.g. kAudioFormatMPEGD_USAC) .
     */
    public static var hasAudioSampleDependencies: AVAsyncProperty<Root, Bool> { get }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVPartialAsyncProperty where Root : AVAssetTrack {

    /**
     Indicates the frame rate associated with this track.
     
     For tracks that carry a full frame per media sample, indicates the frame rate of the track in units of frames per second. For field-based video tracks that carry one field per media sample, the value of this property is the field rate, not the frame rate.
     */
    public static var nominalFrameRate: AVAsyncProperty<Root, Float> { get }

    /**
     Indicates the minimum duration of the track's frames
     
     The value will be kCMTimeInvalid if the minimum frame duration is not known or cannot be calculated
     */
    public static var minFrameDuration: AVAsyncProperty<Root, CMTime> { get }

    /**
     Indicates whether samples in the track may have different values for their presentation and decode timestamps.
     */
    public static var requiresFrameReordering: AVAsyncProperty<Root, Bool> { get }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVPartialAsyncProperty where Root : AVAssetTrack {

    /**
     Provides an array of AVAssetTrackSegments with time mappings from the timeline of the track's media samples to the timeline of the track.
     
     Empty edits, i.e. timeRanges for which no media data is available to be presented, have a value of AVAssetTrackSegment.empty equal to true.
     */
    public static var segments: AVAsyncProperty<Root, [AVAssetTrackSegment]> { get }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVPartialAsyncProperty where Root : AVAssetTrack {

    /**
     Provides access to an array of AVMetadataItems for each common metadata key for which a value is available
     */
    public static var commonMetadata: AVAsyncProperty<Root, [AVMetadataItem]> { get }

    /**
     Provides access to an array of AVMetadataItems for all metadata identifiers for which a value is available
     
     Items can be filtered according to language via
     `AVMetadataItem. metadataItems(from:filteredAndSortedAccordingToPreferredLanguages:)` and according to identifier via `AVMetadataItem.metadataItems(from:filteredByIdentifier:)`.
    */
    public static var metadata: AVAsyncProperty<Root, [AVMetadataItem]> { get }

    /**
     Provides an array in which each element represents a format of metadata that's available for the track (e.g. QuickTime userdata, etc.)
     
     Metadata formats are defined in AVMetadataFormat.
     */
    public static var availableMetadataFormats: AVAsyncProperty<Root, [AVMetadataFormat]> { get }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVPartialAsyncProperty where Root : AVAssetTrack {

    /**
     Provides an array in which each element represents a type of track association that the receiver has with one or more of the other tracks of the asset (e.g. `.chapterList`, `.timecode`, etc).
     */
    public static var availableTrackAssociationTypes: AVAsyncProperty<Root, [AVAssetTrack.AssociationType]> { get }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVPartialAsyncProperty where Root : AVAssetTrack {

    /**
     Indicates whether the receiver can provide instances of AVSampleCursor for traversing its media samples and discovering information about them.
     */
    @available(macOS 12, iOS 16, tvOS 16, watchOS 9, visionOS 1, *)
    public static var canProvideSampleCursors: AVAsyncProperty<Root, Bool> { get }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVPartialAsyncProperty where Root : AVFragmentedAsset {

    /**
     Provides the array of AVFragmentedAssetTracks contained by the fragmented asset.
     */
    public static var tracks: AVAsyncProperty<Root, [AVFragmentedAssetTrack]> { get }
}

@available(macOS 12, iOS 15, watchOS 8, visionOS 1, *)
@available(tvOS, unavailable)
extension AVPartialAsyncProperty where Root : AVMovie {

    /**
     Provides the array of AVMovieTracks contained by the movie.
     */
    public static var tracks: AVAsyncProperty<Root, [AVMovieTrack]> { get }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVPartialAsyncProperty where Root : AVURLAsset {

    /**
     Provides the array of AVURLAssetTracks contained by the url asset.
     */
    public static var tracks: AVAsyncProperty<Root, [AVAssetTrack]> { get }
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
@available(watchOS, unavailable)
public struct AVSpatialVideoConfiguration : Sendable {

    /// Specifies intrinsic and extrinsic parameters for single or multiple lenses.
    ///
    /// The property value is an array of dictionaries describing the camera calibration data for each lens. The camera calibration data includes intrinsics and extrinics with other parameters.  This property is only applicable when the projection kind is kCMTagProjectionTypeParametricImmersive.  Can be nil if the value is unknown.
    public var cameraCalibrationDataLensCollection: CMFormatDescription.Extensions.Value.CameraCalibrationDataLensCollection?

    /// Specifies horizontal field of view in thousandths of a degree. Can be nil if the value is unknown.
    public var horizontalFieldOfView: UInt32?

    /// Specifies the distance between centers of the lenses of the camera system that created the video.
    ///
    /// The distance is in micrometers or thousandths of a millimeter. Can be nil if the value is unknown.
    public var cameraSystemBaseline: UInt32?

    /// Specifies a relative shift of the left and right images, which changes the zero parallax plane.
    ///
    /// The value is in normalized image space and measured over the range of -10000 to 10000 mapping to the uniform range [-1.0...1.0]. The interval of 0.0 to 1.0 or 0 to 10000 maps onto the stereo eye view image width. The negative interval 0.0 to -1.0 or 0 to -10000 similarly map onto the stereo eye view image width. Can be nil if the value is unknown.
    public var disparityAdjustment: Int32?

    /// Initializes an AVSpatialVideoConfiguration instance with all the properties set to nil.
    public init()

    /// Initializes an AVSpatialVideoConfiguration with a format description.
    ///
    /// The format description is not stored.
    /// - Parameter formatDescription: Format description to use to initialize the AVSpatialVideoConfiguration.
    ///
    /// - Returns: An instance of AVSpatialVideoConfiguration
    public init(formatDescription: CMFormatDescription)
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
@available(watchOS, unavailable)
extension AVSpatialVideoConfiguration {

    /// A non-spatial video configuration.
    public static var nonSpatial: AVSpatialVideoConfiguration { get }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVPlayerInterstitialEvent {

    /**
         AVPlayerInterstitialEvent initializer by time
    
         - Parameters:
            - primaryItem: The AVPlayerItem playing the primary content, against which the interstitial event will be scheduled.
            - identifier: A persistent identifier for the event.
            - time: The time within the duration of the primary item at which playback of the primary content should be temporarily suspended and the interstitial items played.
            - templateItems: An array of AVPlayerItems with configurations that will be reproduced for the playback of interstitial content.
            - restrictions: Indicates restrictions on the use of end user playback controls that are imposed by the event.
            - resumptionOffset: Specifies the offset in time at which playback of the primary item should resume after interstitial playback has finished. Definite numeric values are supported. The value .indefinite can also be used, in order to specify that the effective resumption time offset should accord with the wallclock time elapsed during interstitial playback.
            - playoutLimit: Specifies the offset from the beginning of the interstitial at which interstitial playback should end, if the interstitial asset(s) are longer. Pass a positive numeric value, or .invalid to indicate no playout limit.
            - userDefinedAttributes: Storage for attributes defined by the client or the content vendor. Attribute names should begin with X- for uniformity with server insertion.
         */
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
    public convenience init(primaryItem: AVPlayerItem, identifier: String?, time: CMTime, templateItems: [AVPlayerItem], restrictions: AVPlayerInterstitialEvent.Restrictions = [], resumptionOffset: CMTime = .indefinite, playoutLimit: CMTime = .invalid, userDefinedAttributes: [String : Any] = [:])

    /**
         AVPlayerInterstitialEvent initializer by date
    
         - Parameters:
            - primaryItem: The AVPlayerItem playing the primary content, against which the interstitial event will be scheduled. The primaryItem must have an AVAsset that provides an intrinsic mapping from its timeline to real-time dates.
            - identifier: A persistent identifier for the event.
            - date: The date within the date range of the primary item at which playback of the primary content should be temporarily suspended and the interstitial items played.
            - templateItems: An array of AVPlayerItems with configurations that will be reproduced for the playback of interstitial content.
            - restrictions: Indicates restrictions on the use of end user playback controls that are imposed by the event.
            - resumptionOffset: Specifies the offset in time at which playback of the primary item should resume after interstitial playback has finished. Definite numeric values are supported. The value .indefinite can also be used, in order to specify that the effective resumption time offset should accord with the wallclock time elapsed during interstitial playback.
            - playoutLimit: Specifies the offset from the beginning of the interstitial at which interstitial playback should end, if the interstitial asset(s) are longer. Pass a positive numeric value, or .invalid to indicate no playout limit.
            - userDefinedAttributes: Storage for attributes defined by the client or the content vendor. Attribute names should begin with X- for uniformity with server insertion.
         */
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
    public convenience init(primaryItem: AVPlayerItem, identifier: String?, date: Date, templateItems: [AVPlayerItem], restrictions: AVPlayerInterstitialEvent.Restrictions = [], resumptionOffset: CMTime = .indefinite, playoutLimit: CMTime = .invalid, userDefinedAttributes: [String : Any] = [:])
}

extension NSNotification.Name {

    @available(macOS, introduced: 13.3, deprecated: 14.0, renamed: "AVPlayerInterstitialEventMonitor.assetListResponseStatusDidChangeNotification")
    @available(iOS, introduced: 16.4, deprecated: 17.0, renamed: "AVPlayerInterstitialEventMonitor.assetListResponseStatusDidChangeNotification")
    @available(tvOS, introduced: 16.4, deprecated: 17.0, renamed: "AVPlayerInterstitialEventMonitor.assetListResponseStatusDidChangeNotification")
    @available(watchOS, introduced: 9.4, deprecated: 10.0, renamed: "AVPlayerInterstitialEventMonitor.assetListResponseStatusDidChangeNotification")
    @available(visionOS, introduced: 1, deprecated: 1, renamed: "AVPlayerInterstitialEventMonitor.assetListResponseStatusDidChangeNotification")
    public static var AVPlayerInterstitialEventMonitorAssetListResponseStatusDidChange: NSNotification.Name { get }
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
@available(watchOS, unavailable)
extension AVAssetReaderOutput {

    /// Object used to reset an output provider to read specified time ranges.
    public class RandomAccessController {

        /// Starts reading over with a new set of time ranges.
        /// - Parameter timeRanges: The time ranges to read
        public func resetForReading(timeRanges: [CMTimeRange])

        /// Informs the provider that no more reconfiguration of time ranges is necessary and allows the attached AVAssetReader to advance to ``AVAssetReaderStatus/completed``.
        public func markConfigurationAsFinal()

        @objc deinit
    }
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
@available(watchOS, unavailable)
extension AVAssetReaderOutput {

    public protocol SupportedPayload {
    }

    /// Defines an interface for reading a single collection of smaples of a common media type from an AVAssetReader.
    public class Provider<Payload> where Payload : AVAssetReaderOutput.SupportedPayload {

        /// Retruns the next piece of media data.
        /// - Returns: Returns the next piece of media data with the specified Payload type. If no more media data is available, this method returns nil.
        /// - Throws: If the underlying reader encountered an error.
        nonisolated(nonsending) public func next() async throws -> Payload?

        @objc deinit
    }
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
@available(watchOS, unavailable)
extension CMReadySampleBuffer : AVAssetReaderOutput.SupportedPayload where Content == CMSampleBuffer.DynamicContent {
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
@available(watchOS, unavailable)
extension AVAssetReader {

    /// Attaches the output to the reader and returns an output provider for reading sample buffers.
    /// - Parameter output: The output to be attached to the reader.
    /// - Returns: A reader output provider with an interface for reading sample buffers.
    public func outputProvider(for output: AVAssetReaderOutput) -> sending AVAssetReaderOutput.Provider<CMReadySampleBuffer<CMSampleBuffer.DynamicContent>>

    /// Attaches the output to the reader and returns a tuple with an output provider for reading sample buffers, and an associated random access controller.
    /// - Parameter output: The output to be attached to the reader.
    /// - Returns: A tuple with an output provider for reading sample buffers, and an associated random access controller.
    public func outputProviderWithRandomAccess(for output: AVAssetReaderOutput) -> sending (AVAssetReaderOutput.Provider<CMReadySampleBuffer<CMSampleBuffer.DynamicContent>>, AVAssetReaderOutput.RandomAccessController)
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
@available(watchOS, unavailable)
extension AVTimedMetadataGroup : AVAssetReaderOutput.SupportedPayload {
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
@available(watchOS, unavailable)
extension AVAssetReader {

    /// Attaches the output to the reader and returns an output provider for reading timed metadata groups.
    /// - Parameter output: The output to be attached to the reader.
    /// - Returns: A reader output provider with an interface for reading timed metadata groups.
    public func outputMetadataProvider(for output: AVAssetReaderTrackOutput) -> sending AVAssetReaderOutput.Provider<AVTimedMetadataGroup>

    /// Attaches the output to the reader and returns a tuple with an output provider for timed metadata groups buffers, and an associated random access controller.
    /// - Parameter output: The output to be attached to the reader.
    /// - Returns: A tuple with an output provider for reading timed metadata groups, and an associated random access controller.
    public func outputMetadataProviderWithRandomAccess(for output: AVAssetReaderTrackOutput) -> sending (AVAssetReaderOutput.Provider<AVTimedMetadataGroup>, AVAssetReaderOutput.RandomAccessController)
}

@available(macOS 26.0, iOS 26.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension AVCaptionGroup : AVAssetReaderOutput.SupportedPayload {
}

@available(macOS 26.0, iOS 26.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension AVAssetReader {

    /// Attaches the output to the reader and returns an output provider for reading caption groups.
    /// - Parameter output: The output to be attached to the reader.
    /// - Returns: A reader output provider with an interface for reading caption groups.
    public func outputCaptionProvider(for output: AVAssetReaderTrackOutput, validationDelegate: (any AVAssetReaderCaptionValidationHandling)? = nil) -> sending AVAssetReaderOutput.Provider<AVCaptionGroup>

    /// Attaches the output to the reader and returns a tuple with an output provider for reading caption groups, and an associated random access controller.
    /// - Parameter output: The output to be attached to the reader.
    /// - Returns: A tuple with an output provider for reading caption groups, and an associated random access controller.
    public func outputCaptionProviderWithRandomAccess(for output: AVAssetReaderTrackOutput, validationDelegate: (any AVAssetReaderCaptionValidationHandling)? = nil) -> sending (AVAssetReaderOutput.Provider<AVCaptionGroup>, AVAssetReaderOutput.RandomAccessController)
}

@available(watchOS 6.0, *)
extension AVError {

    @available(swift 4.2)
    @available(macCatalyst 14.0, tvOS 17.0, *)
    @available(visionOS, unavailable)
    @available(watchOS, unavailable)
    public var device: AVCaptureDevice? { get }

    /// The time.
    @available(watchOS 6.0, *)
    public var time: CMTime? { get }

    /// The file size.
    @available(watchOS 6.0, *)
    public var fileSize: Int64? { get }

    /// The process ID number.
    @available(watchOS 6.0, *)
    public var processID: Int? { get }

    /// Whether the recording successfully finished.
    @available(watchOS 6.0, *)
    public var recordingSuccessfullyFinished: Bool? { get }

    /// The media type.
    @available(swift 4.2)
    @available(watchOS 6.0, *)
    public var mediaType: AVMediaType? { get }

    /// The media subtypes.
    @available(watchOS 6.0, *)
    public var mediaSubtypes: [Int]? { get }

    /// The presentation time stamp.
    @available(swift 4.2)
    @available(macOS 10.10, iOS 8.0, tvOS 9.0, watchOS 6.0, visionOS 1.0, *)
    public var presentationTimeStamp: CMTime? { get }

    /// The persistent track ID.
    @available(swift 4.2)
    @available(macOS 10.10, iOS 8.0, tvOS 9.0, watchOS 6.0, visionOS 1.0, *)
    public var persistentTrackID: CMPersistentTrackID? { get }

    /// The file type.
    @available(swift 4.2)
    @available(macOS 10.10, iOS 8.0, tvOS 9.0, watchOS 6.0, visionOS 1.0, *)
    public var fileType: AVFileType? { get }
}

@available(macOS 15.0, iOS 18.0, tvOS 18.0, *)
@available(visionOS, unavailable)
@available(watchOS, unavailable)
extension AVCaptureIndexPicker {

    @nonobjc public func setActionQueue(_ actionQueue: DispatchQueue, action: @escaping (Int) -> ())
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
@available(watchOS, unavailable)
extension AVPlayerLayer {

    /// Returns the pixel buffer which is currently being displayed.
    ///
    /// CVReadOnlyPixelBuffer can be nil if the current player's rate is non-zero, displayed pixel buffer is protected, no image is currently being displayed, or if the image is unavailable.
    /// - Returns: A CVReadOnlyPixelBuffer object.
    public func displayedReadOnlyPixelBuffer() -> CVReadOnlyPixelBuffer?
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
@available(watchOS, unavailable)
extension AVAssetWriterInput {

    /// Provides an interface for writing timed metadata groups to an input.
    public class MetadataReceiver {

        /// Suspends until the input is ready for more media data, then appends the timed metadata group.
        /// - Parameter timedMetadataGroup: The timed metadata group to be appended.
        /// - Throws: An error if the underlying writer failed.
        nonisolated(nonsending) public func append(_ timedMetadataGroup: AVTimedMetadataGroup) async throws

        /// Appends the timed metadata group synchronously if the input is ready for more media data.
        /// - Parameter timedMetadataGroup: The timed metadata group to be appended
        /// - Returns: Returns true if the append was successful, false if the input was not ready for more media data.
        /// - Throws: An error if the underlying writer failed.
        public func appendImmediately(_ timedMetadataGroup: AVTimedMetadataGroup) throws -> Bool

        /// Indicates to the AVAssetWriter that no more buffers will be appended to this receiver.
        public func finish()

        @objc deinit
    }
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
@available(watchOS, unavailable)
extension AVAssetWriter {

    /// Attaches the input to the writer and returns an input receiver for writing timed metadata group.
    /// - Parameter input: The input to be attached to the writer.
    /// - Returns: A writer input receiver with an interface for writing timed metadata group.
    public func inputMetadataReceiver(for input: AVAssetWriterInput) -> sending AVAssetWriterInput.MetadataReceiver

    /// Attaches the input to the writer and returns a tuple with an input receiver for writing timed metadata group, and an associated multi pass controller.
    /// - Parameter input: The input to be attached to the writer.
    /// - Returns: A tuple with an input receiver for writing timed metadata group, and an associated multi pass controller.
    public func inputMetadataReceiverRequestingMultiPass(for input: AVAssetWriterInput) -> sending (AVAssetWriterInput.MetadataReceiver, AVAssetWriterInput.MultiPassController)
}

@available(macOS 26.0, iOS 26.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension AVRenderedCaptionImage {

    /**
    	 A CVReadOnlyPixelBuffer that contains pixel data for the rendered caption
    	 
    	 The pixel format is fixed to `kCVPixelFormatType_32BGRA` defined in <CoreVideo/CVPixelBuffer.h>
    	 */
    public var readOnlyPixelBuffer: CVReadOnlyPixelBuffer { get }
}

@available(macOS 10.13, iOS 11.0, macCatalyst 14.0, tvOS 11.0, visionOS 1.0, *)
@available(watchOS, unavailable)
extension AVDepthData {

    @available(macOS 10.13, iOS 11.0, macCatalyst 14.0, tvOS 11.0, visionOS 1.0, *)
    @available(watchOS, unavailable)
    @nonobjc public var availableDepthDataTypes: [OSType] { get }
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, watchOS 26.0, *)
extension CMReadySampleBuffer {

    /// Attaches an AVContentKey to a CMReadySampleBuffer for the purpose of content decryption.
    /// The client is expected to attach AVContentKeys to CMReadySampleBuffers that have been created by the client for enqueueing with AVSampleBufferDisplayLayer or AVSampleBufferAudioRenderer, for which the AVContentKeySpecifier matches indications of suitability that are available to the client according to the content key system that's in use.
    ///
    /// - Parameter contentKey: The content key to be attached.
    ///
    /// - Throws: Describes the reason for failure to attach the content key.
    public mutating func attach(contentKey: AVContentKey) throws
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, watchOS 26.0, *)
extension AVTimedMetadataGroup {

    /// Initializes an instance of AVTimedMetadataGroup with a ready sample buffer.
    /// - Parameter sampleBuffer: A CMReadySampleBuffer with media type kCMMediaType_Metadata.
    ///
    /// - Returns: An instance of AVTimedMetadataGroup.
    public convenience init?(sampleBuffer: CMReadySampleBuffer<CMSampleBuffer.DynamicContent>)
}

@available(macOS 26.0, iOS 26.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension AVAssetWriterInput {

    /// Provides an interface for writing caption data to an input.
    public class CaptionReceiver {

        /// Suspends until the input is ready for more media data, then appends the caption.
        /// - Parameter caption: The caption to be appended.
        /// - Throws: An error if the underlying writer failed.
        nonisolated(nonsending) public func append(_ caption: AVCaption) async throws

        /// Suspends until the input is ready for more media data, then appends the caption group.
        /// - Parameter captionGroup: The caption group to be appended.
        /// - Throws: An error if the underlying writer failed.
        nonisolated(nonsending) public func append(_ captionGroup: AVCaptionGroup) async throws

        /// Appends the caption synchronously if the input is ready for more media data.
        /// - Parameter caption: The caption to be appended.
        /// - Returns: Returns true if the append was successful, false if the input was not ready for more media data.
        /// - Throws: An error if the underlying writer failed.
        public func appendImmediately(_ caption: AVCaption) throws -> Bool

        /// Appends the caption group synchronously if the input is ready for more media data.
        /// - Parameter captionGroup: The caption group to be appended.
        /// - Returns: Returns true if the append was successful, false if the input was not ready for more media data.
        /// - Throws: An error if the underlying writer failed.
        public func appendImmediately(_ captionGroup: AVCaptionGroup) throws -> Bool

        /// Indicates to the AVAssetWriter that no more buffers will be appended to this receiver.
        public func finish()

        @objc deinit
    }
}

@available(macOS 26.0, iOS 26.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension AVAssetWriter {

    /// Attaches the input to the writer and returns an input receiver for writing caption data.
    /// - Parameter input: The input to be attached to the writer.
    /// - Returns: A writer input receiver with an interface for writing caption data.
    public func inputCaptionReceiver(for input: AVAssetWriterInput) -> sending AVAssetWriterInput.CaptionReceiver

    /// Attaches the input to the writer and returns a tuple with an input receiver for writing caption data, and an associated multi pass controller.
    /// - Parameter input: The input to be attached to the writer.
    /// - Returns: A tuple with an input receiver for writing caption data, and an associated multi pass controller.
    public func inputCaptionReceiverRequestingMultiPass(for input: AVAssetWriterInput) -> sending (AVAssetWriterInput.CaptionReceiver, AVAssetWriterInput.MultiPassController)
}

extension NSNotification.Name {

    @available(macOS, introduced: 10.7, deprecated: 15.0, renamed: "AVCaptureSession.runtimeErrorNotification")
    @available(iOS, introduced: 4.0, deprecated: 18.0, renamed: "AVCaptureSession.runtimeErrorNotification")
    @available(macCatalyst, introduced: 14.0, deprecated: 18.0, renamed: "AVCaptureSession.runtimeErrorNotification")
    @available(tvOS, introduced: 17.0, deprecated: 18.0, renamed: "AVCaptureSession.runtimeErrorNotification")
    @available(visionOS, introduced: 1.0, deprecated: 2.0, renamed: "AVCaptureSession.runtimeErrorNotification")
    @available(watchOS, unavailable)
    public static var AVCaptureSessionRuntimeError: NSNotification.Name { get }

    @available(macOS, introduced: 10.7, deprecated: 15.0, renamed: "AVCaptureSession.didStartRunningNotification")
    @available(iOS, introduced: 4.0, deprecated: 18.0, renamed: "AVCaptureSession.didStartRunningNotification")
    @available(macCatalyst, introduced: 14.0, deprecated: 18.0, renamed: "AVCaptureSession.didStartRunningNotification")
    @available(tvOS, introduced: 17.0, deprecated: 18.0, renamed: "AVCaptureSession.didStartRunningNotification")
    @available(visionOS, introduced: 1.0, deprecated: 2.0, renamed: "AVCaptureSession.didStartRunningNotification")
    @available(watchOS, unavailable)
    public static var AVCaptureSessionDidStartRunning: NSNotification.Name { get }

    @available(macOS, introduced: 10.7, deprecated: 15.0, renamed: "AVCaptureSession.didStopRunningNotification")
    @available(iOS, introduced: 4.0, deprecated: 18.0, renamed: "AVCaptureSession.didStopRunningNotification")
    @available(macCatalyst, introduced: 14.0, deprecated: 18.0, renamed: "AVCaptureSession.didStopRunningNotification")
    @available(tvOS, introduced: 17.0, deprecated: 18.0, renamed: "AVCaptureSession.didStopRunningNotification")
    @available(visionOS, introduced: 1.0, deprecated: 2.0, renamed: "AVCaptureSession.didStopRunningNotification")
    @available(watchOS, unavailable)
    public static var AVCaptureSessionDidStopRunning: NSNotification.Name { get }

    @available(macOS, introduced: 10.14, deprecated: 15.0, renamed: "AVCaptureSession.wasInterruptedNotification")
    @available(iOS, introduced: 4.0, deprecated: 18.0, renamed: "AVCaptureSession.wasInterruptedNotification")
    @available(macCatalyst, introduced: 14.0, deprecated: 18.0, renamed: "AVCaptureSession.wasInterruptedNotification")
    @available(tvOS, introduced: 17.0, deprecated: 18.0, renamed: "AVCaptureSession.wasInterruptedNotification")
    @available(visionOS, introduced: 1.0, deprecated: 2.0, renamed: "AVCaptureSession.wasInterruptedNotification")
    @available(watchOS, unavailable)
    public static var AVCaptureSessionWasInterrupted: NSNotification.Name { get }

    @available(macOS, introduced: 10.14, deprecated: 15.0, renamed: "AVCaptureSession.interruptionEndedNotification")
    @available(iOS, introduced: 4.0, deprecated: 18.0, renamed: "AVCaptureSession.interruptionEndedNotification")
    @available(macCatalyst, introduced: 14.0, deprecated: 18.0, renamed: "AVCaptureSession.interruptionEndedNotification")
    @available(tvOS, introduced: 17.0, deprecated: 18.0, renamed: "AVCaptureSession.interruptionEndedNotification")
    @available(visionOS, introduced: 1.0, deprecated: 2.0, renamed: "AVCaptureSession.interruptionEndedNotification")
    @available(watchOS, unavailable)
    public static var AVCaptureSessionInterruptionEnded: NSNotification.Name { get }
}

extension AVAsynchronousKeyValueLoading {

    /**
         Get current status of a property
    
         - Parameters:
            - property: Property to be checked.
         - Returns: Current status of the property
    
         If the property is already loaded, Status contains the value of the property.
         If the property failed to load, Status contains the error identifier.
    	 If property loading was cancelled, the status will be .failed and the error will be an NSError with domain AVFoundationErrorDomain and code AVError.operationCancelled.rawValue.
         */
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
    public func status<T>(of property: AVAsyncProperty<Self, T>) -> AVAsyncProperty<Self, T>.Status

    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
    @backDeployed(before: macOS 26.0, iOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0)
    public func load<T>(_ property: AVAsyncProperty<Self, T>, isolation: isolated (any Actor)? = #isolation) async throws -> T

    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
    @backDeployed(before: macOS 26.0, iOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0)
    public func load<A, B, each C>(_ firstProperty: AVAsyncProperty<Self, A>, _ secondProperty: AVAsyncProperty<Self, B>, _ properties: repeat AVAsyncProperty<Self, each C>, isolation: isolated (any Actor)? = #isolation) async throws -> (A, B, repeat each C)
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
@available(watchOS, unavailable)
extension AVAssetWriterInput {

    /// Provides an interface for writing sample buffers to an input.
    public class SampleBufferReceiver {

        /// Suspends until the input is ready for more media data, then appends the sample buffer.
        /// - Parameter sampleBuffer: The sample buffer to be appended.
        /// - Throws: An error if the underlying writer failed.
        nonisolated(nonsending) public func append(_ sampleBuffer: CMReadySampleBuffer<CMSampleBuffer.DynamicContent>) async throws

        /// Appends the sample buffer synchronously if the input is ready for more media data.
        /// - Parameter sampleBuffer: The sample buffer to be appended
        /// - Returns: Returns true if the append was successful, false if the input was not ready for more media data.
        /// - Throws: An error if the underlying writer failed.
        public func appendImmediately(_ sampleBuffer: CMReadySampleBuffer<CMSampleBuffer.DynamicContent>) throws -> Bool

        /// Indicates to the AVAssetWriter that no more buffers will be appended to this receiver.
        public func finish()

        @objc deinit
    }
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
@available(watchOS, unavailable)
extension AVAssetWriter {

    /// Attaches the input to the writer and returns an input receiver for writing sample buffers.
    /// - Parameter input: The input to be attached to the writer.
    /// - Returns: A writer input receiver with an interface for writing sample buffers.
    public func inputReceiver(for input: AVAssetWriterInput) -> sending AVAssetWriterInput.SampleBufferReceiver

    /// Attaches the input to the writer and returns a tuple with an input receiver for writing sample buffers, and an associated multi pass controller.
    /// - Parameter input: The input to be attached to the writer.
    /// - Returns: A tuple with an input receiver for writing sample buffers, and an associated multi pass controller.
    public func inputReceiverRequestingMultiPass(for input: AVAssetWriterInput) -> sending (AVAssetWriterInput.SampleBufferReceiver, AVAssetWriterInput.MultiPassController)
}

@available(macOS 11.0, iOS 7.0, macCatalyst 14.0, tvOS 17.0, *)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension AVMetadataMachineReadableCodeObject {

    @nonobjc public var corners: [CGPoint] { get }
}

@available(macOS 26.0, iOS 26.0, watchOS 26.0, *)
@available(tvOS, unavailable)
extension AVMutableMovieTrack {

    /// Appends sample data to a media file and adds sample references for the added data to a track's media sample tables.
    ///
    /// If the ready sample buffer carries sample data, the sample data is written to the container specified by the track property mediaDataStorage if non-nil, or else by the movie property defaultMediaDataStorage if non-nil, and sample references will be appended to the track's media. If both media data storage properties are nil, the method will fail with an error.
    ///
    /// If the sample buffer carries sample references only, sample data will not be written and sample references to the samples in their original container will be appended to the track's media as necessary.
    /// Note regarding sample timing: in a track's media, the first sample's decode timestamp must always be zero. For an audio track, each sample buffer's duration is used as the sample decode duration. For other track types, difference between a sample's decode timestamp and the following sample's decode timestamp is used as the first sample's decode duration, so as to preserve the relative timing.
    ///
    /// Note that this method does not modify the track's sourceTimeMappings but only appends sample references and sample data to the track's media. To make the new samples appear in the track's timeline, invoke -insertMediaTimeRange:intoTimeRange:. You can retrieve the mediaPresentationTimeRange property before and after appending a sequence of samples, using CMTimeRangeGetEnd on each to calculate the media TimeRange for -insertMediaTimeRange:intoTimeRange:.
    ///
    /// Note that this method expects
    /// - the sample buffer's media type must match with track's media type
    /// - the sample buffer must contain encoded video (should not contain image buffers)
    /// - the sample buffer must contain encoded media data (should not contain caption groups)
    ///
    /// It's safe for multiple threads to call this method on different tracks at once.
    ///
    /// - Parameter sampleBuffer: The CMReadySampleBuffer to be appended; this may be obtained from an instance of AVAssetReader.
    /// - Returns: A tuple containing the decodeTime & presentationTime.
    ///   - decodeTime: CMTime structure to receive the decode time in the media of the first sample appended from the sample buffer.
    ///   - presentationTime: CMTime structure to receive the presentation time in the media of the first sample appended from the sample buffer. Pass NULL if you do not need this information.
    ///
    /// - Throws: This method throws AVErrorDiskFull if the device containing the track's media data storage is full.
    public func append(_ sampleBuffer: CMReadySampleBuffer<CMSampleBuffer.DynamicContent>) throws -> (decodeTime: CMTime, presentationTime: CMTime)
}

extension AVAsset {

    /**
         Tests, in order of preference, for a match between language identifiers in the specified array of preferred languages and the available chapter locales,
         and loads the array of chapters corresponding to the first match that's found.
    
         - Parameters:
            - locale: Locale of the metadata items carrying chapter titles to be returned (supports the IETF BCP 47 specification).
            - commonKeys: Array of common keys of AVMetadataItem to be included; if no common keys are required, send an empty list. AVMetadataCommonKeyArtwork is the only supported key for now.
         - Returns: An array of AVTimedMetadataGroup objects.
    
         Each object in the array always contains an AVMetadataItem representing the chapter title; the timeRange property of the AVTimedMetadataGroup object is equal to the time range of the chapter title item. An AVMetadataItem with the specified common key will be added to an existing AVTimedMetadataGroup object if the time range (timestamp and duration) of the metadata item and the metadata group overlaps. The locale of items not carrying chapter titles need not match the specified locale parameter. Further filtering of the metadata items in AVTimedMetadataGroups according to language can be accomplished using `AVMetadataItem.metadataItems(from:filteredAndSortedAccordingToPreferredLanguages:)`. Filtering of the metadata items according to locale can be accomplished using `AVMetadataItem.metadataItems(from:withLocale:)`.
         */
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
    public func loadChapterMetadataGroups(withTitleLocale locale: Locale, containingItemsWithCommonKeys commonKeys: [AVMetadataKey] = []) async throws -> [AVTimedMetadataGroup]
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
@available(watchOS, unavailable)
extension AVPlayerItemVideoOutput {

    /**
    	 Initializes an instance of AVPlayerItemVideoOutput, using the specified pixel buffer attributes, for video image output
    	 
    	 - Parameters:
    		- pixelBufferAttributes: The client requirements for output pixel buffers
    	 */
    public convenience init(pixelBufferAttributes: CVPixelBufferAttributes)

    /**
    	 Retrieves an image that is appropriate for display at the specified item time, and marks the image as acquired
    	 
    	 - Parameters:
    		- itemTime: A CMTime that expresses a desired item time
    	 - Returns: A tuple containing the image to be displayed and a CMTime representing the true display deadline for the pixel buffer
    	 
    	 Typically you would call this method in response to a CADisplayLink delegate invocation and if hasNewPixelBuffer(forItemTime:) also returns true.
    	 
    	 The buffer retrieved from pixelBufferAndDisplayTime(forItemTime:) may itself be nil. A nil pixel buffer communicates that nothing should be displayed for the supplied item time.
    	 */
    public func pixelBufferAndDisplayTime(forItemTime itemTime: CMTime) -> (pixelBuffer: CVReadOnlyPixelBuffer?, itemTimeForDisplay: CMTime)
}

@available(macOS 15, iOS 18, tvOS 18, visionOS 2, *)
@available(watchOS, unavailable)
extension AVAssetResourceLoader : @unchecked Sendable {
}

@available(macOS 15, iOS 18, tvOS 18, visionOS 2, *)
@available(watchOS, unavailable)
extension AVAssetResourceLoadingRequest : @unchecked Sendable {
}

@available(macOS 15, iOS 18, tvOS 18, visionOS 2, *)
@available(watchOS, unavailable)
extension AVAssetResourceLoadingRequestor : @unchecked Sendable {
}

@available(macOS 15, iOS 18, tvOS 18, visionOS 2, *)
@available(watchOS, unavailable)
extension AVAssetResourceRenewalRequest : @unchecked Sendable {
}

@available(macOS 15, iOS 18, tvOS 18, visionOS 2, *)
@available(watchOS, unavailable)
extension AVAssetResourceLoadingContentInformationRequest : @unchecked Sendable {
}

@available(macOS 15, iOS 18, tvOS 18, visionOS 2, *)
@available(watchOS, unavailable)
extension AVAssetResourceLoadingDataRequest : @unchecked Sendable {
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, watchOS 26.0, *)
extension AVPlayerItemTrack : Observable {
}

@available(macOS 12.0, iOS 18.0, macCatalyst 15.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension AVCaption {

    @nonobjc public func textColor(at index: String.Index) -> (CGColor?, Range<String.Index>)

    @nonobjc public func backgroundColor(at index: String.Index) -> (CGColor?, Range<String.Index>)

    @nonobjc public func fontWeight(at index: String.Index) -> (AVCaption.FontWeight, Range<String.Index>)

    @nonobjc public func fontStyle(at index: String.Index) -> (AVCaption.FontStyle, Range<String.Index>)

    @nonobjc public func decoration(at index: String.Index) -> (AVCaption.Decoration, Range<String.Index>)

    @nonobjc public func textCombine(at index: String.Index) -> (AVCaption.TextCombine, Range<String.Index>)

    @nonobjc public func ruby(at index: String.Index) -> (AVCaption.Ruby?, Range<String.Index>)
}

@available(macOS 12.0, iOS 18.0, macCatalyst 15.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension AVMutableCaption {

    @nonobjc public func setTextColor(_ textColor: CGColor, in range: NSRange)

    @nonobjc public func setBackgroundColor(_ backgroundColor: CGColor, in range: NSRange)

    @nonobjc public func setFontWeight(_ fontWeight: AVCaption.FontWeight, in range: NSRange)

    @nonobjc public func setFontStyle(_ fontStyle: AVCaption.FontStyle, in range: NSRange)

    @nonobjc public func setDecoration(_ decoration: AVCaption.Decoration, in range: NSRange)

    @nonobjc public func setTextCombine(_ textCombine: AVCaption.TextCombine, in range: NSRange)

    @nonobjc public func setRuby(_ rubyText: AVCaption.Ruby, in range: NSRange)

    @nonobjc public func removeTextColor(in range: NSRange)

    @nonobjc public func removeBackgroundColor(in range: NSRange)

    @nonobjc public func removeFontWeight(in range: NSRange)

    @nonobjc public func removeFontStyle(in range: NSRange)

    @nonobjc public func removeDecoration(in range: NSRange)

    @nonobjc public func removeTextCombine(in range: NSRange)

    @nonobjc public func removeRuby(in range: NSRange)
}

@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
extension AVMetricEventStreamPublisher {

    public func metrics<MetricEvent>(forType metricType: MetricEvent.Type) -> AVMetrics<MetricEvent> where MetricEvent : AVMetricEvent

    public func allMetrics() -> AVMetrics<AVMetricEvent>
}

@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
extension AVMetricPlayerItemLikelyToKeepUpEvent {

    /**
    	- Parameter loadedTimeRanges: Provides a collection of time ranges for which the player has the media data readily available. The ranges provided might be discontinuous. 
    	- Returns: An array containing CMTimeRanges.
    	 */
    @nonobjc public var loadedTimeRanges: [CMTimeRange] { get }
}

@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
extension AVMetricPlayerItemVariantSwitchEvent {

    /**
    	- Parameter loadedTimeRanges: Provides a collection of time ranges for which the player has the media data readily available. The ranges provided might be discontinuous.
    	- Returns: An array containing CMTimeRanges.
    	 */
    @nonobjc public var loadedTimeRanges: [CMTimeRange] { get }
}

@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
extension AVMetricPlayerItemVariantSwitchStartEvent {

    /**
    	- Parameter loadedTimeRanges: Provides a collection of time ranges for which the player has the media data readily available. The ranges provided might be discontinuous.
    	- Returns: An array containing CMTimeRanges.
    	 */
    @nonobjc public var loadedTimeRanges: [CMTimeRange] { get }
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, visionOS 1, *)
@available(watchOS, unavailable)
extension AVVideoComposition {

    @objc(_sourceSampleDataTrackIDs) dynamic public var sourceSampleDataTrackIDs: [CMPersistentTrackID] { get }

    /// The output buffers of the video composition can be specified with the outputBufferDescription. The value is an array of an array of CMTag objects that describes the output buffers.
    ///
    /// If the video composition will output tagged buffers, the details of those buffers should be specified with CMTags. Specifically, the StereoView (eyes) and ProjectionKind must be specified. The behavior is undefined if the output buffers do not match the outputBufferDescription.
    /// The default is nil, which means monoscopic output. Note that an empty array is not valid.
    /// Note that tagged buffers are only supported for custom compositors.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    @available(watchOS, unavailable)
    public var outputBufferDescription: [[CMTag]]? { get }

    /// Indicates the spatial configurations that are available to associate with the output of the video composition.
    ///
    /// A custom compositor can output spatial video by specifying one of these spatial configurations. A spatial configuration with all nil values indicates the video is not spatial. A nil spatial configuration also indicates the video is not spatial. The value can be nil, which indicates the output will not be spatial.
    /// NOTE: If this property is not empty, then the client must attach one of the spatial configurations in this array to all of the pixel buffers, otherwise an exception will be thrown.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, watchOS 26.0, *)
    @available(watchOS, unavailable)
    public var spatialVideoConfigurations: [AVSpatialVideoConfiguration] { get }
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, visionOS 1, *)
@available(watchOS, unavailable)
extension AVMutableVideoComposition {

    @objc(_sourceSampleDataTrackIDs) override dynamic public var sourceSampleDataTrackIDs: [CMPersistentTrackID]
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
@available(watchOS, unavailable)
extension AVVideoComposition : @unchecked Sendable {
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
@available(watchOS, unavailable)
extension AVVideoComposition {

    /// Creates a video composition configured to apply Core Image filters to each video frame of the specified asset.
    /// - Parameter asset: The asset whose configuration matches the intended use of the video composition.
    /// - Parameter applier: A closure that AVFoundation calls when processing each video frame.
    /// - Returns: A new AVVideoComposition instance configured for Core Image filtering.
    nonisolated(nonsending) public convenience init(applyingFiltersTo asset: AVAsset, applier: @escaping @Sendable (AVCIImageFilteringParameters) async throws -> AVCIImageFilteringResult) async throws

    /// Configurable properties for initializing a new AVVideoComposition instance.
    public struct Configuration : Sendable {

        /// A video composition tool to use with Core Animation in offline rendering.
        public var animationTool: AVVideoCompositionCoreAnimationTool?

        /// The color primaries used for video composition.
        public var colorPrimaries: String?

        /// The transfer function used for video composition.
        public var colorTransferFunction: String?

        /// The YCbCr matrix used for video composition.
        public var colorYCbCrMatrix: String?

        /// A custom compositor class to use.
        public var customVideoCompositorClass: (any AVVideoCompositing.Type)?

        /// A time interval for which the video composition should render composed video frames.
        public var frameDuration: CMTime

        /// The video composition instructions.
        public var instructions: [any AVVideoCompositionInstructionProtocol]

        /// The output buffers of the video composition can be specified with the outputBufferDescription. The value is an array of an array of CMTag objects that describes the output buffers.
        ///
        /// If the video composition will output tagged buffers, the details of those buffers should be specified with CMTags. Specifically, the StereoView (eyes) and ProjectionKind must be specified. The behavior is undefined if the output buffers do not match the outputBufferDescription.
        /// The default is nil, which means monoscopic output. Note that an empty array is not valid.
        /// Note that tagged buffers are only supported for custom compositors.
        public var outputBufferDescription: [[CMTag]]?

        /// Indicates the spatial configurations that are available to associate with the output of the video composition.
        ///
        /// A custom compositor can output spatial video by specifying one of these spatial configurations. A spatial configuration with all nil values indicates the video is not spatial. A nil spatial configuration also indicates the video is not spatial. The value can be nil, which indicates the output will not be spatial.
        /// NOTE: If this property is not empty, then the client must attach one of the spatial configurations in this array to all of the pixel buffers, otherwise an exception will be thrown.
        public var spatialVideoConfigurations: [AVSpatialVideoConfiguration]

        /// The policy for display of HDR display metadata on the rendered frame.
        @available(tvOS, unavailable)
        public var perFrameHDRDisplayMetadataPolicy: AVVideoComposition.PerFrameHDRDisplayMetadataPolicy

        /// The scale at which the video composition should render.
        public var renderScale: Float

        /// The size at which the video composition should render.
        public var renderSize: CGSize

        /// The identifiers of source sample data tracks in the composition that the object requires to compose frames.
        public var sourceSampleDataTrackIDs: [CMPersistentTrackID]

        /// An identifier of the source track from which the video composition derives frame timing.
        public var sourceTrackIDForFrameTiming: CMPersistentTrackID

        /// Initializes a video composition configuration with the specified asset properties and optional prototype video composition instruction.
        /// - Parameter asset: asset to use with the video composition
        /// - Parameter prototypeInstruction: a video composition instruction to use as a prototype.
        nonisolated(nonsending) public init(for asset: AVAsset, prototypeInstruction: AVVideoCompositionInstruction? = nil) async throws

        @available(tvOS, unavailable)
        public init(animationTool: AVVideoCompositionCoreAnimationTool? = nil, colorPrimaries: String? = nil, colorTransferFunction: String? = nil, colorYCbCrMatrix: String? = nil, customVideoCompositorClass: (any AVVideoCompositing.Type)? = nil, frameDuration: CMTime = CMTime.zero, instructions: [any AVVideoCompositionInstructionProtocol] = [any AVVideoCompositionInstructionProtocol](), outputBufferDescription: [[CMTag]]? = nil, perFrameHDRDisplayMetadataPolicy: AVVideoComposition.PerFrameHDRDisplayMetadataPolicy = .propagate, renderScale: Float = 1.0, renderSize: CGSize = .zero, sourceSampleDataTrackIDs: [CMPersistentTrackID] = [CMPersistentTrackID](), sourceTrackIDForFrameTiming: Int32 = CMPersistentTrackID.zero, spatialVideoConfigurations: [AVSpatialVideoConfiguration] = [])
    }

    /// Initialize an AVVideoComposition with a configuration.
    /// - Parameter configuration: contains the property values for a new AVVideoComposition.
    public convenience init(configuration: AVVideoComposition.Configuration)
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
@available(watchOS, unavailable)
extension AVVideoCompositionInstruction {

    /// Configurable properties for initializing a new AVVideoCompositionInstruction instance.
    public struct Configuration : Sendable {

        /// The background color of the composition.
        public var backgroundColor: CGColor?

        /// A Boolean value that indicates whether the composition enables post-processing.
        public var enablePostProcessing: Bool

        /// Instructions that specify how to layer and compose video frames from source tracks.
        public var layerInstructions: [AVVideoCompositionLayerInstruction]

        /// The identifiers of source sample data tracks that the compositor requires to compose frames for the instruction.
        public var requiredSourceSampleDataTrackIDs: [CMPersistentTrackID]

        /// The time range to which the instruction applies.
        public var timeRange: CMTimeRange

        public init(backgroundColor: CGColor? = nil, enablePostProcessing: Bool = true, layerInstructions: [AVVideoCompositionLayerInstruction] = [], requiredSourceSampleDataTrackIDs: [CMPersistentTrackID] = [], timeRange: CMTimeRange = .zero)
    }

    /// Initialize an AVVideoCompositionInstruction with a configuration.
    /// - Parameter configuration: contains the property values for a new AVVideoCompositionInstruction.
    public convenience init(configuration: AVVideoCompositionInstruction.Configuration)
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
@available(watchOS, unavailable)
extension AVVideoCompositionLayerInstruction {

    /// Configurable properties for initializing a new AVVideoCompositionLayerInstruction instance.
    public struct Configuration : Sendable {

        /// The track identifier of the source track to which the compositor will apply the instruction.
        public var trackID: CMPersistentTrackID

        /// Creates a new video composition layer instruction for the given track ID.
        public init(trackID: CMPersistentTrackID = .zero)

        /// Creates a new video composition layer instruction for the given track.
        public init(assetTrack: AVAssetTrack)

        /// Obtains the crop rectangle ramp that includes the specified time.
        public func cropRectangleRamp(at time: CMTime) -> AVVideoCompositionLayerInstruction.CropRectangleRamp?

        /// Obtains the opacity ramp that includes a specified time.
        public func opacityRamp(at time: CMTime) -> AVVideoCompositionLayerInstruction.OpacityRamp?

        /// Obtains the transform ramp that includes a specified time.
        public func transformRamp(at time: CMTime) -> AVVideoCompositionLayerInstruction.TransformRamp?

        /// Sets the opacity value at a specific time within the time range of the instruction.
        public mutating func setOpacity(_ opacity: Float, at time: CMTime)

        /// Sets an opacity ramp to apply during a specified time range.
        public mutating func addOpacityRamp(_ ramp: AVVideoCompositionLayerInstruction.OpacityRamp)

        /// Sets the transform value at a time within the time range of the instruction.
        public mutating func setTransform(_ transform: CGAffineTransform, at time: CMTime)

        /// Sets a transform ramp to apply during a given time range.
        public mutating func addTransformRamp(_ ramp: AVVideoCompositionLayerInstruction.TransformRamp)

        /// Sets the crop rectangle value at a time within the time range of the instruction.
        public mutating func setCropRectangle(_ rect: CGRect, at time: CMTime)

        /// Sets a crop rectangle ramp to apply during the specified time range.
        public mutating func addCropRectangleRamp(_ ramp: AVVideoCompositionLayerInstruction.CropRectangleRamp)
    }

    /// Initialize an AVVideoCompositionLayerInstruction with a configuration.
    /// - Parameter configuration: contains the property values for a new AVVideoCompositionLayerInstruction.
    public convenience init(configuration: AVVideoCompositionLayerInstruction.Configuration)
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
@available(watchOS, unavailable)
extension AVVideoCompositionLayerInstruction {

    public struct CropRectangleRamp : Equatable, Sendable {

        public var timeRange: CMTimeRange

        public var start: CGRect

        public var end: CGRect

        public init(timeRange: CMTimeRange, start: CGRect, end: CGRect)

        /// Returns a Boolean value indicating whether two values are equal.
        ///
        /// Equality is the inverse of inequality. For any values `a` and `b`,
        /// `a == b` implies that `a != b` is `false`.
        ///
        /// - Parameters:
        ///   - lhs: A value to compare.
        ///   - rhs: Another value to compare.
        public static func == (a: AVVideoCompositionLayerInstruction.CropRectangleRamp, b: AVVideoCompositionLayerInstruction.CropRectangleRamp) -> Bool
    }

    public struct OpacityRamp : Equatable, Sendable {

        public var timeRange: CMTimeRange

        public var start: Float

        public var end: Float

        public init(timeRange: CMTimeRange, start: Float, end: Float)

        /// Returns a Boolean value indicating whether two values are equal.
        ///
        /// Equality is the inverse of inequality. For any values `a` and `b`,
        /// `a == b` implies that `a != b` is `false`.
        ///
        /// - Parameters:
        ///   - lhs: A value to compare.
        ///   - rhs: Another value to compare.
        public static func == (a: AVVideoCompositionLayerInstruction.OpacityRamp, b: AVVideoCompositionLayerInstruction.OpacityRamp) -> Bool
    }

    public struct TransformRamp : Equatable, Sendable {

        public var timeRange: CMTimeRange

        public var start: CGAffineTransform

        public var end: CGAffineTransform

        public init(timeRange: CMTimeRange, start: CGAffineTransform, end: CGAffineTransform)

        /// Returns a Boolean value indicating whether two values are equal.
        ///
        /// Equality is the inverse of inequality. For any values `a` and `b`,
        /// `a == b` implies that `a != b` is `false`.
        ///
        /// - Parameters:
        ///   - lhs: A value to compare.
        ///   - rhs: Another value to compare.
        public static func == (a: AVVideoCompositionLayerInstruction.TransformRamp, b: AVVideoCompositionLayerInstruction.TransformRamp) -> Bool
    }

    /// Obtains the crop rectangle ramp that includes the specified time.
    public func cropRectangleRamp(at time: CMTime) -> AVVideoCompositionLayerInstruction.CropRectangleRamp?

    /// Obtains the opacity ramp that includes a specified time.
    public func opacityRamp(at time: CMTime) -> AVVideoCompositionLayerInstruction.OpacityRamp?

    /// Obtains the transform ramp that includes a specified time.
    public func transformRamp(at time: CMTime) -> AVVideoCompositionLayerInstruction.TransformRamp?
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
@available(watchOS, unavailable)
extension AVVideoCompositionCoreAnimationTool {

    /// Configurable properties for initializing a new AVVideoCompositionCoreAnimationTool instance.
    public struct Configuration {

        /// Layer(s) to contain the composited video frames. Frames are duplicated if there is more than one layer.
        public var layers: [CALayer]

        /// Containing layer to be rendered into, producing the final frame.
        public var containingLayer: CALayer

        /// Duplicate the composited video frames in each videoLayer and render animationLayer
        /// to produce the final frame. Normally videoLayers should be in animationLayer's sublayer tree.
        /// The animationLayer should not come from, or be added to, another layer tree.
        /// Be aware that on iOS, CALayers backing a UIView usually have their content flipped (as defined by the
        /// -contentsAreFlipped method). It may be required to insert a CALayer with its geometryFlipped property set
        /// to YES in the layer hierarchy to get the same result when attaching a CALayer to a AVVideoCompositionCoreAnimationTool
        /// as when using it to back a UIView.
        public init(postProcessingAsVideoLayers layers: [CALayer], containingLayer: CALayer)

        /// Place composited video frames in videoLayer and render animationLayer
        /// to produce the final frame. Normally videoLayer should be in animationLayer's sublayer tree.
        /// The animationLayer should not come from, or be added to, another layer tree.
        /// Be aware that on iOS, CALayers backing a UIView usually have their content flipped (as defined by the
        /// -contentsAreFlipped method). It may be required to insert a CALayer with its geometryFlipped property set
        /// to YES in the layer hierarchy to get the same result when attaching a CALayer to a AVVideoCompositionCoreAnimationTool
        /// as when using it to back a UIView.
        public init(postProcessingAsVideoLayer layer: CALayer, containingLayer: CALayer)
    }

    /// Compose the composited video frames with the Core Animation layer.
    public convenience init(configuration: sending AVVideoCompositionCoreAnimationTool.Configuration)
}

@available(macOS, introduced: 14, deprecated: 26.0, message: "Use AVAssetWriterInput.TaggedPixelBufferGroupReceiver.append(_:with:isolation:) instead")
@available(iOS, introduced: 17, deprecated: 26.0, message: "Use AVAssetWriterInput.TaggedPixelBufferGroupReceiver.append(_:with:isolation:) instead")
@available(visionOS, introduced: 1, deprecated: 26.0, message: "Use AVAssetWriterInput.TaggedPixelBufferGroupReceiver.append(_:with:isolation:) instead")
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension AVAssetWriterInputTaggedPixelBufferGroupAdaptor {

    public func appendTaggedBuffers(_ taggedBuffers: [CMTaggedBuffer], withPresentationTime: CMTime) -> Bool
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
@available(watchOS, unavailable)
extension AVAssetWriterInput {

    /// Provides an interface to receive an async sequence of pass descriptions for the writer input receiver, if multi-pass is supported.
    public class MultiPassController {

        /// An async sequence of pass descriptions to iterate over if multi-pass is supported. This property is nil when multi-pass is not supported.
        public var passDescriptions: (some AsyncSequence<AVAssetWriterInputPassDescription, Never>)? { get }

        @objc deinit
    }
}

@available(macOS 15.0, iOS 18.0, tvOS 18.0, *)
@available(visionOS, unavailable)
@available(watchOS, unavailable)
extension AVCaptureSlider {

    @nonobjc public var prominentValues: [Float]

    @nonobjc public convenience init(_ localizedTitle: String, symbolName: String, in range: ClosedRange<Float>)

    @nonobjc public convenience init(_ localizedTitle: String, symbolName: String, in range: ClosedRange<Float>, step: Float)

    @nonobjc public convenience init(_ localizedTitle: String, symbolName: String, values: [Float])

    @nonobjc public func setActionQueue(_ actionQueue: DispatchQueue, action: @escaping (Float) -> ())
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, visionOS 1, *)
@available(watchOS, unavailable)
extension AVAsynchronousVideoCompositionRequest {

    @nonobjc public var sourceSampleDataTrackIDs: [CMPersistentTrackID] { get }
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
@available(watchOS, unavailable)
extension AVAsynchronousVideoCompositionRequest {

    /// Returns the source tagged dynamic buffers for the given track ID.
    /// Returns nil if the video track does not contain tagged buffers, or if the track does not contain video. This function should only be called when supportsSourceTaggedBuffers is YES.
    /// - Parameter byTrackID: The track ID for the requested source tagged dynamic buffers.
    /// - Returns: the source CMTaggedBuffer array for the given track ID.
    public func sourceTaggedDynamicBuffers(byTrackID trackID: CMPersistentTrackID) -> [CMTaggedDynamicBuffer]?
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
@available(watchOS, unavailable)
extension AVAsynchronousVideoCompositionRequest {

    /// Returns the source CVReadOnlyPixelBuffer for the given track ID.
    /// If the track contains tagged buffers, a pixel buffer from one of the tagged buffers will be returned.
    /// - Parameter trackID: The track ID for the requested source frame.
    /// - Returns: the source CVReadOnlyPixelBuffer for the given track ID.
    public func sourceReadOnlyPixelBuffer(byTrackID trackID: CMPersistentTrackID) -> CVReadOnlyPixelBuffer?

    /// Returns the source CMReadySampleBuffer for the given track ID.
    /// - Parameter trackID: The track ID for the requested source frame.
    /// - Returns: the source CMReadySampleBuffer for the given track ID.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    @available(watchOS, unavailable)
    public func sourceReadySampleBuffer(byTrackID trackID: CMPersistentTrackID) -> CMReadySampleBuffer<CMSampleBuffer.DynamicContent>?

    /// The method that the custom compositor calls when composition succeeds.
    /// - Parameter composedPixelBuffer: The video frame to finish with. Call finishWithComposedTaggedBufferGroup: instead if outputBufferDescription is non-nil.
    ///
    public func finish(withComposedPixelBuffer readOnlyPixelBuffer: CVReadOnlyPixelBuffer)

    /// The method that the custom compositor calls when composition succeeds.
    /// - Parameter taggedBuffers: The tagged buffers containing the composed tagged buffers. The tagged buffers must be compatible with the outputBufferDescription specified in the video composition. The outputBufferDescription must not be nil when calling this function.
    /// NOTE: If ``AVVideoComposition/spatialConfigurations`` is not empty, then ``attach(spatialVideoConfiguration:to:)`` must be called with one of the spatial configurations. An exception will be thrown otherwise. Also, all pixel buffers must be associated with the same spatial configuration. An exception will be thrown otherwise.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    @available(watchOS, unavailable)
    public func finish(withComposedTaggedBuffers taggedBuffers: [CMTaggedDynamicBuffer])

    /// Associates the pixel buffer with the specified spatial configuration.
    /// - Parameters:
    ///   - spatialVideoConfiguration: The spatial configuration to associate with the pixel buffer.
    ///   - pixelBuffer: The pixel buffer to associate with the spatial configuration.
    /// NOTE: The spatial configuration must be one of the spatial configurations specified in the AVVideoComposition's spatialConfigurations property. An exception will be thrown otherwise.
    /// NOTE: All pixel buffers from the custom compositor must be associated with the same spatial configuration. An exception will be thrown otherwise.
    /// Specify a value of .nonSpatial for spatialVideoConfiguration to indicate the video is not spatial, but note that a .nonSpatial configuration must be in the ``AVVideoComposition/spatialConfigurations`` property or an exception will be thrown.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    @available(watchOS, unavailable)
    public func attach(_ spatialVideoConfiguration: AVSpatialVideoConfiguration, to pixelBuffer: inout CVMutablePixelBuffer) throws
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
@available(watchOS, unavailable)
extension AVVideoCompositionRenderContext {

    /// Vends a CVMutablePixelBuffer to use for rendering.
    /// The buffer will have its kCVImageBufferCleanApertureKey and kCVImageBufferPixelAspectRatioKey attachments set to match the current composition processor properties.
    /// - Returns: a CVMutablePixelBuffer to use for rendering.
    /// - Throws: insufficient memory or other system error.
    public func makeMutablePixelBuffer() throws -> CVMutablePixelBuffer
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, watchOS 26.0, *)
extension AVPlayer : Observable {
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVAssetVariant {

    /**
    	- Parameter peakBitRate: If it is not declared, the value will be nil.
    	 */
    @nonobjc public var peakBitRate: Double? { get }

    /**
    	- Parameter averageBitRate: If it is not declared, the value will be nil.
    	 */
    @nonobjc public var averageBitRate: Double? { get }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVAssetVariant.VideoAttributes {

    /**
    	- Parameter nominalFrameRate: If it is not declared, the value will be nil.
    	 */
    @nonobjc public var nominalFrameRate: Double? { get }

    @nonobjc public var codecTypes: [CMVideoCodecType] { get }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVAssetVariant.AudioAttributes {

    @nonobjc public var formatIDs: [AudioFormatID] { get }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension AVAssetVariant.AudioAttributes.RenditionSpecificAttributes {

    /**
    	 - Parameter channelCount: If it is not declared, the value will be nil.
    	 */
    @nonobjc public var channelCount: Int? { get }
}

@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *)
extension AVAssetVariant.VideoAttributes : @unchecked Sendable {
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
@available(watchOS, unavailable)
extension AVAssetWriterInput {

    /// Provides an interface for writing pixel buffers to an input.
    public class PixelBufferReceiver {

        /// The pixel buffer attributes of pixel buffers that will be vended by the receiver's pixel buffer pool.
        public var sourcePixelBufferAttributes: CVPixelBufferCreationAttributes? { get }

        /// A pixel buffer pool that will vend and efficiently recycle pixel buffer objects that can be appended to the receiver.
        public var pixelBufferPool: CVMutablePixelBuffer.Pool? { get }

        /// Suspends until the input is ready for more media data, then appends the pixel buffer.
        /// - Parameter pixelBuffer: The pixel buffer to be appended.
        /// - Parameter presentationTime: The presentation time for the pixel buffer to be appended.
        /// - Throws: An error if the underlying writer failed.   
        nonisolated(nonsending) public func append(_ pixelBuffer: CVReadOnlyPixelBuffer, with presentationTime: CMTime) async throws

        /// Appends the pixel buffer synchronously if the input is ready for more media data.
        /// - Parameter pixelBuffer: The pixel buffer to be appended.
        /// - Parameter presentationTime: The presentation time for the pixel buffer to be appended.
        /// - Returns: Returns true if the append was successful, false if the input was not ready for more media data.
        /// - Throws: An error if the underlying writer failed.
        public func appendImmediately(_ pixelBuffer: CVReadOnlyPixelBuffer, with presentationTime: CMTime) throws -> Bool

        /// Indicates to the AVAssetWriter that no more buffers will be appended to this receiver.
        public func finish()

        @objc deinit
    }
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
@available(watchOS, unavailable)
extension AVAssetWriter {

    /// Attaches the input to the writer and returns an input receiver for writing pixel buffers.
    /// - Parameter input: The input to be attached to the writer.
    /// - Parameter attributes: The attributes of pixel buffers that will be vended by the input provider's pixel buffer pool.
    /// - Returns: A writer input receiver with an interface for writing pixel buffers.
    public func inputPixelBufferReceiver(for input: AVAssetWriterInput, pixelBufferAttributes attributes: CVPixelBufferCreationAttributes?) -> sending AVAssetWriterInput.PixelBufferReceiver

    /// Attaches the input to the writer and returns a tuple with an input receiver for writing pixel buffers, and an associated multi pass controller.
    /// - Parameter input: The input to be attached to the writer.
    /// - Parameter attributes: The attributes of pixel buffers that will be vended by the input provider's pixel buffer pool.
    /// - Returns: A tuple with an input receiver for writing pixel buffers, and an associated multi pass controller.
    public func inputPixelBufferReceiverRequestingMultiPass(for input: AVAssetWriterInput, pixelBufferAttributes attributes: CVPixelBufferCreationAttributes?) -> sending (AVAssetWriterInput.PixelBufferReceiver, AVAssetWriterInput.MultiPassController)
}

@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2.0, *)
extension AVPlayerItemSegment {

    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2.0, *)
    @nonobjc public var loadedTimeRanges: [CMTimeRange] { get }
}

@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2.0, *)
extension AVPlayerItemIntegratedTimelineSnapshot {

    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2.0, *)
    public func segmentAndOffsetIntoSegment(forTimelineTime: CMTime) -> (AVPlayerItemSegment, CMTime)
}

@available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2.0, *)
extension AVPlayerItemIntegratedTimeline {

    public struct PeriodicTimes : AsyncSequence, Sendable {

        /// The type of element produced by this asynchronous sequence.
        public typealias Element = CMTime

        /// Creates the asynchronous iterator that produces elements of this
        /// asynchronous sequence.
        ///
        /// - Returns: An instance of the `AsyncIterator` type used to produce
        /// elements of the asynchronous sequence.
        public func makeAsyncIterator() -> AVPlayerItemIntegratedTimeline.PeriodicTimes.Iterator

        public struct Iterator : AsyncIteratorProtocol {

            /// Asynchronously advances to the next element and returns it, or ends the
            /// sequence if there is no next element.
            ///
            /// - Returns: The next element, if it exists, or `nil` to signal the end of
            ///   the sequence.
            public mutating func next() async -> AVPlayerItemIntegratedTimeline.PeriodicTimes.Element?

            @available(iOS 18, tvOS 18, watchOS 11, visionOS 2.0, macOS 15, *)
            public typealias Element = AVPlayerItemIntegratedTimeline.PeriodicTimes.Element
        }

        /// The type of asynchronous iterator that produces elements of this
        /// asynchronous sequence.
        @available(iOS 18, tvOS 18, watchOS 11, visionOS 2.0, macOS 15, *)
        public typealias AsyncIterator = AVPlayerItemIntegratedTimeline.PeriodicTimes.Iterator
    }

    public struct BoundaryTimes : AsyncSequence, Sendable {

        /// The type of element produced by this asynchronous sequence.
        public typealias Element = CMTime

        /// Creates the asynchronous iterator that produces elements of this
        /// asynchronous sequence.
        ///
        /// - Returns: An instance of the `AsyncIterator` type used to produce
        /// elements of the asynchronous sequence.
        public func makeAsyncIterator() -> AVPlayerItemIntegratedTimeline.BoundaryTimes.Iterator

        public struct Iterator : AsyncIteratorProtocol {

            /// Asynchronously advances to the next element and returns it, or ends the
            /// sequence if there is no next element.
            ///
            /// - Returns: The next element, if it exists, or `nil` to signal the end of
            ///   the sequence.
            public mutating func next() async -> AVPlayerItemIntegratedTimeline.BoundaryTimes.Element?

            @available(iOS 18, tvOS 18, watchOS 11, visionOS 2.0, macOS 15, *)
            public typealias Element = AVPlayerItemIntegratedTimeline.BoundaryTimes.Element
        }

        /// The type of asynchronous iterator that produces elements of this
        /// asynchronous sequence.
        @available(iOS 18, tvOS 18, watchOS 11, visionOS 2.0, macOS 15, *)
        public typealias AsyncIterator = AVPlayerItemIntegratedTimeline.BoundaryTimes.Iterator
    }

    /**
     Returns an asynchronous sequence of Times periodically as playback progresses.
     */
    public func periodicTimes(forInterval: CMTime) -> AVPlayerItemIntegratedTimeline.PeriodicTimes

    /**
     Returns an asynchronous sequence of Times every time playback reaches segmentTime in the segment.
     One can configure boundaryTimes for traversal of a single point segment. If the segment is no longer
     mappable to the current timeline, the sequence will end.
     */
    public func boundaryTimes(for segment: AVPlayerItemSegment, offsetsIntoSegment: [CMTime]) -> AVPlayerItemIntegratedTimeline.BoundaryTimes
}

@available(iOS 11.0, macCatalyst 18.0, tvOS 17.0, *)
@available(macOS, unavailable)
@available(visionOS, unavailable)
@available(watchOS, unavailable)
extension AVCaptureSynchronizedDataCollection : Sequence {

    /// Returns an iterator over the elements of this sequence.
    public func makeIterator() -> AVCaptureSynchronizedDataCollection.Iterator

    /// A type that provides the sequence's iteration interface and
    /// encapsulates its iteration state.
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
        public mutating func next() -> AVCaptureSynchronizedData?

        /// The type of element traversed by the iterator.
        @available(iOS 11.0, tvOS 17.0, macCatalyst 18.0, *)
        @available(watchOS, unavailable)
        @available(visionOS, unavailable)
        @available(macOS, unavailable)
        public typealias Element = AVCaptureSynchronizedData
    }

    /// A type representing the sequence's elements.
    @available(iOS 11.0, tvOS 17.0, macCatalyst 18.0, *)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    @available(macOS, unavailable)
    public typealias Element = AVCaptureSynchronizedData
}

extension AVPlayerItem {

    /**
         AVPlayerItem initializer that loads supplied properties of an asset automatically
    
         - Parameters:
            - asset: Asset to load.
            - automaticallyLoadedAssetKeys: Asset properties to load automatically.
    
         The value of each key in automaticallyLoadedAssetKeys will be automatically be loaded by the underlying AVAsset before the receiver achieves the status `.readyToPlay`; i.e. when the item is ready to play, the value of `AVPlayerItem.asset.status(of:)` will be `.loaded` or `.failed`.
    	 
         This initializer, along with the companion `asset` property, is MainActor-isolated because AVAsset is not Sendable.  If you are using a Sendable subclass of AVAsset, such as AVURLAsset, an overload of this initializer will be chosen automatically to allow you to initialize an AVPlayerItem while not running on the main actor.
         */
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
    @MainActor @preconcurrency public convenience init(asset: AVAsset, automaticallyLoadedAssetKeys: [AVPartialAsyncProperty<AVAsset>] = [])

    /**
         AVPlayerItem initializer that can be called from any concurrency domain when provided with a Sendable asset.
    
         - Parameters:
            - asset: Asset to load.
         */
    @available(macOS 10.7, iOS 4.0, tvOS 9.0, watchOS 1.0, visionOS 1.0, *)
    nonisolated public convenience init(asset: any AVAsset & Sendable)

    /**
         AVPlayerItem initializer that loads supplied properties of a Sendable asset automatically and can be called from any concurrency domain
    
         - Parameters:
            - asset: Asset to load.
            - automaticallyLoadedAssetKeys: Asset properties to load automatically.
    
         The value of each key in automaticallyLoadedAssetKeys will be automatically be loaded by the underlying AVAsset before the receiver achieves the status `.readyToPlay`; i.e. when the item is ready to play, the value of `AVPlayerItem.asset.status(of:)` will be `.loaded` or `.failed`.
         */
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
    nonisolated public convenience init(asset: any AVAsset & Sendable, automaticallyLoadedAssetKeys: [AVPartialAsyncProperty<AVAsset>])

    /**
     Sets the current playback time to the time specified by the date.
     
     - Parameter date: The date to which to seek.
     - Returns: Returns true if the seek operation completed, false if it did not.
     
     Use this method to seek to a specified date in the player item and await the operation's completion. If the seek request completes without being interrupted (either by another seek request or by any other operation), this method will return true.
     
     If another seek request is already in progress when you call this method, the  the in-progress seek request immediately returns false.
     */
    @available(macOS 13, iOS 16, tvOS 16, watchOS 9, visionOS 1, *)
    nonisolated public func seek(to date: Date) async -> Bool
}

extension NSNotification.Name {

    @available(macOS, introduced: 10.7, deprecated: 100000, message: "Use AVPlayerItem.timeJumpedNotification instead.")
    @available(iOS, introduced: 5.0, deprecated: 100000, message: "Use AVPlayerItem.timeJumpedNotification instead.")
    @available(tvOS, introduced: 9.0, deprecated: 100000, message: "Use AVPlayerItem.timeJumpedNotification instead.")
    @available(watchOS, introduced: 1.0, deprecated: 100000, message: "Use AVPlayerItem.timeJumpedNotification instead.")
    @available(visionOS, introduced: 1.0, deprecated: 100000, message: "Use AVPlayerItem.timeJumpedNotification instead.")
    public static var AVPlayerItemTimeJumped: NSNotification.Name { get }

    @available(macOS, introduced: 10.9, deprecated: 100000, message: "Use AVPlayerItem.playbackStalledNotification instead.")
    @available(iOS, introduced: 6.0, deprecated: 100000, message: "Use AVPlayerItem.playbackStalledNotification instead.")
    @available(tvOS, introduced: 9.0, deprecated: 100000, message: "Use AVPlayerItem.playbackStalledNotification instead.")
    @available(watchOS, introduced: 1.0, deprecated: 100000, message: "Use AVPlayerItem.playbackStalledNotification instead.")
    @available(visionOS, introduced: 1.0, deprecated: 100000, message: "Use AVPlayerItem.playbackStalledNotification instead.")
    public static var AVPlayerItemPlaybackStalled: NSNotification.Name { get }

    @available(macOS, introduced: 10.9, deprecated: 100000, message: "Use AVPlayerItem.newErrorLogEntryNotification instead.")
    @available(iOS, introduced: 6.0, deprecated: 100000, message: "Use AVPlayerItem.newErrorLogEntryNotification instead.")
    @available(tvOS, introduced: 9.0, deprecated: 100000, message: "Use AVPlayerItem.newErrorLogEntryNotification instead.")
    @available(watchOS, introduced: 1.0, deprecated: 100000, message: "Use AVPlayerItem.newErrorLogEntryNotification instead.")
    @available(visionOS, introduced: 1.0, deprecated: 100000, message: "Use AVPlayerItem.newErrorLogEntryNotification instead.")
    public static var AVPlayerItemNewErrorLogEntry: NSNotification.Name { get }

    @available(macOS, introduced: 10.9, deprecated: 100000, message: "Use AVPlayerItem.newAccessLogEntryNotification instead.")
    @available(iOS, introduced: 6.0, deprecated: 100000, message: "Use AVPlayerItem.newAccessLogEntryNotification instead.")
    @available(tvOS, introduced: 9.0, deprecated: 100000, message: "Use AVPlayerItem.newAccessLogEntryNotification instead.")
    @available(watchOS, introduced: 1.0, deprecated: 100000, message: "Use AVPlayerItem.newAccessLogEntryNotification instead.")
    @available(visionOS, introduced: 1.0, deprecated: 100000, message: "Use AVPlayerItem.newAccessLogEntryNotification instead.")
    public static var AVPlayerItemNewAccessLogEntry: NSNotification.Name { get }

    @available(macOS, introduced: 10.7, deprecated: 100000, message: "Use AVPlayerItem.didPlayToEndTimeNotification instead.")
    @available(iOS, introduced: 4.0, deprecated: 100000, message: "Use AVPlayerItem.didPlayToEndTimeNotification instead.")
    @available(tvOS, introduced: 9.0, deprecated: 100000, message: "Use AVPlayerItem.didPlayToEndTimeNotification instead.")
    @available(watchOS, introduced: 1.0, deprecated: 100000, message: "Use AVPlayerItem.didPlayToEndTimeNotification instead.")
    @available(visionOS, introduced: 1.0, deprecated: 100000, message: "Use AVPlayerItem.didPlayToEndTimeNotification instead.")
    public static var AVPlayerItemDidPlayToEndTime: NSNotification.Name { get }

    @available(macOS, introduced: 10.7, deprecated: 100000, message: "Use AVPlayerItem.failedToPlayToEndTimeNotification instead.")
    @available(iOS, introduced: 4.3, deprecated: 100000, message: "Use AVPlayerItem.failedToPlayToEndTimeNotification instead.")
    @available(tvOS, introduced: 9.0, deprecated: 100000, message: "Use AVPlayerItem.failedToPlayToEndTimeNotification instead.")
    @available(watchOS, introduced: 1.0, deprecated: 100000, message: "Use AVPlayerItem.failedToPlayToEndTimeNotification instead.")
    @available(visionOS, introduced: 1.0, deprecated: 100000, message: "Use AVPlayerItem.failedToPlayToEndTimeNotification instead.")
    public static var AVPlayerItemFailedToPlayToEndTime: NSNotification.Name { get }
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, watchOS 26.0, *)
extension AVPlayerItem : Observable {
}

@available(watchOS, unavailable)
extension AVAssetImageGenerator {

    /// Creates an image object for an asset at or near specified the time.
    /// - Parameter time: The time at which the image of the asset is to be created.
    /// - Returns: A tuple containing the image object as a CGImage, and the time at which the image was actually generated as a CMTime.
    @available(macOS 13, iOS 16, tvOS 16, visionOS 1, *)
    @available(watchOS, unavailable)
    public func image(at time: CMTime) async throws -> (image: CGImage, actualTime: CMTime)

    /// Creates a series of image objects for an asset at or near specified times.
    /// - Parameter times: An array of times at which the images of the asset are to be created.
    /// - Returns: The generated images or errors for each time, as an asynchronous sequence of Results.
    @available(macOS 13, iOS 16, tvOS 16, visionOS 1, *)
    @available(watchOS, unavailable)
    public func images(for times: [CMTime]) -> sending AVAssetImageGenerator.Images

    /// An asynchronous sequence where each element is a Result<(requestedTime: CMTime, image: CGImage, actualTime: CMTime), Error>. When image generation is successful, the result is a tuple containing the requested time as a CMTime, the image object as a CGImage, and the time at which the image was actually generated as a CMTime. Otherwise, when image generation fails, the result contains an Error.
    @available(macOS 13, iOS 16, tvOS 16, visionOS 1, *)
    @available(watchOS, unavailable)
    public struct Images : AsyncSequence, AsyncIteratorProtocol {

        /// The type of element produced by this asynchronous sequence.
        @frozen public enum Element : Sendable {

            case success(requestedTime: CMTime, image: CGImage, actualTime: CMTime)

            case failure(requestedTime: CMTime, error: any Error)
        }

        /// Creates the asynchronous iterator that produces elements of this
        /// asynchronous sequence.
        ///
        /// - Returns: An instance of the `AsyncIterator` type used to produce
        /// elements of the asynchronous sequence.
        public func makeAsyncIterator() -> AVAssetImageGenerator.Images

        /// Asynchronously advances to the next element and returns it, or ends the
        /// sequence if there is no next element.
        ///
        /// - Returns: The next element, if it exists, or `nil` to signal the end of
        ///   the sequence.
        public mutating func next() async -> AVAssetImageGenerator.Images.Element?

        /// The type of asynchronous iterator that produces elements of this
        /// asynchronous sequence.
        @available(iOS 16, tvOS 16, visionOS 1, macOS 13, *)
        @available(watchOS, unavailable)
        public typealias AsyncIterator = AVAssetImageGenerator.Images
    }
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
@available(watchOS, unavailable)
extension AVAssetWriter {

    /// Prepares the writer to write media data to its output file.
    ///
    /// - Throws: An error if reading fails to start.
    public func start() throws
}

@available(macOS 26.0, iOS 26.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension AVAssetWriterInput {

    /// Provides an interface for writing tagged pixel buffers to an input.
    public class TaggedPixelBufferGroupReceiver {

        /// The pixel buffer attributes of pixel buffers that will be vended by the receiver's pixel buffer pool.
        public var sourcePixelBufferAttributes: CVPixelBufferCreationAttributes? { get }

        /// A pixel buffer pool that will vend and efficiently recycle pixel buffer objects that can be appended to the receiver.
        public var pixelBufferPool: CVMutablePixelBuffer.Pool? { get }

        /// Suspends until the input is ready for more media data, then appends the tagged pixel buffers.
        /// - Parameter taggedPixelBufferGroup: The tagged pixel buffers to be appended.
        /// - Parameter presentationTime: The presentation time for the tagged pixel buffers to be appended.
        /// - Throws: An error if the underlying writer failed.   
        nonisolated(nonsending) public func append(_ taggedPixelBufferGroup: [CMTaggedDynamicBuffer], with presentationTime: CMTime) async throws

        /// Appends the tagged pixel buffers synchronously if the input is ready for more media data.
        /// - Parameter taggedPixelBufferGroup: The tagged pixel buffers to be appended.
        /// - Parameter presentationTime: The presentation time for the tagged pixel buffers to be appended.
        /// - Returns: Returns true if the append was successful, false if the input was not ready for more media data.
        /// - Throws: An error if the underlying writer failed.
        public func appendImmediately(_ taggedPixelBufferGroup: [CMTaggedDynamicBuffer], with presentationTime: CMTime) throws -> Bool

        /// Indicates to the AVAssetWriter that no more buffers will be appended to this receiver.
        public func finish()

        @objc deinit
    }
}

@available(macOS 26.0, iOS 26.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension AVAssetWriter {

    /// Attaches the input to the writer and returns an input receiver for writing tagged pixel buffers.
    /// - Parameter input: The input to be attached to the writer.
    /// - Parameter attributes: The attributes of pixel buffers that will be vended by the input provider's pixel buffer pool.
    /// - Returns: A writer input receiver with an interface for writing pixel buffers.
    public func inputTaggedPixelBufferGroupReceiver(for input: AVAssetWriterInput, pixelBufferAttributes attributes: CVPixelBufferCreationAttributes?) -> sending AVAssetWriterInput.TaggedPixelBufferGroupReceiver

    /// Attaches the input to the writer and returns a tuple with an input receiver for writing tagged pixel buffers, and an associated multi pass controller.
    /// - Parameter input: The input to be attached to the writer.
    /// - Parameter attributes: The attributes of pixel buffers that will be vended by the input provider's pixel buffer pool.
    /// - Returns: A tuple with an input receiver for writing pixel buffers, and an associated multi pass controller.
    public func inputTaggedPixelBufferGroupReceiverRequestingMultiPass(for input: AVAssetWriterInput, pixelBufferAttributes attributes: CVPixelBufferCreationAttributes?) -> sending (AVAssetWriterInput.TaggedPixelBufferGroupReceiver, AVAssetWriterInput.MultiPassController)
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, visionOS 1.0, *)
@available(watchOS, unavailable)
extension AVAssetExportSession {

    /// Initiates an asset export operation.  Progress can be monitored using states(updateInterval:).  Thrown errors may include:
    ///   - CancellationError: export operation is cancelled
    /// - Parameters:
    ///   - url: Indicates the URL of the export session's output. You may use UTType.preferredFilenameExtension to obtain an appropriate path extension for the fileType you have specified. For more information, see <UniformTypeIdentifiers/UTType.h>
    ///   - fileType: Indicates the type of file to be written by the session.
    @backDeployed(before: macOS 26.0, iOS 26.0, tvOS 26.0, visionOS 26.0)
    final public func export(to url: URL, as fileType: AVFileType, isolation: isolated (any Actor)? = #isolation) async throws
}

@available(macOS 15, iOS 18, tvOS 18, visionOS 2.0, *)
@available(watchOS, unavailable)
extension AVAssetExportSession {

    /// Describes the state of an export session.
    public enum State : Sendable {

        case pending

        case waiting

        case exporting(progress: Progress)
    }

    /// Monitor the progress of an asset export session
    /// - Parameter updateInterval: time interval between updates while in exporting state
    /// - Returns: sequence of asset export session progress states
    public func states(updateInterval: TimeInterval = .infinity) -> some Sendable & AsyncSequence<AVAssetExportSession.State, Never>

}

@available(macOS 13.0, iOS 16.0, tvOS 16.0, visionOS 1.0, *)
@available(watchOS, unavailable)
extension AVRouteDetector : @unchecked Sendable {
}

@available(macOS 13, iOS 16, tvOS 16, watchOS 9, visionOS 1, *)
extension AVMutableComposition {

    /// Inserts all the tracks of a timeRange of an asset into a composition.
    /// - Parameters:
    ///   - timeRange: Specifies the timeRange of the asset to be inserted.
    ///   - asset: Specifies the asset that contains the tracks that are to be inserted. Only instances of AVURLAsset and AVComposition are supported.
    ///   - time: Specifies the time at which the inserted tracks are to be presented by the composition.
    ///   - isolation: The actor isolation for accessing non-Sendable values. Inherits the calling isolation by default.
    @backDeployed(before: macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2)
    final public func insertTimeRange(_ timeRange: CMTimeRange, of asset: AVAsset, at time: CMTime, isolation: isolated (any Actor)? = #isolation) async throws
}

@available(macOS 11.0, iOS 10.0, macCatalyst 14.0, tvOS 17.0, *)
@available(visionOS, unavailable)
@available(watchOS, unavailable)
extension AVCapturePhotoOutput {

    @nonobjc public var supportedFlashModes: [AVCaptureDevice.FlashMode] { get }

    @nonobjc public var availablePhotoPixelFormatTypes: [OSType] { get }

    @nonobjc public var availableRawPhotoPixelFormatTypes: [OSType] { get }
}

@available(macOS 10.15, iOS 11.0, macCatalyst 14.0, tvOS 17.0, *)
@available(visionOS, unavailable)
@available(watchOS, unavailable)
extension AVCapturePhotoOutput {

    @available(macOS 10.15, iOS 11.0, macCatalyst 14.0, tvOS 17.0, *)
    @available(visionOS, unavailable)
    @available(watchOS, unavailable)
    @nonobjc public func supportedPhotoPixelFormatTypes(for fileType: AVFileType) -> [OSType]

    @available(iOS 11.0, macCatalyst 14.0, tvOS 17.0, *)
    @available(macOS, unavailable)
    @available(visionOS, unavailable)
    @available(watchOS, unavailable)
    @nonobjc public func supportedRawPhotoPixelFormatTypes(for fileType: AVFileType) -> [OSType]
}

@available(macOS 11.0, iOS 10.0, macCatalyst 14.0, tvOS 17.0, *)
@available(visionOS, unavailable)
@available(watchOS, unavailable)
extension AVCapturePhotoSettings {

    @nonobjc public var availablePreviewPhotoPixelFormatTypes: [OSType] { get }
}

@available(macOS 14.4, iOS 17.4, tvOS 17.4, visionOS 1.1, *)
@available(watchOS, unavailable)
extension AVSampleBufferVideoRenderer {

    /**
    	 Options for specifying the expected upcoming PTS values for the samples that will be enqueued.
    	 */
    public enum PresentationTimeExpectation : Sendable {

        /**
        		 No promises about the upcoming PTS values.
        		 */
        case none

        /**
        		 Promises that future sample buffers will have monotonically increasing PTS values. Only applicable for forward playback. Calling flush resets such expectations. Only applicable for forward playback. Enqueueing a buffer with a lower PTS than any previously enqueued PTS has the potential to lead to dropped buffers.
        		 */
        case monotonicallyIncreasing

        /**
        		 Promises that future sample buffers will have PTS values no less than a specified lower-bound PTS. For best results, set minimumUpcoming regularly, in between calls to enqueueSampleBuffer, to advance the lower-bound PTS. Calling flush resets such expectations. Only applicable for forward playback. Enqueueing a buffer with a lower PTS than the specified PTS has the potential to lead to dropped buffers.
        		 */
        case minimumUpcoming(CMTime)
    }

    /**
    	 Specifies the expected upcoming PTS values for the samples that will be enqueued. The purpose is to enable power optimizations.
    	 */
    public var presentationTimeExpectation: AVSampleBufferVideoRenderer.PresentationTimeExpectation

    /// Recommended pixel buffer attributes for optimal performance when using CMSampleBuffers containing CVPixelbuffers.
    ///
    /// The returned attributes are not sufficient for pixel buffer creation. Use ``CVPixelBufferAttributes/init?(merging:)``
    /// to merge these with other required attributes.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    @available(watchOS, unavailable)
    public var recommendedPixelBufferAttributes: CVPixelBufferAttributes { get }
}

@available(macOS 14.2, iOS 17.2, tvOS 17.2, watchOS 10.2, visionOS 1.1, *)
extension AVPlayerVideoOutput {

    /**
        Retrieves a video frame along with auxiliary information for display at the specified host time.
     	- Parameter hostTime: A CMTime that expresses a desired host time.
        - Returns: A tuple containing the frame, presentation timestamp, and active configuration for the specified host time, or nil if no frame was available for that host time.
         - taggedBufferGroup: An array of CMTaggedBuffers containing the frame for the specified time.
         - presentationTime: A CMTime whose value is the presentation time in terms of the corresponding AVPlayerItem's timebase for the associated taggedBufferGroup.
     	 - activeConfiguration:  The active configuration corresponding to the associated taggedBufferGroup.
     */
    @available(macOS, introduced: 14.2, deprecated: 100000, message: "Use AVPlayerVideoOutput.sample instead")
    @available(iOS, introduced: 17.2, deprecated: 100000, message: "Use AVPlayerVideoOutput.sample instead")
    @available(tvOS, introduced: 17.2, deprecated: 100000, message: "Use AVPlayerVideoOutput.sample instead")
    @available(watchOS, introduced: 10.2, deprecated: 100000, message: "Use AVPlayerVideoOutput.sample instead")
    @available(visionOS, introduced: 1.1, deprecated: 100000, message: "Use AVPlayerVideoOutput.sample instead")
    public func taggedBuffers(forHostTime hostTime: CMTime) -> (taggedBufferGroup: [CMTaggedBuffer], presentationTime: CMTime, activeConfiguration: AVPlayerVideoOutput.Configuration)?

    /**
     A video frame along with auxiliary information for display at the specified presentation time.
     */
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, watchOS 26.0, *)
    public struct Sample : Sendable {

        /**
        An array of CMTaggedBuffers containing the frame for the specified time.
         */
        public let taggedBuffers: [CMTaggedDynamicBuffer]

        /**
         A CMTime representing the true display deadline for this sample in terms of the corresponding AVPlayerItem's timebase.
         */
        public let presentationTime: CMTime

        /**
         The active configuration that this sample was derived from.
         */
        public let activeConfiguration: AVPlayerVideoOutput.Configuration
    }

    /**
        Retrieves a video sample along with auxiliary information for display at the specified host time.
        - Parameter hostTime: A CMTime that expresses a desired host time.
        - Returns: A sample containing the frame, presentation timestamp, and active configuration for the specified host time, or nil if no sample was available for that host time.
     */
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, watchOS 26.0, *)
    public func sample(forHostTime hostTime: CMTime) -> AVPlayerVideoOutput.Sample?
}

@available(macOS 14.2, iOS 17.2, tvOS 17.2, watchOS 10.2, visionOS 1.1, *)
extension AVVideoOutputSpecification {

    /**
     Creates an instance of AVVideoOutputSpecification initialized with the specified tag collections.
     	- Parameter tagCollections: Expects a non-empty array of CMTagCollections.  Tag collections are given priority based on their position in the array, where position i take priority over position i+1.
     	- Note: This method will produce a fatal error if the input tagCollection has a count of 0.
     */
    @available(macOS 14.2, iOS 17.2, tvOS 17.2, watchOS 10.2, visionOS 1.1, *)
    public convenience init(tagCollections: [[CMTag]])

    /**
     Specifies a mapping between a tag collection and a set of pixel buffer attributes.
     - Parameters:
       - pixelBufferAttributes: The client requirements for CVPixelBuffers related to the tags in tagCollection, expressed using the constants in <CoreVideo/CVPixelBuffer.h>.
       - tagCollection: A single tag collection for which these pixel buffer attributes should map to.
     - Note: Pixel buffer attributes are translated into output settings, therefore, the rules of `setOutputSettings` apply to this method as well.
     Namely, if you set pixel buffer attributes for a tag collection and then output settings for that same tag collection, your pixel buffer attributes will be overridden and vice-versa.
     */
    @available(macOS, introduced: 14.2, deprecated: 100000, message: "Use setOutputSettings instead")
    @available(iOS, introduced: 17.2, deprecated: 100000, message: "Use setOutputSettings instead")
    @available(tvOS, introduced: 17.2, deprecated: 100000, message: "Use setOutputSettings instead")
    @available(watchOS, introduced: 10.2, deprecated: 100000, message: "Use setOutputSettings instead")
    @available(visionOS, introduced: 1.1, deprecated: 100000, message: "Use setOutputSettings instead")
    public func setOutputPixelBufferAttributes(_ pixelBufferAttributes: [String : Any]?, for tagCollection: [CMTag])

    /**
        Specifies a mapping between a tag collection and a set of output settings.
        - Parameters:
        - outputSettings: The client requirements for output CVPixelBuffers related to the tags in tagCollection, expressed using the constants in AVVideoSettings.h. For uncompressed video output, start with kCVPixelBuffer* keys in <CoreVideo/CVPixelBuffer.h>. In addition to the keys in CVPixelBuffer.h, uncompressed video settings dictionaries may also contain the key `AVVideoAllowWideColorKey`.
        - tagCollection: A single tag collection for which these pixel buffer attributes should map to.
     	- Note: If this method is called twice on the same tag collection, the first requested output settings will be overridden.
     */
    @available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    public func setOutputSettings(_ outputSettings: [String : any Sendable]?, for tagCollection: [CMTag])

    /**
     Tag collections held by AVTaggedVideoOutputSpecification.
     */
    @available(macOS 14.2, iOS 17.2, tvOS 17.2, watchOS 10.2, visionOS 1.1, *)
    public var preferredTagCollections: [[CMTag]] { get }
}

@available(macOS 14.2, iOS 17.2, tvOS 17.2, watchOS 10.2, visionOS 1.1, *)
extension AVPlayerVideoOutput.Configuration {

    /**
     List of data channels, represented as an array of CMTags, selected for this configuration.
     */
    public var dataChannelDescription: [[CMTag]] { get }
}

@available(macOS 14.2, iOS 17.2, tvOS 17.2, watchOS 10.2, visionOS 1.1, *)
extension Array where Element == CMTag {

    /**
     Creates a collection of CMTags with the required tags to describe monoscopic video, where there is no stereo view, e.g. kCMTagStereoNone.
     */
    public static func monoscopicForVideoOutput() -> [CMTag]

    /**
     Creates a collection of CMTags with the required tags to describe basic stereoscopic video, where both left and right stereo eyes are present, e.g. kCMTagStereoLeftAndRight.
     */
    public static func stereoscopicForVideoOutput() -> [CMTag]
}

extension NSNotification.Name {

    @available(macOS, introduced: 10.7, deprecated: 15.0, renamed: "AVCaptureInput.Port.formatDescriptionDidChangeNotification")
    @available(iOS, introduced: 4.0, deprecated: 18.0, renamed: "AVCaptureInput.Port.formatDescriptionDidChangeNotification")
    @available(macCatalyst, introduced: 14.0, deprecated: 18.0, renamed: "AVCaptureInput.Port.formatDescriptionDidChangeNotification")
    @available(tvOS, introduced: 17.0, deprecated: 18.0, renamed: "AVCaptureInput.Port.formatDescriptionDidChangeNotification")
    @available(visionOS, unavailable)
    @available(watchOS, unavailable)
    public static var AVCaptureInputPortFormatDescriptionDidChange: NSNotification.Name { get }
}

@available(macOS 15, iOS 18, visionOS 2, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
extension AVAssetDownloadStorageManager : @unchecked Sendable {
}

@available(macOS 12.3, iOS 15.4, tvOS 15.4, visionOS 1, *)
@available(watchOS, unavailable)
extension AVCoordinatedPlaybackSuspension : @unchecked Sendable {
}

@available(macOS 15, iOS 18, tvOS 18, visionOS 2, *)
@available(watchOS, unavailable)
extension AVPlaybackCoordinator : @unchecked Sendable {
}

@available(macOS 10.7, iOS 5.0, macCatalyst 14.0, tvOS 17.0, *)
@available(visionOS, unavailable)
@available(watchOS, unavailable)
extension AVCaptureVideoDataOutput {

    @nonobjc public var availableVideoPixelFormatTypes: [OSType] { get }
}

@available(macOS 11.0, iOS 10.0, macCatalyst 14.0, tvOS 17.0, *)
@available(visionOS, unavailable)
@available(watchOS, unavailable)
extension AVCaptureDevice.Format {

    @nonobjc public var supportedColorSpaces: [AVCaptureColorSpace] { get }
}

@available(macOS 13.0, iOS 16.0, tvOS 17.0, *)
@available(visionOS, unavailable)
@available(watchOS, unavailable)
extension AVCaptureDevice.Format {

    @nonobjc public var supportedMaxPhotoDimensions: [CMVideoDimensions] { get }
}

@available(macOS 13.0, iOS 16.0, tvOS 17.0, *)
@available(visionOS, unavailable)
@available(watchOS, unavailable)
extension AVCaptureDevice.Format {

    @nonobjc public var secondaryNativeResolutionZoomFactors: [CGFloat] { get }
}

@available(iOS 16.0, tvOS 17.0, *)
@available(macOS, unavailable)
@available(visionOS, unavailable)
@available(watchOS, unavailable)
extension AVCaptureDevice.Format {

    @available(iOS, introduced: 16.0, deprecated: 17.2, message: "Use AVCaptureDevice.Format.supportedVideoZoomRangesForDepthDataDelivery instead")
    @available(macCatalyst, introduced: 16.0, deprecated: 17.2, message: "Use AVCaptureDevice.Format.supportedVideoZoomRangesForDepthDataDelivery instead")
    @available(tvOS, introduced: 17.0, deprecated: 17.2, message: "Use AVCaptureDevice.Format.supportedVideoZoomRangesForDepthDataDelivery instead")
    @available(macOS, unavailable)
    @available(visionOS, unavailable)
    @nonobjc public var supportedVideoZoomFactorsForDepthDataDelivery: [CGFloat] { get }
}

@available(macOS 14.2, iOS 17.2, tvOS 17.2, *)
@available(visionOS, unavailable)
@available(watchOS, unavailable)
extension AVCaptureDevice.Format {

    @nonobjc public var supportedVideoZoomRangesForDepthDataDelivery: [ClosedRange<CGFloat>] { get }
}

@available(macOS 15.0, iOS 18.0, tvOS 18.0, *)
@available(visionOS, unavailable)
@available(watchOS, unavailable)
extension AVCaptureDevice.Format {

    @available(macOS 15.0, iOS 18.0, tvOS 18.0, *)
    @available(visionOS, unavailable)
    @available(watchOS, unavailable)
    @nonobjc public var systemRecommendedVideoZoomRange: ClosedRange<CGFloat>? { get }

    @available(macOS 15.0, iOS 18.0, tvOS 18.0, *)
    @available(visionOS, unavailable)
    @available(watchOS, unavailable)
    @nonobjc public var systemRecommendedExposureBiasRange: ClosedRange<Float>? { get }
}

extension NSNotification.Name {

    @available(macOS, introduced: 10.7, deprecated: 15.0, renamed: "AVCaptureDevice.wasConnectedNotification")
    @available(iOS, introduced: 4.0, deprecated: 18.0, renamed: "AVCaptureDevice.wasConnectedNotification")
    @available(macCatalyst, introduced: 14.0, deprecated: 18.0, renamed: "AVCaptureDevice.wasConnectedNotification")
    @available(tvOS, introduced: 17.0, deprecated: 18.0, renamed: "AVCaptureDevice.wasConnectedNotification")
    @available(visionOS, unavailable)
    @available(watchOS, unavailable)
    public static var AVCaptureDeviceWasConnected: NSNotification.Name { get }

    @available(macOS, introduced: 10.7, deprecated: 15.0, renamed: "AVCaptureDevice.wasDisconnectedNotification")
    @available(iOS, introduced: 4.0, deprecated: 18.0, renamed: "AVCaptureDevice.wasDisconnectedNotification")
    @available(macCatalyst, introduced: 14.0, deprecated: 18.0, renamed: "AVCaptureDevice.wasDisconnectedNotification")
    @available(tvOS, introduced: 17.0, deprecated: 18.0, renamed: "AVCaptureDevice.wasDisconnectedNotification")
    @available(visionOS, unavailable)
    @available(watchOS, unavailable)
    public static var AVCaptureDeviceWasDisconnected: NSNotification.Name { get }

    @available(iOS, introduced: 4.0, deprecated: 18.0, renamed: "AVCaptureDevice.subjectAreaDidChangeNotification")
    @available(macCatalyst, introduced: 14.0, deprecated: 18.0, renamed: "AVCaptureDevice.subjectAreaDidChangeNotification")
    @available(tvOS, introduced: 17.0, deprecated: 18.0, renamed: "AVCaptureDevice.subjectAreaDidChangeNotification")
    @available(macOS, unavailable)
    @available(visionOS, unavailable)
    @available(watchOS, unavailable)
    public static var AVCaptureDeviceSubjectAreaDidChange: NSNotification.Name { get }
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
@available(watchOS, unavailable)
extension AVAssetReader {

    /// Prepares the reader to read media data from the asset.
    ///
    /// - Throws: An error if reading fails to start.
    public func start() throws
}

@available(macOS 15.0, iOS 18.0, macCatalyst 15.0, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
extension AVCaptionGroup : @unchecked Sendable {
}

extension AVMovie {

    /**
    	 Initializes an instance of AVMovie for inspection of a media resource.
    	 
    	 - Parameters:
    		- URL: A URL that references a media resource.
    	*/
    @available(macOS 10.10, iOS 13.0, watchOS 6.0, visionOS 1.0, *)
    @available(tvOS, unavailable)
    public convenience init(url: URL)
}

extension AVURLAsset {

    /**
    	 Initializes an instance of AVURLAsset for inspection of a media resource.
    	 
    	 - Parameters:
    		- URL: A URL that references a media resource.
    	*/
    @available(macOS 10.7, iOS 4.0, tvOS 9.0, watchOS 1.0, visionOS 1.0, *)
    public convenience init(url: URL)
}

