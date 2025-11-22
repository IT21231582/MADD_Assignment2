import Foundation

struct KingdomEvent: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let decisions: [DecisionOption]
}

struct DecisionOption: Identifiable {
    let id = UUID()
    let text: String

    // Impacts on the kingdom when this choice is taken
    let happinessImpact: Double
    let templeImpact: Double
    let armyImpact: Double
    let foodImpact: Double
    let treasuryImpact: Double
}
