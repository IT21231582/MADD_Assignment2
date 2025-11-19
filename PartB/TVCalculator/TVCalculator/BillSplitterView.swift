import SwiftUI

struct BillSplitterView: View {

    @State private var total = ""
    @State private var people = ""
    @State private var result: String?

    var body: some View {
        VStack(spacing: 40) {

            Text("Bill Splitter")
                .font(.largeTitle)
                .bold()

            VStack(spacing: 20) {
                TextField("Total Amount", text: $total)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(10)
                    .frame(width: 500)
                    .focusable(true)

                TextField("Number of People", text: $people)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(10)
                    .frame(width: 500)
                    .focusable(true)
            }

            Button("Calculate") {
                calculateSplit()
            }
            .font(.title2)
            .frame(width: 300, height: 70)
            .buttonStyle(FocusableButtonStyle())

            if let result = result {
                Text("Each Person Pays: \(result)")
                    .font(.title2)
                    .padding(.top, 20)
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

    func calculateSplit() {
        guard let t = Double(total),
              let p = Double(people),
              p > 0 else {
            result = "Invalid input"
            return
        }

        let each = t / p
        result = String(format: "%.2f", each)
    }
}
