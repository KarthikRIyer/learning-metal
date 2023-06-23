//
//  RenderScene.swift
//  HelloTriangle
//
//  Created by Karthik Iyer on 23/06/23.
//

import Foundation

class RenderScene {
    var camera: Camera
    var triangles: [SimpleComponent]
    
    init() {
        camera = Camera(position: [0.0, 0.0, 0.0],
                        eulers: [0.0, 90.0, 0.0])
        
        triangles = [
            SimpleComponent(position: [05, 0.0, 0.0],
                            eulers: [0.0, 0.0, 0.0])
        ]
    }
    
    func update() {
        camera.updateVectors()
        for triangle in triangles {
            triangle.eulers.z += 1
            if triangle.eulers.z > 360 {
                triangle.eulers.z -= 360
            }
        }
    }
}
