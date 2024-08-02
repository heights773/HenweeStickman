//
//  Player.swift
//  HenweeStickman
//
//  Created by Elton Ortiz on 12/11/23.
//

import SpriteKit

class Player: SKSpriteNode {
    
    init() {
        let player = SKTexture(imageNamed: "player")
        
        super.init(texture: player, color: UIColor.clear, size: player.size())
        
        name = "player"
        zPosition = 2
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        physicsBody?.contactTestBitMask = CollisionTypes.anchor.rawValue | CollisionTypes.exit.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
