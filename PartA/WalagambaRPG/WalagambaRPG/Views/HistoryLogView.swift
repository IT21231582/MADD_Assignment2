import SwiftUI

struct HistoryLogView: View {
    let logs: [String]

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            if logs.isEmpty {
                VStack(spacing: 12) {
                    Text("No History Yet")
                        .font(.title3.weight(.semibold))
                    Text("Play a few rounds and your decisions will appear here.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            } else {
                List {
                    ForEach(logs, id: \.self) { item in
                        Text(item)
                            .font(.subheadline)
                            .padding(.vertical, 4)
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("History Log")
    }
}
