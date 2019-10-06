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
    private var selectedNode = SKShapeNode() // : SKShapeNode?
    let ballRadius: CGFloat = 30
    var cueNodePoint = CGPoint(x: 0.0, y: 0.0)
    let linearDamping = CGFloat(0.3)
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        var bumperFrame = CGRect(x:-290, y:-650, width:580, height:1300)
        physicsBody = SKPhysicsBody(edgeLoopFrom: bumperFrame )
        
        
        physicsBody!.categoryBitMask = nodeCategoryMask
        
        createCueNode()

    }
    
    func createCueNode() {
        let a = [-100, -50, 0, 50, 100]
        let b = [-75, -25, 25, -75]
        
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
        cueNode = SKShapeNode(circleOfRadius: 40)
        cueNode!.name = "cue"
        cueNode!.fillColor = .white
        cueNode!.position = CGPoint(x: 0, y: -400)
        cueNode!.physicsBody = SKPhysicsBody(circleOfRadius: 45)
        cueNodePoint = cueNode!.position
        cueNode!.physicsBody?.affectedByGravity = false
        cueNode!.physicsBody?.allowsRotation = true
        cueNode!.physicsBody?.isDynamic = true
        cueNode!.physicsBody?.restitution = 1.0
        cueNode!.physicsBody?.linearDamping = linearDamping
        cueNode!.physicsBody?.collisionBitMask = nodeCategoryMask // 0b0001
        //greenBall!.physicsBody?.contactTestBitMask = nodeCategoryMask
        //greenBall!.physicsBody?.categoryBitMask = nodeCategoryMask // 0b0001
        
        addChild(cueNode!)
        
    }
    
    func createShape(atPoint pos : CGPoint) {
        bbNode = SKShapeNode(circleOfRadius: ballRadius)
        bbNode!.name = "num"
        bbNode!.fillColor = .blue
        bbNode!.position = pos
        bbNode!.physicsBody = SKPhysicsBody(circleOfRadius: ballRadius)
        bbNode!.physicsBody?.affectedByGravity = false
        bbNode!.physicsBody?.allowsRotation = true
        bbNode!.physicsBody?.isDynamic = true
        bbNode!.physicsBody?.restitution = 1.0
        bbNode!.physicsBody?.linearDamping = 0.3
        //blueBall!.physicsBody?.collisionBitMask = nodeCategoryMask // 0b0001
        bbNode!.physicsBody?.contactTestBitMask = nodeCategoryMask
        bbNode!.physicsBody?.categoryBitMask = nodeCategoryMask // 0b0001
        addChild(bbNode!)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //print("any contact")
        if contact.bodyA.categoryBitMask == nodeCategoryMask {
            if let a = contact.bodyA.node! as? SKShapeNode {
                //a.fillColor = .orange
                let dx = contact.bodyB.node!.position.x - cueNodePoint.x
                let dy = cueNode!.position.y - cueNodePoint.y
                //print("physicsBody velocity", physicsBody!.velocity)
                contact.bodyA.node!.physicsBody!.applyForce(contact.bodyB.node!.physicsBody!.velocity) //CGVector(dx: dx/10, dy: dy/10))
                //print("bodyA", dx, dy)
            }
            if let b = contact.bodyB.node! as? SKShapeNode {
                //b.fillColor = .red
            }
            //contact.run(.repeatForever(.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            //contact.bodyA.node?.removeFromParent()
            //bodyA.velocity = 10// cueNode!.physicsBody!.velocity
            
            
            
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
    
    func degToRad(degree: Double) -> CGFloat {
        return CGFloat(Double(degree) / 180.0 * Double.pi)
    }

    func selectNodeForTouch(touchLocation: CGPoint) {
      // 1
        let touchedNode = self.atPoint(touchLocation)
      
      if touchedNode is SKShapeNode {
        // 2
        if !selectedNode.isEqual(touchedNode) {
            selectedNode.removeAllActions()
            //selectedNode.run(SKAction.rotate(toAngle: 0.0, duration: 0.1))
      
            selectedNode = touchedNode as! SKShapeNode
            print(selectedNode)
          // 3
          if touchedNode.name! == "cue" {
            //let sequence = SKAction.sequence([SKAction.rotateByAngle(degToRad(-4.0), duration: 0.1),
            //  SKAction.rotateByAngle(0.0, duration: 0.1),
            //  SKAction.rotateByAngle(degToRad(4.0), duration: 0.1)])
            //selectedNode.runAction(SKAction.repeatActionForever(sequence))
          }
        }
      }
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
////        if let label = self.label {
////            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
////        }
//
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
//    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            let previousLocation = t.previousLocation(in: self)
            let touchedNode = self.atPoint(location)
            print("touchesBegan node", t)
            if (touchedNode.name == "cue" || touchedNode.name == "num") {
                touchedNode.physicsBody?.velocity = CGVector(dx: 0,dy: 0)
                //touchedNode.name = "selected"
                selectedNode = touchedNode as! SKShapeNode
                //let velocity = updateNodeVelocity(timeInterval:0.00, touchedNode: touchedNode, location: location, previousLocation: location)
                //touchedNode.physicsBody!.velocity = velocity
                //touchedNode.position = pos
                //self.touchMoved(toPoint: t.location(in: self), touchedNode: touchedNode)
            }
        }
//        for touch in touches {
//            let location = touch.location(in: self)
//            let node : SKNode = self.atPoint(location)
//            if node.name == "cue" {
//                print("touches began cue")
//            }
//        }
    }
    func touchDown(atPoint pos : CGPoint, touchedNode : SKNode) {
        //if let n = self.blueBall?.copy() as! SKShapeNode? {
        //      n.position = pos
        //      n.strokeColor = SKColor.red
        //      self.addChild(n)
        //}
        //createShape(atPoint: pos)
        //print("touchDown node", touchedNode)
        //touchedNode.position = pos
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            let previousLocation = t.previousLocation(in: self)
            let touchedNode = selectedNode //self.atPoint(location)
            print("touchesMoved", t)
            //if (touchedNode.name == "selected") { //touchedNode.name == "cue" || touchedNode.name == "num") {
                
            //let velocity = updateNodeVelocity(timeInterval:0.08, touchedNode: touchedNode, location: location, previousLocation: previousLocation)
            

            //touchedNode.physicsBody!.velocity = velocity
            touchedNode.physicsBody?.velocity = CGVector(dx: 0,dy: 0)
            touchedNode.position = location
            //self.touchMoved(toPoint: t.location(in: self), touchedNode: touchedNode)
            //}
        }
    }
    
    func touchMoved(toPoint pos : CGPoint, touchedNode : SKNode) {
        touchedNode.position = pos
        //updateNodeVelocity(timeInterval: 0.08, touchedNode: touchedNode)
        //cueNodePoint = touchedNode.position
    }
    
    func updateNodeVelocity(timeInterval:TimeInterval, touchedNode: SKNode, location: CGPoint, previousLocation: CGPoint) -> CGVector {
        let dx = location.x - previousLocation.x
        let dy = location.y - previousLocation.y
        let xVelocity = dx/CGFloat(timeInterval)
        let yVelocity = dy/CGFloat(timeInterval)
        return CGVector(dx: xVelocity, dy: yVelocity)
          //touchedNode.physicsBody!.velocity = CGVector(dx: xVelocity, dy: yVelocity)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            let previousLocation = t.previousLocation(in: self)
            let touchedNode = selectedNode //self.atPoint(location)
            print("touchesEnded", t)
            if (touchedNode.name == "cue" || touchedNode.name == "num") {
                //touchedNode.physicsBody?.velocity = CGVector(dx: 0,dy: 0)
                //touchedNode.name = "selected"
                //selectedNode = touchedNode as! SKShapeNode
                let velocity = updateNodeVelocity(timeInterval:0.08, touchedNode: touchedNode, location: location, previousLocation: previousLocation)
                touchedNode.physicsBody!.velocity = velocity
                //touchedNode.physicsBody!.applyForce(velocity)
                //touchedNode.position = pos
                //print("touchesEnded", t)
                self.touchUp(atPoint: t.location(in: self))
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    func touchUp(atPoint pos : CGPoint) {
        selectedNode = SKShapeNode()
        //updateNodeVelocity(timeInterval: 0.08)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        
        //cueNodePoint =
        
    }

    
    func removeBlueBall() {
        if (blueBallCount > 0) {
            if ((bbNode!.position.y < -300)) { // && (blueBall!.parent != nil) && !intersects(blueBall!)) {
                bbNode!.removeFromParent()
                print("blueBall removed.")
                blueBallCount -= 1
                print("blueBall count = ", blueBallCount)
        
            }
        }
    }
}
