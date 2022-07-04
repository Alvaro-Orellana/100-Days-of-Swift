//
//  WhackSlot.swift
//  Project 14
//
//  Created by Alvaro Orellana on 19-09-21.
//

import SpriteKit

class WhackSlot: SKNode {

    var charcterNode: SKSpriteNode!
    var isVisible = false
    var isHit = false
 
    
    func configure(at position: CGPoint) {
        self.position = position
        
        createSprite(named: "whackHole")
        setupCharecterNode()
        
        let cropNode = createCropNode()
        cropNode.addChild(charcterNode)
        addChild(cropNode)
    }
    
    
    private func createSprite(named spriteName: String) {
        let sprite = SKSpriteNode(imageNamed: spriteName)
        addChild(sprite)
    }
    
    private func setupCharecterNode() {
        charcterNode = SKSpriteNode(imageNamed: "penguinGood")
        charcterNode.position = CGPoint(x: 0, y: -90)
        charcterNode.name = "character"
    }
    
    private func createCropNode() -> SKCropNode {
        // Crop node only crops things inside it
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        return cropNode
    }
    
    func show(hideTime: Double)  {
        // Try playing with this. what happens if i remove it
        // do penguins keep moving up?
        guard !isVisible else { return }
        
        charcterNode.xScale = 1
        charcterNode.yScale = 1

        charcterNode.run(.moveBy(x: 0, y: 80, duration: 0.05))
        isVisible = true
        isHit = false

        if Int.random(in: 0...2) == 0 {
            // 1/3 it'll be a good penguin
            charcterNode.texture = SKTexture(imageNamed: "penguinGood")
            charcterNode.name = "charFriend"
        } else {
            // 2/3 it'll be a evil penguin
            charcterNode.texture = SKTexture(imageNamed: "penguinEvil")
            charcterNode.name = "charEnemy"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [weak self] in
            self?.hide()
        }
    }
    
    func hide() {
        guard isVisible else { return }

        charcterNode.run(.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
    }
    
    func hit() {
        isHit = false
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run { [weak self] in self?.isVisible = false }
        let sequence = SKAction.sequence([delay, hide, notVisible])
        
        charcterNode.run(sequence)
    }
}
