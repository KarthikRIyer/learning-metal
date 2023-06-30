//
//  Light.swift
//  HelloTriangle
//
//  Created by Karthik Iyer on 30/06/23.
//

import Foundation

class Light {
    var type: LightType
    var position: vector_float3?
    var eulers: vector_float3?
    var forwards: vector_float3?
    var color: vector_float3
    var t: Float?
    var rotationCenter: vector_float3?
    var pathRadius: Float?
    var pathPhi: Float?
    var angularVelocity: Float?
    
    init(color: vector_float3) {
        self.type = UNDEFINED
        self.color = color
    }
    
    func setDirectional(eulers: vector_float3) {
        self.type = DIRECTIONAL
        self.eulers = eulers
    }
    
    func setSpotlight(position: vector_float3, eulers: vector_float3) {
        self.type = SPOTLIGHT
        self.eulers = eulers
        self.position = position
        self.t = 0.0
    }
    
    func setPointLight(rotationCenter: vector_float3,
                       pathRadius: Float, pathPhi: Float, angularVelocity: Float) {
        self.type = POINTLIGHT
        self.rotationCenter = rotationCenter
        self.pathRadius = pathRadius
        self.pathPhi = pathPhi
        self.angularVelocity = angularVelocity
        self.t = 0.0
        self.position = rotationCenter
    }
    
    func update() {
        if type == DIRECTIONAL {
            forwards = [
                cos(eulers![2] * .pi / 180.0) * sin(eulers![1] * .pi / 180.0),
                sin(eulers![2] * .pi / 180.0) * cos(eulers![1] * .pi / 180.0),
                cos(eulers![1] * .pi / 180.0)
            ]
        } else if type == SPOTLIGHT {
            eulers![1] += 1
            if eulers![1] > 360 {
                eulers! -= 360
            }
            forwards = [
                cos(eulers![2] * .pi / 180.0) * sin(eulers![1] * .pi / 180.0),
                sin(eulers![2] * .pi / 180.0) * cos(eulers![1] * .pi / 180.0),
                cos(eulers![1] * .pi / 180.0)
            ]
        } else if type == POINTLIGHT {
            
        }
    }
}
