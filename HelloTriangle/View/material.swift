//
//  material.swift
//  HelloTriangle
//
//  Created by Karthik Iyer on 29/06/23.
//

import MetalKit

class Material {
    let texture: MTLTexture
    let sampler: MTLSamplerState
    
    init(device: MTLDevice, allocator: MTKTextureLoader, filename: String) {
        
        let options: [MTKTextureLoader.Option: Any] = [
            .SRGB: false,
            .generateMipmaps: true
        ]
        
        do {
            texture = try allocator.newTexture(name: filename, scaleFactor: 1, bundle: Bundle.main, options: options)
        } catch {
            fatalError("Could not load texture")
        }
        
        let samplerDescriptor = MTLSamplerDescriptor()
        samplerDescriptor.sAddressMode = .repeat
        samplerDescriptor.tAddressMode = .repeat
        samplerDescriptor.minFilter = .nearest
        samplerDescriptor.magFilter = .linear
        
        sampler = device.makeSamplerState(descriptor: samplerDescriptor)!
    }
}
