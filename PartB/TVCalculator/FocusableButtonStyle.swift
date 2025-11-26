import SwiftUI

struct FocusableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        FocusableButtonStyleBody(configuration: configuration)
    }

    private struct FocusableButtonStyleBody: View {
        let configuration: Configuration

        @Environment(\.isFocused) private var isFocused: Bool

        private var backgroundColor: Color {
            if configuration.isPressed {
                return Color.blue.opacity(0.9)
            }
            return isFocused ? Color.blue.opacity(0.7) : Color.gray.opacity(0.4)
        }

        var body: some View {
            configuration.label
                .padding()
                .background(backgroundColor)
                .cornerRadius(16)
                .scaleEffect(isFocused ? 1.10 : (configuration.isPressed ? 0.97 : 1.0))
                .shadow(
                    color: isFocused ? Color.blue.opacity(0.6) : Color.clear,
                    radius: isFocused ? 24 : 0,
                    x: 0,
                    y: 0
                )
                .focusable(true)
                .animation(.easeInOut(duration: 0.18), value: isFocused)
                .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
        }
    }
}

struct FocusableButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title2)
                .frame(width: 200, height: 90)
        }
        .buttonStyle(FocusableButtonStyle())
    }
}
