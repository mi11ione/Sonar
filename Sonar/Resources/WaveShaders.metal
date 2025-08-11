// Sonar waveform color shader (SwiftUI colorEffect)
#include <metal_stdlib>
using namespace metal;

// Applies a subtle glow along a sine wave whose amplitude is driven by mic level.
// Signature per SwiftUI color shader requirements:
// [[ stitchable ]] half4 name(float2 position, half4 color, args...)
// See: SwiftUI Shader docs: [[ stitchable ]] half4 name(float2 position, half4 color, args...)
[[ stitchable ]]
half4 sonar_color_wave(float2 position, half4 srcColor, float amplitude, float phase)
{
    // Expected canvas height is ~60pt; center line at y=30
    const float midY = 30.0;
    const float baseAmp = 6.0;
    const float maxAmp = 28.0;
    const float freq = 0.03; // radians per point; ~2*pi every ~209pt

    float amp = clamp(baseAmp + amplitude * maxAmp, baseAmp, baseAmp + maxAmp);
    float y = sin(position.x * freq + phase) * amp + midY;
    float dist = fabs(position.y - y);

    // Exponential falloff around the curve for a gentle glow
    float glow = exp(-dist * 0.18);
    half3 rgb = half3(srcColor.rgb) * half(1.0 + glow * 0.9);
    return half4(rgb, srcColor.a);
}


