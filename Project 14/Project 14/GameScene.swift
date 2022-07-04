//
//  GameScene.swift
//  Project 14
//
//  Created by Alvaro Orellana on 19-09-21.
//

import SpriteKit

class GameScene: SKScene {
   
    var slots = [WhackSlot]()
    var gameScore: SKLabelNode!
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    var popupTime = 0.85

     
    override func didMove(to view: SKView) {
        configureBackground()
        configureGameScore()
        createSlots()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.createEnemy()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            
            guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
            if !whackSlot.isVisible { continue }
            if whackSlot.isHit { continue }
            
            whackSlot.hit()
            
            if node.name == "charFriend" {
                // they shouldn't have whacked this penguin
                score -= 5

                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
            } else if node.name == "charEnemy" {
                // they should have whacked this one
                score += 1

                whackSlot.charcterNode.xScale = 0.85
                whackSlot.charcterNode.yScale = 0.85

                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion:false))
                
            }
        }
        
    }
    
    private func configureBackground() {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
    }
    
    private func configureGameScore() {
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
    }
    
    private func createSlots() {
        for i in 1...5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) }
        for i in 1...4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
        for i in 1...5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
        for i in 1...4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }
    }
    
    private func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    private func createEnemy() {
        // Decrease popupTime a little everytime this function is called
        popupTime *= 0.991

        slots.shuffle()
        slots[0].show(hideTime: popupTime)
        showRandomSlots()

        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.createEnemy()
        }
    }
    
    private func showRandomSlots() {
        if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 8 {  slots[2].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 10 { slots[3].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 11 { slots[4].show(hideTime: popupTime)  }
    }
    
}
