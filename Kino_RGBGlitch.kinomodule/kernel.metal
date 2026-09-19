#include <metal_stdlib>
#include <CoreImage/CoreImage.h>

using namespace metal;

// CIColorKernel memanipulasi warna dari setiap piksel
extern "C" coreimage::sample_t rgbGlitchKernel(
    coreimage::sampler src,
    float intensity,
    float4 tintColor
) {
    // Geser koordinat berdasarkan intensitas
    float2 offsetR = float2(intensity * 0.05, 0.0);
    float2 offsetB = float2(-intensity * 0.05, 0.0);
    
    // Ambil sampel piksel yang digeser
    float4 rSample = src.sample(src.coord() + offsetR);
    float4 gSample = src.sample(src.coord());
    float4 bSample = src.sample(src.coord() + offsetB);
    
    // Campurkan warna yang sudah bergeser (efek chromatic aberration)
    float4 glitchedColor = float4(rSample.r, gSample.g, bSample.b, gSample.a);
    
    // Gabungkan dengan warna Tint Color menggunakan Alpha blending sederhana
    // Jika tintColor.a sangat rendah, maka tidak ada tint.
    float tintBlend = tintColor.a * 0.5;
    float4 finalColor = mix(glitchedColor, tintColor, tintBlend);
    
    return finalColor;
}
