//
//  NextButton.swift
//  Dumbo
//
//  Created by Febrian Daniel on 27/06/23.
//

import Foundation
import SpriteKit

class NextButton: SKSpriteNode {
    
    init(scene: SKScene){
        let nextTexture = SKTexture(imageNamed: "Button Next Small")
        
        super.init(texture: nextTexture, color: UIColor.clear, size: nextTexture.size())
        
        scene.addChild(self)
        zPosition = 11
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
