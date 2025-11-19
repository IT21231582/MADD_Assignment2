import SwiftUI
import Charts

struct HistoryView: View {
    @EnvironmentObject var vm: FitnessViewModel

    var body: some View {
        VStack {
            Text("History")
                .font(.largeTitle.bold())
                .padding()

            Chart(vm.summaries.prefix(14)) { item in
                BarMark(
                    x: .value("Date", item.date ?? Date()),
                    y: .value("Steps", item.steps)
                )
                .foregroundStyle(.green)
            }
            .frame(height: 250)

            List(vm.summaries.prefix(14), id: \.self) { day in
                VStack(alignment: .leading) {
                    Text(day.date!.formatted(date: .abbreviated, time: .omitted))
                        .font(.headline)
                    Text("Steps: \(day.steps)")
                    Text("Calories: \(day.calories)")
                    Text("Workout: \(day.workoutMinutes) min")
                }
            }
        }
    }
}
