//
//  GameScene.swift
//  Project 11
//
//  Created by Alvaro Orellana on 26-08-21.
//

import SpriteKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background )
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else { return  }

        let location = firstTouch.location(in: self)

        let squareSize = CGSize(width: 64, height: 64)
        let square = SKSpriteNode(color: .red, size: squareSize)
        square.physicsBody = SKPhysicsBody(rectangleOf: squareSize)
         square.position = location
        addChild(square)
        
    }
    
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let firstTouch = touches.first else { return  }
//
//        let location = firstTouch.location(in: self)
//
//        let squareSize = CGSize(width: 64, height: 64)
//        //let square = SKSpriteNode(color: .red, size: squareSize)
//        let square =  SKSpriteNode(imageNamed: "ballGreen")
//
//        //square.physicsBody = SKPhysicsBody(rectangleOf: squareSize)
//        square.physicsBody = SKPhysicsBody(circleOfRadius: 25)
//         square.position = location
//        addChild(square)
//    }
    
}
