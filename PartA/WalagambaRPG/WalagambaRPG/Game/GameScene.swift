import SpriteKit
import SwiftUI

// Physics bitmasks
struct PhysicsCategory {
    static let player: UInt32 = 0x1 << 0
    static let enemy:  UInt32 = 0x1 << 1
    static let npc:    UInt32 = 0x1 << 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    // MARK: - References

    weak var gameState: GameState?

    // MARK: - Nodes

    private let worldNode = SKNode()
    private let playerNode = SKSpriteNode(color: .yellow, size: CGSize(width: 40, height: 40))

    // NPCs (for future quests / dialogue)
    private let templeNPC = SKSpriteNode(color: .white, size: CGSize(width: 30, height: 30))

    // MARK: - Config

    private let tileSize = CGSize(width: 80, height: 80)
    private let enemySpawnInterval: TimeInterval = 3.0
    private let baseEnemySpeed: CGFloat = 120.0
    private let playerMoveSpeed: CGFloat = 220.0
    private let playerDamageFromEnemy = 10
    private let playerAttackDamage = 25
    private let playerAttackRange: CGFloat = 90

    // MARK: - Lifecycle

    override func didMove(to view: SKView) {
        backgroundColor = .black
        physicsWorld.contactDelegate = self

        addChild(worldNode)
        setupMap()
        setupPlayer()
        setupNPCs()
        startEnemySpawning()
    }

    // MARK: - Setup

    private func setupMap() {
        // Simple“Sri Lankan” themed grid:
        // bottom: road
        // left: palace grounds
        // top: temple
        // right: fields

        let cols = 8
        let rows = 10

        let totalWidth = CGFloat(cols) * tileSize.width
        let totalHeight = CGFloat(rows) * tileSize.height

        let originX = -totalWidth / 2 + tileSize.width / 2
        let originY = -totalHeight / 2 + tileSize.height / 2

        for row in 0..<rows {
            for col in 0..<cols {
                let tile = SKSpriteNode(color: .darkGray, size: tileSize)

                let isRoad = row == 0 || row == 1
                let isPalaceSide = col == 0 || col == 1
                let isTempleSide = row >= rows - 2
                let isFieldSide = col >= cols - 2

                if isRoad {
                    tile.color = .brown // main road
                } else if isPalaceSide {
                    tile.color = SKColor(red: 0.8, green: 0.75, blue: 0.4, alpha: 1.0) // palace area
                } else if isTempleSide {
                    tile.color = .white // temple district
                } else if isFieldSide {
                    tile.color = SKColor(red: 0.1, green: 0.5, blue: 0.1, alpha: 1.0) // paddy fields
                } else {
                    tile.color = SKColor(
                        red: 0.05,
                        green: 0.25 + CGFloat.random(in: 0...0.1),
                        blue: 0.05,
                        alpha: 1.0
                    )
                }

                let x = originX + CGFloat(col) * tileSize.width
                let y = originY + CGFloat(row) * tileSize.height
                tile.position = CGPoint(x: x, y: y)

                tile.zPosition = -2
                worldNode.addChild(tile)
            }
        }
    }

    private func setupPlayer() {
        playerNode.position = CGPoint(x: 0, y: -tileSize.height * 2)
        playerNode.zPosition = 10
        playerNode.name = "player"

        playerNode.physicsBody = SKPhysicsBody(rectangleOf: playerNode.size)
        playerNode.physicsBody?.isDynamic = true
        playerNode.physicsBody?.categoryBitMask = PhysicsCategory.player
        playerNode.physicsBody?.collisionBitMask = 0
        playerNode.physicsBody?.contactTestBitMask = PhysicsCategory.enemy | PhysicsCategory.npc

        worldNode.addChild(playerNode)
    }

    private func setupNPCs() {
        // Temple monk NPC at the temple area (top middle)
        templeNPC.position = CGPoint(x: 0, y: tileSize.height * 3.5)
        templeNPC.zPosition = 5
        templeNPC.name = "templeNPC"

        templeNPC.physicsBody = SKPhysicsBody(rectangleOf: templeNPC.size)
        templeNPC.physicsBody?.isDynamic = false
        templeNPC.physicsBody?.categoryBitMask = PhysicsCategory.npc
        templeNPC.physicsBody?.collisionBitMask = 0
        templeNPC.physicsBody?.contactTestBitMask = PhysicsCategory.player

        worldNode.addChild(templeNPC)
    }

    private func startEnemySpawning() {
        let spawnAction = SKAction.sequence([
            SKAction.run { [weak self] in
                self?.spawnEnemy()
            },
            SKAction.wait(forDuration: enemySpawnInterval)
        ])

        run(SKAction.repeatForever(spawnAction), withKey: "enemySpawnLoop")
    }

    private func spawnEnemy() {
        // After some progress, occasionally spawn a stronger one
        let enemyType: EnemyType
        if (gameState?.enemiesDefeated ?? 0) >= 10 && Int.random(in: 0..<5) == 0 {
            enemyType = .boss
        } else if Int.random(in: 0..<3) == 0 {
            enemyType = .soldier
        } else {
            enemyType = .raider
        }

        let enemySize = CGSize(width: 35, height: 35)
        let enemy = EnemyNode(type: enemyType, size: enemySize)

        // Spawn at random edge
        let margin: CGFloat = 40
        let edge = Int.random(in: 0..<4)
        var position: CGPoint

        switch edge {
        case 0: // left
            position = CGPoint(x: -size.width/2 + margin, y: CGFloat.random(in: -size.height/2...size.height/2))
        case 1: // right
            position = CGPoint(x: size.width/2 - margin, y: CGFloat.random(in: -size.height/2...size.height/2))
        case 2: // bottom
            position = CGPoint(x: CGFloat.random(in: -size.width/2...size.width/2), y: -size.height/2 + margin)
        default: // top
            position = CGPoint(x: CGFloat.random(in: -size.width/2...size.width/2), y: size.height/2 - margin)
        }

        enemy.position = convert(position, to: worldNode)
        enemy.zPosition = 5

        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemySize)
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        enemy.physicsBody?.collisionBitMask = 0
        enemy.physicsBody?.contactTestBitMask = PhysicsCategory.player

        worldNode.addChild(enemy)

        moveEnemyTowardPlayer(enemy)
    }

    private func moveEnemyTowardPlayer(_ enemy: EnemyNode) {
        let dx = playerNode.position.x - enemy.position.x
        let dy = playerNode.position.y - enemy.position.y
        let distance = hypot(dx, dy)

        guard distance > 0 else { return }

        let speed = enemy.enemyType.moveSpeed
        let duration = TimeInterval(distance / speed)
        let moveAction = SKAction.move(to: playerNode.position, duration: duration)

        enemy.run(moveAction)
    }

    // MARK: - Input Handling (tap to move)

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard
            let touch = touches.first,
            !isPlayerDead()
        else { return }

        let locationInScene = touch.location(in: self)
        let locationInWorld = convert(locationInScene, to: worldNode)

        movePlayer(to: locationInWorld)
    }

    private func movePlayer(to position: CGPoint) {
        playerNode.removeAction(forKey: "playerMove")

        let dx = position.x - playerNode.position.x
        let dy = position.y - playerNode.position.y
        let distance = hypot(dx, dy)

        guard distance > 0 else { return }

        let duration = TimeInterval(distance / playerMoveSpeed)
        let moveAction = SKAction.move(to: position, duration: duration)
        playerNode.run(moveAction, withKey: "playerMove")
    }

    // MARK: - Sword Attack (called from SwiftUI button)

    func playerAttack() {
        guard !isPlayerDead() else { return }

        // simple "swing" visual
        swingAnimation()

        // determine attack area in front of the player
        let facingVector = CGVector(dx: 0, dy: 1) // up for now
        let attackCenter = CGPoint(
            x: playerNode.position.x + facingVector.dx * playerAttackRange * 0.5,
            y: playerNode.position.y + facingVector.dy * playerAttackRange * 0.5
        )

        worldNode.enumerateChildNodes(withName: "enemy") { node, _ in
            guard let enemy = node as? EnemyNode else { return }
            let distance = hypot(enemy.position.x - attackCenter.x,
                                 enemy.position.y - attackCenter.y)
            if distance <= self.playerAttackRange {
                let died = enemy.takeDamage(self.playerAttackDamage)
                self.hitFlash(on: enemy)
                if died {
                    enemy.removeFromParent()
                    self.gameState?.enemyDefeated()
                    self.gameState?.checkQuestCompletion()
                }
            }
        }
    }

    private func swingAnimation() {
        let arc = SKShapeNode(circleOfRadius: playerAttackRange / 2)
        arc.position = playerNode.position
        arc.zPosition = 1
        arc.strokeColor = .yellow
        arc.lineWidth = 3
        arc.alpha = 0.0
        worldNode.addChild(arc)

        let fadeIn = SKAction.fadeAlpha(to: 0.7, duration: 0.05)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let remove = SKAction.removeFromParent()
        arc.run(SKAction.sequence([fadeIn, fadeOut, remove]))
    }

    private func hitFlash(on node: SKNode) {
        let flash = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.3, duration: 0.1),
            SKAction.fadeAlpha(to: 1.0, duration: 0.1)
        ])
        node.run(flash)
    }

    // MARK: - Physics Contacts

    func didBegin(_ contact: SKPhysicsContact) {
        guard !isPlayerDead() else { return }

        let bodies = [contact.bodyA, contact.bodyB]

        let hasPlayer = bodies.contains { $0.categoryBitMask == PhysicsCategory.player }
        let enemyBody = bodies.first { $0.categoryBitMask == PhysicsCategory.enemy }
        let npcBody = bodies.first { $0.categoryBitMask == PhysicsCategory.npc }

        if hasPlayer, let enemyBody = enemyBody {
            if let enemyNode = enemyBody.node as? EnemyNode {
                handlePlayerHit(by: enemyNode)
            }
        }

        if hasPlayer, let npcBody = npcBody {
            if npcBody.node === templeNPC {
                gameState?.showTempleDialogue()
            }
        }
    }

    private func handlePlayerHit(by enemy: EnemyNode) {
        gameState?.takeDamage(playerDamageFromEnemy)

        let flash = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.3, duration: 0.1),
            SKAction.fadeAlpha(to: 1.0, duration: 0.1)
        ])
        playerNode.run(flash)

        if isPlayerDead() {
            handleDeath()
        }
    }

    private func handleDeath() {
        playerNode.removeAllActions()

        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        playerNode.run(fadeOut)

        removeAction(forKey: "enemySpawnLoop")

        worldNode.enumerateChildNodes(withName: "enemy") { node, _ in
            node.removeAllActions()
            node.removeFromParent()
        }
    }

    private func isPlayerDead() -> Bool {
        return gameState?.isPlayerDead ?? false
    }
}
