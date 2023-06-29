//
//  Obstacle.swift
//  Dumbo
//
//  Created by Febrian Daniel on 24/06/23.
//

import Foundation
import SpriteKit

class Obstacle: SKSpriteNode {
    
    let obstacleTextures = [
        SKTexture(imageNamed: "botol"),
        SKTexture(imageNamed: "bungkus makanan"),
        SKTexture(imageNamed: "kantong plastik"),
        SKTexture(imageNamed: "sandal")
        // Add more texture options as needed
    ]
    
    init(){
        // Randomly select a texture from the array
        let randomTextureIndex = Int.random(in: 0..<obstacleTextures.count)
        let randomTexture = obstacleTextures[randomTextureIndex]
//        let obstacleSize = CGSize(width: 80, height: 80)
        super.init(texture: randomTexture, color: UIColor.clear, size: randomTexture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func spawn(in scene: SKScene) {
        scene.addChild(self)
        
        let randomY = CGFloat.random(in: -scene.frame.size.height/2...scene.frame.size.height/2)
        let obstacleX = scene.frame.size.width/2 + size.width
        
        position = CGPoint(x: obstacleX, y: randomY)
        zPosition = 2
        
        // Add physics body to the obstacle for collision detection
        
        let obstacleTextures = texture!
        let obstacleSize = obstacleTextures.size()
        
        let customPhysicsBodyFromTexture = SKPhysicsBody(texture: obstacleTextures, alphaThreshold: 0.5, size: obstacleSize)
        
        physicsBody = customPhysicsBodyFromTexture
//        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.categoryBitMask = PhysicsCategory.obstacleCategory
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = PhysicsCategory.playerCategory
        physicsBody?.affectedByGravity = false
        physicsBody?.velocity = CGVector(dx: -170.0, dy: 0)
        
        let floatingAction = SKAction.applyForce(CGVector(dx: 0.0, dy: 10.0), duration: 1)
        let reverseFloatingAction = SKAction.applyForce(CGVector(dx: 0.0, dy: -10.0), duration: 1)
        let floatingSequence = SKAction.sequence([floatingAction, reverseFloatingAction])
        let floatingRepeat = SKAction.repeatForever(floatingSequence)
        
        run(floatingRepeat, withKey: "float")
        
        //Create an action to check the obstacle's position and remove it if off-screen
        let despawnAction = SKAction.run {
            self.checkDespawn()
        }
        
        let checkDespawnSequence = SKAction.sequence([SKAction.wait(forDuration: 0.1), despawnAction])
        let checkDespawnForever = SKAction.repeatForever(checkDespawnSequence)
        
        run(checkDespawnForever, withKey: "despawnObstacle")
    }
    
    func checkDespawn() {
        let despawnX = -scene!.frame.size.width
        
        if position.x <= despawnX {
            removeFromParent()
        }
    }
    
    func stopObstacleSpawn() {
        removeAction(forKey: "spawnObstacles")
    }
    
    
    func stopMoving() {
//        physicsBody = nil
//        removeAction(forKey: "float") // Remove any running actions on the obstacle
//        let floatingAction = SKAction.applyForce(CGVector(dx: 0.0, dy: 0.0), duration: 1)
//        let reverseFloatingAction = SKAction.applyForce(CGVector(dx: 0.0, dy: 0.0), duration: 1)
    }
    
    func resumeMoving() {
        
    }

}
