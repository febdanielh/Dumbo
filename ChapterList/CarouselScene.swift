//
//  CarouselScene.swift
//  Dumbo
//
//  Created by Angelica Pinonkuan on 29/06/23.
//

import Foundation
import SpriteKit

class CarouselScene: SKScene {
    
    var backButton: SKSpriteNode!
    var carouselContainer: SKCropNode!
    var slideContainer: SKSpriteNode!
    
    let slideCount = 3
    let slideWidth: CGFloat = UIScreen.main.bounds.width - 300
    
    override func didMove(to view: SKView) {
        backButton = SKSpriteNode(imageNamed: "Button Back Small")
        backButton.position = CGPoint(x: -192, y: 50)

        carouselContainer = SKCropNode()
        carouselContainer.maskNode = SKSpriteNode(color: .white, size: self.size) // Use scene's visible frame as the mask
        
        slideContainer = SKSpriteNode()
        slideContainer.size = CGSize(width: slideCount * Int(slideWidth), height: Int(size.height))
        
        for i in 0..<slideCount {
            let slideNode = createSlide(at: i)
            slideNode.position.x = CGFloat(i) * slideWidth
            slideContainer.addChild(slideNode)
        }
        
        carouselContainer.addChild(slideContainer)
        addChild(carouselContainer)
        addChild(backButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if backButton.contains(location) {
                let scene = MainMenu(fileNamed: "MainMenu")
                scene!.scaleMode = .aspectFill
                self.view?.presentScene(scene)
            }
        }
    }
    
    func createSlide(at index: Int) -> SKSpriteNode {
        let slideNode = SKSpriteNode(color: .clear, size: CGSize(width: slideWidth/10, height: size.height/10))
        
        let imageName = "chapter\(index + 1)"
        let imageNode = SKSpriteNode(imageNamed: imageName)
        imageNode.position = CGPoint(x: slideNode.size.width / 8, y: slideNode.size.height / 2)
        imageNode.size = CGSize(width: 204, height: 178)
        
        slideNode.addChild(imageNode)
        
        return slideNode
    }
}
