import SwiftUI

struct ContentView: View {
    @State private var selectedItem: FurnitureItem = SampleFurniture.chair
    @State private var placeRequest: Int = 0

    var body: some View {
        VStack(spacing: 0) {
            ARViewContainer(
                selectedModelName: selectedItem.modelName,
                placeRequest: $placeRequest
            )
            .ignoresSafeArea()

            bottomBar
                .padding()
                .background(.ultraThinMaterial)
        }
    }

    private var bottomBar: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(selectedItem.name)
                        .font(.headline)
                    Text("Tap Place to add in AR")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Button {
                    placeRequest += 1
                } label: {
                    Text("Place")
                        .fontWeight(.semibold)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }

            HStack(spacing: 16) {
                ForEach(SampleFurniture.all) { item in
                    Button {
                        selectedItem = item
                    } label: {
                        VStack {
                            Image(systemName: iconName(for: item))
                                .font(.title2)
                                .padding(12)
                                .background(
                                    selectedItem.id == item.id
                                    ? Color.blue.opacity(0.2)
                                    : Color.gray.opacity(0.15)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 14))

                            Text(item.nameShort)
                                .font(.caption)
                                .lineLimit(1)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func iconName(for item: FurnitureItem) -> String {
        switch item.modelName {
        case "chair": return "chair.lounge.fill"
        case "table": return "square.fill"
        case "lamp":  return "lightbulb.fill"
        default:      return "cube.fill"
        }
    }
}
