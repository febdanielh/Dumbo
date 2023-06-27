//
//  Ground1.swift
//  Dumbo
//
//  Created by Febrian Daniel on 24/06/23.
//

import Foundation
import SpriteKit

class Ground1: SKSpriteNode {
    
    init(scene: SKScene){
        let groundTexture = SKTexture(imageNamed: "ground-1")
        super.init(texture: groundTexture, color: UIColor.clear, size: groundTexture.size())
        
//        scene.addChild(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func spawn() {
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        zPosition = 1
        
        let groundTextures = texture!
        let groundSize = groundTextures.size()
        
        let customPhysicsBodyFromTexture = SKPhysicsBody(texture: groundTextures, alphaThreshold: 0.5, size: groundSize)
        
        
        physicsBody = customPhysicsBodyFromTexture
        physicsBody?.categoryBitMask = PhysicsCategory.groundCategory
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = PhysicsCategory.playerCategory
        physicsBody?.affectedByGravity = false
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.isDynamic = true
    }
    
    func moveGround(deltaTime: TimeInterval, cameraMovePerSecond: CGFloat){
        let amountToMove = cameraMovePerSecond * CGFloat(deltaTime)
        self.position.x -= amountToMove
    }
    
}
