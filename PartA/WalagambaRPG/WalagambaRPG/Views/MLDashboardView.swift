import SwiftUI
import Charts

struct MLDashboardView: View {
    @ObservedObject var vm: KingdomViewModel

    struct ProsperityPoint: Identifiable {
        let id = UUID()
        let turn: Int
        let value: Int
    }

    var prosperityPoints: [ProsperityPoint] {
        vm.prosperityHistory.enumerated().map { index, value in
            ProsperityPoint(turn: index + 1, value: value)
        }
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    Text("ML Insights")
                        .font(.largeTitle.bold())
                        .padding(.top, 16)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Model Suggestion")
                            .font(.headline)
                        Text(vm.state.lastMLSuggestion)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(radius: 6, y: 3)
                    .padding(.horizontal)

                    if !prosperityPoints.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Prosperity Over Time")
                                .font(.headline)

                            Chart(prosperityPoints) { point in
                                LineMark(
                                    x: .value("Turn", point.turn),
                                    y: .value("Prosperity", point.value)
                                )
                                PointMark(
                                    x: .value("Turn", point.turn),
                                    y: .value("Prosperity", point.value)
                                )
                            }
                            .frame(height: 260)
                        }
                        .padding()
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(radius: 6, y: 3)
                        .padding(.horizontal)
                    } else {
                        Text("Make a few decisions to see how prosperity changes over time.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .padding()
                    }

                    Spacer()
                }
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("ML Dashboard")
    }
}
