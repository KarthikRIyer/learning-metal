//
//  RenderScene.swift
//  HelloTriangle
//
//  Created by Karthik Iyer on 23/06/23.
//

import Foundation

class RenderScene: ObservableObject {
    @Published var camera: Entity
    @Published var cubes: [Entity]
    
    init() {
        let newCamera = Entity()
        newCamera.addCameraComponent(position: [-5.0, 0.0, 2.5], eulers: [0.0, 110.0, 0.0])
        camera = newCamera
        
        cubes = []
        let newCube = Entity()
        newCube.addTransformComponent(position: [3, 0.0, 0.0], eulers: [0.0, 0.0, 0.0])
        cubes.append(newCube)
    }
    
    func update() {
        camera.update()
        for cube in cubes {
            cube.eulers!.z += 1
            if cube.eulers!.z > 360 {
                cube.eulers!.z -= 360
            }
            cube.update()
        }
    }
    
    func spinCamera(offset: CGSize) {
        let dTheta: Float = Float(offset.width)
        let dPhi: Float = Float(offset.height)
        
        camera.eulers!.z -= 0.001 * dTheta
        camera.eulers!.y += 0.001 * dPhi
        
        if camera.eulers!.z < 0 || camera.eulers!.z > 360{
            camera.eulers!.z -= 360
        }
        
        if camera.eulers!.y < 1 {
            camera.eulers!.y = 1
        } else if camera.eulers!.y > 179 {
            camera.eulers!.y = 179
        }
        
//        camera.updateVectors()
    }
}
