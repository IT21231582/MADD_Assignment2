import SwiftUI

struct FocusableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(configuration.isPressed ? 0.4 : 0.2))
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .focusable(true)
    }
}

struct FocusableButton: View {
    @State private var isFocused = false
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title2)
                .frame(width: 200, height: 90)
                .background(isFocused ? Color.blue.opacity(0.4) : Color.gray.opacity(0.2))
                .cornerRadius(15)
                .scaleEffect(isFocused ? 1.08 : 1.0)
        }
        .focusable(true) { newState in
            withAnimation(.easeInOut(duration: 0.15)) {
                isFocused = newState
            }
        }
    }
}
