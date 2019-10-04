//
//  GameScene.swift
//  TestGame
//
//  Created by Jesse Struck on 9/23/19.
//  Copyright © 2019 Jesse Struck. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let boundaryCategoryMask: UInt32 = 0x1 << 1
    let nodeCategoryMask: UInt32 = 0x1 << 2
    
    private var asteroidCount = 0
    private var redBallCount = 0
    private var blueBallCount = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    // Screen width.
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    // Screen height.
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    
    private var blueBall : SKShapeNode?
    private var redBall : SKShapeNode?
    private var greenBall : SKShapeNode?
    private var ground : SKShapeNode?
    private var asteroid : SKShapeNode?
    let ballRadius: CGFloat = 20
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        physicsBody!.categoryBitMask = boundaryCategoryMask
        for i in [-100, -50, 0, 50, 100]{
            createShape(atPoint: CGPoint(x: i, y: 0))
        }
        greenBall = SKShapeNode(circleOfRadius: 40)
        greenBall!.fillColor = .green
        greenBall!.physicsBody = SKPhysicsBody(circleOfRadius: 40)
        greenBall!.physicsBody?.affectedByGravity = false
        greenBall!.physicsBody?.collisionBitMask = nodeCategoryMask // 0b0001
        //greenBall!.physicsBody?.contactTestBitMask = nodeCategoryMask
        //greenBall!.physicsBody?.categoryBitMask = nodeCategoryMask // 0b0001
        greenBall!.position = CGPoint(x: 0, y: -400)
        addChild(greenBall!)

    }
    func didBegin(_ contact: SKPhysicsContact) {
        print("contact")
        if contact.bodyA.categoryBitMask == nodeCategoryMask {
            //contact.run(.repeatForever(.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            //contact.bodyA.node?.removeFromParent()
            //print("asteroid removed")
        }
        if contact.bodyB.categoryBitMask == nodeCategoryMask {
            contact.bodyB.node?.removeFromParent()
            print("asteroid removed")
        }
    }
    func createShape(atPoint pos : CGPoint) {
        blueBall = SKShapeNode(circleOfRadius: ballRadius)
        blueBall!.fillColor = .blue
        blueBall!.position = pos
        blueBall!.physicsBody = SKPhysicsBody(circleOfRadius: ballRadius)
        blueBall!.physicsBody?.affectedByGravity = false
        
        //blueBall!.physicsBody?.collisionBitMask = nodeCategoryMask // 0b0001
        blueBall!.physicsBody?.contactTestBitMask = nodeCategoryMask
        blueBall!.physicsBody?.categoryBitMask = nodeCategoryMask // 0b0001        blueBall!.name = "bad"
       
        addChild(blueBall!)
        blueBallCount += 1
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
        } else if object.name == "bad" {
            destroy(ball: ball)
        }
    }

    func destroy(ball: SKNode) {
        ball.removeFromParent()
    }
    
    func touchDown(atPoint pos : CGPoint) {
        //if let n = self.blueBall?.copy() as! SKShapeNode? {
        //      n.position = pos
        //      n.strokeColor = SKColor.red
        //      self.addChild(n)
        //}
        //createShape(atPoint: pos)
    }

    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.greenBall?.copy() as! SKShapeNode? {
              greenBall!.position = pos
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        //removeAsteroid()
        //removeBlueBall()
        //removeRedBall()
        
    }
    
    func removeAsteroid() {
        if (asteroidCount > 0) {
            let y = asteroid!.position.y
            let x = asteroid!.position.x
            if (y < -50 || y > 50 || x < -100 || x > 100) { //} && (asteroid!.parent != nil) && !intersects(asteroid!)) {
                asteroid!.removeFromParent()
                print("asteroid removed.")
                asteroidCount -= 1
                print("asteroid count = ", asteroidCount)
            }
        }
    }
    
    func removeRedBall() {
        if (redBallCount > 0) {
            if ((redBall!.position.y < -300)) { // && (redBall!.parent != nil) && !intersects(redBall!)) {
                redBall!.removeFromParent()
                print("redBall removed.")
                redBallCount -= 1
                print("redBall count = ", redBallCount)
            }
        }
    }
    
    func removeBlueBall() {
        if (blueBallCount > 0) {
            if ((blueBall!.position.y < -300)) { // && (blueBall!.parent != nil) && !intersects(blueBall!)) {
                blueBall!.removeFromParent()
                print("blueBall removed.")
                blueBallCount -= 1
                print("blueBall count = ", blueBallCount)
        
            }
        }
    }
}
