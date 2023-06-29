//
//  MenuButton.swift
//  Dumbo
//
//  Created by Febrian Daniel on 26/06/23.
//

import Foundation
import SpriteKit

class MenuButton: SKSpriteNode {
    
    init(scene: SKScene){
        let menuTexture = SKTexture(imageNamed: "Button Menu Small")
        
        super.init(texture: menuTexture, color: UIColor.clear, size: menuTexture.size())
        
        scene.addChild(self)
        zPosition = 11
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

