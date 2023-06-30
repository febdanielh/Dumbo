//
//  MainMenu.swift
//  Dumbo
//
//  Created by Febrian Daniel on 26/06/23.
//

import Foundation
import SpriteKit
import AVFoundation

class MainMenu: SKScene {
    
    var playButton: SKSpriteNode!
    var chapterList: SKSpriteNode!
    var book: SKSpriteNode!
    
    var playButtonSoundURL = NSURL(fileURLWithPath:Bundle.main.path(forResource: "Play Button Sound", ofType: "mp3")!)
    var audioPlayer = AVAudioPlayer()

    func playButtonSound(){
        guard let soundToPlay = try? AVAudioPlayer(contentsOf: playButtonSoundURL as URL) else {
            fatalError("Failed to initialize the audio player with asset: \(playButtonSoundURL)")
        }
        soundToPlay.prepareToPlay()
        self.audioPlayer = soundToPlay
        self.audioPlayer.play()
    }
    
    override func didMove(to view: SKView) {
        let mainSound = SKAudioNode(fileNamed: "Main Menu Sound")
        addChild(mainSound)
        
        playButton = SKSpriteNode(imageNamed: "Button Play")
        playButton.position = CGPoint(x: -120, y: -94)
        
        chapterList = SKSpriteNode(imageNamed: "Button Chapter List - Sec")
        chapterList.position = CGPoint(x: 120, y: -94)
//        chapterList.isUserInteractionEnabled = false
        
        book = SKSpriteNode(imageNamed: "Icon Book - Sec")
        book.position = CGPoint(x: -375, y: 150)
        
        // Check if the user is an existing user
        let existingUser = UserDefaults.standard.bool(forKey: "ExistingUser")
        
        if existingUser {
            // Set new textures for existing users
            chapterList.texture = SKTexture(imageNamed: "Button Chapter List - Prim")
            book.texture = SKTexture(imageNamed: "Icon Book - Prim")
            
            // Enable the chapterList and book buttons for existing users
//            chapterList.isUserInteractionEnabled = true
//            book.isUserInteractionEnabled = true
            
            print("existing user")
        }
        else{
//            book.isUserInteractionEnabled = false
            print("new user")
        }
        
        addChild(playButton)
        addChild(chapterList)
        addChild(book)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            let existingUser = UserDefaults.standard.bool(forKey: "ExistingUser")
            
            if chapterList.contains(location) {
                let scene = CarouselScene(fileNamed: "CarouselScene")
                scene!.scaleMode = .aspectFill
                self.view?.presentScene(scene)
            }
            
            if playButton.contains(location) {
                if existingUser {
                    playButtonSound()
                    let scene = GameScene(fileNamed: "GameScene")
                    scene!.scaleMode = .aspectFill
                    self.view?.presentScene(scene)
                }
                else {
                    playButtonSound()
                    let scene = InitialStory(fileNamed: "InitialStory")
                    scene!.scaleMode = .aspectFill
                    self.view?.presentScene(scene)
                }
            }
            if existingUser {
                if book.contains(location) {
                    let scene = InitialStory(fileNamed: "InitialStory")
                    scene!.scaleMode = .aspectFill
                    self.view?.presentScene(scene)
                }
                
                                  
            }
        }
    }
}
