//
//  retryButton.swift
//  Dumbo
//
//  Created by Febrian Daniel on 26/06/23.
//

import Foundation
import SpriteKit

class RetryButton: SKSpriteNode {
    
    init(scene: SKScene) {
        let texture = SKTexture(imageNamed: "Button Retry Small")
        
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        scene.addChild(self)
        zPosition = 11
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
