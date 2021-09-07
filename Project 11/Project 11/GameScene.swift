//
//  GameScene.swift
//  Project 11
//
//  Created by Alvaro Orellana on 26-08-21.
//

import SpriteKit

class GameScene: SKScene {
    
    
    // MARK: - variables
    var scoreLabel: SKLabelNode!
    var editLabel: SKLabelNode!
    var numberOfBallsLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var isInEditingMode = false {
        didSet {
            if isInEditingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    let maxNumberOfBallsPerGame = 100
    lazy var ballCount = maxNumberOfBallsPerGame {
        didSet {
            numberOfBallsLabel.text = "Balls: \(ballCount)"
        }
    }
    
    var imageNames = ["ballBlue", "ballCyan", "ballGreen", "ballGrey", "ballPurple", "ballRed", "ballYellow"]
    
    
    
    // MARK: - Methods
    override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self

        makeBackGround()
        configureScoreLabel()
        configureEditLabel()
        configureNumberOfBallsLabel()
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
    }
    
    
    private func makeBackGround() {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
    }

    
    // MARK: - Core game logic
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else { return  }
        let location = firstTouch.location(in: self)
        
        if nodes(at: location).contains(editLabel) {
            //User tapped on edit label
            isInEditingMode.toggle()
        
        } else {
            if isInEditingMode {
                makeRandomLine(at: location)
           
            } else if ballCount > 0  {
                makeBall(at: location)
                ballCount -= 1
            }
        }
        
    }
    
  
    
    
    func makeBall(at position: CGPoint) {
                
        let randomImageName = imageNames.randomElement()!
        let ball = SKSpriteNode(imageNamed: randomImageName)
        // X postition is where the user tapped and Y position will be from top of the screen
        ball.position = CGPoint(x: position.x, y: 720)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
        ball.physicsBody?.restitution = 0.7
        ball.name = "ball"
        
        addChild(ball)
    }
    
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false
        
        addChild(bouncer)
    }
    
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode

        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }

        // Configure the slot base
        slotBase.position = position
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        addChild(slotBase)
      
        // Configure the slot glow
        slotGlow.position = position
        addChild(slotGlow)
        let spinAction = SKAction.repeatForever(.rotate(byAngle: .pi, duration: 10))
        slotGlow.run(spinAction)
    }
    
    
    func makeRandomLine(at position: CGPoint) {
        let randomColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
        let randomSize = CGSize(width: Int.random(in: 16...128), height: 16)
        let line = SKSpriteNode(color: randomColor, size: randomSize)
        
        line.position = position
        line.physicsBody = SKPhysicsBody(rectangleOf: line.size)
        line.physicsBody?.isDynamic = false
        line.zRotation = CGFloat.random(in: 0...3)
        line.name = "line"
        addChild(line)
    }
    
}



// MARK: - SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

        if nodeA.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
       
        } else if nodeB.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }
    
    
    private func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            score += 1
            ballCount += 1
            destroy(ball: ball)
      
        } else if object.name == "bad" {
            score -= 1
            destroy(ball: ball)
       
        } else if object.name == "line" {
            //object.removeFromParent()
        }
    }

    
    private func destroy(ball: SKNode) {
        if let fireEffect = SKEmitterNode(fileNamed: "FireParticles") {
            fireEffect.position = ball.position
            addChild(fireEffect)
        }
        ball.removeFromParent()
    }
}



// MARK: - Labels configuration
extension GameScene {
    
    private func configureScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
    }
    

    private func configureEditLabel() {
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.horizontalAlignmentMode = .left
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
    }
    
    
    private func configureNumberOfBallsLabel() {
        numberOfBallsLabel = SKLabelNode(fontNamed: "Chalkduster")
        numberOfBallsLabel.text = "Balls: \(ballCount)"
        numberOfBallsLabel.horizontalAlignmentMode = .right
        numberOfBallsLabel.position = CGPoint(x: 980, y: 600)
        addChild(numberOfBallsLabel)
    }
}
