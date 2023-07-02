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
    private var imageNodeClickable: Bool = false
    
    var touchLocation = CGPoint()
    var isFirstPage = false
    
    private let images = ["dummychapter", "chapter0","chapter1", "chapter2", "chapter3", "chapter4", "chapter5", "chapter6", "chapter7", "chapter8"]
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
        
        var xOffset: CGFloat = 0.0
        for (index, imageName) in images.enumerated() {
            let imageTexture = SKTexture(imageNamed: imageName)
            let imageNode = SKSpriteNode(texture: imageTexture)
            
            let yOffset: CGFloat = 15
            
            if index == 0 {
                imageNode.position = CGPoint(x: -300, y: yOffset)
            } else if index == 1 {
                imageNode.position = CGPoint(x: xOffset, y: yOffset)
            } else {
                xOffset += imageNode.size.width + spacing
                imageNode.position = CGPoint(x: xOffset, y: yOffset)
            }
            
            imageNode.name = imageName
            imageNode.size = CGSize(width: 240, height: 178)
            
            print(imageNode.name)
            print(index)
            print(imageNode.position)
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
        for touch in touches {
            
            touchLocation = touch.location(in: self)
            
            print(touchLocation)
            
            for node in carouselNode.children {
                if let imageNode = node as? SKSpriteNode {
                    if imageNode.contains(touchLocation) {
                        if currentPageIndex == 0 &&  carouselNode.children.firstIndex(of: imageNode) == 0 {
                            print("\(imageNode.name)")
                            let scene = GameScene(fileNamed: "GameScene")
                            scene!.scaleMode = .aspectFill
                            self.scene?.view?.presentScene(scene)
                            print("First node is touched.")
                        } else {
                            print("\(imageNode.name) node is touched.")
                        }
                        break
                    }
                }
            }
                       
            
            if touchLocation.x > frame.midX {
                moveToNextPage()
            }
            else if touchLocation.x < frame.midX {
                moveToPreviousPage()
            }
            
            if backButton.contains(touchLocation) {
                let scene = MainMenu(fileNamed: "MainMenu")
                scene!.scaleMode = .aspectFill
                self.scene?.view?.presentScene(scene)
                print(touchLocation)
            }
            

        }
    }
}

//            if let chapter1 = carouselNode.children.first{
//                let scene = GameScene(fileNamed: "GameScene")
//                scene!.scaleMode = .aspectFill
//                self.scene?.view?.presentScene(scene)
//            }




//            if let desiredNode = carouselNode.children.first(where: { node in
//                guard let spriteNode = node as? SKSpriteNode,
//                      let nodeName = spriteNode.name,
//                      nodeName == "chapter0" else {
//                    return false
//                }
//                return true
//            }) as? SKSpriteNode {
//
////            if let desiredNode = carouselNode.childNode(withName: "chapter0") {
//                if isFirstPage {
//                    if desiredNode.contains(touchLocation) {
//                        let scene = GameScene(fileNamed: "GameScene")
//                        scene!.scaleMode = .aspectFill
//                        self.scene?.view?.presentScene(scene)
//                        print(desiredNode.name)
//                    } else if touchLocation.x > frame.midX {
//                        moveToNextPage()
//                    }
//                } else {
//                    if touchLocation.x > frame.midX {
//                        moveToNextPage()
//                    }
//                    else if touchLocation.x < frame.midX {
//                        moveToPreviousPage()
//                    }
//                }
//            }
