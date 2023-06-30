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
    @Published var groundTiles: [Entity]
    @Published var sun: Light
    @Published var spotLight: Light
    
    init() {
        cubes = []
        groundTiles = []
        
        let newCamera = Entity()
        newCamera.addCameraComponent(position: [-5.0, 2.5, 3.5], eulers: [0.0, 110.0, 40.0])
        camera = newCamera
        
        let newSpotLight = Light(color: [1.0, 0.0, 0.0])
        newSpotLight.setSpotlight(position: [-2.0, 0.0, 2.0], eulers: [0.0, 0.0, 180.0])
        spotLight = newSpotLight
        
        let newSun = Light(color: [1.0, 1.0, 0.0])
        newSun.setDirectional(eulers: [0.0, 135.0, -45.0])
        sun = newSun
        sun.update()
        
        let newCube = Entity()
        newCube.addTransformComponent(position: [3.0, 0.0, 0.0], eulers: [0.0, 0.0, 0.0])
        cubes.append(newCube)
        
        
        let newTile = Entity()
        newTile.addTransformComponent(position: [3.0, 0.0, -1.0], eulers: [90.0, 0.0, 0.0])
        groundTiles.append(newTile)
    }
    
    func update() {
        camera.update()
        for cube in cubes {
//            cube.eulers!.z += 1
//            if cube.eulers!.z > 360 {
//                cube.eulers!.z -= 360
//            }
            cube.update()
        }
        for tile in groundTiles {
            tile.update()
        }
        spotLight.update()
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
