//
//  Player.swift
//  Dumbo
//
//  Created by Febrian Daniel on 24/06/23.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode {
    var frames: [SKTexture] = []
    
    init(scene: SKScene){
        
        for i in 1...36 {
            let textureName = "swim-\(i)"
            let texture = SKTexture(imageNamed: textureName)
            frames.append(texture)
        }
        
        let playerTexture = frames[0]
        let playerSize = CGSize(width: 60, height: 60)
        
        super.init(texture: playerTexture, color: UIColor.clear, size: playerSize)
        
        let animationAction = SKAction.animate(with: frames, timePerFrame: 0.05)
        
        self.run(SKAction.repeatForever(animationAction))
        
        scene.addChild(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func spawn() {
        
        position = CGPoint(x: -frame.width/3, y: 0)
        zPosition = 5.0
        
        let karakterTextures = self.texture!
        let karakterSize = self.size
        
        let customPhysicsBodyFromTextureKarakter = SKPhysicsBody(texture: karakterTextures, alphaThreshold: 0.5, size: karakterSize)
        
        // Add physics body to the player for collision detection
        self.physicsBody = customPhysicsBodyFromTextureKarakter
        self.physicsBody?.categoryBitMask = PhysicsCategory.playerCategory
        self.physicsBody?.collisionBitMask = PhysicsCategory.boundaryCategory
        self.physicsBody?.contactTestBitMask = PhysicsCategory.obstacleCategory | PhysicsCategory.groundCategory
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.allowsRotation = true
    }
    
    func movePlayer() {
        self.physicsBody?.velocity = CGVector(dx: 170.0, dy: 0)
    }
}
