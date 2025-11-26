import SwiftUI

enum UnitCategory: String, CaseIterable, Identifiable {
    case length = "Length"
    case weight = "Weight"
    case temperature = "Temperature"

    var id: String { rawValue }
}

enum ConversionType: String, Identifiable {
    case metersToKilometers = "Meters → Kilometers"
    case kilometersToMeters = "Kilometers → Meters"
    case kilogramsToGrams = "Kilograms → Grams"
    case gramsToKilograms = "Grams → Kilograms"
    case celsiusToFahrenheit = "Celsius → Fahrenheit"
    case fahrenheitToCelsius = "Fahrenheit → Celsius"

    var id: String { rawValue }
}

struct UnitConverterView: View {

    @State private var selectedCategory: UnitCategory? = .length
    @State private var selectedConversion: ConversionType? = .metersToKilometers
    @State private var inputValue: String = ""
    @State private var outputValue: String = ""

    private var availableConversions: [ConversionType] {
        switch selectedCategory {
        case .length:
            return [.metersToKilometers, .kilometersToMeters]
        case .weight:
            return [.kilogramsToGrams, .gramsToKilograms]
        case .temperature:
            return [.celsiusToFahrenheit, .fahrenheitToCelsius]
        case .none:
            return []
        }
    }

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

            VStack(spacing: 50) {
                Text("Unit Converter")
                    .font(.largeTitle)
                    .bold()

                // Category selection
                HStack(spacing: 40) {
                    ForEach(UnitCategory.allCases) { category in
                        Button(action: {
                            selectedCategory = category
                            // Reset conversion and values when category changes
                            switch category {
                            case .length:
                                selectedConversion = .metersToKilometers
                            case .weight:
                                selectedConversion = .kilogramsToGrams
                            case .temperature:
                                selectedConversion = .celsiusToFahrenheit
                            }
                            inputValue = ""
                            outputValue = ""
                        }) {
                            Text(category.rawValue)
                                .font(.system(size: 32, weight: .semibold))
                                .frame(width: 260, height: 80)
                        }
                        .buttonStyle(FocusableButtonStyle())
                    }
                }

                // Conversion options
                if let _ = selectedCategory {
                    HStack(spacing: 30) {
                        ForEach(availableConversions) { conversion in
                            Button(action: {
                                selectedConversion = conversion
                                inputValue = ""
                                outputValue = ""
                            }) {
                                Text(conversion.rawValue)
                                    .font(.system(size: 28, weight: .regular))
                                    .multilineTextAlignment(.center)
                                    .frame(width: 320, height: 90)
                            }
                            .buttonStyle(FocusableButtonStyle())
                        }
                    }
                }

                // Input + keypad + result
                if selectedConversion != nil {
                    VStack(spacing: 30) {
                        // Input preview
                        Text("Input: \(inputValue.isEmpty ? "0" : inputValue)")
                            .font(.system(size: 40, weight: .medium))

                        // Output preview (large result text)
                        if !outputValue.isEmpty {
                            Text(outputValue)
                                .font(.largeTitle)
                                .padding(.bottom, 10)
                        }

                        // Numeric keypad
                        NumericKeypadView(
                            onAppend: { char in
                                inputValue.append(char)
                            },
                            onBackspace: {
                                if !inputValue.isEmpty { inputValue.removeLast() }
                            },
                            onClear: {
                                inputValue = ""
                                outputValue = ""
                            }
                        )

                        // Convert button
                        Button(action: {
                            convertValue()
                        }) {
                            Text("Convert")
                                .font(.system(size: 34, weight: .bold))
                                .frame(width: 320, height: 80)
                        }
                        .buttonStyle(FocusableButtonStyle())
                    }
                }

                Spacer()
            }
            .padding()
        }
    }

    private func convertValue() {
        guard let conversion = selectedConversion,
              let value = Double(inputValue) else {
            outputValue = "Please enter a valid number"
            return
        }

        let result: Double

        switch conversion {
        case .metersToKilometers:
            result = value / 1000.0
        case .kilometersToMeters:
            result = value * 1000.0
        case .kilogramsToGrams:
            result = value * 1000.0
        case .gramsToKilograms:
            result = value / 1000.0
        case .celsiusToFahrenheit:
            result = (value * 9.0 / 5.0) + 32.0
        case .fahrenheitToCelsius:
            result = (value - 32.0) * 5.0 / 9.0
        }

        outputValue = String(format: "Result: %.2f", result)
    }
}

struct NumericKeypadView: View {

    let onAppend: (String) -> Void
    let onBackspace: () -> Void
    let onClear: () -> Void

    private let rows: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        [".", "0"]
    ]

    var body: some View {
        VStack(spacing: 16) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 20) {
                    ForEach(row, id: \.self) { value in
                        Button(action: {
                            onAppend(value)
                        }) {
                            Text(value)
                                .font(.system(size: 32, weight: .medium))
                                .frame(width: 120, height: 70)
                        }
                        .buttonStyle(FocusableButtonStyle())
                    }
                }
            }

            HStack(spacing: 40) {
                Button(action: {
                    onClear()
                }) {
                    Text("Clear")
                        .font(.system(size: 28, weight: .semibold))
                        .frame(width: 200, height: 70)
                }
                .buttonStyle(FocusableButtonStyle())

                Button(action: {
                    onBackspace()
                }) {
                    Text("⌫")
                        .font(.system(size: 28, weight: .semibold))
                        .frame(width: 200, height: 70)
                }
                .buttonStyle(FocusableButtonStyle())
            }
        }
    }
}

struct UnitConverterView_Previews: PreviewProvider {
    static var previews: some View {
        UnitConverterView()
    }
}
