import Foundation
import SwiftUI
import Combine

class Player: ObservableObject {
    @Published var name: String
    @Published var level: Int
    @Published var weapon: InventoryItem?
    @Published var inventory: [InventoryItem]
    @Published var kingdom: KingdomStats

    init(
        name: String = "King Walagamba",
        level: Int = 1,
        weapon: InventoryItem? = nil,
        inventory: [InventoryItem] = [],
        kingdom: KingdomStats = KingdomStats()
    ) {
        self.name = name
        self.level = level
        self.weapon = weapon
        self.inventory = inventory
        self.kingdom = kingdom
    }
}
