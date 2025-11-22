import SwiftUI

struct PlayerProfileView: View {

    @ObservedObject var player: Player

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            Form {
                Section(header: Text("Kingly Profile")) {
                    TextField("Name", text: $player.name)
                    Text("Level: \(player.level)")
                        .foregroundColor(.secondary)
                }

                Section(header: Text("Equipped Weapon")) {
                    Text(player.weapon?.name ?? "None")
                        .foregroundColor(player.weapon == nil ? .secondary : .primary)
                }

                Section(header: Text("Inventory")) {
                    if player.inventory.isEmpty {
                        Text("No items in inventory.")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(player.inventory) { item in
                            Text(item.name)
                        }
                    }
                }

                Section(header: Text("Kingdom Stats")) {
                    statRow(label: "People Happiness", value: player.kingdom.peopleHappiness)
                    statRow(label: "Army Strength", value: player.kingdom.armyStrength)
                    statRow(label: "Temple Respect", value: player.kingdom.templeRespect)
                    statRow(label: "Food Supply", value: player.kingdom.foodSupply)
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Player Profile")
    }

    private func statRow(label: String, value: Int) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text("\(value)")
                .foregroundColor(.secondary)
        }
    }
}
