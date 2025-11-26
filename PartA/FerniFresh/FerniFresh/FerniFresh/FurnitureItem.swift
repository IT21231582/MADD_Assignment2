import Foundation

struct FurnitureItem: Identifiable {
    let id = UUID()
    let name: String
    let nameShort: String
    let modelName: String
}

struct SampleFurniture {
    static let chair = FurnitureItem(
        name: "Modern Chair",
        nameShort: "Chair",
        modelName: "chair"
    )

    static let table = FurnitureItem(
        name: "Dining Table",
        nameShort: "Table",
        modelName: "table"
    )

    static let lamp = FurnitureItem(
        name: "Floor Lamp",
        nameShort: "Lamp",
        modelName: "lamp"
    )

    static let all = [chair, table, lamp]
}
