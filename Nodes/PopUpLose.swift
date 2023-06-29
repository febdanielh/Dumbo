//
//  PopUp.swift
//  Dumbo
//
//  Created by Azella Mutyara on 26/06/23.
//

import Foundation
import SpriteKit

class PopUpLose: SKSpriteNode {
    
    init(scene: SKScene){
        let texture = SKTexture(imageNamed: "Pop Up Lose")
        
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        scene.addChild(self)
        zPosition = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
