import SwiftUI

struct DailyInspirationItem: Identifiable {
    let id = UUID()
    let text: String
    let systemImageName: String

    static let all: [DailyInspirationItem] = [
        DailyInspirationItem(
            text: "Small consistent steps every day lead to big results.",
            systemImageName: "sun.max.fill"
        ),
        DailyInspirationItem(
            text: "Fun fact: Bananas are berries, but strawberries aren’t.",
            systemImageName: "leaf.fill"
        ),
        DailyInspirationItem(
            text: "Progress, not perfection. Every calculation counts.",
            systemImageName: "sparkles"
        ),
        DailyInspirationItem(
            text: "Fun fact: Honey never spoils and can last for thousands of years.",
            systemImageName: "drop.fill"
        )
    ]

    static func random() -> DailyInspirationItem {
        all.randomElement() ?? all[0]
    }
}

struct DailyInspirationRow: View {
    let item: DailyInspirationItem

    @State private var isFocused = false

    var body: some View {
        Button(action: {}) {
            HStack(alignment: .center, spacing: 40) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Daily Inspiration")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)

                    Text(item.text)
                        .font(.system(size: 32, weight: .regular, design: .rounded))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                        .frame(maxWidth: 900, alignment: .leading)
                }

                Spacer()

                Image(systemName: item.systemImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                    .foregroundColor(.accentColor)
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 28)
            .background(
                RoundedRectangle(cornerRadius: 32)
                    .fill(Color.white.opacity(0.35))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 32)
                    .stroke(isFocused ? Color.blue.opacity(0.9) : Color.clear, lineWidth: 4)
            )
            .scaleEffect(isFocused ? 1.06 : 1.0)
            .shadow(color: isFocused ? Color.blue.opacity(0.5) : Color.clear,
                    radius: isFocused ? 30 : 0,
                    x: 0,
                    y: 0)
            .animation(.easeInOut(duration: 0.22), value: isFocused)
        }
        .buttonStyle(.plain)
        .focusable(true) { focused in
            withAnimation(.easeInOut(duration: 0.22)) {
                isFocused = focused
            }
        }
    }
}

struct HomeView: View {
    private let inspirationItem = DailyInspirationItem.random()

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.8),
                    Color.white
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 40) {
                Text("TV Calculator")
                    .font(.largeTitle)
                    .bold()

                DailyInspirationRow(item: inspirationItem)

                NavigationLink(destination: CalculatorView()) {
                    Text("Calculator")
                        .font(.title2)
                        .frame(width: 400, height: 80)
                }
                .buttonStyle(FocusableButtonStyle())

                NavigationLink(destination: UnitConverterView()) {
                    Text("Unit Converter")
                        .font(.title2)
                        .frame(width: 400, height: 80)
                }
                .buttonStyle(FocusableButtonStyle())
            }
            .padding()
        }
    }
}
