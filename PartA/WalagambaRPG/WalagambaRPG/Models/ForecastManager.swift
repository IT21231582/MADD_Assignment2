import Foundation

class ForecastManager {

    static let shared = ForecastManager()

    func predictNextFive(
        happiness: Int,
        temple: Int,
        army: Int,
        food: Int,
        treasury: Int
    ) -> [Int] {

        var results: [Int] = []
        var current = (happiness, temple, army, food, treasury)

        for _ in 1...5 {
            let predicted = MLModelManager.shared.predictOutcome(
                happiness: Double(current.0),
                temple: Double(current.1),
                army: Double(current.2),
                food: Double(current.3),
                treasury: Double(current.4)
            )

            let intPred = max(0, min(100, Int(predicted)))
            results.append(intPred)

            // Slight growth simulation to project forward
            current.0 = min(100, current.0 + Int.random(in: -2...2))
            current.1 = min(100, current.1 + Int.random(in: -2...2))
            current.2 = min(100, current.2 + Int.random(in: -2...2))
            current.3 = min(100, current.3 + Int.random(in: -2...2))
            current.4 = min(300, current.4 + Int.random(in: -5...20))
        }

        return results
    }
}
