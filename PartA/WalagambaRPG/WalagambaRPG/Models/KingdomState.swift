import SwiftUI

enum KingdomEra: String, Codable {
    case goldenAge = "Golden Age"
    case hardTimes = "Hard Times"
    case corruption = "Corruption Era"
    case stability = "Stability"
}

struct KingdomState: Codable {
    var peopleHappiness: Int = 60
    var templeRespect: Int = 50
    var armyStrength: Int = 40
    var foodSupply: Int = 70
    var treasury: Int = 100
    var prosperity: Int = 55

    var taxRate: Int = 5
    var incomePerTurn: Int = 20
    var lastMLSuggestion: String = ""

    // NEW
    var era: KingdomEra = .stability

    var eraColor: Color {
        switch era {
        case .goldenAge: return Color.yellow.opacity(0.35)
        case .hardTimes: return Color.red.opacity(0.25)
        case .corruption: return Color.purple.opacity(0.30)
        case .stability: return Color.green.opacity(0.25)
        }
    }
}
