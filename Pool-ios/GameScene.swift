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
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    // Screen height.
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    private var bbNode : SKShapeNode?
    private var redBall : SKShapeNode?
    private var cueNode : SKShapeNode?
    private var bumperFrame : CGRect?
    private var selectedNode = SKShapeNode()
    let ballRadius: CGFloat = 30
    var selectedNodeVelocity = CGVector(dx: 0.0, dy: 0.0)
    var selectedNodeTouchesMovedCount = 0
    let linearDamping = CGFloat(0.8)
    
    override func didMove(to view: SKView) {
        print("nativeBounds", UIScreen.main.nativeBounds)
        print("bounds", UIScreen.main.bounds)
        print("nativeScale", UIScreen.main.nativeScale)
        print("scale", UIScreen.main.scale)
        self.physicsWorld.contactDelegate = self
        let bumperFrame = CGRect(x:-290, y:-650, width:580, height:1300)
        physicsBody = SKPhysicsBody(edgeLoopFrom: bumperFrame )
        
        
        physicsBody!.categoryBitMask = nodeCategoryMask
        
        createCueNode()

    }
    
    func createCueNode() {
        //let a = [-100, -50, 0, 50, 100]
        //let b = [-75, -25, 25, -75]
        
        createShape(atPoint: CGPoint(x: 0, y: 100))
        
        for i in [-25, 25] {
            createShape(atPoint: CGPoint(x: i, y: 150))
        }
        for i in [-50, 0, 50] {
            createShape(atPoint: CGPoint(x: i, y: 200))
        }
        for i in [-75, -25, 25, 75] {
            createShape(atPoint: CGPoint(x: i, y: 250))
        }
        for i in [-100, -50, 0, 50, 100] {
            createShape(atPoint: CGPoint(x: i, y: 300))
        }
        cueNode = Ball(circleOfRadius: 40)
        cueNode!.name = "cue"
        cueNode!.fillColor = .white
        cueNode!.position = CGPoint(x: 0, y: -400)
//        cueNode!.physicsBody = SKPhysicsBody(circleOfRadius: 45)
//        //cueNodePoint = cueNode!.position
//        cueNode!.physicsBody?.affectedByGravity = false
//        cueNode!.physicsBody?.allowsRotation = true
//        cueNode!.physicsBody?.isDynamic = true
//        cueNode!.physicsBody?.restitution = 1.0
//        cueNode!.physicsBody?.linearDamping = linearDamping
//        cueNode!.physicsBody?.collisionBitMask = nodeCategoryMask // 0b0001
//        //greenBall!.physicsBody?.contactTestBitMask = nodeCategoryMask
//        //greenBall!.physicsBody?.categoryBitMask = nodeCategoryMask // 0b0001
//
        addChild(cueNode!)
        
    }
    
    func createShape(atPoint pos : CGPoint) {
        bbNode = Ball(circleOfRadius: ballRadius)
        bbNode!.name = "num"
        bbNode!.fillColor = .blue
        bbNode!.position = pos
//        bbNode!.physicsBody = SKPhysicsBody(circleOfRadius: ballRadius)
//        bbNode!.physicsBody?.affectedByGravity = false
//        bbNode!.physicsBody?.allowsRotation = true
//        bbNode!.physicsBody?.isDynamic = false
//        bbNode!.physicsBody?.restitution = 1.0
//        bbNode!.physicsBody?.linearDamping = linearDamping
//        //blueBall!.physicsBody?.collisionBitMask = nodeCategoryMask // 0b0001
//        bbNode!.physicsBody?.contactTestBitMask = nodeCategoryMask
//        bbNode!.physicsBody?.categoryBitMask = nodeCategoryMask // 0b0001
        addChild(bbNode!)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //print("any contact")
        if contact.bodyA.categoryBitMask == nodeCategoryMask {
            if let a = contact.bodyA.node! as? SKShapeNode {
                a.physicsBody!.applyForce(contact.bodyB.node!.physicsBody!.velocity) //CGVector(dx: dx/10, dy: dy/10))
            }
            if contact.bodyB.node! is SKShapeNode {
            }
        }
        if contact.bodyB.categoryBitMask == nodeCategoryMask {
            //contact.bodyB.node?.removeFromParent()
            contact.bodyB.node?.physicsBody?.applyForce(CGVector(dx: 1.0, dy: 1.0))
            //print("bodyB")
        }
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            print("touchesBegan touch count", t.tapCount)
            let location = t.location(in: self)
            print(location)
            //let previousLocation = t.previousLocation(in: self)
            let touchedNode = self.atPoint(location)
            //print("touchesBegan node", t)
            if (touchedNode.name == "cue" || touchedNode.name == "num") {
                touchedNode.physicsBody?.velocity = CGVector(dx: 0,dy: 0)
                selectedNode = touchedNode as! SKShapeNode
            }
        }
    }
    func touchDown(atPoint pos : CGPoint, touchedNode : SKNode) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            let previousLocation = t.previousLocation(in: self)
            let touchedNode = selectedNode
            selectedNodeVelocity = updateNodeVelocity(timeInterval:0.05, touchedNode: touchedNode, location: location, previousLocation: previousLocation)
            touchedNode.physicsBody?.velocity = CGVector(dx: 0,dy: 0)
            touchedNode.position = location
            selectedNodeTouchesMovedCount += 1
        }
    }
    
    func touchMoved(toPoint pos : CGPoint, touchedNode : SKNode) {
    }
    
    func updateNodeVelocity(timeInterval:TimeInterval, touchedNode: SKNode, location: CGPoint, previousLocation: CGPoint) -> CGVector {
        let dx = location.x - previousLocation.x
        let dy = location.y - previousLocation.y
        let xVelocity = dx/CGFloat(timeInterval)
        let yVelocity = dy/CGFloat(timeInterval)
        return CGVector(dx: xVelocity, dy: yVelocity)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            //let location = t.location(in: self)
            //let previousLocation = t.previousLocation(in: self)
            let touchedNode = selectedNode
            if (touchedNode.name == "cue" || touchedNode.name == "num") {
                touchedNode.physicsBody!.velocity = selectedNodeVelocity
                self.touchUp(atPoint: t.location(in: self))
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    func touchUp(atPoint pos : CGPoint) {
        selectedNode = SKShapeNode()
        print(selectedNodeTouchesMovedCount)
        selectedNodeTouchesMovedCount = 0
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
