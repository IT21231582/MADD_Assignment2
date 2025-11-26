import SwiftUI

struct BillSplitterView: View {

    @State private var total = ""
    @State private var people = ""
    @State private var result: String?
    @State private var errorMessage: String?

    @FocusState private var isAmountFocused: Bool
    @FocusState private var isPeopleFocused: Bool

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

            VStack(spacing: 60) {

                Text("Bill Splitter")
                    .font(.largeTitle)
                    .bold()

                // Input rows
                VStack(spacing: 30) {
                    HStack(spacing: 24) {
                        Text("Total Amount")
                            .font(.system(size: 32, weight: .semibold))
                            .frame(width: 260, alignment: .trailing)

                        TextField("0.00", text: $total)
                            .keyboardType(.decimalPad)
                            .font(.system(size: 32, weight: .regular))
                            .submitLabel(.done)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .padding()
                            .background(Color.black.opacity(0.2))
                            .cornerRadius(12)
                            .frame(width: 360, alignment: .leading)
                            .focused($isAmountFocused)
                            .focusable(true)
                            .onSubmit {
                                // Move focus to people field when user submits amount
                                isPeopleFocused = true
                            }
                    }

                    HStack(spacing: 24) {
                        Text("Number of People")
                            .font(.system(size: 32, weight: .semibold))
                            .frame(width: 260, alignment: .trailing)

                        TextField("0", text: $people)
                            .keyboardType(.numberPad)
                            .font(.system(size: 32, weight: .regular))
                            .submitLabel(.done)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .padding()
                            .background(Color.black.opacity(0.2))
                            .cornerRadius(12)
                            .frame(width: 360, alignment: .leading)
                            .focused($isPeopleFocused)
                            .focusable(true)
                            .onSubmit {
                                // Trigger calculation when people field submits
                                calculateSplit()
                            }
                    }
                }

                // Calculate button
                Button("Calculate") {
                    calculateSplit()
                }
                .font(.system(size: 34, weight: .semibold))
                .frame(width: 320, height: 80)
                .buttonStyle(FocusableButtonStyle())

                // Result / error display
                if let error = errorMessage {
                    Text(error)
                        .font(.system(size: 26, weight: .medium))
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.top, 16)
                } else if let result = result {
                    VStack(spacing: 10) {
                        Text("Each Person Pays")
                            .font(.system(size: 32, weight: .regular))
                        Text(result)
                            .font(.system(size: 56, weight: .bold))
                    }
                    .padding(.top, 24)
                }

                // Back navigation
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
    }

    func calculateSplit() {
        // Reset previous state
        errorMessage = nil
        result = nil

        guard let t = Double(total),
              let p = Double(people),
              p > 0 else {
            errorMessage = "Please enter valid numbers (people must be greater than 0)."
            return
        }

        let each = t / p
        result = String(format: "%.2f", each)
    }
}
