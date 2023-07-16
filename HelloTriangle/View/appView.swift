//
//  appView.swift
//  HelloTriangle
//
//  Created by Karthik Iyer on 23/06/23.
//

import SwiftUI
import simd

struct appView : View {
    
    @EnvironmentObject var renderScene: RenderScene
    
    var body: some View {
        VStack {
            Text("Billboard")
            ContentView()
                .frame(width: 800, height: 600)
                .gesture(DragGesture()
                    .onChanged { gesture in
                        renderScene.strafeCamera(offset: gesture.translation)
                    })
            Text("Debug info")
        }
        VStack {
            Text("Camera")
            HStack {
                Text("Position")
                VStack {
                    Text(String(renderScene.camera.position![0]))
                    Text(String(renderScene.camera.position![1]))
                    Text(String(renderScene.camera.position![2 ]))
                }
                Text("Distance")
                Text(String(simd.length(renderScene.camera.position!)))
                Text("Forwards")
                VStack {
                    Text(String(renderScene.camera.forwards![0]))
                    Text(String(renderScene.camera.forwards![1]))
                    Text(String(renderScene.camera.forwards![2]))
                }
                Text("Right")
                VStack {
                    Text(String(renderScene.camera.right![0]))
                    Text(String(renderScene.camera.right![1]))
                    Text(String(renderScene.camera.right![2]))
                }
                Text("Up")
                VStack {
                    Text(String(renderScene.camera.up![0]))
                    Text(String(renderScene.camera.up![1]))
                    Text(String(renderScene.camera.up![2]))
                }
            }
        }
    }
}

struct appView_Previews : PreviewProvider {
    static var  previews: some View {
        appView().environmentObject(RenderScene() )
    }
}
