import Foundation
import SpriteKit

enum EnemyType {
    case raider
    case soldier
    case boss

    var maxHealth: Int {
        switch self {
        case .raider: return 30
        case .soldier: return 50
        case .boss: return 200
        }
    }

    var moveSpeed: CGFloat {
        switch self {
        case .raider: return 120
        case .soldier: return 90
        case .boss: return 70
        }
    }

    var color: SKColor {
        switch self {
        case .raider: return .red
        case .soldier: return .orange
        case .boss: return .purple
        }
    }
}

// Custom node with HP
class EnemyNode: SKSpriteNode {
    let enemyType: EnemyType
    var health: Int

    init(type: EnemyType, size: CGSize) {
        self.enemyType = type
        self.health = type.maxHealth
        super.init(texture: nil, color: type.color, size: size)
        self.name = "enemy"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func takeDamage(_ amount: Int) -> Bool {
        health = max(health - amount, 0)
        return health <= 0
    }
}
