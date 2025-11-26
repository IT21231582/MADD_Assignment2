import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {
    let selectedModelName: String
    @Binding var placeRequest: Int

    class Coordinator: NSObject {
        var arView: ARView?
        var lastPlaceRequest: Int = 0

        func placeModel(named name: String) {
            guard let arView = arView else { return }

            // Raycast from the center of the screen
            let center = CGPoint(x: arView.bounds.midX, y: arView.bounds.midY)
            let results = arView.raycast(
                from: center,
                allowing: .estimatedPlane,
                alignment: .horizontal
            )

            guard let result = results.first else {
                print("[AR] No surface found to place model")
                return
            }

            do {
                let entity = try ModelEntity.load(named: name)
                entity.generateCollisionShapes(recursive: true)

                let anchor = AnchorEntity(world: result.worldTransform)
                anchor.addChild(entity)

                arView.scene.addAnchor(anchor)

                print("[AR] Placed model:", name)
            } catch {
                print("[AR] Failed to load model '\(name)': \(error)")
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        config.environmentTexturing = .automatic

        arView.session.run(config)
        context.coordinator.arView = arView

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // When placeRequest changes, place the selected model
        if placeRequest != context.coordinator.lastPlaceRequest {
            context.coordinator.lastPlaceRequest = placeRequest
            context.coordinator.placeModel(named: selectedModelName)
        }
    }
}
