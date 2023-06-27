//
//  MainMenu.swift
//  Dumbo
//
//  Created by Febrian Daniel on 26/06/23.
//

import Foundation
import SpriteKit

class MainMenu: SKScene {
    
    var homeAudio: SKAudioNode!
    
    var playButton: SKSpriteNode!
    var chapterList: SKSpriteNode!
    var book: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        if let homeAudioURL = Bundle.main.url(forResource: "Main Menu Sound", withExtension: "mp3") {
            homeAudio = SKAudioNode(url: homeAudioURL)
            addChild(homeAudio)
        }
        
        playButton = SKSpriteNode(imageNamed: "Button Play")
        playButton.position = CGPoint(x: -120, y: -94)
        
        chapterList = SKSpriteNode(imageNamed: "Button Chapter List - Sec")
        chapterList.position = CGPoint(x: 120, y: -94)
        
        book = SKSpriteNode(imageNamed: "Icon Book - Sec")
        book.position = CGPoint(x: -375, y: 150)
        
        addChild(playButton)
        addChild(chapterList)
        addChild(book)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if playButton.contains(location) {
                let scene = GameScene(fileNamed: "GameScene")
                scene!.scaleMode = .aspectFill
                self.view?.presentScene(scene)
            }
        }
    }
}
