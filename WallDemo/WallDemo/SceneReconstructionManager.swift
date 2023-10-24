//
//  SceneReconstructionManager.swift
//  WallDemo
//
//  Created by Hunter Harris on 10/5/23.
//

import ARKit
import RealityKit
import Combine

let rootEntity = Entity()

class SceneReconstructionManager {
    static var shared = SceneReconstructionManager()
    
    var generated: Bool = false
    var wallMaterial: SimpleMaterial = .init()
    
    init () {
        loadWallMaterial()
    }
    
    private func loadWallMaterial() {
        wallMaterial.color = .init(tint: .white.withAlphaComponent(1),
                                   texture: .init(try! .load(named: "MetaverseTexture.png")))
    }
    
    func generate() {
        guard SceneReconstructionProvider.isSupported else { return }
        let session = ARKitSession()
        let sceneInfo = SceneReconstructionProvider(modes: [.classification])
        
        Task {
            try await session.run([sceneInfo])
            for await update in sceneInfo.anchorUpdates {
                handleUpdate(update: update)
            }
        }
    }
    
    /// Handle Anchor Updates from SceneReconstructionProvider
    /// since this will be ran continuously, we need to keep track of which anchors we've added and their corresponding ModelEntity
    ///
    /// If we already have an Anchor, update it with the new mesh information
    func handleUpdate(update: AnchorUpdate<MeshAnchor>) {
        _ = Task(priority: .low) {
            if MeshAnchorTracker.containsAnchor(anchor: update.anchor) {
                await MeshAnchorTracker.shared.updateAnchor(anchor: update.anchor)
            } else {
                await MeshAnchorTracker.shared.createNewModel(anchor: update.anchor)
            }
        }
    }
}
    
    
    //  Non-tested, just generate a single mesh 1 time,
    //  unsure if sceneInfo.anchorUpdates provides continues updates or not
    //
    //    func handleUpdate(update: AnchorUpdate<MeshAnchor>) {
    //
    //        guard !generated else { return }
    //        _ = Task(priority: .low) {
    //            do {
    //                let shape = try await ShapeResource.generateStaticMesh(from: update.anchor)
    //                let anchor = update.anchor
    //
    //
    //                Task { @MainActor in
    //
    //                    let entity = ModelEntity(mesh: .generateBox(size: 1), materials: [wallMaterial])
    //                    entity.components[CollisionComponent.self] = .init(shapes: [shape])
    //                    entity.components[PhysicsBodyComponent.self] = .init(
    //                        massProperties: .default,
    //                        material: nil,
    //                        mode: .static
    //                    )
    //
    //                    rootEntity.addChild(entity)
    //                    generated = true
    //                    print("Successfully generated mesh for scene collision.")
    //
    //                    do {
    //                        entity.transform = .init(matrix: anchor.originFromAnchorTransform)
    //                        let geom = anchor.geometry
    //                        var desc = MeshDescriptor()
    //                        let posValues = geom.vertices.asSIMD3(ofType: Float.self)
    //                        desc.positions = .init(posValues)
    //                        let normalValues = geom.normals.asSIMD3(ofType: Float.self)
    //                        desc.normals = .init(normalValues)
    //                        do {
    //                            desc.primitives = .polygons(
    //                                (0..<geom.faces.count).map { _ in UInt8(geom.faces.primitive.indexCount ) },
    //                                (0..<geom.faces.count * geom.faces.primitive.indexCount).map {
    //                                geom.faces.buffer.contents()
    //                                    .advanced(by: $0 * geom.faces.bytesPerIndex)
    //                                    .assumingMemoryBound(to: UInt32.self).pointee
    //                                }
    //                            )
    //                        }
    //
    //                        do {
    //                            let meshResource = try await MeshResource.init(from: [desc])
    //                            entity.components[ModelComponent.self] = ModelComponent(
    //                                mesh: meshResource,
    //                                materials: [wallMaterial]
    //                            )
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //    }
