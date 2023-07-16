//
//  billboard.swift
//  HelloTriangle
//
//  Created by Karthik Iyer on 16/07/23.
//

import Foundation
import simd

class Billboard {
    var position: simd_float3
    var model: matrix_float4x4
    
    init(position: simd_float3) {
        self.position = position
        self.model = Matrix44.create_identity()
    }
    
    func update(viewerPos: simd_float3) {
        let selfToViewer = viewerPos - position
        let theta = simd.atan2(selfToViewer[1],  selfToViewer[0]) * (180.0 / .pi)
        let horizontalDistance = simd.length(selfToViewer)
        let phi = -simd.atan2(selfToViewer[2],  horizontalDistance) * (180.0 / .pi)
        model = Matrix44.create_from_rotation(eulers: [0, phi, theta])
        model = Matrix44.create_from_translation(translation: position) * model
    }
}
