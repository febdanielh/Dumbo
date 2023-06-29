//
//  BackButton.swift
//  Dumbo
//
//  Created by Angelica Pinonkuan on 29/06/23.
//

import Foundation
import SpriteKit

class BackButton: SKSpriteNode {
    
    init(scene: SKScene) {
        let texture = SKTexture(imageNamed: "Button Back Small")
        
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        scene.addChild(self)
        zPosition = 11
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
