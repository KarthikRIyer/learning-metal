//
//  ContentView.swift
//  HelloTriangle
//
//  Created by Karthik Iyer on 18/06/23.
//

import SwiftUI
import MetalKit

struct ContentView: NSViewRepresentable {
    
    func makeCoordinator() -> Renderer {
        Renderer(self)
    }
    
    func makeNSView(context: NSViewRepresentableContext<ContentView>) -> MTKView {
        let mtkView = MTKView()
        mtkView.delegate = context.coordinator
        mtkView.preferredFramesPerSecond = 60
        mtkView.enableSetNeedsDisplay = true
        
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            mtkView.device = metalDevice
        }
        
        mtkView.framebufferOnly = false
        mtkView.drawableSize = mtkView.frame.size
        
        return mtkView
    }
    
    func updateNSView(_ nsView: MTKView, context: NSViewRepresentableContext<ContentView>) {
    
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
