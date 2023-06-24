//
//  HelloTriangleApp.swift
//  HelloTriangle
//
//  Created by Karthik Iyer on 18/06/23.
//

import SwiftUI

@main
struct HelloTriangleApp: App {
    
    @StateObject  private var renderScene = RenderScene()
    
    var body: some Scene {
        WindowGroup {
            appView().environmentObject(renderScene)
        }
    }
}
