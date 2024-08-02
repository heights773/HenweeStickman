//
//  Exit.swift
//  HenweeStickman
//
//  Created by Elton Ortiz on 12/11/23.
//

import SpriteKit

class Exit: SKSpriteNode {
    
    init() {
        let exit = SKTexture(imageNamed: "exit")
        
        super.init(texture: exit, color: UIColor.clear, size: exit.size())
        
        name = "exit"
        zPosition = 1
        physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = CollisionTypes.exit.rawValue
        physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
