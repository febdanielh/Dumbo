//
//  TutorialAnimation.swift
//  Dumbo
//
//  Created by measthmatic on 28/06/23.
//

import Foundation
import UIKit
import SpriteKit

class DragUpTutorial: SKSpriteNode {
    
    init(scene: SKScene){
        let dragUpTexture = SKTexture(imageNamed: "Drag up")
        super.init(texture: dragUpTexture, color: UIColor.clear, size: dragUpTexture.size())
        
        let fadeAnimation = SKAction.sequence([SKAction.fadeIn(withDuration: 0.5), SKAction.wait(forDuration: 1.0), SKAction.fadeOut(withDuration: 1.0)])
        let repeatFour = SKAction.repeat(fadeAnimation, count: 4)
        
        super.run(repeatFour)
        scene.addChild(self)
        
        zPosition = 11
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class DragDownTutorial: SKSpriteNode {
    
    init(scene: SKScene){
        let dragDownTexture = SKTexture(imageNamed: "Drag down")
        super.init(texture: dragDownTexture, color: UIColor.clear, size: dragDownTexture.size())
        
        let fadeAnimation = SKAction.sequence([SKAction.fadeIn(withDuration: 0.5), SKAction.wait(forDuration: 1.0), SKAction.fadeOut(withDuration: 1.0)])
        let repeatFour = SKAction.repeat(fadeAnimation, count: 4)
        
        super.run(repeatFour)
        scene.addChild(self)
        
        zPosition = 11
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
