import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var vm: FitnessViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                Text("Today’s Activity")
                    .font(.largeTitle.bold())

                ProgressCard(title: "Steps",
                             current: vm.todaySteps,
                             goal: Int(vm.goal?.steps ?? 0),
                             unit: "steps")

                ProgressCard(title: "Calories",
                             current: vm.todayCalories,
                             goal: Int(vm.goal?.calories ?? 0),
                             unit: "kcal")

                ProgressCard(title: "Exercise",
                             current: vm.todayWorkoutMinutes,
                             goal: Int(vm.goal?.workoutMinutes ?? 0),
                             unit: "min")

                NavigationLink("View History") {
                    HistoryView()
                }
                .buttonStyle(.borderedProminent)

                NavigationLink("Goals & Insights") {
                    GoalsView()
                }
                .buttonStyle(.bordered)

                Spacer()
            }
            .padding()
        }
    }
}

struct ProgressCard: View {
    let title: String
    let current: Int
    let goal: Int
    let unit: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title).font(.headline)

            ProgressView(value: Double(current),
                         total: Double(goal))
                .tint(.green)
                .scaleEffect(x: 1, y: 2, anchor: .center)

            HStack {
                Text("\(current) \(unit)")
                Spacer()
                Text("Goal: \(goal)")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(18)
    }
}
