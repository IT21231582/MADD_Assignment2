import Foundation

enum FactCategory: String, CaseIterable, Codable {
    case religion = "Religion & Culture"
    case kingship = "Kingship & Governance"
    case engineering = "Engineering & Irrigation"
}

struct HistoricalFact: Identifiable, Codable {
    var id = UUID()
    let text: String
    let category: FactCategory
}
