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
    
    init(device: MTLDevice, allocator: MTKTextureLoader, filename: String, filenameExtension: String) {
        
        let options: [MTKTextureLoader.Option: Any] = [
            .SRGB: false,
            .generateMipmaps: true
        ]

        guard let materialURL = Bundle.main.url(forResource: filename, withExtension: filenameExtension) else {
            fatalError("Could not load image \(filename)")
        }
        
        do {
            texture = try allocator.newTexture(URL: materialURL, options: options)
        } catch {
            print("\(error)")
            fatalError("Could not load texture from \(filename)")
        }
        
        let samplerDescriptor = MTLSamplerDescriptor()
        samplerDescriptor.sAddressMode = .repeat
        samplerDescriptor.tAddressMode = .repeat
        samplerDescriptor.minFilter = .nearest
        samplerDescriptor.magFilter = .linear
        
        sampler = device.makeSamplerState(descriptor: samplerDescriptor)!
    }
}
