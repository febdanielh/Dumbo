//
//  InitialStory.swift
//  Dumbo
//
//  Created by Khadijah Rizqy on 28/06/23.
//

import Foundation
import SpriteKit

class InitialStory: SKScene {
    
    var closeButton: SKSpriteNode!
    var skipButton: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        skipButton = SKSpriteNode(imageNamed: "Icon Skip")
        skipButton.position = CGPoint(x: 385, y: 150)
        
        closeButton = SKSpriteNode(imageNamed: "Icon Close")
        closeButton.position = CGPoint(x: 385, y: 150)
        let existingUser = UserDefaults.standard.bool(forKey: "ExistingUser")

        if existingUser {
            addChild(closeButton)
            print("existing user")
        }
        else {
            addChild(skipButton)
            print("new user")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if skipButton.contains(location) {
                // Set the flag indicating that the user is now an existing user
                // UserDefaults.standard.set(true, forKey: "ExistingUser")
                let scene = GameScene(fileNamed: "GameScene")
                scene!.scaleMode = .aspectFill
                self.view?.presentScene(scene)
            }
            if closeButton.contains(location) {
                // Set the flag indicating that the user is now an existing user
                // UserDefaults.standard.set(true, forKey: "ExistingUser")
                let scene = GameScene(fileNamed: "GameScene")
                scene!.scaleMode = .aspectFill
                self.view?.presentScene(scene)
            }
        }
    }
}
