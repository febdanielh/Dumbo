//
//  InitialStory.swift
//  Dumbo
//
//  Created by Khadijah Rizqy on 28/06/23.
//

import Foundation
import SpriteKit
import AVFoundation

class InitialStory: SKScene {
    
    var closeButton: SKSpriteNode!
    var skipButton: SKSpriteNode!
    
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
            
            let existingUser = UserDefaults.standard.bool(forKey: "ExistingUser")
            
            if existingUser {
                if closeButton.contains(location) {
                    let scene = MainMenu(fileNamed: "MainMenu")
                    scene!.scaleMode = .aspectFill
                    scene!.selectedButtonSound()
                    self.view?.presentScene(scene)
                }
            } else {
                if skipButton.contains(location) {
                    let scene = GameScene(fileNamed: "GameScene")
                    scene!.scaleMode = .aspectFill
                    scene!.playButtonSound()
                    self.view?.presentScene(scene)
                }
            }
        }
    }
}
