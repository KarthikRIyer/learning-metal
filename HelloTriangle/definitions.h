//
//  definitions.h
//  HelloTriangle
//
//  Created by Karthik Iyer on 18/06/23.
//

#ifndef definitions_h
#define definitions_h

#include <simd/simd.h>

struct Vertex {
    vector_float3 position;
    vector_float4 color;
};

struct CameraParameters {
    matrix_float4x4 view;
    matrix_float4x4 projection;
    vector_float3 position;
};

struct DirectionalLight {
    vector_float3 forwards;
    vector_float3 color;
};

struct SpotLight {
    vector_float3 forwards;
    vector_float3 position;
    vector_float3 color;
};

struct PointLight {
    vector_float3 position;
    vector_float3 color;
};

enum LightType {
    UNDEFINED,
    DIRECTIONAL,
    SPOTLIGHT,
    POINTLIGHT,
};

#endif /* definitions_h */
