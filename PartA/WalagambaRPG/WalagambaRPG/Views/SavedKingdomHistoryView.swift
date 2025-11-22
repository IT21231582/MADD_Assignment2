import SwiftUI
import CoreData
import Charts

struct SavedKingdomHistoryView: View {

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \KingdomRecord.timestamp, ascending: true)],
        animation: .default
    )
    private var records: FetchedResults<KingdomRecord>

    struct ProsperityPoint: Identifiable {
        let id: UUID
        let turn: Int
        let value: Int
    }

    var prosperityPoints: [ProsperityPoint] {
        records.enumerated().map { index, record in
            ProsperityPoint(
                id: UUID(),
                turn: index + 1,
                value: Int(record.prosperity)
            )
        }
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    Text("Kingdom History")
                        .font(.largeTitle.bold())
                        .padding(.top, 16)

                    Text("These records show how your decisions shaped the Kingdom of Walagamba over time.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    if prosperityPoints.isEmpty {
                        Text("No historical data saved yet.\nPlay and make decisions to build your history.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        VStack(alignment: .leading, spacing: 10) {
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

                        Divider()
                            .padding(.vertical, 8)

                        Text("Decision Timeline")
                            .font(.headline)

                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(records) { record in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(record.timestamp?.formatted() ?? "Unknown Date")
                                        .font(.caption)
                                        .foregroundColor(.secondary)

                                    HStack {
                                        stat("Happiness", Int(record.peopleHappiness))
                                        stat("Temple", Int(record.templeRespect))
                                    }
                                    HStack {
                                        stat("Army", Int(record.armyStrength))
                                        stat("Food", Int(record.foodSupply))
                                    }
                                    HStack {
                                        stat("Treasury", Int(record.treasury))
                                        stat("Prosperity", Int(record.prosperity))
                                    }
                                }
                                .padding()
                                .background(.thinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .shadow(radius: 4, y: 2)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("History Records")
    }

    func stat(_ name: String, _ value: Int) -> some View {
        HStack {
            Text(name)
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
            Text("\(value)")
                .font(.caption.weight(.semibold))
        }
    }
}
