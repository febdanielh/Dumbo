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

struct PhysicsCategory {
    static let playerCategory: UInt32 = 0x2
    static let obstacleCategory: UInt32 = 0x1
    static let groundCategory: UInt32 = 0x4
    static let boundaryCategory: UInt32 = 0x16
    static let invisNodeCategory: UInt32 = 0x8
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var stageOneSound: SKAudioNode!
    var swimSound: SKAudioNode!
    
    var karakter: Player!
    var obstacles: Obstacle!
    
    var groundNode: Ground1!
    var groundNode2: Ground2!
    var groundNode3: Ground3!
    var groundNode4: Ground4!
    var groundNode5: Ground5!
    
    var groundNodes: [SKSpriteNode] = []
    
    var backgroundNode: SKSpriteNode!
    var invisNode: InvisibleNode!
    
    var popUpLose: PopUpLose!
    var popUpWin: PopUpWin!
    var popUpPause: PopUpPause!
    var menuButton: MenuButton!
    var retryButton: RetryButton!
    var nextButton: NextButton!
    
    var touchLocation = CGPoint()
    var startTouchPos: CGFloat!
    var karakterStartPos: CGFloat!
    
    var isTouched: Bool = false
    var isGameOver: Bool = false
    var isGameWin: Bool = false
    var isInitialTouch: Bool = true
    var popUpAppeared: Bool = false
    
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
        //
        if let stageOneSoundURL = Bundle.main.url(forResource: "Stage 1 Sound", withExtension: "mp3") {
            stageOneSound = SKAudioNode(url: stageOneSoundURL)
            addChild(stageOneSound)
        }
        
        
        physicsWorld.contactDelegate = self
        
        karakter = Player(scene: self)
        karakter.spawn()
        karakter.position = CGPoint(x: -frame.width/3, y: 0)
        
        spawnGrounds()
        createBG()
    }
    
    func startObstacleSpawn() {
        let spawnAction = SKAction.run {
            let obstacle = Obstacle()
            obstacle.spawn(in: self)
        }
        
        let waitAction = SKAction.wait(forDuration: 3.0)
        
        let spawnSequence = SKAction.sequence([spawnAction, waitAction])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        
        run(spawnForever, withKey: "spawnObstacles")
    }
    
    func stopObstacleSpawn() {
        removeAction(forKey: "spawnObstacles")
    }
    
    func createBG() {
        for i in 0...18 {
            let textureName = "bg-\(i+1)"
            let backgroundTexture = SKTexture(imageNamed: textureName)
            backgroundNode = SKSpriteNode(texture: backgroundTexture)
            backgroundNode.name = "Background"
            backgroundNode.position = CGPoint(x: CGFloat(i) * backgroundNode.frame.width, y: 0)
            backgroundNode.zPosition = -1.0
            addChild(backgroundNode)
            
            print(backgroundNode.position)
        }
    }
    
    func stopBackgroundMovement() {
        enumerateChildNodes(withName: "Background") { (node, _) in
            node.removeAction(forKey: "MoveBackground")
        }
    }
    
    func startBackgroundMovement() {
        let moveDirection = backgroundNode.texture!.size().width
        let moveLeft = SKAction.moveBy(x: CGFloat(-moveDirection), y: 0, duration: 20)
        let moveForever = SKAction.repeatForever(moveLeft)
        
        enumerateChildNodes(withName: "Background") { (node, _) in
            node.run(moveForever, withKey: "MoveBackground")
        }
    }
    
    func spawnGrounds() {
        
        groundNode = Ground1(scene: self)
        groundNode.spawn()
        groundNode2 = Ground2(scene: self)
        groundNode2.spawn()
        groundNode3 = Ground3(scene: self)
        groundNode3.spawn()
        groundNode4 = Ground4(scene: self)
        groundNode4.spawn()
        groundNode5 = Ground5(scene: self)
        groundNode5.spawn()
        
        groundNodes.append(groundNode)
        groundNodes.append(groundNode2)
        groundNodes.append(groundNode3)
        groundNodes.append(groundNode4)
        groundNodes.append(groundNode5)
        
        var previousGroundNode: SKSpriteNode?
        let initialXPosition: CGFloat = 375
        let groundNodeYPosition: CGFloat = -126.918
        
        // Loop through the ground nodes and set their positions
        for groundNode in groundNodes {
            if let previousNode = previousGroundNode {
                groundNode.position = CGPoint(x: previousNode.position.x + previousNode.size.width, y: groundNodeYPosition)
            } else {
                groundNode.position = CGPoint(x: initialXPosition, y: groundNodeYPosition)
            }
            
            addChild(groundNode)
            
            previousGroundNode = groundNode
        }
        // Set the position of the invisible node after all the ground nodes
        if let lastGroundNode = groundNodes.last {
            invisNode = InvisibleNode(scene: self)
            invisNode.spawn()
            invisNode.position = CGPoint(x: lastGroundNode.position.x + lastGroundNode.size.width, y: 0)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategory.playerCategory | PhysicsCategory.groundCategory {
            // Collision between player and ground detected
            if let player = contact.bodyA.node as? SKSpriteNode {
                player.removeFromParent()
                
                isInitialTouch = true
                stopBackgroundMovement()
                stopObstacleSpawn()
                
                isGameOver = true
                isTouched = false
                
                popUpLose = PopUpLose(scene: self)
                
                menuButton = MenuButton(scene: self)
                menuButton.position = CGPoint(x: -80, y: -31)
                
                retryButton = RetryButton(scene: self)
                retryButton.position = CGPoint(x: 80, y: -31)
                
                stageOneSound.run(SKAction.stop())
                print("game over")
                
            } else if let obstacle = contact.bodyB.node as? SKSpriteNode {
                
            }
            // Handle any other collision-related logic
        } else if contactMask == PhysicsCategory.playerCategory | PhysicsCategory.obstacleCategory {
            // Collision between player and obstacle detected
            if let player = contact.bodyA.node as? SKSpriteNode {
                player.removeFromParent()
                
                isInitialTouch = true
                stopBackgroundMovement()
                stopObstacleSpawn()
                
                isGameOver = true
                isTouched = false
                
                popUpLose = PopUpLose(scene: self)
                
                menuButton = MenuButton(scene: self)
                menuButton.position = CGPoint(x: -80, y: -31)
                
                retryButton = RetryButton(scene: self)
                retryButton.position = CGPoint(x: 80, y: -31)
                
                stageOneSound.run(SKAction.stop())
                print("game over")
            }
            
        } else if contactMask == PhysicsCategory.playerCategory | PhysicsCategory.invisNodeCategory {
            isInitialTouch = true
            stopBackgroundMovement()
            stopObstacleSpawn()
            karakter.movePlayer()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            touchLocation = touch.location(in: self)
            startTouchPos = touchLocation.y
            karakterStartPos = karakter.position.y
            
            if isGameOver == true {
                popUpAppeared = true
                if menuButton.contains(touchLocation) {
                    let scene = MainMenu(fileNamed: "MainMenu")
                    scene!.scaleMode = .aspectFill
                    self.scene?.view?.presentScene(scene)
                } else if retryButton.contains(touchLocation) {
                    let scene = GameScene(fileNamed: "GameScene")
                    scene!.scaleMode = .aspectFill
                    self.scene?.view?.presentScene(scene)
                }
            } else if isGameWin == true {
                popUpAppeared = true
                if menuButton.contains(touchLocation) {
                    let scene = MainMenu(fileNamed: "MainMenu")
                    scene!.scaleMode = .aspectFill
                    self.scene?.view?.presentScene(scene)
                } else if nextButton.contains(touchLocation) {
                    let scene = MainMenu(fileNamed: "MainMenu")
                    scene!.scaleMode = .aspectFill
                    self.scene?.view?.presentScene(scene)
                }
            }
        }
        
        if popUpAppeared == true {
            guard isInitialTouch else {
                return
            }
            
            isInitialTouch = true
        } else {
            guard isInitialTouch else {
                return
            }
            isInitialTouch = false
            startBackgroundMovement()
            startObstacleSpawn()
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
        //        isTouched = true
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isInitialTouch == false {
            if lastUpdateTime > 0 {
                dt = currentTime - lastUpdateTime
            } else {
                dt = 0
            }
            lastUpdateTime = currentTime
            cameraMovePointPerSecond += 0.02
            
            groundNode.moveGround(deltaTime: dt, cameraMovePerSecond: cameraMovePointPerSecond)
            groundNode2.moveGround(deltaTime: dt, cameraMovePerSecond: cameraMovePointPerSecond)
            groundNode3.moveGround(deltaTime: dt, cameraMovePerSecond: cameraMovePointPerSecond)
            groundNode4.moveGround(deltaTime: dt, cameraMovePerSecond: cameraMovePointPerSecond)
            groundNode5.moveGround(deltaTime: dt, cameraMovePerSecond: cameraMovePointPerSecond)
            invisNode.moveNode(deltaTime: dt, cameraMovePerSecond: cameraMovePointPerSecond)
        }
        
        if karakter.position.x > frame.size.width {
            isGameWin = true
            
            popUpWin = PopUpWin(scene: self)
            
            menuButton = MenuButton(scene: self)
            menuButton.position = CGPoint(x: -80, y: -31)
            
            nextButton = NextButton(scene: self)
            nextButton.position = CGPoint(x: 80, y: -31)
            
            print("win game")
        }
    }
}
