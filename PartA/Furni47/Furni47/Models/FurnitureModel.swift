import Foundation

// MARK: - Swift Model for UI
struct FurnitureItem: Identifiable, Codable {
    let id: UUID
    let name: String
    let modelName: String
    let timestamp: Date

    init(id: UUID = UUID(), name: String, modelName: String, timestamp: Date = Date()) {
        self.id = id
        self.name = name
        self.modelName = modelName
        self.timestamp = timestamp
    }

    // Convert from Core Data entity (handling optionals safely)
    init(from entity: FurnitureEntity) {
        self.id = entity.id ?? UUID()
        self.name = entity.name ?? ""
        self.modelName = entity.modelName ?? ""
        self.timestamp = entity.timestamp ?? Date()
    }
}

// MARK: - Sample Furniture Data
struct SampleFurniture {
    static let chair = FurnitureItem(name: "Modern Chair", modelName: "chair")
    static let table = FurnitureItem(name: "Dining Table", modelName: "table")
    static let lamp = FurnitureItem(name: "Floor Lamp", modelName: "lamp")

    static let all = [chair, table, lamp]
}
