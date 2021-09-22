//
//  WhackSlot.swift
//  Project 14
//
//  Created by Alvaro Orellana on 19-09-21.
//

import SpriteKit

class WhackSlot: SKNode {

    var charcterNode: SKSpriteNode!

    
    func configure(at position: CGPoint) {
        self.position = position
        
        createWholeSprite()
        
        // Crop node only crops things inside it
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = nil//SKSpriteNode(imageNamed: "whackMask")

        charcterNode = SKSpriteNode(imageNamed: "penguinGood")
        charcterNode.position = CGPoint(x: 0, y: -90)
        charcterNode.name = "character"
        // The crop node contains the character
        cropNode.addChild(charcterNode)

        addChild(cropNode)
    }
    
    
    private func createWholeSprite() {
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
    }
}
