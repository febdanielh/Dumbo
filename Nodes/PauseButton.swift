//
//  PauseButton.swift
//  Dumbo
//
//  Created by Angelica Pinonkuan on 28/06/23.
//

import Foundation

import Foundation
import SpriteKit

class PauseButton: SKSpriteNode {
    
    init(scene: SKScene) {
        let texture = SKTexture(imageNamed: "Button Pause")
        
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        scene.addChild(self)
        zPosition = 11
        position = CGPoint(x: -375, y: 150)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
