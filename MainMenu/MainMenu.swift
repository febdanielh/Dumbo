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
    
    // Button Sound Handler
    var playButtonSoundURL = NSURL(fileURLWithPath:Bundle.main.path(forResource: "Play Button Sound", ofType: "mp3")!)
    var selectedButtonSoundURL = NSURL(fileURLWithPath:Bundle.main.path(forResource: "Selected Button Sound", ofType: "mp3")!)
    var playAudioPlayer = AVAudioPlayer()
    var selectedAudioPlayer = AVAudioPlayer()

    func playButtonSound(){
        guard let playButtonSound = try? AVAudioPlayer(contentsOf: playButtonSoundURL as URL) else {
            fatalError("Failed to initialize the audio player with asset: \(playButtonSoundURL)")
        }
        playButtonSound.prepareToPlay()
        self.playAudioPlayer = playButtonSound
        self.playAudioPlayer.play()
    }
    
    func selectedButtonSound(){
        guard let selectedButtonSound = try? AVAudioPlayer(contentsOf: selectedButtonSoundURL as URL) else {
            fatalError("Failed to initialize the audio player with asset: \(selectedButtonSoundURL)")
        }
        selectedButtonSound.prepareToPlay()
        self.selectedAudioPlayer = selectedButtonSound
        self.selectedAudioPlayer.play()
    }
    
    override func didMove(to view: SKView) {
        let mainSound = SKAudioNode(fileNamed: "Main Menu Sound")
        addChild(mainSound)
        
        playButton = SKSpriteNode(imageNamed: "Button Play")
        playButton.position = CGPoint(x: -120, y: -94)
        
        chapterList = SKSpriteNode(imageNamed: "Button Chapter List - Sec")
        chapterList.position = CGPoint(x: 120, y: -94)
        chapterList.isUserInteractionEnabled = false
        
        book = SKSpriteNode(imageNamed: "Icon Book - Sec")
        book.position = CGPoint(x: -375, y: 150)
        book.isUserInteractionEnabled = false
        
        // Check if the user is an existing user
        let existingUser = UserDefaults.standard.bool(forKey: "ExistingUser")
        if existingUser {
            // Set new textures for existing users
            chapterList.texture = SKTexture(imageNamed: "Button Chapter List - Prim")
            book.texture = SKTexture(imageNamed: "Icon Book - Prim")
            
            // Enable the chapterList and book buttons for existing users
            chapterList.isUserInteractionEnabled = true
            book.isUserInteractionEnabled = true
            
            print("existing user")
        }
        else{
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
            if playButton.contains(location) {
                if existingUser {
                    let scene = GameScene(fileNamed: "GameScene")
                    scene!.scaleMode = .aspectFill
                    scene!.playButtonSound()
                    self.view?.presentScene(scene)
                }
                else {
                    let scene = InitialStory(fileNamed: "InitialStory")
                    scene!.scaleMode = .aspectFill
                    scene!.playButtonSound()
                    self.view?.presentScene(scene)
                }
            }
        }
    }
}
