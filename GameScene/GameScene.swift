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
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var karakter: Player!
    var obstacles: Obstacle!
    var groundNode: Ground1!
    var groundNode2: Ground2!
    var groundNode3: Ground3!
    var backgroundNode: SKSpriteNode!
    
    var touchLocation = CGPoint()
    var startTouchPos: CGFloat!
    var karakterStartPos: CGFloat!
    
    var cameraNode = SKCameraNode()
    var cameraMovePointPerSecond: CGFloat = 140.0
    
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
    
    //    let obstacleType1Category: UInt32 = 0x2 << 1
    //    let obstacleType2Category: UInt32 = 0x2 << 2
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        karakter = Player(scene: self)
        karakter.spawn()
        karakter.position = CGPoint(x: -frame.width/3, y: 0)
        
        startObstacleSpawn()
        
        groundNode = Ground1(scene: self)
        groundNode.spawn()
        groundNode.position = CGPoint(x: 375, y: -126.918)
        groundNode.size.height = groundNode.size.height + 50
        
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
        
        let backgroundTexture = SKTexture(imageNamed: "bg")
        
        for i in 0...2 {
            backgroundNode = SKSpriteNode(imageNamed: "background-1")
            backgroundNode.name = "Background"
            backgroundNode.position = CGPoint(x: CGFloat(i) * backgroundNode.frame.width, y: 0)
            backgroundNode.zPosition = -1.0
            addChild(backgroundNode)
            
            let moveLeft = SKAction.moveBy(x: -backgroundTexture.size().width, y: 0, duration: 20)
            let moveReset = SKAction.moveBy(x: backgroundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            backgroundNode.run(moveForever)
            print(backgroundNode.position)
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategory.playerCategory | PhysicsCategory.groundCategory {
            // Collision between player and obstacle detected
            if let obstacle = contact.bodyA.node as? SKSpriteNode {
                karakter.removeFromParent()
                print("game over")
            } else if let obstacle = contact.bodyB.node as? SKSpriteNode {
                //                obstacle.removeFromParent()
            }
            
            // Handle any other collision-related logic
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            touchLocation = touch.location(in: self)
            startTouchPos = touchLocation.y
            karakterStartPos = karakter.position.y
        }
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
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        
        lastUpdateTime = currentTime
        groundNode.moveGround(deltaTime: dt, cameraMovePerSecond: cameraMovePointPerSecond)
        groundNode2.moveGround(deltaTime: dt, cameraMovePerSecond: cameraMovePointPerSecond)
        groundNode3.moveGround(deltaTime: dt, cameraMovePerSecond: cameraMovePointPerSecond)
    }
}
