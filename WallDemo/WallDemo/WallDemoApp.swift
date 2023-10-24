//
//  WallDemoApp.swift
//  WallDemo
//
//  Created by Hunter Harris on 10/5/23.
//

import SwiftUI

@main
struct WallDemoApp: App {
    
    @State private var viewModel = ViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }.immersionStyle(selection: $viewModel.immersionStyle, in: .full, .mixed)
    }
}
