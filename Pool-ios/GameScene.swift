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
    
    var screenWidth: CGFloat = 0.0
    
    // Screen height.
    var screenHeight: CGFloat = 0.0
    
    private var bbNode : SKShapeNode?
    private var redBall : SKShapeNode?
    private var cueNode : SKShapeNode?
    private var bumperFrame : CGRect?
    private var selectedNode = SKShapeNode()
    let ballRadius: CGFloat = 40
    let pocketRadius: CGFloat = 50
    var selectedNodeVelocity = CGVector(dx: 0.0, dy: 0.0)
    var selectedNodeTouchesMovedCount = 0
    let linearDamping = CGFloat(0.8)
    
    override func didMove(to view: SKView) {
        print("nativeBounds", UIScreen.main.nativeBounds, "bounds", UIScreen.main.bounds, "nativeScale", UIScreen.main.nativeScale, "scale", UIScreen.main.scale)
//        print("bounds", UIScreen.main.bounds)
//        print("nativeScale", UIScreen.main.nativeScale)
//        print("scale", UIScreen.main.scale)
        self.view?.isPaused = false
        self.screenWidth = (self.view?.bounds.width)!
        self.screenHeight = (self.view?.bounds.height)!
        print(screenWidth, screenHeight)
        self.physicsWorld.contactDelegate = self
        let bumperFrame = CGRect(x:-372, y:-665, width:740, height:1330)
        physicsBody = SKPhysicsBody(edgeLoopFrom: bumperFrame )
        physicsBody!.categoryBitMask = nodeCategoryMask
        
        setupPocketNodes()
        setupBallNodes()

    }
    
    func setupPocketNodes() {
        createPocket(atPoint: CGPoint(x: -372+10, y: 665-10), name: "ll", color: .darkGray)
        createPocket(atPoint: CGPoint(x: 372-10, y: 665-10), name: "ll", color: .darkGray)
        createPocket(atPoint: CGPoint(x: -372+10, y: -665+10), name: "ll", color: .darkGray)
        createPocket(atPoint: CGPoint(x: 372-10, y: -665+10), name: "ll", color: .darkGray)
        createPocket(atPoint: CGPoint(x: -372-15, y: -0), name: "ll", color: .darkGray)
        createPocket(atPoint: CGPoint(x: 372+15, y: -0), name: "ll", color: .darkGray)
        
    }
    
    func createPocket(atPoint pos : CGPoint, name : String, color : UIColor) {
        let pocket = Pocket(circleOfRadius: pocketRadius)
    
        pocket.name = name
        pocket.fillColor = color
        pocket.position = pos
        
        addChild(pocket)
    }
    
    func setupBallNodes() {
        let a = [-100, -50, 0, 50, 100]
        let b = [-75, -25, 25, 75]
        let poolBallColors = [.white as UIColor, .yellow, .blue, .red, .purple, .orange, .green, .brown, .black, .yellow, .blue, .red, .purple, .orange, .green, .brown]
        var counter = 0
        print("cue..", 0, "\t", 0, "\t\t", counter)
        createBall(atPoint: CGPoint(x: 0, y: -400), name: String(counter), color: poolBallColors[0])          //white
        counter += 1
        createBall(atPoint: CGPoint(x: 0, y: 100), name: String(counter), color: poolBallColors[1])
        print("1st..", 0, "\t", 0, "\t\t", counter)      //yellow
        counter += 1
        for i in 1...2 {
            print("1...2", i, "\t", b[i], "\t", counter)
            createBall(atPoint: CGPoint(x: b[i], y: 150), name: String(counter), color: poolBallColors[counter])//blue red
            counter += 1
        }
        for i in 1...3 {
            print("1...3", i, "\t", a[i], "\t", counter)
            createBall(atPoint: CGPoint(x: a[i], y: 200), name: String(counter), color: poolBallColors[counter])//purple orange green
            counter += 1
        }
        for i in 0...3 {
            print("0...3", i, "\t", b[i], "\t", counter)
            createBall(atPoint: CGPoint(x: b[i], y: 250), name: String(counter), color: poolBallColors[counter])//brown black yellow blue
            counter += 1
        }
        for i  in 0...4 {
            print("0...4", i, "\t", a[i], "\t", counter)
            createBall(atPoint: CGPoint(x: a[i], y: 300), name: String(counter), color: poolBallColors[counter])//red purple orange green brown
            counter += 1
        }
        
        
//        cueNode = Ball(circleOfRadius: 40)
//        cueNode!.name = "cue"
//        cueNode!.fillColor = .white
//        cueNode!.position = CGPoint(x: 0, y: -400)
//
//        addChild(cueNode!)
        
    }
    
    func createBall(atPoint pos : CGPoint, name : String, color : UIColor) {
        let ball = Ball(circleOfRadius: ballRadius)
        ball.name = name
        ball.fillColor = color
        ball.position = pos
        
        addChild(ball)
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
            print("nativeBounds", UIScreen.main.nativeBounds, "bounds", UIScreen.main.bounds, "nativeScale", UIScreen.main.nativeScale, "scale", UIScreen.main.scale)
            //let previousLocation = t.previousLocation(in: self)
            self.view?.isPaused = false

            let touchedNode = self.atPoint(location)
            //print("touchesBegan node", t)
            if (touchedNode is Ball) {//0 <= Int(touchedNode.name!)! || Int(touchedNode.name!)! <= 16) {
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
            print(location)
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
            if (touchedNode is Ball) { //Int(touchedNode.name!)! >= 0  || touchedNode.name == "num") {
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
        selectedNodeVelocity = CGVector()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
