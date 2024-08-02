//
//  Anchor.swift
//  HenweeStickman
//
//  Created by Elton Ortiz on 12/11/23.
//

import SpriteKit

class Anchor: SKSpriteNode {
    
    init() {
        let anchor = SKTexture(imageNamed: "anchor")
        
        super.init(texture: anchor, color: UIColor.clear, size: anchor.size())
        
        name = "anchor"
        zPosition = 0
        physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = CollisionTypes.anchor.rawValue
        physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        
        let spin = SKAction.rotate(byAngle: CGFloat(2.4), duration: 0.6)
        let oppositeSpin = SKAction.rotate(byAngle: CGFloat(-2.4), duration: 0.6)
        let sequence = SKAction.sequence([spin, oppositeSpin])
        let spinForever = SKAction.repeatForever(sequence)
        
        run(spinForever)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
