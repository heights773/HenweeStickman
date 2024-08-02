//
//  GameScene.swift
//  HenweeStickman
//
//  Created by Elton Ortiz on 12/10/23.
//

import SpriteKit

enum CollisionTypes: UInt32 {
    case player = 1
    case anchor = 2
    case spikes = 4
    case exit = 8
}

enum Nodes: String {
    case player = "player"
    case anchor = "anchor"
    case exit = "exit"
    case spikes = "spikes"
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - Internal Properties
    
    var pin = SKPhysicsJointPin()
    var player = Player()
    var anchor = Anchor()
    var anchor2 = Anchor()
    var anchorsInGame = [SKSpriteNode]()
    var currentAnchor = SKSpriteNode()
    var exit = Exit()
    
    // MARK: - GameScene Overrides

    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        create(anchor, at: CGPoint(x: 425, y: 450))
        create(anchor2, at: CGPoint(x: 575, y: 450))
        
//        create(exit, at: CGPoint(x: 512, y: 70))
        
        createSpikes(x: 60, y: 45)
        
        setLevel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        while player.physicsBody!.joints.isEmpty == false {
            physicsWorld.remove(pin)
            
            // this gives us the "bounciness" when the player jumps from an anchor. right now it only works in one direction (right) because our dx value is positive. need to figure out how to have this work both ways.
            
            if player.position.x > currentAnchor.position.x {
                player.physicsBody?.velocity = CGVector(dx: 300, dy: 300)
            } else {
                player.physicsBody?.velocity = CGVector(dx: -300, dy: 300)
            }
            break
        }
    }
    
//    override func update(_ currentTime: TimeInterval) {
//        <#code#>
//    }
    
    // MARK: - Internal Functions
    
//    func createAnchor(at postition: CGPoint) {
//        anchor = SKSpriteNode(imageNamed: "anchor")
//        
//        anchor.name = "anchor"
//        anchor.position = postition
//        anchor.zPosition = 0
//        anchor.physicsBody = SKPhysicsBody(circleOfRadius: anchor.size.width / 2)
//        anchor.physicsBody?.isDynamic = false
//        anchor.physicsBody?.categoryBitMask = CollisionTypes.anchor.rawValue
//        anchor.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
//        
//        let spin = SKAction.rotate(byAngle: CGFloat(2.4), duration: 0.6)
//        let oppositeSpin = SKAction.rotate(byAngle: CGFloat(-2.4), duration: 0.6)
//        let sequence = SKAction.sequence([spin, oppositeSpin])
//        let spinForever = SKAction.repeatForever(sequence)
//        
//        anchor.run(spinForever)
//        
//        anchorsInGame.append(anchor)
//        addChild(anchor)
//    }
    
    func createSpikeNode(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "spikes")
        
        node.name = "spikes"
        node.position = position
        node.zPosition = 0
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionTypes.spikes.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        
        addChild(node)
    }
    
    func createSpikes(x: Double, y: Double) {
        var xPos = x
        
        while xPos < 980 {
            createSpikeNode(at: CGPoint(x: xPos, y: y))
            xPos += 75
        }
    }
    
    func create(_ node: SKSpriteNode, at position: CGPoint) {
        node.position = position
        
        if node.name == Nodes.anchor.rawValue {
            anchorsInGame.append(node)
        } else if node.name == Nodes.player.rawValue {
            player.zRotation = 0.0
        }
        
        addChild(node)
    }
    
    func setLevel() {
        let startingAnchor = anchorsInGame.first!
        let startingPosition = CGPoint(x: startingAnchor.position.x - 30, y: startingAnchor.position.y - 34)
        currentAnchor = startingAnchor
        
        create(player, at: startingPosition)
        
        pin = SKPhysicsJointPin.joint(withBodyA: startingAnchor.physicsBody!, bodyB: player.physicsBody!, anchor: startingAnchor.position)
        physicsWorld.add(pin)
    }
    
    // MARK: - Collision Detection
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == Nodes.player.rawValue {
            
            if nodeB.name == Nodes.anchor.rawValue {
                while nodeB != pin.bodyA.node {
                    currentAnchor = nodeB as! SKSpriteNode
                    let startingPosition = CGPoint(x: nodeB.position.x - 30, y: nodeB.position.y - 34)
                    player.removeFromParent()
                    create(player, at: startingPosition)
                    
                    pin = SKPhysicsJointPin.joint(withBodyA: nodeB.physicsBody!, bodyB: player.physicsBody!, anchor: nodeB.position)
                    physicsWorld.add(pin)
                }
                
            } else if nodeB.name == Nodes.spikes.rawValue {
                nodeA.removeFromParent()
                
                if let fireParticle = SKEmitterNode(fileNamed: "FireParticles") {
                    fireParticle.position = nodeA.position
                    addChild(fireParticle)
                    
                    let wait = SKAction.wait(forDuration: 1.3)
                    let remove = SKAction.removeFromParent()
                    let sequence = SKAction.sequence([wait, remove])
                    
                    fireParticle.run(sequence) {
                        self.setLevel()
                    }
                }
                
            } else {
                nodeA.removeFromParent()
            }
            
        } else if nodeB.name == Nodes.player.rawValue {
            
            if nodeA.name == Nodes.anchor.rawValue {
                while nodeA != pin.bodyA.node {
                    currentAnchor = nodeA as! SKSpriteNode
                    let startingPosition = CGPoint(x: nodeA.position.x - 30, y: nodeA.position.y - 34)
                    player.removeFromParent()
                    create(player, at: startingPosition)
                    
                   pin = SKPhysicsJointPin.joint(withBodyA: nodeA.physicsBody!, bodyB: player.physicsBody!, anchor: nodeA.position)
                    physicsWorld.add(pin)
                }
                
            } else if nodeA.name == Nodes.spikes.rawValue {
                nodeB.removeFromParent()
                
                if let fireParticle = SKEmitterNode(fileNamed: "FireParticles") {
                    fireParticle.position = nodeB.position
                    addChild(fireParticle)
                    
                    let wait = SKAction.wait(forDuration: 1.3)
                    let remove = SKAction.removeFromParent()
                    let sequence = SKAction.sequence([wait, remove])
                    
                    fireParticle.run(sequence) {
                        self.setLevel()
                    }
                }
                
            } else {
                nodeB.removeFromParent()
            }
        }
    }
}
