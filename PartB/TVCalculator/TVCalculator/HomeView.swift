import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 40) {
            Text("TV Calculator")
                .font(.largeTitle)
                .bold()

            NavigationLink(destination: CalculatorView()) {
                Text("Calculator")
                    .font(.title2)
                    .frame(width: 400, height: 80)
            }
            .buttonStyle(FocusableButtonStyle())

            NavigationLink(destination: BillSplitterView()) {
                Text("Bill Splitter")
                    .font(.title2)
                    .frame(width: 400, height: 80)
            }
            .buttonStyle(FocusableButtonStyle())
        }
        .padding()
    }
}
