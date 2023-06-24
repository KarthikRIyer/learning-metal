//
//  RenderScene.swift
//  HelloTriangle
//
//  Created by Karthik Iyer on 23/06/23.
//

import Foundation

class RenderScene {
    var camera: Camera
    var cubes: [SimpleComponent]
    
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
}
