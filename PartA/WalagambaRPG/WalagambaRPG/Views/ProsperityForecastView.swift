import SwiftUI
import Charts

struct ProsperityForecastView: View {

    let values: [Int]

    struct ForecastPoint: Identifiable {
        let id = UUID()
        let turn: Int
        let value: Int
    }

    var points: [ForecastPoint] {
        values.enumerated().map { ForecastPoint(turn: $0.offset + 1, value: $0.element) }
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 20) {

                Text("Prosperity Forecast")
                    .font(.largeTitle.bold())
                    .padding(.top, 16)

                Text("Using CoreML, the simulator predicts the next turns of prosperity based on your current kingdom state.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                if points.isEmpty {
                    Text("No forecast available yet. Make a decision in the kingdom to generate predictions.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Predicted Prosperity")
                            .font(.headline)

                        Chart(points) { point in
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
                }

                Spacer()
            }
            .padding(.bottom, 24)
        }
        .navigationTitle("Forecast")
    }
}
