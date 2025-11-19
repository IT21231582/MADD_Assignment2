import SwiftUI

struct GoalsView: View {
    @EnvironmentObject var vm: FitnessViewModel

    @State private var steps: Int = 0
    @State private var calories: Int = 0
    @State private var minutes: Int = 0

    var body: some View {
        Form {
            Section("Daily Goals") {
                Stepper("Steps: \(steps)", value: $steps, in: 1000...20000)
                Stepper("Calories: \(calories)", value: $calories, in: 100...1000)
                Stepper("Workout Minutes: \(minutes)", value: $minutes, in: 10...120)
            }

            Button("Save Goals") {
                vm.updateGoal(steps: steps, calories: calories, minutes: minutes)
            }
            .buttonStyle(.borderedProminent)

            Section("Insight") {
                Text(generateInsight())
            }
        }
        .onAppear {
            steps = Int(vm.goal?.steps ?? 6000)
            calories = Int(vm.goal?.calories ?? 300)
            minutes = Int(vm.goal?.workoutMinutes ?? 20)
        }
    }

    func generateInsight() -> String {
        let hit = vm.summaries.filter { $0.goalHit }.count

        if hit >= 5 { return "Great consistency! You’re hitting most goals." }
        if hit >= 3 { return "You’re getting there—try short 10-minute walks." }
        return "Let’s start small. Aim for easy goals to build momentum."
    }
}
