import SwiftUI
import SpriteKit

struct GameView: View {
    @StateObject private var gameState = GameState()
    @State private var scene = GameScene(size: UIScreen.main.bounds.size)

    var body: some View {
        ZStack {
            // Game content
            SpriteView(scene: scene)
                .ignoresSafeArea()
                .onAppear {
                    scene.scaleMode = .resizeFill
                    scene.gameState = gameState
                }

            // HUD & overlays
            VStack {
                gameHUD
                    .padding()
                Spacer()

                if gameState.isPlayerDead {
                    deathOverlay
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                } else {
                    attackButtonBar
                        .padding(.bottom, 12)
                }
            }

            if let dialogue = gameState.activeDialogue {
                dialogueOverlay(dialogue)
            }
        }
        .navigationBarBackButtonHidden(false)
    }

    // MARK: - HUD

    private var gameHUD: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("King Walagamba")
                        .font(.headline)
                    if let quest = gameState.currentQuest {
                        Text("Quest: \(quest.title)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("Enemies defeated")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(gameState.enemiesDefeated)")
                        .font(.headline)
                }
            }

            healthBar
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(radius: 12, y: 6)
    }

    private var healthBar: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let ratio = CGFloat(gameState.playerHealth) / CGFloat(gameState.maxHealth)

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.red.opacity(0.18))

                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.red.opacity(0.7))
                    .frame(width: max(0, width * ratio))

                HStack {
                    Spacer()
                    Text("\(gameState.playerHealth)/\(gameState.maxHealth)")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.85))
                        .padding(.trailing, 6)
                }
            }
        }
        .frame(height: 18)
    }

    // MARK: - Attack Controls

    private var attackButtonBar: some View {
        HStack {
            Spacer()
            Button {
                scene.playerAttack()
            } label: {
                Text("Attack")
                    .font(.headline)
                    .padding(.horizontal, 26)
                    .padding(.vertical, 10)
            }
            .buttonStyle(.borderedProminent)
            .tint(.primary.opacity(0.85))
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 20, style: .continuous)
            )
            .shadow(radius: 10, y: 4)
            .padding(.trailing, 16)
        }
    }

    // MARK: - Death Overlay

    private var deathOverlay: some View {
        VStack(spacing: 16) {
            Text("You have fallen")
                .font(.title2.weight(.semibold))

            Text("Enemies defeated: \(gameState.enemiesDefeated)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Button("Restart") {
                restartGame()
            }
            .buttonStyle(.borderedProminent)
            .tint(.primary.opacity(0.85))
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(radius: 16, y: 6)
        .padding(.bottom, 60)
    }

    private func restartGame() {
        gameState.reset()
        scene = GameScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .resizeFill
        scene.gameState = gameState
    }

    // MARK: - Dialogue Overlay

    private func dialogueOverlay(_ dialogue: Dialogue) -> some View {
        VStack {
            Spacer()
            VStack(spacing: 12) {
                Text(dialogue.title)
                    .font(.headline)

                Text(dialogue.message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)

                Button("OK") {
                    gameState.activeDialogue = nil
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(radius: 12, y: 5)
            .padding()
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}
