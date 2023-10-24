//
//  ImmersiveView.swift
//  WallDemo
//
//  Created by Hunter Harris on 10/6/23.
//

import Foundation
import SwiftUI
import _RealityKit_SwiftUI

struct ImmersiveView: View {
    
    var body: some View {
        RealityView { content in
            content.add(rootEntity) // Add the global root entity for the scene
        }.task {
            SceneReconstructionManager.shared.generate()
        }
    }
}
