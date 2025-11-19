import SwiftUI

struct CalculatorView: View {

    @State private var display = "0"

    let buttons: [[String]] = [
        ["7","8","9","÷"],
        ["4","5","6","×"],
        ["1","2","3","−"],
        ["0",".","=","+"]
    ]

    var body: some View {
        VStack(spacing: 30) {

            Text(display)
                .font(.system(size: 60))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black.opacity(0.2))
                .cornerRadius(20)

            VStack(spacing: 20) {
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 20) {
                        ForEach(row, id: \.self) { value in
                            Button(action: { buttonTap(value) }) {
                                Text(value)
                                    .font(.largeTitle)
                                    .frame(width: 200, height: 90)
                            }
                            .buttonStyle(FocusableButtonStyle())
                        }
                    }
                }
            }

            NavigationLink(destination: HomeView()) {
                Text("Back")
                    .font(.title3)
                    .frame(width: 300, height: 60)
            }
            .buttonStyle(FocusableButtonStyle())

            Spacer()
        }
        .padding()
    }

    // MARK: - Logic
    func buttonTap(_ value: String) {
        switch value {
        case "÷", "×", "−", "+":
            display += " \(value) "
        case "=":
            calculate()
        default:
            if display == "0" { display = value }
            else { display += value }
        }
    }

    func calculate() {
        let exp = display
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
            .replacingOccurrences(of: "−", with: "-")

        let expression = NSExpression(format: exp)
        if let result = expression.expressionValue(with: nil, context: nil) as? NSNumber {
            display = result.stringValue
        }
    }
}
