//
//  Shaders.metal
//  HelloTriangle
//
//  Created by Karthik Iyer on 18/06/23.
//

#include <metal_stdlib>
using namespace metal;

#include "definitions.h"

struct VertexIn {
    float4 position [[ attribute(0) ]];
    float2 texcoord [[ attribute(1) ]];
    float3 normal [[ attribute(2) ]];
};

struct Fragment {
    float4 position [[position]]; // this is in screen space
    float2 texcoord;
    float3 normal;
    float3 cameraPos;
    float3 fragPos;
};

vertex Fragment vertexShader(const VertexIn vertex_in [[ stage_in ]],
                             constant matrix_float4x4 &model [[ buffer(1) ]],
                             constant CameraParameters &camera [[ buffer(2) ]]) {
    
    matrix_float3x3 model_without_translation;
    model_without_translation[0][0] = model[0][0];
    model_without_translation[0][1] = model[0][1];
    model_without_translation[0][2] = model[0][2];
    model_without_translation[1][0] = model[1][0];
    model_without_translation[1][1] = model[1][1];
    model_without_translation[1][2] = model[1][2];
    model_without_translation[2][0] = model[2][0];
    model_without_translation[2][1] = model[2][1];
    model_without_translation[2][2] = model[2][2];
    
    Fragment output ;
    output.position = camera.projection *  camera.view * model * vertex_in.position;
    output.texcoord = vertex_in.texcoord;
    output.normal = model_without_translation * vertex_in.normal;
    output.fragPos = float3(model * vertex_in.position);
    return output;
}

fragment float4 fragmentShader(Fragment input [[stage_in]],
                               texture2d<float> objectTexture [[texture(0)]],
                               sampler samplerObject[[ sampler(0) ]],
                               constant DirectionalLight &sun [[ buffer(0) ]],
                               constant SpotLight &spotLight [[ buffer(1) ]]) {
    float3 baseColor = float3(objectTexture.sample(samplerObject, input.texcoord));
    float3 color = 0.2 * baseColor;
    
//    //directions
    float3 fragToCamera = normalize(input.cameraPos - input.fragPos);
//    float3 halfVec = normalize(-sun.forwards + fragToCamera);
//
//    //diffuse
//    float lightAmount = max(0.0, dot(input.normal, -sun.forwards));
//    color += lightAmount * baseColor * sun.color;
//
//    //specular
//    lightAmount = pow(max(0.0, dot(input.normal, halfVec)), 64);
//    color += lightAmount * baseColor * sun.color;
    
    //directions
    float3 fragToLight = normalize(spotLight.position - input.fragPos);
    float3 halfVec = normalize(fragToLight + fragToCamera);
    
    //diffuse
    float lightAmount = max(0.0, dot(input.normal, fragToLight)) * pow(max(0.0, dot(spotLight.forwards, -fragToLight)), 32);
    color += lightAmount * baseColor * spotLight.color;
    
    //specular
    lightAmount = pow(max(0.0, dot(input.normal, halfVec)), 64);
//    color += lightAmount * baseColor * sun.color;
    
    return float4(color, 1.0);
}
