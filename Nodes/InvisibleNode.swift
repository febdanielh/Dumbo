//
//  InvisibleNode.swift
//  Dumbo
//
//  Created by Febrian Daniel on 27/06/23.
//

import Foundation
import SpriteKit

class InvisibleNode: SKNode {
    
    var invisNode: SKSpriteNode!
    
    init(scene: SKScene) {
        invisNode = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 17, height: 390))
        
        super.init()
        
        scene.addChild(self)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func spawn() {
        zPosition = 6
        
        physicsBody = SKPhysicsBody(rectangleOf: invisNode.size)
        physicsBody?.categoryBitMask = PhysicsCategory.invisNodeCategory
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = PhysicsCategory.playerCategory
        physicsBody?.affectedByGravity = false
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.isDynamic = true
    }
    
    func moveNode(deltaTime: TimeInterval, cameraMovePerSecond: CGFloat){
        let amountToMove = cameraMovePerSecond * CGFloat(deltaTime)
        self.position.x -= amountToMove
    }
    
}
