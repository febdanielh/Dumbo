//
//  GameScene.swift
//  Dumbo
//
//  Created by Febrian Daniel on 14/06/23.
//

import SpriteKit
import GameplayKit
import AVFoundation

struct PhysicsCategory {
    static let playerCategory: UInt32 = 0x2
    static let obstacleCategory: UInt32 = 0x1
    static let groundCategory: UInt32 = 0x4
    static let boundaryCategory: UInt32 = 0x16
    static let invisNodeCategory: UInt32 = 0x8
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var dragUpTutorial: DragUpTutorial!
    var dragDownTutorial: DragDownTutorial!
    
    var stageOneSound: SKAudioNode!
    var swimSound: SKAudioNode!
    var winSound: SKAudioNode!
    var loseSound: SKAudioNode!
    
    var karakter: Player!
    var karakterDead: PlayerDead!
    var obstacles: Obstacle!
    
    var groundNode: Ground1!
    var groundNode2: Ground2!
    var groundNode3: Ground3!
    var groundNode4: Ground4!
    var groundNode5: Ground5!
    
    var groundNodes: [SKSpriteNode] = []
    
    var backgroundNode: SKSpriteNode!
    var invisNode: InvisibleNode!
    var shaderNode: ShaderNode!
    
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
    var isAnimated: Bool = false
    
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
        
//        self.alpha = 0 // Set the initial alpha value to 0 (fully transparent)
//        let fadeInAction = SKAction.fadeIn(withDuration: 0.5) // Fade in action with a duration of 0.5seconds
//        self.run(fadeInAction) // Run the fade in action on the GameScene node

        // Play Background Music
        if let stageOneSoundURL = Bundle.main.url(forResource: "Stage 1 Sound", withExtension: "mp3") {
            stageOneSound = SKAudioNode(url: stageOneSoundURL)
            addChild(stageOneSound)
        }
        // Play Swim Music
        if let swimSoundURL = Bundle.main.url(forResource: "SwimSound", withExtension: "mp3") {
            swimSound = SKAudioNode(url: swimSoundURL)
            addChild(swimSound)
        }
        
        let existingUser = UserDefaults.standard.bool(forKey: "ExistingUser")
        
        physicsWorld.contactDelegate = self
        
        karakter = Player(scene: self)
        karakter.spawn()
        karakter.position = CGPoint(x: -frame.width/3, y: 0)
        
        spawnGrounds()
        createBG()
        
        if existingUser {
            print("existing user")
        } else {
            shaderNode = ShaderNode(scene: self)
            
            dragUpTutorial = DragUpTutorial(scene:self)
            dragUpTutorial.position = CGPoint(x: -frame.width/3, y: 100)
            
            dragDownTutorial = DragDownTutorial(scene:self)
            dragDownTutorial.position = CGPoint(x: -frame.width/3, y: -100)
            print("new user")
        }
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
            invisNode.position = CGPoint(x: lastGroundNode.position.x + lastGroundNode.size.width + 5, y: 0)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        // Play Lose Music
        if let loseSoundURL = Bundle.main.url(forResource: "Lose Sound", withExtension: "mp3") {
            loseSound = SKAudioNode(url: loseSoundURL)
            loseSound.autoplayLooped = false
            addChild(loseSound)
        }
        
        if contactMask == PhysicsCategory.playerCategory | PhysicsCategory.groundCategory {
            // Collision between player and ground detected
            if let player = contact.bodyA.node as? SKSpriteNode {
                let deadPos = player.position
                player.removeFromParent()
                
                isInitialTouch = true
                stopBackgroundMovement()
                stopObstacleSpawn()
                
                karakterDead = PlayerDead(scene: self, completion: {
                    self.shaderNode = ShaderNode(scene: self)
                    self.popUpLose = PopUpLose(scene: self)
                    
                    self.menuButton = MenuButton(scene: self)
                    self.menuButton.position = CGPoint(x: -80, y: -31)
                    
                    self.retryButton = RetryButton(scene: self)
                    self.retryButton.position = CGPoint(x: 80, y: -31)
                })
                karakterDead.position = deadPos
                
                isGameOver = true
                
                stageOneSound.run(SKAction.stop())
                swimSound.run(SKAction.stop())
                loseSound.run(SKAction.play())
                print("game over")
            }
            
        } else if contactMask == PhysicsCategory.playerCategory | PhysicsCategory.obstacleCategory {
            // Collision between player and obstacle detected
            if let player = contact.bodyA.node as? SKSpriteNode {
                let deadPos = player.position
                player.removeFromParent()
                
                isInitialTouch = true
                stopBackgroundMovement()
                stopObstacleSpawn()
                
                karakterDead = PlayerDead(scene: self, completion: {
                    self.shaderNode = ShaderNode(scene: self)
                    self.popUpLose = PopUpLose(scene: self)
                    
                    self.menuButton = MenuButton(scene: self)
                    self.menuButton.position = CGPoint(x: -80, y: -31)
                    
                    self.retryButton = RetryButton(scene: self)
                    self.retryButton.position = CGPoint(x: 80, y: -31)
                })
                karakterDead.position = deadPos
                
                isGameOver = true
                
                stageOneSound.run(SKAction.stop())
                swimSound.run(SKAction.stop())
                loseSound.run(SKAction.play())
                print("game over")
            }
            
        } else if contactMask == PhysicsCategory.playerCategory | PhysicsCategory.invisNodeCategory {
            isTouched = true
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
                if menuButton != nil && menuButton.contains(touchLocation) {
                    UserDefaults.standard.set(true, forKey: "ExistingUser")
                    UserDefaults.standard.synchronize()

                    if let scene = MainMenu(fileNamed: "MainMenu") {
                        scene.scaleMode = .aspectFill
                        let transition = SKTransition.fade(withDuration: 2.5)
                        scene.selectedButtonSound()
                        self.scene?.view?.presentScene(scene, transition: transition)
                    }
                    
                } else if retryButton != nil && retryButton.contains(touchLocation) {
                    UserDefaults.standard.set(true, forKey: "ExistingUser")
                    UserDefaults.standard.synchronize()

                    if let scene = GameScene(fileNamed: "GameScene") {
                        scene.scaleMode = .aspectFill
                        let transition = SKTransition.fade(withDuration: 2.5)
                        scene.playButtonSound()
                        self.scene?.view?.presentScene(scene, transition: transition)
                    }
                }
            } else if isGameWin == true {
                popUpAppeared = true
                if menuButton.contains(touchLocation) {
                    UserDefaults.standard.set(true, forKey: "ExistingUser")
                    UserDefaults.standard.synchronize()

                    if let scene = MainMenu(fileNamed: "MainMenu") {
                        scene.scaleMode = .aspectFill
                        let transition = SKTransition.fade(withDuration: 2.5)
                        scene.selectedButtonSound()
                        self.scene?.view?.presentScene(scene, transition: transition)
                    }
                    
                } else if nextButton.contains(touchLocation) {
                    UserDefaults.standard.set(true, forKey: "ExistingUser")
                    UserDefaults.standard.synchronize()

                    if let scene = MainMenu(fileNamed: "MainMenu") {
                        scene.scaleMode = .aspectFill
                        let transition = SKTransition.fade(withDuration: 2.5)
                        scene.playButtonSound()
                        self.scene?.view?.presentScene(scene, transition: transition)
                    }
                }
            }
        }
        
        if popUpAppeared || isTouched {
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
            if shaderNode != nil {
                shaderNode.removeFromParent()
            }
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
        
        if karakter.position.x > frame.size.width && !isGameWin {
            if let winSoundURL = Bundle.main.url(forResource: "Win Sound", withExtension: "mp3") {
                winSound = SKAudioNode(url: winSoundURL)
                winSound.autoplayLooped = false
                addChild(winSound)
            }
            
            isGameWin = true
            
            popUpWin = PopUpWin(scene: self)
            menuButton = MenuButton(scene: self)
            menuButton.position = CGPoint(x: -80, y: -31)
            nextButton = NextButton(scene: self)
            nextButton.position = CGPoint(x: 80, y: -31)
            
            stageOneSound.run(SKAction.stop())
            swimSound.run(SKAction.stop())
            winSound.run(SKAction.play())
            print("win game")
        }
    }
}
