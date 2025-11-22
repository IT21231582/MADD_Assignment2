import Foundation
import SwiftUI
import Combine

// Simple dialogue and quest models for RPG flavour
struct Dialogue: Identifiable {
    let id = UUID()
    let title: String
    let message: String
}

struct Quest: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    var isCompleted: Bool = false
}

class GameState: ObservableObject {
    // Combat
    @Published var playerHealth: Int
    @Published var maxHealth: Int
    @Published var enemiesDefeated: Int

    // RPG / Story bits
    @Published var activeDialogue: Dialogue?
    @Published var currentQuest: Quest?
    @Published var completedQuests: [Quest]

    var isPlayerDead: Bool {
        playerHealth <= 0
    }

    init(
        playerHealth: Int = 100,
        maxHealth: Int = 100,
        enemiesDefeated: Int = 0,
        activeDialogue: Dialogue? = nil,
        currentQuest: Quest? = nil,
        completedQuests: [Quest] = []
    ) {
        self.playerHealth = playerHealth
        self.maxHealth = maxHealth
        self.enemiesDefeated = enemiesDefeated
        self.activeDialogue = activeDialogue
        self.currentQuest = currentQuest
        self.completedQuests = completedQuests
    }

    // MARK: - Combat helpers

    func takeDamage(_ amount: Int) {
        playerHealth = max(playerHealth - amount, 0)
    }

    func heal(_ amount: Int) {
        playerHealth = min(playerHealth + amount, maxHealth)
    }

    func enemyDefeated() {
        enemiesDefeated += 1
    }

    func reset() {
        playerHealth = maxHealth
        enemiesDefeated = 0
        activeDialogue = nil
        currentQuest = nil
    }

    // MARK: - Dialogue / Quest

    func showTempleDialogue() {
        activeDialogue = Dialogue(
            title: "Temple Monk",
            message: "Great King, protect the villagers from raiders near the forest. This will honour the Dhamma."
        )
        currentQuest = Quest(
            title: "Protect the Villagers",
            description: "Defeat 5 enemies to keep the village safe."
        )
    }

    func checkQuestCompletion() {
        guard var quest = currentQuest else { return }
        // Simple quest: defeat 5 enemies
        if enemiesDefeated >= 5 && !quest.isCompleted {
            quest.isCompleted = true
            currentQuest = quest
            completedQuests.append(quest)
            activeDialogue = Dialogue(
                title: "Royal Advisor",
                message: "Your Majesty, the people praise you. The threat has been pushed back for now."
            )
        }
    }
}
