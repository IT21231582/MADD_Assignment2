import Foundation
import SwiftUI
import CoreData
import Combine

struct CutsceneData {
    let title: String
    let message: String
}

final class KingdomViewModel: ObservableObject {

    // MARK: - Published state

    @Published var state = KingdomState()
    @Published var currentEvent: KingdomEvent?
    @Published var eventLog: [String] = []
    @Published var randomFact: String = ""
    @Published var activeCutscene: CutsceneData?
    @Published var prosperityHistory: [Int] = []
    @Published var forecastValues: [Int] = []

    // MARK: - Facts source

    private let facts: [HistoricalFact] = HistoricalFactsData.facts

    // MARK: - Core Data

    private let context = PersistenceController.shared.container.viewContext

    // MARK: - Init

    init() {
        generateEvent()
        showRandomFact()
    }

    // MARK: - Events

    func generateEvent() {
        let events: [KingdomEvent] = [
            KingdomEvent(
                title: "Village Irrigation Request",
                description: "Villagers ask you to repair an ancient canal to improve paddy fields.",
                decisions: [
                    DecisionOption(
                        text: "Fund repairs (50 treasury)",
                        happinessImpact: 10, templeImpact: 0, armyImpact: 0,
                        foodImpact: 12, treasuryImpact: -50
                    ),
                    DecisionOption(
                        text: "Send the army to help instead",
                        happinessImpact: 5, templeImpact: 0, armyImpact: -8,
                        foodImpact: 8, treasuryImpact: 0
                    ),
                    DecisionOption(
                        text: "Refuse — focus on palace projects",
                        happinessImpact: -15, templeImpact: -2, armyImpact: 0,
                        foodImpact: -5, treasuryImpact: 0
                    )
                ]
            ),
            KingdomEvent(
                title: "Temple Construction",
                description: "Monks request resources to build a new stupa to honour the Dhamma.",
                decisions: [
                    DecisionOption(
                        text: "Generously donate (60 treasury)",
                        happinessImpact: 8, templeImpact: 15, armyImpact: 0,
                        foodImpact: 0, treasuryImpact: -60
                    ),
                    DecisionOption(
                        text: "Donate modestly (25 treasury)",
                        happinessImpact: 3, templeImpact: 8, armyImpact: 0,
                        foodImpact: 0, treasuryImpact: -25
                    ),
                    DecisionOption(
                        text: "Refuse — funds are tight",
                        happinessImpact: -5, templeImpact: -10, armyImpact: 0,
                        foodImpact: 0, treasuryImpact: 0
                    )
                ]
            ),
            KingdomEvent(
                title: "Border Tension",
                description: "Scouts report unrest near the border of the kingdom.",
                decisions: [
                    DecisionOption(
                        text: "Increase army patrols (10 treasury)",
                        happinessImpact: 0, templeImpact: 0, armyImpact: 10,
                        foodImpact: -3, treasuryImpact: -10
                    ),
                    DecisionOption(
                        text: "Send envoys to negotiate",
                        happinessImpact: 5, templeImpact: 2, armyImpact: -5,
                        foodImpact: 0, treasuryImpact: -5
                    ),
                    DecisionOption(
                        text: "Ignore — hope it calms down",
                        happinessImpact: -8, templeImpact: 0, armyImpact: -5,
                        foodImpact: 0, treasuryImpact: 0
                    )
                ]
            )
        ]

        currentEvent = events.randomElement()
    }

    // MARK: - Decisions

    func applyDecision(_ decision: DecisionOption) {
        guard let event = currentEvent else { return }

        // ML prediction
        let predictedOutcome = MLModelManager.shared.predictOutcome(
            happiness: Double(state.peopleHappiness),
            temple: Double(state.templeRespect),
            army: Double(state.armyStrength),
            food: Double(state.foodSupply),
            treasury: Double(state.treasury)
        )

        // Apply impacts
        state.peopleHappiness = clamp(state.peopleHappiness + Int(decision.happinessImpact))
        state.templeRespect   = clamp(state.templeRespect   + Int(decision.templeImpact))
        state.armyStrength    = clamp(state.armyStrength    + Int(decision.armyImpact))
        state.foodSupply      = clamp(state.foodSupply      + Int(decision.foodImpact))
        state.treasury        = max(0, state.treasury + Int(decision.treasuryImpact))

        // Prosperity = blend
        let blended = (Double(state.prosperity) + predictedOutcome) / 2.0
        state.prosperity = clamp(Int(blended))

        applyEconomyTick()
        updateEra()

        prosperityHistory.append(state.prosperity)
        generateMLSuggestion()

        eventLog.append("Event: \(event.title) → \(decision.text)")

        saveSnapshot()
        showRandomFact()
        generateCutsceneIfNeeded()

        // Built-in iOS narration — no audio files required
        SpeechNarrator.shared.speak("You selected: \(decision.text)")

        // Prepare next event
        currentEvent = nil

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.generateEvent()
        }
    }

    // MARK: - Economy

    private func applyEconomyTick() {
        let incomeFromFood = state.foodSupply / 10
        let incomeFromArmy = state.armyStrength / 20
        let taxBonus = (state.peopleHappiness * state.taxRate) / 100
        state.treasury += state.incomePerTurn + incomeFromFood + incomeFromArmy + taxBonus
    }

    // MARK: - Era System

    private func updateEra() {
        if state.prosperity >= 75 && state.peopleHappiness >= 70 {
            state.era = .goldenAge
        } else if state.prosperity <= 35 {
            state.era = .hardTimes
        } else if state.templeRespect < 30 && state.peopleHappiness < 40 {
            state.era = .corruption
        } else {
            state.era = .stability
        }
    }

    // MARK: - ML Suggestion

    private func generateMLSuggestion() {
        let outcome = MLModelManager.shared.predictOutcome(
            happiness: Double(state.peopleHappiness),
            temple: Double(state.templeRespect),
            army: Double(state.armyStrength),
            food: Double(state.foodSupply),
            treasury: Double(state.treasury)
        )

        if outcome > 80 {
            state.lastMLSuggestion = "Your kingdom is thriving. Consider investing in temples and education."
        } else if outcome > 60 {
            state.lastMLSuggestion = "Prosperity is stable. Improving food supply could raise it further."
        } else if outcome > 40 {
            state.lastMLSuggestion = "The people are uncertain. Focus on happiness and fair taxation."
        } else {
            state.lastMLSuggestion = "The kingdom is struggling. Reduce taxes and support villages urgently."
        }
    }

    // MARK: - Forecast

    func generateForecast() {
        forecastValues = ForecastManager.shared.predictNextFive(
            happiness: state.peopleHappiness,
            temple: state.templeRespect,
            army: state.armyStrength,
            food: state.foodSupply,
            treasury: state.treasury
        )
    }

    // MARK: - Cutscenes

    private func generateCutsceneIfNeeded() {
        if state.prosperity >= 85 && activeCutscene == nil {
            activeCutscene = CutsceneData(
                title: "Golden Era of Anuradhapura",
                message: "Under your wise rule, the kingdom enters a golden era. Temples flourish and trade prospers across the island."
            )
        } else if state.prosperity <= 25 && activeCutscene == nil {
            activeCutscene = CutsceneData(
                title: "Time of Hardship",
                message: "Famine and unrest spread. Your next decisions will determine whether the kingdom recovers or falls."
            )
        }
    }

    func dismissCutscene() {
        activeCutscene = nil
    }

    // MARK: - Facts

    /// Show a completely random fact from all categories
    func showRandomFact() {
        if let fact = facts.randomElement() {
            randomFact = fact.text
        } else {
            randomFact = ""
        }
    }

    /// Show a random fact from a specific category (used by the Categories menu)
    func showFact(from category: FactCategory) {
        let filtered = facts.filter { $0.category == category }
        if let fact = filtered.randomElement() {
            randomFact = fact.text
            // Optional: narrate the fact too
            // SpeechNarrator.shared.speak(fact.text)
        } else {
            randomFact = ""
        }
    }

    // MARK: - Persistence

    private func saveSnapshot() {
        let record = KingdomRecord(context: context)
        record.timestamp = Date()
        record.peopleHappiness = Int16(state.peopleHappiness)
        record.templeRespect   = Int16(state.templeRespect)
        record.armyStrength    = Int16(state.armyStrength)
        record.foodSupply      = Int16(state.foodSupply)
        record.treasury        = Int16(state.treasury)
        record.prosperity      = Int16(state.prosperity)
        try? context.save()
    }

    // MARK: - Helpers

    private func clamp(_ value: Int) -> Int {
        max(0, min(100, value))
    }
}
