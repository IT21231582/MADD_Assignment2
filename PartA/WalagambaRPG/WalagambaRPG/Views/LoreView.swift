import SwiftUI

struct LoreView: View {
    let facts = [
        "Walagamba reigned during the Anuradhapura period.",
        "He built the Abhayagiri Viharaya.",
        "He faced 14 years in hiding before reclaiming the throne."
    ]

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("History & Lore")
                        .font(.largeTitle.bold())
                        .padding(.top, 16)

                    Text("Learn a little background about King Walagamba and the ancient city of Anuradhapura.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    VStack(spacing: 12) {
                        ForEach(facts, id: \.self) { fact in
                            HStack(alignment: .top, spacing: 8) {
                                Circle()
                                    .fill(Color.secondary.opacity(0.25))
                                    .frame(width: 6, height: 6)
                                    .padding(.top, 6)
                                Text(fact)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(radius: 6, y: 3)

                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
