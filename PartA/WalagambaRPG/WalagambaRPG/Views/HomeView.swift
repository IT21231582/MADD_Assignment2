import SwiftUI

struct HomeView: View {

    @StateObject var player = Player()

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(.systemBackground),
                        Color(.secondarySystemBackground)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 28) {
                    VStack(spacing: 8) {
                        Text("Rise of Walagamba")
                            .font(.largeTitle.weight(.bold))

                        Text("A calm kingdom-simulation and learning experience.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }

                    VStack(spacing: 14) {
                        NavigationLink {
                            GameView()
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Start Game")
                                        .font(.headline)
                                    Text("Play as King Walagamba and face key decisions.")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                            .padding()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.primary.opacity(0.9))

                        NavigationLink {
                            PlayerProfileView(player: player)
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Player Profile")
                                        .font(.headline)
                                    Text("Review your kingly stats and inventory.")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                            .padding()
                        }
                        .buttonStyle(.bordered)

                        NavigationLink {
                            LoreView()
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("History & Lore")
                                        .font(.headline)
                                    Text("Learn about Anuradhapura and Walagamba.")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                            .padding()
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .padding(.top, 40)
                .padding(.bottom, 24)
            }
        }
    }
}
