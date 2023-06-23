//
//  appView.swift
//  HelloTriangle
//
//  Created by Karthik Iyer on 23/06/23.
//

import SwiftUI

struct appView : View {
    var body: some View {
        VStack {
//            Text("My Triangle")
            ContentView().frame(width: 800, height: 600)
        }
    }
}

struct appView_Previews : PreviewProvider {
    static var  previews: some View {
        appView()
    }
}
