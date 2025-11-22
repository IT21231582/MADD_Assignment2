import Foundation
import CoreML

final class MLModelManager {

    static let shared = MLModelManager()

    private let model: KingdomPredictor?

    private init() {
        model = try? KingdomPredictor(configuration: .init())
    }

    /// Predict an outcome (0–100 prosperity) given the current stats.
    func predictOutcome(
        happiness: Double,
        temple: Double,
        army: Double,
        food: Double,
        treasury: Double
    ) -> Double {

        guard let model else {
            // Fallback if model couldn't be loaded
            return (happiness + temple + army + food) / 4.0
        }

        do {
            // Make sure your mlmodel input names match these
            let result = try model.prediction(
                peopleHappiness: Int64(happiness),
                templeRespect: Int64(temple),
                armyStrength: Int64(army),
                foodSupply: Int64(food),
                treasury: Int64(treasury)
            )
            return result.outcome
        } catch {
            return (happiness + temple + army + food) / 4.0
        }
    }
}
