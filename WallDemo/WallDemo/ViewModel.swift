//
//  ViewModel.swift
//  WallDemo
//
//  Created by Hunter Harris on 10/6/23.
//

import SwiftUI
import RealityKit
import ARKit

class ViewModel: ObservableObject {
    @Published var immersionStyle: ImmersionStyle = .mixed
    
    func spawnBall() {
        guard let resource = try? TextureResource.load(named: "MetaverseTexture") else { return }
        
        var material = UnlitMaterial()
        material.color = .init(texture: .init(resource))
        
        let ballEntity = ModelEntity(mesh: .generateSphere(radius: 0.3), materials: [material], collisionShape: .generateSphere(radius: 0.3), mass: 100)
        
        ballEntity.components[PhysicsBodyComponent.self] = .init(massProperties: .default, material: .default,  mode: .dynamic)
        ballEntity.position = .init(x: 0, y: 5, z: 0)
        ballEntity.components[InputTargetComponent.self] = InputTargetComponent(allowedInputTypes: .all)
        ballEntity.generateCollisionShapes(recursive: true)
        rootEntity.addChild(ballEntity)
    }
}
