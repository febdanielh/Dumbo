//
//  PopUpPause.swift
//  Dumbo
//
//  Created by Azella Mutyara on 26/06/23.
//

import Foundation
import SpriteKit

class PopUpPause: SKSpriteNode {
    
    init(scene: SKScene){
        let texture = SKTexture(imageNamed: "Pop Up Pause")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        scene.addChild(self)
        zPosition = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
