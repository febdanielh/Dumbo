//
//  GameScene.swift
//  Dumbo
//
//  Created by Febrian Daniel on 14/06/23.
//

import SpriteKit
import GameplayKit
import Lottie
import UIKit
import SwiftUI

struct PhysicsCategory {
    static let playerCategory: UInt32 = 0x2
    static let obstacleCategory: UInt32 = 0x1
    static let groundCategory: UInt32 = 0x4
    static let boundaryCategory: UInt32 = 0x16
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var karakter: Player!
    var obstacles: Obstacle!
    var groundNode: Ground1!
    var groundNode2: Ground2!
    var groundNode3: Ground3!
    var backgroundNode: SKSpriteNode!
    
    var popUpLose: PopUpLose!
    
    var touchLocation = CGPoint()
    var startTouchPos: CGFloat!
    var karakterStartPos: CGFloat!
    var isTouched: Bool = false
    
    var cameraNode = SKCameraNode()
    var cameraMovePointPerSecond: CGFloat = 120.0
    
    var lastUpdateTime: TimeInterval = 0.0
    var dt: TimeInterval = 0.0
    
    var playableRect: CGRect {
        let ratio: CGFloat
        
        switch UIScreen.main.nativeBounds.height {
        case 2688, 1792, 2436:
            ratio = 2.16
        default:
            ratio = 16/9
        }
        
        let playableHeight = size.width
        let playableMargin = (size.height - playableHeight) / 2.0
        
        return CGRect(x: 0.0, y: playableMargin, width: size.width, height: playableHeight)
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        karakter = Player(scene: self)
        karakter.spawn()
        karakter.position = CGPoint(x: -frame.width/3, y: 0)
        
        startObstacleSpawn()
        
        groundNode = Ground1(scene: self)
        groundNode.spawn()
        groundNode.position = CGPoint(x: 375, y: -126.918)
        groundNode.size.height = groundNode.size.height
        
        groundNode2 = Ground2(scene: self)
        groundNode2.spawn()
        groundNode2.position = CGPoint(x: 375 + (groundNode.texture?.size().width)!, y: -126.918)
        
        groundNode3 = Ground3(scene: self)
        groundNode3.spawn()
        groundNode3.position = CGPoint(x: 375 + (groundNode.texture?.size().width)! + (groundNode2.texture?.size().width)!, y: -126.918)
        
        createBG()
    }
    
    func startObstacleSpawn() {
        let spawnAction = SKAction.run {
            let obstacle = Obstacle()
            obstacle.spawn(in: self)
        }
        
        let waitAction = SKAction.wait(forDuration: 4.0)
        
        let spawnSequence = SKAction.sequence([spawnAction, waitAction])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        
        run(spawnForever, withKey: "spawnObstacles")
    }
    
    func createBG() {
        
        for i in 0...18 {
            let textureName = "background-\(i+1)"
            let backgroundTexture = SKTexture(imageNamed: textureName)
            backgroundNode = SKSpriteNode(texture: backgroundTexture)
            backgroundNode.name = "Background"
            backgroundNode.position = CGPoint(x: CGFloat(i) * backgroundNode.frame.width, y: 0)
            backgroundNode.zPosition = -1.0
            addChild(backgroundNode)
            
            let moveDirection = backgroundTexture.size().width
            
            let moveLeft = SKAction.moveBy(x: CGFloat(-moveDirection), y: 0, duration: 20)
            //            let moveReset = SKAction.moveBy(x: moveDirection, y: 0, duration: 0)
            //            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLeft)
            
            backgroundNode.run(moveForever)
            
            print(backgroundNode.position)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategory.playerCategory | PhysicsCategory.groundCategory {
            // Collision between player and obstacle detected
            if let player = contact.bodyA.node as? SKSpriteNode {
                player.removeFromParent()
                popUpLose = PopUpLose(scene: self)
                print("game over")
            } else if let obstacle = contact.bodyB.node as? SKSpriteNode {
                
            }
            // Handle any other collision-related logic
        } else if contactMask == PhysicsCategory.playerCategory | PhysicsCategory.obstacleCategory {
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            touchLocation = touch.location(in: self)
            startTouchPos = touchLocation.y
            karakterStartPos = karakter.position.y
        }
        isTouched = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        var endTouchPos: CGFloat
        var offset: CGFloat
        
        for touch in touches {
            touchLocation = touch.location(in: self)
            endTouchPos = touchLocation.y
            offset = endTouchPos - startTouchPos
            karakter.position.y = karakterStartPos + offset
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        startTouchPos = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isTouched == true {
            if lastUpdateTime > 0 {
                dt = currentTime - lastUpdateTime
            } else {
                dt = 0
            }
            lastUpdateTime = currentTime
            cameraMovePointPerSecond += 0.0001
            
            groundNode.moveGround(deltaTime: dt, cameraMovePerSecond: cameraMovePointPerSecond)
            groundNode2.moveGround(deltaTime: dt, cameraMovePerSecond: cameraMovePointPerSecond)
            groundNode3.moveGround(deltaTime: dt, cameraMovePerSecond: cameraMovePointPerSecond)
            
        }
    }
}
