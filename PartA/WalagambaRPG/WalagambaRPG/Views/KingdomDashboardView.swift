import SwiftUI

struct KingdomDashboardView: View {

    @StateObject private var vm = KingdomViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {

                        // Header image
                        Image("stupa")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .shadow(radius: 10, y: 6)
                            .padding(.horizontal)
                            .padding(.top, 16)

                        // Title and era
                        VStack(spacing: 4) {
                            Text("Kingdom of Anuradhapura")
                                .font(.largeTitle.weight(.bold))
                                .multilineTextAlignment(.center)

                            Text("Era: \(vm.state.era.rawValue)")
                                .font(.subheadline.weight(.medium))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(vm.state.eraColor.opacity(0.25))
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }
                        .padding(.horizontal)

                        // Fact box
                        if !vm.randomFact.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Did you know?")
                                    .font(.headline)

                                Text(vm.randomFact)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)

                                HStack(spacing: 10) {
                                    Button("Another fact") {
                                        vm.showRandomFact()
                                    }
                                    .buttonStyle(.bordered)
                                    .font(.caption)

                                    Menu {
                                        ForEach(FactCategory.allCases, id: \.self) { cat in
                                            Button(cat.rawValue) {
                                                vm.showFact(from: cat)
                                            }
                                        }
                                    } label: {
                                        Label("Categories", systemImage: "line.3.horizontal.decrease.circle")
                                            .font(.caption)
                                    }
                                    .buttonStyle(.bordered)
                                }
                            }
                            .padding()
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(radius: 8, y: 4)
                            .padding(.horizontal)
                        }

                        // Stats
                        VStack(spacing: 12) {
                            statCard(title: "People Happiness", value: vm.state.peopleHappiness, emoji: "👥")
                            statCard(title: "Temple Respect", value: vm.state.templeRespect, emoji: "🛕")
                            statCard(title: "Army Strength", value: vm.state.armyStrength, emoji: "🛡️")
                            statCard(title: "Food Supply", value: vm.state.foodSupply, emoji: "🌾")
                            statCard(title: "Treasury", value: vm.state.treasury, emoji: "💰", maxValue: 300)
                            statCard(title: "Prosperity", value: vm.state.prosperity, emoji: "📈")
                        }
                        .padding(.horizontal)

                        // Event card
                        if let event = vm.currentEvent {
                            eventCard(event)
                                .padding(.horizontal)
                        }

                        // Navigation buttons
                        VStack(spacing: 12) {
                            NavigationLink {
                                MLDashboardView(vm: vm)
                            } label: {
                                navButtonLabel(
                                    title: "ML Insights",
                                    subtitle: "See how the model interprets your rule.",
                                    systemImage: "cpu"
                                )
                            }
                            .buttonStyle(.borderedProminent)

                            NavigationLink {
                                HistoryLogView(logs: vm.eventLog)
                            } label: {
                                navButtonLabel(
                                    title: "History Log",
                                    subtitle: "Review decisions from this session.",
                                    systemImage: "clock.arrow.circlepath"
                                )
                            }
                            .buttonStyle(.bordered)

                            NavigationLink {
                                SavedKingdomHistoryView()
                            } label: {
                                navButtonLabel(
                                    title: "Kingdom History",
                                    subtitle: "See long-term prosperity trends.",
                                    systemImage: "archivebox"
                                )
                            }
                            .buttonStyle(.bordered)

                            NavigationLink {
                                ProsperityForecastView(values: vm.forecastValues)
                                    .onAppear { vm.generateForecast() }
                            } label: {
                                navButtonLabel(
                                    title: "Prosperity Forecast",
                                    subtitle: "View predicted future prosperity.",
                                    systemImage: "chart.line.uptrend.xyaxis"
                                )
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 32)
                    }
                }

                // Cutscene overlay
                if let cutscene = vm.activeCutscene {
                    CutsceneView(data: cutscene, onClose: {
                        vm.dismissCutscene()
                    })
                }
            }
            .navigationTitle("Walagamba Simulator")
        }
    }

    // MARK: - Components

    private func statCard(title: String, value: Int, emoji: String, maxValue: Int = 100) -> some View {
        let safeValue = min(max(0, value), maxValue)

        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(emoji)
                Text(title)
                    .font(.headline)
                Spacer()
                Text("\(value)")
                    .font(.headline)
            }

            ProgressView(value: Double(safeValue), total: Double(maxValue))
                .tint(.primary.opacity(0.9))
        }
        .padding()
        .background(.ultraThickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(radius: 8, y: 4)
    }

    private func eventCard(_ event: KingdomEvent) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(event.title)
                .font(.title3.bold())

            Text(event.description)
                .font(.body)
                .foregroundColor(.secondary)

            ForEach(event.decisions) { decision in
                Button(decision.text) {
                    vm.applyDecision(decision)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(radius: 8, y: 4)
    }

    private func navButtonLabel(title: String, subtitle: String, systemImage: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.title3)
                .frame(width: 32, height: 32)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
    }
}
