//
//  Renderer.swift
//  HelloTriangle
//
//  Created by Karthik Iyer on 18/06/23.
//

import MetalKit

class Renderer: NSObject, MTKViewDelegate {
    
    var parent: ContentView
    var metalDevice: MTLDevice!
    var metalCommandQueue: MTLCommandQueue!
    var allocator: MTKMeshBufferAllocator
    let materialLoader: MTKTextureLoader
    let pipelineState: MTLRenderPipelineState
    let depthStencilState: MTLDepthStencilState
    var scene: RenderScene
    let mesh: ObjMesh
    let material: Material
    
    init(_ parent: ContentView, scene: RenderScene) {
        self.parent = parent
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            self.metalDevice = metalDevice
        }
        self.metalCommandQueue = metalDevice.makeCommandQueue()
        self.allocator = MTKMeshBufferAllocator(device: metalDevice)
        self.materialLoader = MTKTextureLoader(device: metalDevice)
        material = Material(device: metalDevice, allocator: materialLoader, filename: "arty")
        
        mesh = ObjMesh(device: metalDevice, allocator: allocator, filename: "cube")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        let library = metalDevice.makeDefaultLibrary()
        pipelineDescriptor.vertexFunction = library?.makeFunction(name: "vertexShader")
        pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "fragmentShader")
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mesh.metalMesh.vertexDescriptor)
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilDescriptor.isDepthWriteEnabled = true
        depthStencilState = metalDevice.makeDepthStencilState(descriptor: depthStencilDescriptor)!
        
        do {
            try pipelineState = metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
              fatalError("could not create pipeline")
        }
         
        self.scene = scene 
        super.init()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        scene.update()
        guard let drawable = view.currentDrawable else {return}
        
        let commandBuffer = metalCommandQueue.makeCommandBuffer()
        let renderPassDescriptor = view.currentRenderPassDescriptor
        renderPassDescriptor?.colorAttachments[0].clearColor = MTLClearColorMake(0, 0.5, 0.5, 1.0)
        renderPassDescriptor?.colorAttachments[0].loadAction = .clear
        renderPassDescriptor?.colorAttachments[0].storeAction = .store
        
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor!)
        renderEncoder?.setRenderPipelineState(pipelineState)
        renderEncoder?.setDepthStencilState(depthStencilState)
        
        var cameraData: CameraParameters = CameraParameters()
        cameraData.view = scene.camera.view!
        cameraData.projection = Matrix44.create_perspective_projection(fovy: 45,
                                                                       aspect: 800/600,
                                                                       near: 0.1,
                                                                        far: 10)
        renderEncoder?.setVertexBytes(&cameraData, length: MemoryLayout<CameraParameters>.stride, index: 2)
        renderEncoder?.setVertexBuffer(mesh.metalMesh.vertexBuffers[0].buffer, offset: 0, index: 0)
        renderEncoder?.setFragmentTexture(material.texture, index: 0)
        renderEncoder?.setFragmentSamplerState(material.sampler, index: 0)
        for cube in scene.cubes {
            
            renderEncoder?.setVertexBytes(&(cube.model!), length: MemoryLayout<matrix_float4x4>.stride, index: 1)
            
            for submesh in mesh.metalMesh.submeshes {
                renderEncoder?.drawIndexedPrimitives(type: .triangle,
                                                     indexCount: submesh.indexCount,
                                                     indexType: submesh.indexType,
                                                     indexBuffer: submesh.indexBuffer.buffer,
                                                     indexBufferOffset: submesh.indexBuffer.offset)
            }
        }
        
        renderEncoder?.endEncoding()
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
    
    
    
}
