//
//  PlayerDead.swift
//  Dumbo
//
//  Created by Febrian Daniel on 27/06/23.
//

import Foundation
import SpriteKit

class PlayerDead: SKSpriteNode {
    var frames: [SKTexture] = []
    
    init(scene: SKScene, completion: (() -> Void)?) {
        
        for i in 0...26 {
            let textureName = "dead-\(i)"
            let texture = SKTexture(imageNamed: textureName)
            frames.append(texture)
        }
        
        let playerTexture = frames[0]
        let playerSize = CGSize(width: 60, height: 60)
        
        super.init(texture: playerTexture, color: UIColor.clear, size: playerSize)
        
        zPosition = 6.0
        
        let animationAction = SKAction.animate(with: frames, timePerFrame: 0.05)
        self.run(SKAction.repeat(animationAction, count: 1), completion: { [weak self] in
            self?.animationDidFinish(completion: completion)
        })
//        self.position = position
        
        scene.addChild(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func animationDidFinish(completion: (() -> Void)?) {
        completion?()
    }
}
