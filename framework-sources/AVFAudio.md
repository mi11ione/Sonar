import AVFAudio.AVAudioApplication
import AVFAudio.AVAudioBuffer
import AVFAudio.AVAudioChannelLayout
import AVFAudio.AVAudioConnectionPoint
import AVFAudio.AVAudioConverter
import AVFAudio.AVAudioEngine
import AVFAudio.AVAudioEnvironmentNode
import AVFAudio.AVAudioFile
import AVFAudio.AVAudioFormat
import AVFAudio.AVAudioIONode
import AVFAudio.AVAudioMixerNode
import AVFAudio.AVAudioMixing
import AVFAudio.AVAudioNode
import AVFAudio.AVAudioPlayer
import AVFAudio.AVAudioPlayerNode
import AVFAudio.AVAudioRecorder
import AVFAudio.AVAudioRoutingArbiter
import AVFAudio.AVAudioSequencer
import AVFAudio.AVAudioSession
import AVFAudio.AVAudioSessionDeprecated
import AVFAudio.AVAudioSessionRoute
import AVFAudio.AVAudioSessionTypes
import AVFAudio.AVAudioSettings
import AVFAudio.AVAudioSinkNode
import AVFAudio.AVAudioSourceNode
import AVFAudio.AVAudioTime
import AVFAudio.AVAudioTypes
import AVFAudio.AVAudioUnit
import AVFAudio.AVAudioUnitComponent
import AVFAudio.AVAudioUnitDelay
import AVFAudio.AVAudioUnitDistortion
import AVFAudio.AVAudioUnitEQ
import AVFAudio.AVAudioUnitEffect
import AVFAudio.AVAudioUnitGenerator
import AVFAudio.AVAudioUnitMIDIInstrument
import AVFAudio.AVAudioUnitReverb
import AVFAudio.AVAudioUnitSampler
import AVFAudio.AVAudioUnitTimeEffect
import AVFAudio.AVAudioUnitTimePitch
import AVFAudio.AVAudioUnitVarispeed
import AVFAudio.AVMIDIPlayer
import AVFAudio.AVMusicEvents
import AVFAudio.AVSpeechSynthesis
import AVFAudio.AVSpeechSynthesisProvider
import CoreAudioTypes
import Foundation

@available(iOS 7.0, watchOS 2.0, tvOS 9.0, visionOS 1, *)
@available(macOS, unavailable)
extension AVAudioSession.Location {

    @available(macOS, unavailable)
    @available(iOS, deprecated, introduced: 7.0, renamed: "AVAudioSession.Orientation.top")
    @available(tvOS, deprecated, introduced: 9.0, renamed: "AVAudioSession.Orientation.top")
    @available(watchOS, deprecated, introduced: 2.0, renamed: "AVAudioSession.Orientation.top")
    @available(visionOS, deprecated, introduced: 1.0, renamed: "AVAudioSession.Orientation.top")
    public static var orientationTop: AVAudioSession.Location { get }

    @available(macOS, unavailable)
    @available(iOS, deprecated, introduced: 7.0, renamed: "AVAudioSession.Orientation.bottom")
    @available(tvOS, deprecated, introduced: 9.0, renamed: "AVAudioSession.Orientation.bottom")
    @available(watchOS, deprecated, introduced: 2.0, renamed: "AVAudioSession.Orientation.bottom")
    @available(visionOS, deprecated, introduced: 1.0, renamed: "AVAudioSession.Orientation.bottom")
    public static var orientationBottom: AVAudioSession.Location { get }

    @available(macOS, unavailable)
    @available(iOS, deprecated, introduced: 7.0, renamed: "AVAudioSession.Orientation.front")
    @available(tvOS, deprecated, introduced: 9.0, renamed: "AVAudioSession.Orientation.front")
    @available(watchOS, deprecated, introduced: 2.0, renamed: "AVAudioSession.Orientation.front")
    @available(visionOS, deprecated, introduced: 1.0, renamed: "AVAudioSession.Orientation.front")
    public static var orientationFront: AVAudioSession.Location { get }

    @available(macOS, unavailable)
    @available(iOS, deprecated, introduced: 7.0, renamed: "AVAudioSession.Orientation.back")
    @available(tvOS, deprecated, introduced: 9.0, renamed: "AVAudioSession.Orientation.back")
    @available(watchOS, deprecated, introduced: 2.0, renamed: "AVAudioSession.Orientation.back")
    @available(visionOS, deprecated, introduced: 1.0, renamed: "AVAudioSession.Orientation.back")
    public static var orientationBack: AVAudioSession.Location { get }

    @available(macOS, unavailable)
    @available(iOS, deprecated, introduced: 8.0, renamed: "AVAudioSession.Orientation.left")
    @available(tvOS, deprecated, introduced: 9.0, renamed: "AVAudioSession.Orientation.left")
    @available(watchOS, deprecated, introduced: 2.0, renamed: "AVAudioSession.Orientation.left")
    @available(visionOS, deprecated, introduced: 1.0, renamed: "AVAudioSession.Orientation.left")
    public static var orientationLeft: AVAudioSession.Location { get }

    @available(macOS, unavailable)
    @available(iOS, deprecated, introduced: 8.0, renamed: "AVAudioSession.Orientation.right")
    @available(tvOS, deprecated, introduced: 9.0, renamed: "AVAudioSession.Orientation.right")
    @available(watchOS, deprecated, introduced: 2.0, renamed: "AVAudioSession.Orientation.right")
    @available(visionOS, deprecated, introduced: 1.0, renamed: "AVAudioSession.Orientation.right")
    public static var orientationRight: AVAudioSession.Location { get }
}

@available(iOS 7.0, tvOS 9.0, watchOS 2.0, visionOS 1.0, *)
@available(macOS, unavailable)
extension AVAudioSession.Location {

    @available(macOS, unavailable)
    @available(iOS, deprecated, introduced: 7.0, renamed: "AVAudioSession.PolarPattern.cardioid")
    @available(tvOS, deprecated, introduced: 9.0, renamed: "AVAudioSession.PolarPattern.cardioid")
    @available(watchOS, deprecated, introduced: 2.0, renamed: "AVAudioSession.PolarPattern.cardioid")
    @available(visionOS, deprecated, introduced: 1.0, renamed: "AVAudioSession.PolarPattern.cardioid")
    public static var polarPatternCardioid: AVAudioSession.Location { get }

    @available(macOS, unavailable)
    @available(iOS, deprecated, introduced: 7.0, renamed: "AVAudioSession.PolarPattern.omnidirectional")
    @available(tvOS, deprecated, introduced: 9.0, renamed: "AVAudioSession.PolarPattern.omnidirectional")
    @available(watchOS, deprecated, introduced: 2.0, renamed: "AVAudioSession.PolarPattern.omnidirectional")
    @available(visionOS, deprecated, introduced: 1.0, renamed: "AVAudioSession.PolarPattern.omnidirectional")
    public static var polarPatternOmnidirectional: AVAudioSession.Location { get }

    @available(macOS, unavailable)
    @available(iOS, deprecated, introduced: 7.0, renamed: "AVAudioSession.PolarPattern.subcardioid")
    @available(tvOS, deprecated, introduced: 9.0, renamed: "AVAudioSession.PolarPattern.subcardioid")
    @available(watchOS, deprecated, introduced: 2.0, renamed: "AVAudioSession.PolarPattern.subcardioid")
    @available(visionOS, deprecated, introduced: 1.0, renamed: "AVAudioSession.PolarPattern.subcardioid")
    public static var polarPatternSubcardioid: AVAudioSession.Location { get }
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, watchOS 26.0, *)
extension AVAudioCompressedBuffer {

    /// Packet Dependencies
    ///
    /// If the format doesn't employ packet dependencies, this will be `nil`.
    public var packetDependencies: [AudioStreamPacketDependencyDescription]? { get }
}

