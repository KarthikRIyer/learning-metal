//
//  Entity.swift
//  HelloTriangle
//
//  Created by Karthik Iyer on 29/06/23.
//

import Foundation
import simd 

class Entity {
    var hasTransformComponent: Bool
    var position: simd_float3?
    var eulers: simd_float3?
    var model: matrix_float4x4?
    
    var hasCameraComponent: Bool
    var forwards: vector_float3?
    var right: vector_float3?
    var up: vector_float3?
    var view: matrix_float4x4?
    
    init() {
        self.hasCameraComponent = false
        self.hasTransformComponent = false
    }
    
    func addTransformComponent(position: simd_float3, eulers: simd_float3) {
        self.hasTransformComponent = true
        self.position = position
        self.eulers = eulers
//        self.model = Matrix44.create_identity()
        update()
    }
    
    func addCameraComponent(position: simd_float3, eulers: simd_float3) {
        self.hasCameraComponent = true
        self.position = position
        self.eulers = eulers
//        self.view = Matrix44.create_identity()
        update()
    }
    
    func strafe(rightAmount: Float, upAmount: Float) {
//        let distanceFromOrigin = simd.length(position!)
        position = position! + rightAmount * right! + upAmount * up!
        let distanceFromOrigin = simd.length(position!)
        moveForwards(amount: distanceFromOrigin - 10)
    }
    
    func moveForwards(amount: Float) {
        position = position! + amount * forwards!
    }
    
    func update() {
        if hasTransformComponent {
            model = Matrix44.create_from_rotation(eulers: eulers!)
            model = Matrix44.create_from_translation(translation: position!) * model!
        }
        
        if hasCameraComponent {
//            forwards = [
//                cos(eulers![2] * .pi / 180.0) * sin(eulers![1] * .pi / 180.0),
//                sin(eulers![2] * .pi / 180.0) * cos(eulers![1] * .pi / 180.0),
//                cos(eulers![1] * .pi / 180.0)
//            ]
            
            forwards = simd.normalize([0,0,0] - position!)
            
            let globalUp: vector_float3 = [0.0, 0.0, 1.0]
            right = simd.normalize(simd.cross(globalUp, forwards!))
            up = simd.normalize(simd.cross(forwards!, right!))
            view = Matrix44.create_lookat(eye: position!,
//                                          target: position! + forwards!,
                                          target: [0,0,0],
                                          up: up!)
        }
        
    }
    
}
