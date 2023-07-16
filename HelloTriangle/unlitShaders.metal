//
//  unlitShaders.metal
//  HelloTriangle
//
//  Created by Karthik Iyer on 16/07/23.
//

#include <metal_stdlib>
using namespace metal;

#include "definitions.h"

struct VertexUnlit {
    float4 position [[ attribute(0) ]];
    float2 texcoord [[ attribute(1) ]];
};

struct FragmentUnlit {
    float4 position [[position]]; // this is in screen space
    float2 texcoord;
};

vertex FragmentUnlit vertexShaderUnlit(const VertexUnlit  vertex_in [[ stage_in ]],
                             constant matrix_float4x4 &model [[ buffer(1) ]],
                             constant CameraParameters &camera [[ buffer(2) ]]) {
    
    FragmentUnlit output ;
    output.position = camera.projection *  camera.view * model * vertex_in.position;
    output.texcoord = vertex_in.texcoord;
    return output;
}

fragment float4 fragmentShaderUnlit(FragmentUnlit input [[stage_in]],
                               texture2d<float> objectTexture [[texture(0)]],
                               sampler samplerObject [[ sampler(0) ]],
                               constant float3 &tint [[ buffer(0) ]]) {
    float3 baseColor = float3(objectTexture.sample(samplerObject, input.texcoord));
    float alpha = objectTexture.sample(samplerObject, input.texcoord).a ;
    
    
    return float4(tint * baseColor, alpha);
}
