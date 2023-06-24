//
//  appView.swift
//  HelloTriangle
//
//  Created by Karthik Iyer on 23/06/23.
//

import SwiftUI

struct appView : View {
    
    @EnvironmentObject var renderScene: RenderScene
    
    var body: some View {
        VStack {
            ContentView()
                .frame(width: 800, height: 600)
                .gesture(DragGesture()
                    .onChanged { gesture in
                        renderScene.spinCamera(offset: gesture.translation)
                    })
        }
    }
}

struct appView_Previews : PreviewProvider {
    static var  previews: some View {
        appView().environmentObject(RenderScene() )
    }
}
