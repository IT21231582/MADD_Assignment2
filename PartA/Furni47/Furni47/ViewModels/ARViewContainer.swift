import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {
    let selectedModelName: String?

    // Registry to access the underlying ARView for a given container instance
    private static var viewRegistry = NSMapTable<ARViewContainerBox, ARView>(keyOptions: .weakMemory, valueOptions: .weakMemory)
    private let box = ARViewContainerBox()

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        arView.session.run(config, options: [])

        // Store in registry
        ARViewContainer.viewRegistry.setObject(arView, forKey: box)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // Later: place model here using selectedModelName if needed
    }

    // Public API to reset the AR scene
    func resetScene() {
        guard let arView = ARViewContainer.viewRegistry.object(forKey: box) else { return }

        // Remove all anchors
        arView.scene.anchors.removeAll()

        // Restart AR session with reset options
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        arView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
    }
}

// Helper class to provide a stable reference identity for the NSMapTable key
private final class ARViewContainerBox: NSObject {}
