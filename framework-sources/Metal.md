import Metal.MTL4AccelerationStructure
import Metal.MTL4Archive
import Metal.MTL4ArgumentTable
import Metal.MTL4BinaryFunction
import Metal.MTL4BinaryFunctionDescriptor
import Metal.MTL4BufferRange
import Metal.MTL4CommandAllocator
import Metal.MTL4CommandBuffer
import Metal.MTL4CommandEncoder
import Metal.MTL4CommandQueue
import Metal.MTL4CommitFeedback
import Metal.MTL4Compiler
import Metal.MTL4CompilerTask
import Metal.MTL4ComputeCommandEncoder
import Metal.MTL4ComputePipeline
import Metal.MTL4Counters
import Metal.MTL4FunctionDescriptor
import Metal.MTL4LibraryDescriptor
import Metal.MTL4LibraryFunctionDescriptor
import Metal.MTL4LinkingDescriptor
import Metal.MTL4MachineLearningCommandEncoder
import Metal.MTL4MachineLearningPipeline
import Metal.MTL4MeshRenderPipeline
import Metal.MTL4PipelineDataSetSerializer
import Metal.MTL4PipelineState
import Metal.MTL4RenderCommandEncoder
import Metal.MTL4RenderPass
import Metal.MTL4RenderPipeline
import Metal.MTL4SpecializedFunctionDescriptor
import Metal.MTL4StitchedFunctionDescriptor
import Metal.MTL4TileRenderPipeline
import Metal.MTLAccelerationStructure
import Metal.MTLAccelerationStructureCommandEncoder
import Metal.MTLAccelerationStructureTypes
import Metal.MTLAllocation
import Metal.MTLArgument
import Metal.MTLArgumentEncoder
import Metal.MTLBinaryArchive
import Metal.MTLBlitCommandEncoder
import Metal.MTLBlitPass
import Metal.MTLBuffer
import Metal.MTLCaptureManager
import Metal.MTLCaptureScope
import Metal.MTLCommandBuffer
import Metal.MTLCommandEncoder
import Metal.MTLCommandQueue
import Metal.MTLComputeCommandEncoder
import Metal.MTLComputePass
import Metal.MTLComputePipeline
import Metal.MTLCounters
import Metal.MTLDataType
import Metal.MTLDefines
import Metal.MTLDepthStencil
import Metal.MTLDevice
import Metal.MTLDeviceCertification
import Metal.MTLDrawable
import Metal.MTLDynamicLibrary
import Metal.MTLEvent
import Metal.MTLFence
import Metal.MTLFunctionConstantValues
import Metal.MTLFunctionDescriptor
import Metal.MTLFunctionHandle
import Metal.MTLFunctionLog
import Metal.MTLFunctionStitching
import Metal.MTLGPUAddress
import Metal.MTLHeap
import Metal.MTLIOCommandBuffer
import Metal.MTLIOCommandQueue
import Metal.MTLIOCompressor
import Metal.MTLIndirectCommandBuffer
import Metal.MTLIndirectCommandEncoder
import Metal.MTLIntersectionFunctionTable
import Metal.MTLLibrary
import Metal.MTLLinkedFunctions
import Metal.MTLLogState
import Metal.MTLParallelRenderCommandEncoder
import Metal.MTLPipeline
import Metal.MTLPixelFormat
import Metal.MTLRasterizationRate
import Metal.MTLRenderCommandEncoder
import Metal.MTLRenderPass
import Metal.MTLRenderPipeline
import Metal.MTLResidencySet
import Metal.MTLResource
import Metal.MTLResourceStateCommandEncoder
import Metal.MTLResourceStatePass
import Metal.MTLResourceViewPool
import Metal.MTLSampler
import Metal.MTLStageInputOutputDescriptor
import Metal.MTLTensor
import Metal.MTLTexture
import Metal.MTLTextureViewPool
import Metal.MTLTypes
import Metal.MTLVertexDescriptor
import Metal.MTLVisibleFunctionTable

@available(macOS 13.0, iOS 16.0, tvOS 16.0, *)
public func MTLIOCreateCompressionContext(_ path: String, _ type: MTLIOCompressionMethod, _ chunkSize: Int) -> MTLIOCompressionContext?

@available(macOS 11.0, iOS 14.0, tvOS 14.0, *)
public struct MTLLogContainer : Sequence {

    /// A type representing the sequence's elements.
    public typealias Element = MTLFunctionLog

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
        public mutating func next() -> (any MTLFunctionLog)?

        /// The type of element traversed by the iterator.
        @available(iOS 14.0, tvOS 14.0, macOS 11.0, *)
        public typealias Element = any MTLFunctionLog
    }

    /// Returns an iterator over the elements of this sequence.
    public func makeIterator() -> MTLLogContainer.Iterator
}

@available(macOS 10.11, iOS 8.0, tvOS 8.0, *)
extension MTLBlitCommandEncoder {

    public func fill(buffer: any MTLBuffer, range: Range<Int>, value: UInt8)

    @available(macOS 10.14, iOS 12.0, tvOS 12.0, *)
    public func resetCommandsInBuffer(_ buffer: any MTLIndirectCommandBuffer, range: Range<Int>)

    @available(macOS 10.14, iOS 12.0, tvOS 12.0, *)
    public func copyIndirectCommandBuffer(_ buffer: any MTLIndirectCommandBuffer, sourceRange: Range<Int>, destination: any MTLIndirectCommandBuffer, destinationIndex: Int)

    @available(macOS 10.14, iOS 12.0, tvOS 12.0, *)
    public func optimizeIndirectCommandBuffer(_ buffer: any MTLIndirectCommandBuffer, range: Range<Int>)

    @available(macOS 11.0, iOS 14.0, tvOS 14.0, *)
    public func resolveCounters(_ sampleBuffer: any MTLCounterSampleBuffer, range: Range<Int>, destinationBuffer: any MTLBuffer, destinationOffset: Int)
}

@available(macOS 10.11, iOS 8.0, tvOS 8.0, *)
extension MTLBuffer {

    @available(macOS 10.12, iOS 10.0, tvOS 10.0, *)
    public func addDebugMarker(_ marker: String, range: Range<Int>)
}

@available(macOS 10.11, iOS 8.0, tvOS 8.0, *)
extension MTLCommandBuffer {

    @available(macOS 11.0, iOS 14.0, tvOS 14.0, *)
    public var logs: MTLLogContainer { get }

    @available(macOS 15.0, iOS 18.0, tvOS 18.0, *)
    public func useResidencySets(_ residencySets: [any MTLResidencySet])

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
    @backDeployed(before: macOS 16.0, iOS 19.0, tvOS 19.0, visionOS 3.0)
    public func scheduled() async

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
    @backDeployed(before: macOS 16.0, iOS 19.0, tvOS 19.0, visionOS 3.0)
    public func completed() async
}

@available(macOS 11.0, iOS 14.0, tvOS 16.0, *)
extension MTLAccelerationStructureCommandEncoder {

    public func useResources(_ resources: [any MTLResource], usage: MTLResourceUsage)

    public func useHeaps(_ heaps: [any MTLHeap])
}

@available(macOS 11.0, iOS 14.0, tvOS 16.0, *)
extension MTLVisibleFunctionTable {

    public func setFunctions(_ functions: [(any MTLFunctionHandle)?], range: Range<Int>)
}

@available(macOS 11.0, iOS 14.0, tvOS 16.0, *)
extension MTLIntersectionFunctionTable {

    public func setBuffers(_ buffers: [(any MTLBuffer)?], offsets: [Int], range: Range<Int>)

    public func setFunctions(_ functions: [(any MTLFunctionHandle)?], range: Range<Int>)

    public func setVisibleFunctionTables(_ functionTables: [(any MTLVisibleFunctionTable)?], bufferRange: Range<Int>)
}

@available(macOS 10.11, iOS 8.0, tvOS 8.0, *)
extension MTLComputeCommandEncoder {

    @available(macOS 10.13, iOS 11.0, tvOS 11.0, *)
    public func useResources(_ resources: [any MTLResource], usage: MTLResourceUsage)

    @available(macOS 10.13, iOS 11.0, tvOS 11.0, *)
    public func useHeaps(_ heaps: [any MTLHeap])

    public func setBuffers(_ buffers: [(any MTLBuffer)?], offsets: [Int], range: Range<Int>)

    @available(macOS 14.0, iOS 17.0, tvOS 17.0, *)
    public func setBuffers(_ buffers: [(any MTLBuffer)?], offsets: [Int], attributeStrides: [Int], range: Range<Int>)

    public func setTextures(_ textures: [(any MTLTexture)?], range: Range<Int>)

    public func setSamplerStates(_ samplers: [(any MTLSamplerState)?], range: Range<Int>)

    public func setSamplerStates(_ samplers: [(any MTLSamplerState)?], lodMinClamps: [Float], lodMaxClamps: [Float], range: Range<Int>)

    @available(macOS 10.14, iOS 12.0, tvOS 12.0, *)
    public func memoryBarrier(resources: [any MTLResource])

    @available(iOS, introduced: 13.0, deprecated: 14.0, renamed: "executeCommandsInBuffer")
    @available(tvOS, introduced: 13.0, deprecated: 14.0, renamed: "executeCommandsInBuffer")
    public func executeCommands(in indirectCommandBuffer: any MTLIndirectCommandBuffer, with executionRange: NSRange)

    @available(iOS, introduced: 13.0, deprecated: 14.0, renamed: "executeCommandsInBuffer")
    @available(tvOS, introduced: 13.0, deprecated: 14.0, renamed: "executeCommandsInBuffer")
    public func executeCommands(in indirectCommandbuffer: any MTLIndirectCommandBuffer, indirectBuffer indirectRangeBuffer: any MTLBuffer, indirectBufferOffset: Int)

    @available(iOS 13.0, tvOS 13.0, macOS 11.0, macCatalyst 14.0, *)
    public func executeCommandsInBuffer(_ buffer: any MTLIndirectCommandBuffer, range: Range<Int>)

    @available(iOS 13.0, tvOS 13.0, macOS 11.0, macCatalyst 14.0, *)
    public func executeCommandsInBuffer(_ buffer: any MTLIndirectCommandBuffer, indirectBuffer indirectRangeBuffer: any MTLBuffer, offset: Int)

    @available(macOS 11.0, iOS 14.0, tvOS 16.0, *)
    public func setVisibleFunctionTables(_ visibleFunctionTables: [(any MTLVisibleFunctionTable)?], bufferRange: Range<Int>)

    @available(macOS 11.0, iOS 14.0, tvOS 16.0, *)
    public func setIntersectionFunctionTables(_ intersectionFunctionTables: [(any MTLIntersectionFunctionTable)?], bufferRange: Range<Int>)
}

@available(macOS 10.11, iOS 8.0, tvOS 8.0, *)
extension MTLDevice {

    @available(macOS 10.13, iOS 11.0, tvOS 11.0, *)
    public func getDefaultSamplePositions(sampleCount: Int) -> [MTLSamplePosition]

    @available(macOS 11.0, iOS 14.0, tvOS 14.0, *)
    public func sampleTimestamps() -> (cpu: MTLTimestamp, gpu: MTLTimestamp)

    public func makeLibrary(data: DispatchData) throws -> any MTLLibrary

    @available(macOS 10.11, macCatalyst 13.0, iOS 9.0, tvOS 9.0, *)
    public func makeComputePipelineState(descriptor: MTLComputePipelineDescriptor, options: MTLPipelineOption) throws -> (any MTLComputePipelineState, MTLComputePipelineReflection?)

    @available(macOS 10.11, macCatalyst 13.0, iOS 8.0, tvOS 9.0, *)
    public func makeRenderPipelineState(descriptor: MTLRenderPipelineDescriptor, options: MTLPipelineOption) throws -> (any MTLRenderPipelineState, MTLRenderPipelineReflection?)

    @available(macOS 11.0, macCatalyst 14.0, iOS 11.0, tvOS 14.5, *)
    public func makeRenderPipelineState(tileDescriptor: MTLTileRenderPipelineDescriptor, options: MTLPipelineOption) throws -> (any MTLRenderPipelineState, MTLRenderPipelineReflection?)

    @available(macOS 13.0, iOS 16.0, tvOS 16.0, *)
    public func makeRenderPipelineState(descriptor: MTLMeshRenderPipelineDescriptor, options: MTLPipelineOption) throws -> (any MTLRenderPipelineState, MTLRenderPipelineReflection?)
}

@available(macOS 11.0, iOS 14.0, tvOS 14.0, *)
extension MTLCounterSampleBuffer {

    @available(macOS 11.0, iOS 14.0, tvOS 14.0, *)
    public func resolveCounterRange(_ range: Range<Int>) throws -> Data?
}

@available(macOS 10.12, iOS 10.0, tvOS 10.0, *)
extension MTLFunctionConstantValues {

    public func setConstantValues(_ values: UnsafeRawPointer, type: MTLDataType, range: Range<Int>)
}

@available(macOS 15.0, iOS 18.0, tvOS 18.0, *)
extension MTLResidencySet {

    @available(macOS 15.0, iOS 18.0, tvOS 18.0, *)
    public func addAllocations(_ allocations: [any MTLAllocation])

    @available(macOS 15.0, iOS 18.0, tvOS 18.0, *)
    public func removeAllocations(_ allocations: [any MTLAllocation])
}

@available(macOS 15.0, iOS 18.0, tvOS 18.0, *)
extension MTLCommandQueue {

    @available(macOS 15.0, iOS 18.0, tvOS 18.0, *)
    public func addResidencySets(_ residencySets: [any MTLResidencySet])

    @available(macOS 15.0, iOS 18.0, tvOS 18.0, *)
    public func removeResidencySets(_ residencySets: [any MTLResidencySet])
}

@available(macOS 10.13, iOS 11.0, tvOS 11.0, *)
extension MTLArgumentEncoder {

    public func setBuffers(_ buffers: [(any MTLBuffer)?], offsets: [Int], range: Range<Int>)

    public func setTextures(_ textures: [(any MTLTexture)?], range: Range<Int>)

    public func setSamplerStates(_ samplers: [(any MTLSamplerState)?], range: Range<Int>)

    @available(macOS 10.14, iOS 13.0, tvOS 13.0, *)
    public func setRenderPipelineStates(_ pipelines: [(any MTLRenderPipelineState)?], range: Range<Int>)

    @available(iOS, introduced: 13.0, deprecated: 14.0, renamed: "setComputePipelineState")
    @available(tvOS, introduced: 13.0, deprecated: 14.0, renamed: "setComputePipelineState")
    public func setComputePipelineState(_ pipeline: (any MTLComputePipelineState)?, at index: Int)

    @available(iOS, introduced: 13.0, deprecated: 14.0, renamed: "setComputePipelineStates")
    @available(tvOS, introduced: 13.0, deprecated: 14.0, renamed: "setComputePipelineStates")
    public func setComputePipelineStates(_ pipelines: UnsafePointer<(any MTLComputePipelineState)?>, with range: NSRange)

    @available(iOS 13.0, tvOS 13.0, macOS 11.0, macCatalyst 14.0, *)
    public func setComputePipelineStates(_ pipelines: [(any MTLComputePipelineState)?], range: Range<Int>)

    @available(macOS 10.14, iOS 12.0, tvOS 12.0, *)
    public func setIndirectCommandBuffers(_ buffers: [(any MTLIndirectCommandBuffer)?], range: Range<Int>)

    @available(macOS 11.0, iOS 14.0, tvOS 16.0, *)
    public func setVisibleFunctionTables(_ visibleFunctionTables: [(any MTLVisibleFunctionTable)?], range: Range<Int>)

    @available(macOS 11.0, iOS 14.0, tvOS 16.0, *)
    public func setIntersectionFunctionTables(_ intersectionFunctionTables: [(any MTLIntersectionFunctionTable)?], range: Range<Int>)
}

@available(macOS 10.11, iOS 8.0, tvOS 8.0, *)
extension MTLRenderCommandEncoder {

    @available(macOS, introduced: 10.13, deprecated: 13.0, message: "Please specify stages with useResources(_:usage:stages:)")
    @available(iOS, introduced: 11.0, deprecated: 16.0, message: "Please specify stages with useResources(_:usage:stages:)")
    @available(tvOS, introduced: 11.0, deprecated: 16.0, message: "Please specify stages with useResources(_:usage:stages:)")
    public func useResources(_ resources: [any MTLResource], usage: MTLResourceUsage)

    @available(macOS, introduced: 10.13, deprecated: 13.0, message: "Please specify stages with useHeaps(_:stages:)")
    @available(iOS, introduced: 11.0, deprecated: 16.0, message: "Please specify stages with useHeaps(_:stages:)")
    @available(tvOS, introduced: 11.0, deprecated: 16.0, message: "Please specify stages with useHeaps(_:stages:)")
    public func useHeaps(_ heaps: [any MTLHeap])

    @available(macOS 10.15, macCatalyst 13.1, iOS 13.0, tvOS 13.0, *)
    public func useResources(_ resources: [any MTLResource], usage: MTLResourceUsage, stages: MTLRenderStages)

    @available(macOS 10.15, macCatalyst 13.1, iOS 13.0, tvOS 13.0, *)
    public func useHeaps(_ heaps: [any MTLHeap], stages: MTLRenderStages)

    @available(macOS, introduced: 10.15, deprecated: 13.0, renamed: "useResource(_:usage:stages:)")
    @available(macCatalyst, introduced: 13.1, deprecated: 16.0, renamed: "useResource(_:usage:stages:)")
    @available(iOS, introduced: 13.0, deprecated: 16.0, renamed: "useResource(_:usage:stages:)")
    @available(tvOS, introduced: 13.0, deprecated: 16.0, renamed: "useResource(_:usage:stages:)")
    public func use(_ resource: any MTLResource, usage: MTLResourceUsage, stages: MTLRenderStages)

    @available(macOS, introduced: 10.15, deprecated: 13.0, renamed: "useResources(_:usage:stages:)")
    @available(macCatalyst, introduced: 13.1, deprecated: 16.0, renamed: "useResources(_:usage:stages:)")
    @available(iOS, introduced: 13.0, deprecated: 16.0, renamed: "useResources(_:usage:stages:)")
    @available(tvOS, introduced: 13.0, deprecated: 16.0, renamed: "useResources(_:usage:stages:)")
    public func use(_ resources: UnsafePointer<any MTLResource>, count: Int, usage: MTLResourceUsage, stages: MTLRenderStages)

    @available(macOS, introduced: 10.15, deprecated: 13.0, renamed: "useHeap(_:stages:)")
    @available(macCatalyst, introduced: 13.1, deprecated: 16.0, renamed: "useHeap(_:stages:)")
    @available(iOS, introduced: 13.0, deprecated: 16.0, renamed: "useHeap(_:stages:)")
    @available(tvOS, introduced: 13.0, deprecated: 16.0, renamed: "useHeap(_:stages:)")
    public func use(_ heap: any MTLHeap, stages: MTLRenderStages)

    @available(macOS, introduced: 10.15, deprecated: 13.0, renamed: "useHeaps(_:stages:)")
    @available(macCatalyst, introduced: 13.1, deprecated: 16.0, renamed: "useHeaps(_:stages:)")
    @available(iOS, introduced: 13.0, deprecated: 16.0, renamed: "useHeaps(_:stages:)")
    @available(tvOS, introduced: 13.0, deprecated: 16.0, renamed: "useHeaps(_:stages:)")
    public func use(_ heaps: UnsafePointer<any MTLHeap>, count: Int, stages: MTLRenderStages)

    @available(macOS 10.13, iOS 12.0, tvOS 14.5, *)
    public func setViewports(_ viewports: [MTLViewport])

    @available(macOS 10.13, iOS 12.0, tvOS 14.5, *)
    public func setScissorRects(_ scissorRects: [MTLScissorRect])

    public func setVertexBuffers(_ buffers: [(any MTLBuffer)?], offsets: [Int], range: Range<Int>)

    @available(macOS 14.0, iOS 17.0, tvOS 17.0, *)
    public func setVertexBuffers(_ buffers: [(any MTLBuffer)?], offsets: [Int], attributeStrides: [Int], range: Range<Int>)

    public func setVertexTextures(_ textures: [(any MTLTexture)?], range: Range<Int>)

    public func setVertexSamplerStates(_ samplers: [(any MTLSamplerState)?], range: Range<Int>)

    public func setVertexSamplerStates(_ samplers: [(any MTLSamplerState)?], lodMinClamps: [Float], lodMaxClamps: [Float], range: Range<Int>)

    public func setFragmentBuffers(_ buffers: [(any MTLBuffer)?], offsets: [Int], range: Range<Int>)

    public func setFragmentTextures(_ textures: [(any MTLTexture)?], range: Range<Int>)

    public func setFragmentSamplerStates(_ samplers: [(any MTLSamplerState)?], range: Range<Int>)

    public func setFragmentSamplerStates(_ samplers: [(any MTLSamplerState)?], lodMinClamps: [Float], lodMaxClamps: [Float], range: Range<Int>)

    @available(iOS 11.0, macOS 11.0, tvOS 14.5, macCatalyst 14.0, *)
    public func setTileBuffers(_ buffers: [(any MTLBuffer)?], offsets: [Int], range: Range<Int>)

    @available(iOS 11.0, macOS 11.0, tvOS 14.5, macCatalyst 14.0, *)
    public func setTileTextures(_ textures: [(any MTLTexture)?], range: Range<Int>)

    @available(iOS 11.0, macOS 11.0, tvOS 14.5, macCatalyst 14.0, *)
    public func setTileSamplerStates(_ samplers: [(any MTLSamplerState)?], range: Range<Int>)

    @available(iOS 11.0, macOS 11.0, tvOS 14.5, macCatalyst 14.0, *)
    public func setTileSamplerStates(_ samplers: [(any MTLSamplerState)?], lodMinClamps: [Float], lodMaxClamps: [Float], range: Range<Int>)

    @available(macOS 13.0, iOS 16.0, tvOS 16.0, *)
    public func setObjectBuffers(_ buffers: [(any MTLBuffer)?], offsets: [Int], range: Range<Int>)

    @available(macOS 13.0, iOS 16.0, tvOS 16.0, *)
    public func setObjectTextures(_ textures: [(any MTLTexture)?], range: Range<Int>)

    @available(macOS 13.0, iOS 16.0, tvOS 16.0, *)
    public func setObjectSamplerStates(_ samplers: [(any MTLSamplerState)?], range: Range<Int>)

    @available(macOS 13.0, iOS 16.0, tvOS 16.0, *)
    public func setObjectSamplerStates(_ samplers: [(any MTLSamplerState)?], lodMinClamps: [Float], lodMaxClamps: [Float], range: Range<Int>)

    @available(macOS 13.0, iOS 16.0, tvOS 16.0, *)
    public func setMeshBuffers(_ buffers: [(any MTLBuffer)?], offsets: [Int], range: Range<Int>)

    @available(macOS 13.0, iOS 16.0, tvOS 16.0, *)
    public func setMeshTextures(_ textures: [(any MTLTexture)?], range: Range<Int>)

    @available(macOS 13.0, iOS 16.0, tvOS 16.0, *)
    public func setMeshSamplerStates(_ samplers: [(any MTLSamplerState)?], range: Range<Int>)

    @available(macOS 13.0, iOS 16.0, tvOS 16.0, *)
    public func setMeshSamplerStates(_ samplers: [(any MTLSamplerState)?], lodMinClamps: [Float], lodMaxClamps: [Float], range: Range<Int>)

    @available(macOS 10.14, macCatalyst 14.0, iOS 16.0, tvOS 16.0, *)
    public func memoryBarrier(resources: [any MTLResource], after: MTLRenderStages, before: MTLRenderStages)

    @available(macOS 10.14, iOS 12.0, tvOS 12.0, *)
    public func executeCommandsInBuffer(_ buffer: any MTLIndirectCommandBuffer, range: Range<Int>)

    @available(macOS 10.14, iOS 13.0, tvOS 13.0, *)
    public func executeCommandsInBuffer(_ buffer: any MTLIndirectCommandBuffer, indirectBuffer indirectRangeBuffer: any MTLBuffer, offset: Int)

    @available(macOS 12.0, iOS 15.0, tvOS 16.0, *)
    public func setVertexVisibleFunctionTables(_ functionTables: [(any MTLVisibleFunctionTable)?], bufferRange: Range<Int>)

    @available(macOS 12.0, iOS 15.0, tvOS 16.0, *)
    public func setFragmentVisibleFunctionTables(_ functionTables: [(any MTLVisibleFunctionTable)?], bufferRange: Range<Int>)

    @available(macOS 12.0, iOS 15.0, tvOS 16.0, *)
    public func setTileVisibleFunctionTables(_ functionTables: [(any MTLVisibleFunctionTable)?], bufferRange: Range<Int>)

    @available(macOS 12.0, iOS 15.0, tvOS 16.0, *)
    public func setVertexIntersectionFunctionTables(_ functionTables: [(any MTLIntersectionFunctionTable)?], bufferRange: Range<Int>)

    @available(macOS 12.0, iOS 15.0, tvOS 16.0, *)
    public func setFragmentIntersectionFunctionTables(_ functionTables: [(any MTLIntersectionFunctionTable)?], bufferRange: Range<Int>)

    @available(macOS 12.0, iOS 15.0, tvOS 16.0, *)
    public func setTileIntersectionFunctionTables(_ functionTables: [(any MTLIntersectionFunctionTable)?], bufferRange: Range<Int>)
}

@available(macOS 10.14, iOS 12.0, tvOS 12.0, *)
extension MTLIndirectCommandBuffer {

    public func reset(_ range: Range<Int>)

    @available(macOS, unavailable)
    @available(macCatalyst, introduced: 14.0, deprecated: 14.0, renamed: "indirectComputeCommandAt")
    @available(iOS, introduced: 13.0, deprecated: 14.0, renamed: "indirectComputeCommandAt")
    @available(tvOS, introduced: 13.0, deprecated: 14.0, renamed: "indirectComputeCommandAt")
    public func indirectComputeCommand(at Index: Int) -> any MTLIndirectComputeCommand
}

@available(macOS 11.0, iOS 13.0, tvOS 13.0, *)
extension MTLIndirectComputeCommand {

    @available(macOS, unavailable)
    @available(macCatalyst, introduced: 14.0, deprecated: 14.0, renamed: "setStageInRegion(_:)")
    @available(iOS, introduced: 13.0, deprecated: 14.0, renamed: "setStageInRegion(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 14.0, renamed: "setStageInRegion(_:)")
    public func setStageIn(_ region: MTLRegion)

    @available(macOS, unavailable)
    @available(macCatalyst, introduced: 14.0, deprecated: 14.0, renamed: "setThreadgroupMemoryLength(_:index:)")
    @available(iOS, introduced: 13.0, deprecated: 14.0, renamed: "setThreadgroupMemoryLength(_:index:)")
    @available(tvOS, introduced: 13.0, deprecated: 14.0, renamed: "setThreadgroupMemoryLength(_:index:)")
    public func setThreadgroupMemoryLength(_ length: Int, at index: Int)
}

@available(macOS 10.11, iOS 8.0, tvOS 8.0, *)
extension MTLRenderPassDescriptor {

    @available(macOS 10.13, iOS 11.0, tvOS 11.0, *)
    public func setSamplePositions(_ positions: [MTLSamplePosition])

    @available(macOS 10.13, iOS 11.0, tvOS 11.0, *)
    public func getSamplePositions() -> [MTLSamplePosition]
}

@available(macOS 10.11, iOS 8.0, tvOS 8.0, *)
extension MTLTexture {

    @available(macOS 10.11, iOS 9.0, tvOS 9.0, *)
    public func makeTextureView(pixelFormat: MTLPixelFormat, textureType: MTLTextureType, levels levelRange: Range<Int>, slices sliceRange: Range<Int>) -> (any MTLTexture)?

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
    public func makeTextureView(pixelFormat: MTLPixelFormat, textureType: MTLTextureType, levels levelRange: Range<Int>, slices sliceRange: Range<Int>, swizzle: MTLTextureSwizzleChannels) -> (any MTLTexture)?
}

@available(macOS 10.15.4, macCatalyst 13.4, iOS 13.0, tvOS 16.0, *)
extension MTLRasterizationRateSampleArray {

    public subscript(index: Int) -> Float
}

@available(macOS 10.15.4, macCatalyst 13.4, iOS 13.0, tvOS 16.0, *)
extension MTLRasterizationRateLayerDescriptor {

    public convenience init(horizontal: [Float], vertical: [Float])
}

@available(macOS 10.15.4, macCatalyst 13.4, iOS 13.0, tvOS 16.0, *)
extension MTLRasterizationRateMapDescriptor {

    public convenience init(screenSize: MTLSize, label: String? = nil)

    public convenience init(screenSize: MTLSize, layer: MTLRasterizationRateLayerDescriptor, label: String? = nil)

    public convenience init(screenSize: MTLSize, layers: [MTLRasterizationRateLayerDescriptor], label: String? = nil)
}

@available(macOS 10.14, iOS 12.0, tvOS 12.0, *)
extension MTLSharedEvent {

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
    @backDeployed(before: macOS 16.0, iOS 19.0, tvOS 19.0, visionOS 3.0)
    public func valueSignaled(_ value: UInt64) async
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
extension MTL4RenderCommandEncoder {

    /// Sets an array of viewports to transform vertices from normalized device coordinates to window coordinates.
    ///
    /// Metal clips fragments that lie outside of the viewport, and optionally clamps fragments outside of z-near/z-far range,
    /// depending on the value you assign to ``setDepthClipMode:``.
    ///
    /// Metal selects the viewport to use from the `[[ viewport_array_index ]]` attribute you specify in the pipeline
    /// state's vertex shader function in the Metal Shading Language.
    ///
    /// - Parameters:
    ///   - viewports: A Swift array of ``MTLViewport`` elements.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func setViewports(_ viewports: [MTLViewport])

    /// Sets an array of scissor rectangles for a fragment scissor test.
    ///
    /// Metal uses the specific scissor rectangle corresponding to the index you specify via the `[[ viewport_array_index ]]`
    /// output attribute of the vertex shader function in the Metal Shading Language, discarding all fragments outside of
    /// the scissor rect.
    ///
    /// - Parameters:
    ///   - scissorRects:A Swift array of ``MTLScissorRect`` elements.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func setScissorRects(_ scissorRects: [MTLScissorRect])

    /// Sets the vertex amplification count and its view mapping for each amplification ID.
    ///
    /// Each view mapping element describes how to route the corresponding amplification ID to a specific viewport and
    /// render target array index by using offsets from the base array index provided by the `[[ render_target_array_index ]]`
    /// and/or `[[ viewport_array_index ]]` output attributes in the vertex shader. This allows Metal to route each amplified
    ///  vertex to a different `[[ render_target_array_index ]]` and `[[ viewport_array_index ]]`, even though you can't
    ///  directly amplify these attributes.
    ///
    /// - Parameters:
    ///   - count: The number of outputs to create. The maximum value is `2`.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func setVertexAmplificationCount(_ count: Int)

    /// Sets the vertex amplification count and its view mapping for each amplification ID.
    ///
    /// Each view mapping element describes how to route the corresponding amplification ID to a specific viewport and
    /// render target array index by using offsets from the base array index provided by the `[[ render_target_array_index ]]`
    /// and/or `[[ viewport_array_index ]]` output attributes in the vertex shader. This allows Metal to route each amplified
    ///  vertex to a different `[[ render_target_array_index ]]` and `[[ viewport_array_index ]]`, even though you can't
    ///  directly amplify these attributes.
    ///
    /// - Parameters:
    ///   - viewMappings: A Swift array of ``MTLVertexAmplificationViewMapping`` elements. Each element in the array provides
    ///                   per-output offsets to a specific render target and viewport
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func setVertexAmplificationCount(_ viewMappings: [MTLVertexAmplificationViewMapping])

    /// Encodes a command that runs a range of commands from an indirect command buffer.
    ///
    /// - Parameters:
    ///   - buffer: An ``MTLIndirectCommandBuffer`` instance that contains other commands the current command runs.
    ///   - range: A span of integers that represent the command entries in buffer the current command runs.
    ///            The number of commands needs to be less than or equal to `16,384`.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func executeCommands(buffer: any MTLIndirectCommandBuffer, range: Range<Int>)
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
extension MTL4ComputeCommandEncoder {

    /// Encodes a command to execute commands from an indirect command buffer.
    ///
    /// - Parameters:
    ///   - buffer: An ``MTLIndirectCommandBuffer`` instance that contains other commands the current command runs.
    ///   - range: A span of integers that represent the command entries in buffer the current command runs.
    ///            The number of commands needs to be less than or equal to `16,384`.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func executeCommands(buffer: any MTLIndirectCommandBuffer, range: Range<Int>)

    /// Encodes a command that copies image data from a slice of a texture instance to a buffer, with
    /// options for special texture formats.
    ///
    /// - Parameters:
    ///   - sourceTexture:            An ``MTLTexture`` texture that the command copies data from. To read the source
    ///                               texture contents, you need to set its ``MTLTexture/framebufferOnly`` property
    ///                               to <doc://com.apple.documentation/documentation/swift/false> prior to drawing into it.
    ///   - sourceSlice:              A slice within `sourceTexture` the command uses as a starting point to copy
    ///                               data from. Set this to `0` if `sourceTexture` isn’t a texture array or a
    ///                               cube texture.
    ///   - sourceLevel:              A mipmap level within `sourceTexture`.
    ///   - sourceOrigin:             An ``MTLOrigin`` instance that represents a location within `sourceTexture`
    ///                               that the command begins copying data from. Assign `0` to each dimension
    ///                               that’s not relevant to `sourceTexture`.
    ///   - sourceSize:               An ``MTLSize`` instance that represents the size of the region, in pixels,
    ///                               that the command copies from `sourceTexture`, starting at `sourceOrigin`.
    ///                               Assign `1` to each dimension that’s not relevant to `sourceTexture`.
    ///                               If `sourceTexture` uses a compressed pixel format, set `sourceSize` to a
    ///                               multiple of the `sourceTexture's` ``MTLTexture/pixelFormat`` block size.
    ///                               If the block extends outside the bounds of the texture, clamp `sourceSize`
    ///                               to the edge of the texture.
    ///   - destinationBuffer:        An ``MTLBuffer`` instance the command copies data to.
    ///   - destinationOffset:        A byte offset within `destinationBuffer` the command copies to. The value
    ///                               you provide as this argument needs to be a multiple of `sourceTexture's` pixel size,
    ///                               in bytes.
    ///   - destinationBytesPerRow:   The number of bytes between adjacent rows of pixels in `destinationBuffer`.
    ///                               This value must be a multiple of `sourceTexture's` pixel size, in bytes,
    ///                               and less than or equal to the product of `sourceTexture's` pixel size,
    ///                               in bytes, and the largest pixel width `sourceTexture’s` type allows. If
    ///                               `sourceTexture` uses a compressed pixel format, set `destinationBytesPerRow`
    ///                               to the number of bytes between the starts of two row blocks.
    ///   - destinationBytesPerImage: The number of bytes between each 2D image of a 3D texture. This value must
    ///                               be a multiple of `sourceTexture's` pixel size, in bytes. Set this value to
    ///                               `0` if `sourceSize's` ``MTLSize/depth`` value is `1`.
    ///   - options:                  A ``MTLBlitOption`` value that applies to textures with applicable pixel
    ///                               formats, such as combined depth/stencil or PVRTC formats. If `sourceTexture's`
    ///                               ``MTLTexture/pixelFormat`` is a combined depth/stencil format, set `options`
    ///                               to either ``MTLBlitOption/MTLBlitOptionDepthFromDepthStencil`` or
    ///                               ``MTLBlitOption/MTLBlitOptionStencilFromDepthStencil``, but not both.
    ///                               If `sourceTexture's` ``MTLTexture/pixelFormat`` is a PVRTC format, set
    ///                               `options` to ``MTLBlitOption/MTLBlitOptionRowLinearPVRTC``.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func copy(sourceTexture: any MTLTexture, sourceSlice: Int, sourceLevel: Int, sourceOrigin: MTLOrigin, sourceSize: MTLSize, destinationBuffer: any MTLBuffer, destinationOffset: Int, destinationBytesPerRow: Int, destinationBytesPerImage: Int, options: MTLBlitOption = [])

    /// Encodes a command to copy image data from a buffer into a texture with options for special texture formats.
    ///
    /// - Parameters:
    ///   - sourceBuffer:        An ``MTLBuffer`` instance the command copies data from.
    ///   - sourceOffset:        A byte offset within `sourceBuffer` the command copies from. Set this value to
    ///                          a multiple of `destinationTexture's` pixel size, in bytes.
    ///   - sourceBytesPerRow:   The number of bytes between adjacent rows of pixels in `sourceBuffer`. Set this value to
    ///                          a multiple of `destinationTexture's` pixel size, in bytes, and less than or equal to
    ///                          the product of `destinationTexture's` pixel size, in bytes, and the largest pixel width
    ///                          `destinationTexture's` type allows. If `destinationTexture` uses a compressed pixel format,
    ///                          set `sourceBytesPerRow` to the number of bytes between the starts of two row blocks.
    ///   - sourceBytesPerImage: The number of bytes between each 2D image of a 3D texture. Set this value to a
    ///                          multiple of `destinationTexture's` pixel size, in bytes, or `0`
    ///                          if `sourceSize's` ``MTLSize/depth`` value is `1`.
    ///   - sourceSize:          An ``MTLSize`` instance that represents the size of the region in
    ///                          `destinationTexture`, in pixels, that the command copies data to, starting at
    ///                          `destinationOrigin`. Assign `1` to each dimension that’s not relevant to
    ///                          `destinationTexture`. If `destinationTexture` uses a compressed pixel format,
    ///                          set `sourceSize` to a multiple of `destinationTexture's` ``MTLTexture/pixelFormat``
    ///                          block size. If the block extends outside the bounds of the texture, clamp
    ///                          `sourceSize` to the edge of the texture.
    ///   - destinationTexture:  An ``MTLTexture`` instance the command copies data to. In order to copy the contents into
    ///                          the destination texture, set its ``MTLTexture/framebufferOnly`` property to
    ///                          <doc://com.apple.documentation/documentation/swift/false> and don't
    ///                          use a combined depth/stencil ``MTLTexture/pixelFormat``.
    ///   - destinationSlice:    A slice within `destinationTexture` the command uses as its starting point for
    ///                          copying data to. Set this to `0` if `destinationTexture` isn’t a texture array
    ///                          or a cube texture.
    ///   - destinationLevel:    A mipmap level within `destinationTexture` the command copies data to.
    ///   - destinationOrigin:   An ``MTLOrigin`` instance that represents a location within `destinationTexture`
    ///                          that the command begins copying data to. Assign `0` to each dimension that’s not
    ///                          relevant to `destinationTexture`.
    ///   - options:             An ``MTLBlitOption`` value that applies to textures with applicable pixel formats,
    ///                          such as combined depth/stencil or PVRTC formats. If `destinationTexture's`
    ///                          ``MTLTexture/pixelFormat`` is a combined depth/stencil format, set `options` to
    ///                          either ``MTLBlitOption/MTLBlitOptionDepthFromDepthStencil`` or
    ///                          ``MTLBlitOption/MTLBlitOptionStencilFromDepthStencil``, but not both.
    ///                          If `destinationTexture's` ``MTLTexture/pixelFormat`` is a PVRTC format, set
    ///                          `options` to ``MTLBlitOption/MTLBlitOptionRowLinearPVRTC``.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func copy(sourceBuffer: any MTLBuffer, sourceOffset: Int, sourceBytesPerRow: Int, sourceBytesPerImage: Int, sourceSize: MTLSize, destinationTexture: any MTLTexture, destinationSlice: Int, destinationLevel: Int, destinationOrigin: MTLOrigin, options: MTLBlitOption = [])

    /// Encodes a command that fills a buffer with a constant value for each byte.
    ///
    /// - Parameters:
    ///   - buffer: A MTLBuffer instance the command assigns each byte in range to value.
    ///   - range: A range of bytes within the buffer the command assigns value to. The range’s count property needs to be greater than 0.
    ///   - value: The value to write to each byte.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func fill(buffer: any MTLBuffer, range: Range<Int>, value: UInt8)

    /// Encodes a command that copies commands from one indirect command buffer into another.
    ///
    /// - Parameters:
    ///   - source:           An ``MTLIndirectCommandBuffer`` instance from where the command copies.
    ///   - sourceRange:      The range of commands in `sourceBuffer` to copy.
    ///                       The copy operation requires that the source range starts at a valid execution point.
    ///   - destination:      Another ``MTLIndirectCommandBuffer`` instance into which the command copies.
    ///   - destinationIndex: An index in `destinationBuffer` into where the command copies content to. The copy operation requires
    ///                       that the destination index is a valid execution point with enough space left in `destinationBuffer`
    ///                       to accommodate `sourceRange.count` commands.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func copyCommands(sourceBuffer: any MTLIndirectCommandBuffer, sourceRange: Range<Int>, destinationBuffer: any MTLIndirectCommandBuffer, destinationIndex: Int)

    /// Encodes a command that resets a range of commands in an indirect command buffer.
    ///
    /// - Parameters:
    ///   - buffer: An ``MTLIndirectCommandBuffer`` the command resets.
    ///   - range: A range of commands within `buffer`.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func resetCommands(buffer: any MTLIndirectCommandBuffer, range: Range<Int>)

    /// Encode a command to attempt to improve the performance of a range of commands within an indirect command buffer.
    ///
    /// - Parameters:
    ///   - buffer: An ``MTLIndirectCommandBuffer`` instance that this command optimizes.
    ///   - range:                 A range of commands within `indirectCommandBuffer`.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func optimizeCommands(buffer: any MTLIndirectCommandBuffer, range: Range<Int>)
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
extension MTL4CommandQueue {

    /// Enqueues an array of command buffer instances for execution with a set of options.
    ///
    /// Provide an ``MTL4CommitOptions`` instance to configure the commit operation.
    ///
    /// The order in which you sort the command buffers in the array is meaningful, especially when it contains suspending/resuming
    /// render passes. A suspending/resuming render pass is a render pass you create by calling
    /// ``MTL4CommandBuffer/renderCommandEncoderWithDescriptor:options:``,
    /// and provide `MTL4RenderEncoderOptionSuspending` or `MTL4RenderEncoderOptionResuming` for the `options` parameter.
    ///
    /// If your command buffers contain suspend/resume render passes, ensure that the first command buffer only suspends,
    /// and the last one only resumes. Additionally, make sure that all intermediate command buffers are both suspending
    /// and resuming.
    ///
    /// When you commit work from multiple threads, modifying and reusing the same options instance,
    /// you are responsible for externally synchronizing access to it.
    ///
    /// - Parameters:
    ///   - commandBuffers: A Swift array of ``MTL4CommandBuffers`` to commit.
    ///   - options: an instance of ``MTL4CommitOptions`` that configures the commit operation.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func commit(_ commandBuffers: [any MTL4CommandBuffer], options: MTL4CommitOptions? = nil)

    /// Marks an array of residency sets as part of this command queue.
    ///
    /// Ensures that Metal makes the residency set resident during the execution of all command buffers you commit to this
    /// command queue.
    ///
    /// Each command queue supports up to 32 unique residency set instances.
    ///
    /// - Parameters:
    ///   - residencySets: A Swift array of ``MTLResidencySet`` instances to add to the command queue.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func addResidencySets(_ residencySets: [any MTLResidencySet])

    /// Removes multiple residency sets from the command queue.
    ///
    /// After calling this method ensures only the remaining residency sets remain resident during the execution of the
    /// command buffers you commit this command queue.
    ///
    /// - Parameters:
    ///   - residencySets: A Swift array of ``MTLResidencySet`` instances to remove from the command queue.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func removeResidencySets(_ residencySets: [any MTLResidencySet])

    /// Updates multiple regions within a placement sparse texture to alias specific tiles of a Metal heap.
    ///
    /// You can provide a `nil` parameter to the `heap` argument only if when you perform unmap operations. Otherwise, you are
    /// responsible for ensuring the heap is non-nil and has a
    /// ``MTLHeapDescriptor/maxCompatiblePlacementSparsePageSize`` of at least the texture's
    /// ``MTLTextureDescriptor/placementSparsePageSize``.
    ///
    /// When performing a sparse mapping update, you are responsible for issuing a barrier against stage `MTLStageResourceState`.
    ///
    /// You can determine the sparse texture tier by calling `MTLTexture/sparseTextureTier`.
    ///
    /// - Parameters:
    ///   - texture: A placement sparse ``MTLTexture``.
    ///   - heap: ``MTLHeap`` you allocate with type ``MTLHeapType/MTLHeapTypePlacement``.
    ///   - operations: An array of ``MTL4UpdateSparseTextureMappingOperation`` instances to perform.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func updateMappings(texture: any MTLTexture, heap: (any MTLHeap)?, operations: [MTL4UpdateSparseTextureMappingOperation])

    /// Updates multiple regions within a placement sparse buffer to alias specific tiles from a Metal heap.
    ///
    /// You can provide a `nil` parameter to the `heap` argument only when you perform unmap operations. Otherwise, you are
    /// responsible for ensuring parameter `heap` references an ``MTLHeap`` that has a ``MTLHeapDescriptor/maxCompatiblePlacementSparsePageSize``
    /// of at least the buffer's `placementSparsePageSize` you assign when creating the sparse buffer via
    /// ``MTLDevice/newBufferWithLength:options:placementSparsePageSize:``.
    ///
    /// - Parameters:
    ///   - buffer: A placement sparse ``MTLBuffer``.
    ///   - heap: An ``MTLHeap`` you allocate with type ``MTLHeapType/MTLHeapTypePlacement``.
    ///   - operations: An array of ``MTL4UpdateSparseBufferMappingOperation`` instances to perform.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func updateMappings(buffer: any MTLBuffer, heap: (any MTLHeap)?, operations: [MTL4UpdateSparseBufferMappingOperation])

    /// Copies multiple regions within a source placement sparse texture to a destination placement sparse texture.
    ///
    /// You are responsible for ensuring the source and destination textures have the same
    /// ``MTLTextureDescriptor/placementSparsePageSize``.
    ///
    /// Additionally, you are responsible for ensuring that the source and destination textures don't use the same aliased tiles
    /// at the same time.
    ///
    /// - Note: If a sparse texture and a sparse buffer share the same backing tiles, these don't provide you
    /// you with meaningful views of the other resource’s data.
    ///
    /// - Parameters:
    ///   - sourceTexture: The source placement sparse ``MTLTexture``.
    ///   - destinationTexture: The destination placement sparse ``MTLTexture``.
    ///   - operations: An array of ``MTL4CopySparseTextureMappingOperation`` instances to perform.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func copyMappings(sourceTexture: any MTLTexture, destinationTexture: any MTLTexture, operations: [MTL4CopySparseTextureMappingOperation])

    /// Copies multiple offsets within a source placement sparse buffer to a destination placement sparse buffer.
    ///
    /// You are responsible for ensuring the source destination sparse buffers have the same `placementSparsePageSize` when
    /// you create them via ``MTLDevice/newBufferWithLength:options:placementSparsePageSize:``.
    ///
    /// Additionally, you are responsible for ensuring both the source and destination sparse buffers don't use the same aliased
    /// tiles at the same time.
    ///
    /// - Note: If a sparse texture and a sparse buffer share the same backing tiles, these don't provide you
    ///         with meaningful views of the other resource’s data.
    ///
    /// - Parameters:
    ///   - sourceBuffer: The source placement sparse ``MTLBuffer``.
    ///   - destinationBuffer: The destination placement sparse ``MTLBuffer``.
    ///   - operations: An array of ``MTL4CopySparseBufferMappingOperation`` instances to perform.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func copyMappings(sourceBuffer: any MTLBuffer, destinationBuffer: any MTLBuffer, operations: [MTL4CopySparseBufferMappingOperation])
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
extension MTL4CommandBuffer {

    /// Marks an array of residency sets as part of the command buffer's execution.
    ///
    /// Ensures that Metal makes resident the resources that residency sets contain during execution of this command buffer.
    ///
    /// - Parameters:
    ///   - residencySets: Array of ``MTLResidencySet`` instances to mark resident.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func useResidencySets(_ residencySets: [any MTLResidencySet])

    /// Encodes a command that resolves an opaque counter heap into a buffer.
    ///
    /// The command this method encodes converts the data within a counter heap into a common format
    /// and stores it into the `buffer` parameter.
    ///
    /// The command places each entry in the counter heap within `range` sequentially, starting at `offset`.
    /// Each entry needs to be a fixed size that you can query by calling the
    /// ``MTLDevice/sizeOfCounterHeapEntry:`` method.
    ///
    /// This command runs during the `MTLStageBlit` stage of the GPU timeline. Barrier against this stage
    /// to ensure the data is present in the resolve buffer parameter before you access it.
    ///
    /// - Note: Your app needs ensure the GPU places data in the heap before you resolve it by
    /// synchronizing this stage with other GPU operations.
    ///
    /// Similarly, your app needs to synchronize any GPU accesses to `buffer` after
    /// the command completes with barrier.
    ///
    /// If your app needs to access `buffer` from the CPU, signal an ``MTLSharedEvent``
    /// to notify the CPU when it's ready.
    /// Alternatively, you can resolve the heap's data from the CPU by calling
    /// the heap's ``MTL4CounterHeap/resolveCounterRange:`` method.
    ///
    /// - Parameters:
    ///   - counterHeap: A heap the command resolves.
    ///   - range: A range of index values within the heap the command resolves.
    ///   - buffer: A buffer the command saves the data it resolves into.
    ///   - offset: An offset within `buffer` that indicates where the command begins writing the data.
    ///   - fenceToWait: A fence the GPU waits for before starting, if applicable; otherwise `nil`.
    ///   - fenceToUpdate: A fence the system updates after the command finishes resolving the data; otherwise `nil`.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func resolveCounterHeap(_ counterHeap: any MTL4CounterHeap, range: Range<Int>, buffer: MTL4BufferRange, fenceToWait: (any MTLFence)? = nil, fenceToUpdate: (any MTLFence)? = nil)
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
extension MTL4CommandEncoder {

    /// Encodes a consumer barrier on work you commit to the same command queue.
    ///
    /// Encode a barrier that guarantees that any subsequent work you encode in the current command encoder that corresponds
    /// to the `beforeStages` stages doesn't proceed until Metal completes all work prior to the current command encoder
    /// corresponding to the `afterQueueStages` stages, completes.
    ///
    /// Metal can reorder the exact point where it applies the barrier, so encode the barrier as close to the command that
    /// consumes the resource as possible. Don't use this method for synchronizing resource access within the same pass.
    ///
    /// If you need to synchronize work within a pass that you encode with an instance of a subclass of ``MTLCommandEncoder``,
    /// use memory barriers instead. For subclasses of ``MTL4CommandEncoder``, use encoder barriers.
    ///
    /// You can specify `afterQueueStages` and `beforeStages` that contain ``MTLStages`` unrelated to the current command
    /// encoder.
    ///
    /// - Parameters:
    ///   - afterQueueStages: ``MTLStages`` mask that represents the stages of work to wait for.
    ///                        This argument applies to work corresponding to these stages you
    ///                        encode in prior command encoders, and not for the current encoder.
    ///   - beforeStages:     ``MTLStages`` mask that represents the stages of work that wait.
    ///                        This argument applies to work you encode in the current command encoder.
    ///   - visibilityOptions: ``MTL4VisibilityOptions`` of the barrier.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func barrier(afterQueueStages: MTLStages, beforeStages: MTLStages, visibilityOptions: MTL4VisibilityOptions = [ .device ])

    /// Encodes a producer barrier on work committed to the same command queue.
    ///
    /// This method encodes a barrier that guarantees that any work you encode using *subsequent command encoders*,
    /// corresponding to `beforeQueueStages`, don't begin until all commands you previously encode in the current
    /// encoder (and prior encoders), corresponding to `afterStages`, complete.
    ///
    /// When calling this method, you can pass any ``MTLStages`` to parameters `afterStages` and `beforeQueueStages`,
    /// even stages that don't relate to the current or prior command encoders.
    ///
    /// - Parameters:
    ///   - afterStages:       ``MTLStages`` mask that represents the stages of work to wait for.
    ///                         This argument applies to work corresponding to these stages you encode in
    ///                         the current command encoder prior to this barrier command.
    ///   - beforeQueueStages: ``MTLStages`` mask that represents the stages of work that need to wait.
    ///                         This argument applies to subsequent encoders and not to work in the current
    ///                         command encoder.
    ///   - visibilityOptions: ``MTL4VisibilityOptions`` of the barrier, controlling cache flush behavior.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func barrier(afterStages: MTLStages, beforeQueueStages: MTLStages, visibilityOptions: MTL4VisibilityOptions = [ .device ])

    /// Encodes an intra-pass barrier.
    ///
    /// Encode a barrier that guarantees that any subsequent work you encode in the *current command encoder*,
    /// corresponding to `beforeEncoderStages`, doesn't begin until all prior commands in this command encoder,
    /// corresponding to `afterEncoderStages`, completes.
    ///
    /// When calling this method, it's your responsibility to ensure parameters `afterEncoderStages` and `beforeEncoderStages`
    /// contain a combination of ``MTLStages`` for which this encoder can encode commands. For example, for a
    /// ``MTL4ComputeCommandEncoder`` instance, you can provide any combination of ``MTLStages/MTLStageDispatch``,
    /// ``MTLStages/MTLStageBlit`` and ``MTLStages/MTLStageAccelerationStructure``.
    ///
    /// - Parameters:
    ///   - afterEncoderStages:  ``MTLStages`` mask that represents the stages of work to wait for.
    ///                          This argument only applies to subsequent work you encode in the current command encoder.
    ///   - beforeEncoderStages: ``MTLStages`` mask that represents the stages of work that wait.
    ///                          This argument only applies to work you encode in the current command encoder prior to
    ///                          this barrier.
    ///   - visibilityOptions: ``MTL4VisibilityOptions`` of the barrier, controlling cache flush behavior.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func barrier(afterEncoderStages: MTLStages, beforeEncoderStages: MTLStages, visibilityOptions: MTL4VisibilityOptions = [ .device ])
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
extension MTL4Compiler {

    /// Creates a new compute pipeline state object synchronously.
    ///
    /// - Parameters:
    ///   - descriptor: A compute pipeline state descriptor describing the pipeline this compiler creates.
    ///   - compilerTaskOptions: A description of the compilation process itself, providing parameters that
    ///         influence execution of the compilation process.
    ///   - error: An optional parameter into which Metal stores information in case of an error.
    ///
    /// - Returns: A new compute pipeline state object upon success, otherwise this method throws.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func makeComputePipelineState(descriptor: MTL4ComputePipelineDescriptor, dynamicLinkingDescriptor: MTL4PipelineStageDynamicLinkingDescriptor? = nil, compilerTaskOptions: MTL4CompilerTaskOptions? = nil) throws -> any MTLComputePipelineState

    /// Creates a new compute pipeline state asynchronously.
    ///
    /// - Parameters:
    ///   - descriptor: A compute pipeline state descriptor, describing the compute pipeline to create.
    ///   - dynamicLinkingDescriptor: An optional parameter that provides additional configuration for linking the pipeline state object.
    ///   - compilerTaskOptions: A description of the compilation process itself, providing parameters that
    ///         influence execution of the compilation process.
    /// - Returns: a compute pipeline state upon success, otherwise this method throws.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func makeComputePipelineState(descriptor: MTL4ComputePipelineDescriptor, dynamicLinkingDescriptor: MTL4PipelineStageDynamicLinkingDescriptor? = nil, compilerTaskOptions: MTL4CompilerTaskOptions? = nil) async throws -> any MTLComputePipelineState

    /// Creates a new render pipeline state synchronously.
    ///
    /// Use this method to build any render pipeline type, including render, tile, and mesh render pipeline states.
    /// The type of the descriptor you pass indicates the pipeline type this method builds.
    ///
    /// Passing in a compute pipeline descriptor to the `descriptor` parameter produces an error.
    ///
    /// - Parameters:
    ///   - descriptor: A render, tile, or mesh pipeline state descriptor that describes the pipeline to create.
    ///   - dynamicLinkingDescriptor: An optional parameter that provides additional configuration for linking the pipeline state object.
    ///   - compilerTaskOptions: A description of the compilation process itself, providing parameters that
    ///         influence execution of the compilation process.
    /// - Returns: a render pipeline state upon success, otherwise this function throws.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func makeRenderPipelineState(descriptor: MTL4PipelineDescriptor, dynamicLinkingDescriptor: MTL4RenderPipelineDynamicLinkingDescriptor? = nil, compilerTaskOptions: MTL4CompilerTaskOptions? = nil) throws -> any MTLRenderPipelineState

    /// Creates a new render pipeline state asynchronously.
    ///
    /// Use this method to build any render pipeline type, including render, tile, and mesh render pipeline states.
    /// The type of the descriptor you pass indicates the pipeline type this method builds.
    ///
    /// Passing in a compute pipeline descriptor to the `descriptor` parameter produces an error.
    ///
    /// - Parameters:
    ///   - descriptor: A render, tile, or mesh pipeline state descriptor that describes the pipeline to create.
    ///   - dynamicLinkingDescriptor: An optional parameter that provides additional configuration for linking the pipeline state object.
    ///   - compilerTaskOptions: A description of the compilation process itself, providing parameters that
    ///         influence execution of the compilation process.
    /// - Returns: a render pipeline state if operation upon success, otherwise this function throws.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func makeRenderPipelineState(descriptor: MTL4PipelineDescriptor, dynamicLinkingDescriptor: MTL4RenderPipelineDynamicLinkingDescriptor? = nil, compilerTaskOptions: MTL4CompilerTaskOptions? = nil) async throws -> any MTLRenderPipelineState

    /// Creates a new render pipeline state from another, previously unspecialized, pipeline state.
    ///
    /// Metal specializes the pipeline state with new state values the descriptor provides, observing the following rules:
    /// * The compiler only updates properties that were originally specified as *unspecialized*. It doesn't modify other
    /// already-specialized properties
    /// * The compiler sets to their default behavior any unspecialized properties that your passed-in descriptor doesn't specialize
    ///
    /// Additionally, there are some cases where the Metal can't specialize a pipeline:
    /// * If the original pipeline state object doesn't have any unspecialized properties
    /// * You can't re-specialize a previously specialized pipeline state object
    ///
    /// - Parameters:
    ///   - descriptor: A render pipeline state descriptor or any type: default, tile, or mesh render pipeline descriptor.
    ///   - pipeline: A render pipeline state containing unspecialized substate.
    ///
    /// - Returns: a fully-specialized pipeline state object upon success, otherwise this function throws.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func makeRenderPipelineStateBySpecialization(descriptor: MTL4PipelineDescriptor, pipeline: any MTLRenderPipelineState) throws -> any MTLRenderPipelineState

    /// Creates a new render pipeline state from another, previously unspecialized, pipeline state
    ///
    /// Metal specializes the pipeline state with new state values the descriptor provides, observing the following rules:
    /// * The compiler only updates properties that were originally specified as *unspecialized*. It doesn't modify other
    /// already-specialized properties
    /// * The compiler sets to their default behavior any unspecialized properties that your passed-in descriptor doesn't specialize
    ///
    /// Additionally, there are some cases where the Metal can't specialize a pipeline:
    /// * If the original pipeline state object doesn't have any unspecialized properties
    /// * You can't re-specialize a previosuly specialized pipeline state object
    ///
    /// - Parameters:
    ///   - descriptor: A render pipeline state descriptor or any type: default, tile, or mesh render pipeline descriptor.
    ///   - pipeline: A render pipeline state containing unspecialized substate.
    ///
    /// - Returns: a fully-specialized pipeline state object upon success, otherwise this function throws.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func makeRenderPipelineStateBySpecialization(descriptor: MTL4PipelineDescriptor, pipeline: any MTLRenderPipelineState) async throws -> any MTLRenderPipelineState

    /// Creates a new binary visible or intersection function synchronously.
    ///
    /// - Parameters:
    ///   - descriptor: A binary function descriptor to use for creating the binary function.
    ///   - compilerTaskOptions: A descriptor of the compilation itself, providing parameters that
    ///         influence execution of the compilation process.
    ///
    /// - Returns: a binary function upon success, otherwise this function throws.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func makeBinaryFunction(descriptor: MTL4BinaryFunctionDescriptor, compilerTaskOptions: MTL4CompilerTaskOptions? = nil) throws -> any MTL4BinaryFunction

    /// Creates a new binary visible or intersection function asynchronously.
    ///
    /// - Parameters:
    ///   - descriptor: A binary function descriptor to use for creating the binary function.
    ///   - compilerTaskOptions: A descriptor of the compilation itself, providing parameters that
    ///         influence execution of the compilation process.
    ///
    /// - Returns: a binary function upon success, otherwise this function throws.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func makeBinaryFunction(descriptor: MTL4BinaryFunctionDescriptor, compilerTaskOptions: MTL4CompilerTaskOptions? = nil) async throws -> any MTL4BinaryFunction

    /// Creates a new Metal library asynchronously.
    ///
    /// - Parameters:
    ///   - descriptor: A description of the library to create.
    ///
    /// - Returns: a Metal library instance upon success, otherwise this function throws.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func makeLibrary(descriptor: MTL4LibraryDescriptor) async throws -> any MTLLibrary

    /// Creates a new Metal library instance asynchronously.
    ///
    /// - Parameters:
    ///   - descriptor: A description of the library to create.
    ///
    /// - Returns: a dynamic metal library upon success, otherwise this function throws.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func makeDynamicLibrary(library: any MTLLibrary) async throws -> any MTLDynamicLibrary

    /// Creates a new dynamic library from the contents of a file at an URL location synchronously.
    ///
    /// - Parameters:
    ///   - url: An URL referencing a file whose contents this compiler uses to build a dynamic library.
    ///
    /// - Returns: a dynamic metal library upon success, otherwise this function throws.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func makeDynamicLibrary(url: URL) async throws -> any MTLDynamicLibrary

    /// Creates a new ML pipeline state with descriptor.
    ///
    /// - Parameters:
    ///   - descriptor: A machine learning pipeline state descriptor to use for creating the new pipeline state.
    ///
    /// - Returns: a machine learning pipeline state upon success, otherwise this function throws.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func makeMachineLearningPipelineState(descriptor: MTL4MachineLearningPipelineDescriptor) throws -> any MTL4MachineLearningPipelineState

    /// Creates a new machine learning pipeline state asynchronously.
    ///
    /// - Parameters:
    ///   - descriptor: A machine learning pipeline state descriptor to use for creating the new pipeline state.
    ///
    /// - Returns: A machine learning pipeline state upon success, otherwise this function throws.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func makeMachineLearningPipelineState(descriptor: MTL4MachineLearningPipelineDescriptor) async throws -> any MTL4MachineLearningPipelineState
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
extension MTL4Archive {

    /// Creates a compute pipeline state from the archive with a compute descriptor and a dynamic linking descriptor.
    ///
    /// - Parameters:
    ///   - descriptor: A compute pipeline descriptor.
    ///   - dynamicLinkingDescriptor: A descriptor that provides additional properties to link other functions with the pipeline.
    ///
    /// - Returns: A compute pipeline state object upon success, otherwise this function throws.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func makeComputePipelineState(descriptor: MTL4ComputePipelineDescriptor, dynamicLinkingDescriptor: MTL4PipelineStageDynamicLinkingDescriptor? = nil) throws -> any MTLComputePipelineState

    /// Creates a render pipeline state from the archive with a render descriptor and a dynamic linking descriptor.
    ///
    /// You create any kind of render pipeline states with this method, including:
    /// - Traditional render pipelines
    /// - Mesh render pipelines
    /// - Tile render pipelines
    ///
    /// - Parameters:
    ///   - descriptor: A render pipeline descriptor.
    ///   - dynamicLinkingDescriptor: A descriptor that provides additional properties to link other functions with the pipeline.
    ///
    /// - Returns: A compute pipeline state object upon success, otherwise this function throws.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func makeRenderPipelineState(descriptor: MTL4PipelineDescriptor, dynamicLinkingDescriptor: MTL4RenderPipelineDynamicLinkingDescriptor? = nil) throws -> any MTLRenderPipelineState
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
extension MTL4RenderPassDescriptor {

    /// Configures the custom sample positions to use in MSAA rendering.
    ///
    /// Set to an empty array to disable custom sample positions.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public var samplePositions: [MTLSamplePosition]
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
extension MTLLogicalToPhysicalColorAttachmentMap {

    /// Maps a physical color attachment index to a logical index.
    ///
    /// To set the physical index, which represents the render pass color attachment index `P`, for a logical index,
    /// which represents the pipeline state's configuration for a color attachment `L`, assign:
    /// `myMapping[L] = P`. To retrieve a stored physical index use `let P = myMapping[L]`.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public subscript(logicalIndex: Int) -> Int
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
extension MTLTensorExtents {

    /// Creates a tensor with extents from an array of dimension values.
    ///
    /// You are responsible for ensuring the array contains at most `MTL_TENSOR_MAX_RANK` (`16`) elements.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public convenience init?(_ values: [Int])

    /// Retrieves the extents for this object.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public var extents: [Int] { get }
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
extension MTL4MachineLearningPipelineDescriptor {

    /// Sets the dimensions of multiple input tensors on a range of buffer bindings.
    ///
    /// - Parameters:
    ///   - dimensions: An array of tensor extents.
    ///   - bufferIndex: The index of the first input to modify. Subsequent array elements affect subsequent indices.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func setInputDimensions(_ dimensions: [MTLTensorExtents], bufferIndex: Int)
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
extension MTLResourceViewPool {

    /// Copies a range of resource views from a source view pool to a destination location in this view pool.
    ///
    /// - Parameters:
    ///   - sourcePool: resource view pool from which to copy resource views.
    ///   - sourceRange: The range in the source resource view pool to copy.
    ///   - destinationIndex: The starting index in this destination view pool into which to copy the source range of resource views.
    ///   
    /// - Returns: The ``MTLResourceID`` of the resource view corresponding to `destinationIndex` of the copy in this resource view pool.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func copyResourceViews(sourcePool: any MTLResourceViewPool, sourceRange: Range<Int>, destinationIndex: Int) -> MTLResourceID
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
extension MTLTextureViewDescriptor {

    /// A desired range of mip levels of a texture view.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public var levelRange: Range<Int>

    /// A desired range of slices of a texture view.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public var sliceRange: Range<Int>
}

@available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
extension MTL4CounterHeap {

    /// Resolves heap data on the CPU timeline.
    ///
    /// This method resolves heap data in the CPU timeline. Your app needs to ensure the GPU work has completed in order to
    /// retrieve the data correctly. You can alternatively resolve the heap data in the GPU timeline by calling
    /// ``MTL4CommandBuffer/resolveCounterHeap:withRange:intoBuffer:atOffset:waitFence:updateFence:``.
    ///
    /// - Note: When resolving counters in the CPU timeline, signaling an instance of ``MTLSharedEvent`` after any workloads
    ///  write counters (and waiting on that signal on the CPU) is sufficient to ensure synchronization.
    ///
    /// - Parameter range: The range in the heap to resolve.
    /// - Returns a newly allocated autoreleased NSData containing tightly packed resolved heap counter values.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func resolveCounterRange(_ range: Range<Int>) throws -> Data?

    /// Invalidates a range of entries in this counter heap.
    ///
    /// The effect of this call is immediate on the CPU timeline. You are responsible for ensuring that this counter heap is not currently in use on the GPU.
    ///
    /// - Note: Invalidated entries produce 0 when resolved.
    ///
    /// - Parameters:
    ///   - range: A heap index range to invalidate.
    @available(macOS 26.0, iOS 26.0, tvOS 26.0, *)
    public func invalidateCounterRange(_ range: Range<Int>)
}

