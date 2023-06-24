//
//  RenderScene.swift
//  HelloTriangle
//
//  Created by Karthik Iyer on 23/06/23.
//

import Foundation

class RenderScene: ObservableObject {
    @Published var camera: Camera
    @Published var cubes: [SimpleComponent]
    
    init() {
        camera = Camera(position: [-5.0, 0.0, 2.5],
                        eulers: [0.0, 110.0, 0.0])
        
        cubes = [
            SimpleComponent(position: [3, 0.0, 0.0],
                            eulers: [0.0, 0.0, 0.0])
        ]
    }
    
    func update() {
        camera.updateVectors()
        for cube in cubes {
            cube.eulers.z += 1
            if cube.eulers.z > 360 {
                cube.eulers.z -= 360
            }
        }
    }
    
    func spinCamera(offset: CGSize) {
        let dTheta: Float = Float(offset.width)
        let dPhi: Float = Float(offset.height)
        
        camera.eulers.z -= 0.001 * dTheta
        camera.eulers.y += 0.001 * dPhi
        
        if camera.eulers.z < 0 || camera.eulers.z > 360{
            camera.eulers.z -= 360
        }
        
        if camera.eulers.y < 1 {
            camera.eulers.y = 1
        } else if camera.eulers.y > 179 {
            camera.eulers.y = 179
        }
        
        camera.updateVectors()
    }
}
