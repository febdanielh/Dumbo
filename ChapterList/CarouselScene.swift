//
//  CarouselScene.swift
//  Dumbo
//
//  Created by Angelica Pinonkuan on 29/06/23.
//
import SpriteKit

class CarouselScene: SKScene {
    
    private var carouselNode: SKSpriteNode!
    private var currentPageIndex = 0
    private var backButton: SKSpriteNode!
    
    var touchLocation = CGPoint()
    var isFirstPage = false
    
    private let images = ["chapter1", "chapter2", "chapter3", "chapter4", "chapter5", "chapter6", "chapter7", "chapter8", "chapter9"]
    private let spacing: CGFloat = 75.0
    
    override func didMove(to view: SKView) {
        isFirstPage = true
        setupCarousel()
    }
    
    private func setupCarousel() {
        carouselNode = SKSpriteNode()
        addChild(carouselNode)
        
        backButton = SKSpriteNode(imageNamed: "Button Back Small")
        backButton.position = CGPoint(x: frame.minX + 100 , y: frame.maxY - 60)
        backButton.zPosition = 5
        
        addChild(backButton)
        
        let carouselWidth = frame.width  //* CGFloat(images.count / 3)
        let carouselHeight = frame.height / 2
        
        carouselNode.size = CGSize(width: carouselWidth, height: carouselHeight)
        carouselNode.zPosition = 4
        carouselNode.position = CGPoint(x: -frame.width/3 + 15 , y: frame.midY - 40) //midX - carouselWidth / 9
        
        for (index, imageName) in images.enumerated() {
            let imageTexture = SKTexture(imageNamed: imageName)
            let imageNode = SKSpriteNode(texture: imageTexture)
            let xOffset = (imageNode.size.width + spacing) * CGFloat(index)
            let yOffset: CGFloat = 15
            
            imageNode.position = CGPoint(x: xOffset, y: yOffset)
            imageNode.size = CGSize(width: 240, height: 178)
            carouselNode.addChild(imageNode)
        }
    }
    
    private func moveToNextPage() {
        let nextPageIndex = currentPageIndex + 1
        
        if nextPageIndex < images.count / 3 {
            let moveAction = SKAction.moveBy(x: -frame.width, y: 0, duration: 0.5)
            carouselNode.run(moveAction)
            
            currentPageIndex = nextPageIndex
        }
    }
    
    private func moveToPreviousPage() {
        let previousPageIndex = currentPageIndex - 1
        
        if previousPageIndex >= 0 {
            let moveAction = SKAction.moveBy(x: frame.width, y: 0, duration: 0.5)
            carouselNode.run(moveAction)
            
            currentPageIndex = previousPageIndex
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //                guard let touch = touches.first else { return }
        for touch in touches {
            touchLocation = touch.location(in: self)
            
            if let desiredNode = carouselNode.children.first(where: { node in
                guard let spriteNode = node as? SKSpriteNode else {
                    return false
                }
                return spriteNode.texture?.description.contains("chapter1") == true
            }) as? SKSpriteNode {
                if isFirstPage {
                    if desiredNode.contains(touchLocation) {
                        let scene = GameScene(fileNamed: "GameScene")
                        scene!.scaleMode = .aspectFill
                        self.scene?.view?.presentScene(scene)
                        print(touchLocation)
                    } else if touchLocation.x > frame.midX {
                        moveToNextPage()
                    }
                } else {
                    if touchLocation.x > frame.midX {
                        moveToNextPage()
                    }
                    else if touchLocation.x < frame.midX {
                        moveToPreviousPage()
                    }
                }
            }
            if backButton.contains(touchLocation) {
                let scene = MainMenu(fileNamed: "MainMenu")
                scene!.scaleMode = .aspectFill
                self.scene?.view?.presentScene(scene)
                print(touchLocation)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if currentPageIndex == 0 {
            isFirstPage = true
        } else if currentPageIndex > 0 {
            isFirstPage = false
        }
    }
}


//import Foundation
//import SpriteKit
//
//class CarouselScene: SKScene {
//
//    private var carouselNode: SKNode!
//    private var currentPageIndex = 0
//    private var backButton: SKSpriteNode!
//
//    private let images = ["chapter1", "chapter2", "chapter3", "chapter4", "chapter5", "chapter6", "chapter7", "chapter8", "chapter9"]
//    private let spacing: CGFloat = 50.0
//
//    override func didMove(to view: SKView) {
//        setupCarousel()
//    }
//
//    private func setupCarousel() {
//
//        carouselNode = SKNode()
//        addChild(carouselNode)
//
////        backButton = SKSpriteNode(imageNamed: "Button Back Small")
////        backButton.position = CGPoint(x: 0, y: 20)
//
//        let carouselWidth = frame.width * CGFloat(images.count / 3)
//        let carouselHeight = frame.height
//
//        carouselNode.position = CGPoint(x: frame.midX - carouselWidth / 9 , y: frame.midY)
//
//        for (index, imageName) in images.enumerated() {
//
//            let imageNode = SKSpriteNode(imageNamed: imageName)
//            let xOffset = (imageNode.size.width + spacing) * CGFloat(index)
//            let yOffset: CGFloat = 15
//
//            imageNode.position = CGPoint(x: xOffset, y: yOffset)
//
//            imageNode.size = CGSize(width: 240, height: 178)
//            carouselNode.addChild(imageNode)
//        }
////        carouselNode.addChild(backButton)
//    }
//
//
//    private func moveToNextPage() {
//        let nextPageIndex = currentPageIndex + 1
//
//        if nextPageIndex < images.count / 3 {
//            let moveAction = SKAction.moveBy(x: -frame.width, y: 0, duration: 0.5)
//            carouselNode.run(moveAction)
//
//            currentPageIndex = nextPageIndex
//        }
//    }
//
//    private func moveToPreviousPage() {
//        let previousPageIndex = currentPageIndex - 1
//
//        if previousPageIndex >= 0 {
//            let moveAction = SKAction.moveBy(x: frame.width, y: 0, duration: 0.5)
//            carouselNode.run(moveAction)
//
//            currentPageIndex = previousPageIndex
//        }
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//
//        let touchLocation = touch.location(in: self)
//
////        if backButton.contains(touchLocation){
////            let scene = MainMenu(fileNamed: "MainMenu")
////            scene!.scaleMode = .aspectFill
////            self.scene?.view?.presentScene(scene)
////        }
////        else
//
//        if touchLocation.x > frame.midX {
//            moveToNextPage()
//        } else {
//            moveToPreviousPage()
//        }
//    }
//}
