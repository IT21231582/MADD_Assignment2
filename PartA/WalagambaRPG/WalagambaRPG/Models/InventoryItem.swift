import Foundation

enum ItemType: String, Codable {
    case weapon
    case armor
    case relic
    case resource
    case questItem
}

struct InventoryItem: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var type: ItemType
    var description: String
    var value: Int
}
