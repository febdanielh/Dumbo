//
//  ShaderNode.swift
//  Dumbo
//
//  Created by Febrian Daniel on 29/06/23.
//

import Foundation
import SpriteKit

class ShaderNode: SKSpriteNode {
    
    init(scene: SKScene) {
        let shaderTexture = SKTexture(imageNamed: "bg opacity")
        
        super.init(texture: shaderTexture, color: UIColor.clear, size: shaderTexture.size())
        
        zPosition = 4.0
        
        scene.addChild(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
