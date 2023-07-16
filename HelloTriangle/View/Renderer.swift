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
    var meshAllocator: MTKMeshBufferAllocator
    let materialLoader: MTKTextureLoader
    let litPipelineState: MTLRenderPipelineState
    let unlitPipelineState: MTLRenderPipelineState
    let depthStencilState: MTLDepthStencilState
    var scene: RenderScene
    
    let cubeMesh: ObjMesh
    let groundMesh: ObjMesh
    let mausMesh: ObjMesh
    let lightMesh: ObjMesh
    
    let cubeMaterial: Material
    let woodyMaterial: Material
    let mausMaterial: Material
    let lightMaterial: Material
    
    init(_ parent: ContentView, scene: RenderScene) {
        self.parent = parent
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            self.metalDevice = metalDevice
        }
        self.metalCommandQueue = metalDevice.makeCommandQueue()
        self.meshAllocator = MTKMeshBufferAllocator(device: metalDevice)
        self.materialLoader = MTKTextureLoader(device: metalDevice)
        cubeMaterial = Material(device: metalDevice, allocator: materialLoader, filename: "arty", filenameExtension: "jpg")
        woodyMaterial = Material(device: metalDevice, allocator: materialLoader, filename: "wood", filenameExtension: "jpeg")
        mausMaterial = Material(device: metalDevice, allocator: materialLoader, filename: "maus", filenameExtension: "png")
        lightMaterial = Material(device: metalDevice, allocator: materialLoader, filename: "star", filenameExtension: "png")
        
        cubeMesh = ObjMesh(device: metalDevice, allocator: meshAllocator, filename: "cube")
        groundMesh = ObjMesh(device: metalDevice, allocator: meshAllocator, filename: "ground")
        mausMesh = ObjMesh(device: metalDevice, allocator: meshAllocator, filename: "mouse")
        lightMesh = ObjMesh(device: metalDevice, allocator: meshAllocator, filename: "light")
        
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilDescriptor.isDepthWriteEnabled = true
        depthStencilState = metalDevice.makeDepthStencilState(descriptor: depthStencilDescriptor)!
        
        guard let metalLibrary: MTLLibrary = metalDevice.makeDefaultLibrary() else {
            fatalError("Could not create MTLLibrary")
        }
        let vertexDescriptor: MDLVertexDescriptor = cubeMesh.modelIOMesh.vertexDescriptor
        litPipelineState = PipelineBuilder.buildPipeline(metalDevice: metalDevice, library: metalLibrary, vsEntry: "vertexShader", fsEntry: "fragmentShader", vertexDescriptor: vertexDescriptor)
        unlitPipelineState = PipelineBuilder.buildPipeline(metalDevice: metalDevice, library: metalLibrary, vsEntry: "vertexShaderUnlit", fsEntry: "fragmentShaderUnlit", vertexDescriptor: vertexDescriptor)
         
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
        
        drawLitObjects(renderEncoder: renderEncoder)
        drawUnlitObjects(renderEncoder: renderEncoder)
        
        renderEncoder?.endEncoding()
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
    func drawLitObjects(renderEncoder: MTLRenderCommandEncoder?) {
        renderEncoder?.setRenderPipelineState(litPipelineState)
        renderEncoder?.setDepthStencilState(depthStencilState)
        
        sendCameraData(renderEncoder: renderEncoder)
        
        sendLightData(renderEncoder: renderEncoder)
        
        armForDrawing(renderEncoder: renderEncoder, mesh: cubeMesh, material: cubeMaterial)
        
        for cube in scene.cubes {
            draw(renderEncoder: renderEncoder, mesh: cubeMesh, modelTransform: &(cube.model!))
        }
        
        //armForDrawing()
        armForDrawing(renderEncoder: renderEncoder, mesh: groundMesh, material: woodyMaterial)
        for tile in scene.groundTiles {
            draw(renderEncoder: renderEncoder, mesh: groundMesh, modelTransform: &(tile.model!))
        }
        
        armForDrawing(renderEncoder: renderEncoder, mesh: mausMesh, material: mausMaterial)
        draw(renderEncoder: renderEncoder, mesh: mausMesh, modelTransform: &(scene.maus.model))
        
    }
    
    func drawUnlitObjects(renderEncoder: MTLRenderCommandEncoder?) {
        renderEncoder?.setRenderPipelineState(unlitPipelineState)
        renderEncoder?.setDepthStencilState(depthStencilState)
        
        sendCameraData(renderEncoder: renderEncoder)
        
        armForDrawing(renderEncoder: renderEncoder, mesh: lightMesh, material: lightMaterial)
        
        for light in scene.pointLights {
            renderEncoder?.setFragmentBytes(&(light.color), length: MemoryLayout<simd_float3>.stride, index: 0)
            draw(renderEncoder: renderEncoder, mesh: lightMesh, modelTransform: &(light.model))
        }
    }
    
    func sendCameraData(renderEncoder: MTLRenderCommandEncoder?) {
        var cameraData: CameraParameters = CameraParameters()
        cameraData.view = scene.camera.view!
        cameraData.position = scene.camera.position!
        cameraData.projection = Matrix44.create_perspective_projection(fovy: 45,
                                                                       aspect: 800/600,
                                                                       near: 0.1,
                                                                        far: 100)
        renderEncoder?.setVertexBytes(&cameraData, length: MemoryLayout<CameraParameters>.stride, index: 2)
    }
    
    func sendLightData(renderEncoder: MTLRenderCommandEncoder?) {
        var sun: DirectionalLight = DirectionalLight()
        sun.forwards = scene.sun.forwards!
        sun.color = scene.sun.color
        renderEncoder?.setFragmentBytes(&sun, length: MemoryLayout<DirectionalLight>.stride, index: 0)
        
        var spotLight: SpotLight = SpotLight()
        spotLight.color = scene.spotLight.color
        spotLight.forwards = scene.spotLight.forwards!
        spotLight.position = scene.spotLight.position!
        renderEncoder?.setFragmentBytes(&spotLight, length: MemoryLayout<SpotLight>.stride, index: 1)
        
        var pointLights: [PointLight] = []
        for light in scene.pointLights {
            pointLights.append(PointLight(position: light.position, color: light.color))
        }
        renderEncoder?.setFragmentBytes(&pointLights, length: MemoryLayout<PointLight>.stride * scene.pointLights.count, index: 2)
        
        var fragUBO: FragmentData = FragmentData()
        fragUBO.lightCount = UInt32(scene.pointLights.count)
        renderEncoder?.setFragmentBytes(&fragUBO, length: MemoryLayout<FragmentData>.stride, index: 3)
    }
    
    func armForDrawing(renderEncoder: MTLRenderCommandEncoder?, mesh: ObjMesh, material: Material) {
        renderEncoder?.setVertexBuffer(mesh.metalMesh.vertexBuffers[0].buffer, offset: 0, index: 0)
        renderEncoder?.setFragmentTexture(material.texture, index: 0)
        renderEncoder?.setFragmentSamplerState(material.sampler, index: 0)
    }
    
    func draw(renderEncoder: MTLRenderCommandEncoder?, mesh: ObjMesh, modelTransform: UnsafeMutablePointer<matrix_float4x4>) {
        renderEncoder?.setVertexBytes(modelTransform, length: MemoryLayout<matrix_float4x4>.stride, index: 1)

        for submesh in mesh.metalMesh.submeshes {
            renderEncoder?.drawIndexedPrimitives(type: .triangle,
                                                 indexCount: submesh.indexCount,
                                                 indexType: submesh.indexType,
                                                 indexBuffer: submesh.indexBuffer.buffer,
                                                 indexBufferOffset: submesh.indexBuffer.offset)
        }
    }
    
}
