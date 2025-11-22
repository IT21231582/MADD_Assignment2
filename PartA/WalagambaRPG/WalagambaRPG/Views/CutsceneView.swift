import SwiftUI

struct CutsceneView: View {
    let data: CutsceneData
    let onClose: () -> Void

    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            VStack {
                Spacer()

                VStack(spacing: 16) {
                    Text(data.title)
                        .font(.title2.weight(.semibold))
                        .multilineTextAlignment(.center)

                    Text(data.message)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)

                    Button(action: onClose) {
                        Text("Continue")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.primary.opacity(0.85))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .shadow(radius: 18, y: 8)
                .padding(.horizontal)
                .padding(.bottom, 32)

                Spacer()
            }
        }
    }
}
