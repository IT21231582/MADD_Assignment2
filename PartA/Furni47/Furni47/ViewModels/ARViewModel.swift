import Foundation
import RealityKit
import ARKit
import Combine

// MARK: - AR View Model
/// ViewModel for managing AR scene state and interactions
class ARViewModel: NSObject, ObservableObject {
    // MARK: - Published Properties
    @Published var selectedFurniture: FurnitureItem?
    @Published var isPlacementEnabled = false
    @Published var arViewContainer: ARViewContainer?
    @Published var isSaved = false
    @Published var showSaveAlert = false
    @Published var alertMessage = ""
    
    // MARK: - Private Properties
    private let coreDataManager = CoreDataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    override init() {
        super.init()
        setupBindings()
    }
    
    // MARK: - Setup Bindings
    /// Sets up reactive bindings for the view model
    private func setupBindings() {
        $selectedFurniture
            .sink { [weak self] furniture in
                self?.isPlacementEnabled = furniture != nil
                if let furniture = furniture {
                    self?.isSaved = self?.coreDataManager.isFurnitureSaved(withId: furniture.id) ?? false
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Select Furniture
    /// Selects a furniture item for placement
    func selectFurniture(_ item: FurnitureItem) {
        selectedFurniture = item
        isPlacementEnabled = true
    }
    
    // MARK: - Save Furniture
    /// Saves the selected furniture to Core Data
    func saveFurniture() {
        guard let furniture = selectedFurniture else { return }
        
        if !coreDataManager.isFurnitureSaved(withId: furniture.id) {
            coreDataManager.saveFurniture(item: furniture)
            isSaved = true
            alertMessage = "✓ \(furniture.name) saved to favorites!"
        } else {
            alertMessage = "Already saved!"
        }
        showSaveAlert = true
    }
    
    // MARK: - Reset Scene
    /// Resets the AR scene
    func resetScene() {
        selectedFurniture = nil
        isPlacementEnabled = false
        arViewContainer?.resetScene()
    }
    
    // MARK: - Load Model
    /// Loads a 3D model from the Models folder
    func loadModel(named modelName: String) -> ModelEntity? {
        do {
            let model = try ModelEntity.loadModel(named: modelName)
            return model
        } catch {
            print("Error loading model \(modelName): \(error)")
            return nil
        }
    }
}
