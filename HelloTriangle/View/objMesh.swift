//
//  objMesh.swift
//  HelloTriangle
//
//  Created by Karthik Iyer on 24/06/23.
//

import MetalKit

class ObjMesh {
    let modelIOMesh: MDLMesh
    let metalMesh: MTKMesh
    
    init(device: MTLDevice, allocator: MTKMeshBufferAllocator, filename: String) {
        guard let meshURL = Bundle.main.url(forResource: filename, withExtension: "obj") else {
            fatalError("Could not load mesh")
        }
        
        let vertexDescriptor = MTLVertexDescriptor()
        var offset: Int = 0
        
        //position
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = offset
        vertexDescriptor.attributes[0].bufferIndex = 0
        offset += MemoryLayout<SIMD3<Float>>.stride
        
        vertexDescriptor.layouts[0].stride = offset
        
        let meshDescriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor)
        (meshDescriptor.attributes[0] as! MDLVertexAttribute).name = MDLVertexAttributePosition
        
        let asset = MDLAsset(url: meshURL, vertexDescriptor: meshDescriptor, bufferAllocator: allocator)
        modelIOMesh = asset.childObjects(of: MDLMesh.self).first as! MDLMesh
        
        do {
            metalMesh = try MTKMesh(mesh: modelIOMesh, device: device)
        } catch {
            fatalError("Could not convert modelIOMesh to metalMesh")
        }
    }
}