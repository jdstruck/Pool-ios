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
    var screenSize: CGSize = CGSize()
    
    var screenWidth: CGFloat = 0.0
    
    // Screen height.
    var screenHeight: CGFloat = 0.0
    
    private var bbNode : SKShapeNode?
    private var redBall : SKShapeNode?
    private var cueNode : SKShapeNode?
    private var bumperFrame : CGRect?
    private var selectedNode = SKShapeNode()
    let ballRadius: CGFloat = 40
    let pocketRadius: CGFloat = 60
    var selectedNodeVelocity = CGVector(dx: 0.0, dy: 0.0)
    var selectedNodeTouchesMovedCount = 0
    let linearDamping = CGFloat(0.8)
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        print("nativeBounds", UIScreen.main.nativeBounds, "bounds", UIScreen.main.bounds, "nativeScale", UIScreen.main.nativeScale, "scale", UIScreen.main.scale)
//        print("bounds", UIScreen.main.bounds)
//        print("nativeScale", UIScreen.main.nativeScale)
//        print("scale", UIScreen.main.scale)
        self.screenSize = viewSizeInLocalCoordinates()
        self.view?.isPaused = false
        self.screenWidth = abs(screenSize.width)
        self.screenHeight = abs(screenSize.height)
        print("screenSize", screenSize, "screenWidth/Height", screenSize.width, screenSize.height)
        
        let bumperFrame = CGRect(x:-screenSize.width/2, y:screenSize.height/2, width: screenWidth, height: screenHeight)
        physicsBody = SKPhysicsBody(edgeLoopFrom: bumperFrame )
        physicsBody!.categoryBitMask = nodeCategoryMask
        
        setupPocketNodes()
        setupBallNodes()

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA.node
        let bodyB = contact.bodyB.node
        print("Collision")
        print("BodyA", contact.bodyA.node?.name)
        print("BodyB", bodyB!.name)
        print("BodyA velocity", bodyA!.physicsBody!.velocity)
        //print("BodyB velocity", bodyB!.physicsBody!.velocity)
        //bodyB!.physicsBody!.velocity = CGVector(dx:0,dy:0)
        let bodyBVelocity = bodyB!.physicsBody!.velocity
        bodyB!.physicsBody!.isDynamic = false
        let dx = bodyB!.position.x
        print("BodyB velocity", bodyBVelocity)
        let removeBall = SKAction.sequence([.wait(forDuration: 0.5),
                                            .removeFromParent()])
        bodyB?.run(.repeatForever(.move(by: bodyBVelocity, duration: 0.5)))
        bodyB?.run(removeBall)
        
        //destroy(ball: contact.bodyB.node!)
    }
    
    func viewSizeInLocalCoordinates() -> CGSize {
        let reference = CGPoint(x: view!.bounds.maxX, y: view!.bounds.maxY)
        let bottomLeft = convertPoint(fromView: .zero)
        let topRight = convertPoint(fromView: reference)
        let d = CGPoint(x: topRight.x - bottomLeft.x, y: topRight.y - bottomLeft.y)
        return CGSize(width: d.x, height: d.y)
    }
    
    func setupPocketNodes() {
        let cornerPocketsOffset = CGFloat(10)
        let sidePocketsOffset = CGFloat(20)
        let x = screenWidth/2 - cornerPocketsOffset
        let y = screenHeight/2 - cornerPocketsOffset
        createPocket(atPoint: CGPoint(x: -x, y: y), name: "ul", color: .darkGray, radius: pocketRadius)
        createPocket(atPoint: CGPoint(x: x, y: y), name: "ur", color: .darkGray, radius: pocketRadius)
        createPocket(atPoint: CGPoint(x: -x, y: -y), name: "ll", color: .darkGray, radius: pocketRadius)
        createPocket(atPoint: CGPoint(x: x, y: -y), name: "lr", color: .darkGray, radius: pocketRadius)
        createPocket(atPoint: CGPoint(x: -x-sidePocketsOffset, y: 0), name: "ml", color: .darkGray, radius: pocketRadius-5)
        createPocket(atPoint: CGPoint(x: x+sidePocketsOffset, y: 0), name: "mr", color: .darkGray, radius: pocketRadius-5)
        
    }
    
    func createPocket(atPoint pos : CGPoint, name : String, color : UIColor, radius : CGFloat) {
        let pocket = Pocket(circleOfRadius: radius)
        pocket.initializeBall(radius: radius, name: name, color: color, position: pos)
    
//        pocket.name = name
//        pocket.fillColor = color
//        pocket.position = pos
        
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
            print("nativeBounds", UIScreen.main.nativeBounds.height, "bounds", UIScreen.main.bounds, "nativeScale", UIScreen.main.nativeScale, "scale", UIScreen.main.scale)
            //print(height)
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
            
            let touchLocation = t.location(in: self)
            
            //print(convertPoint(fromView: location))
            let previousTouchLocation = t.previousLocation(in: self)
            let touchedNode = selectedNode
            selectedNodeVelocity = updateNodeVelocity(timeInterval:0.05, touchedNode: touchedNode, location: touchLocation, previousLocation: previousTouchLocation)
            print("touchedNode velocity", selectedNodeVelocity)
            touchedNode.physicsBody?.velocity = CGVector(dx: 0,dy: 0)
            touchedNode.position = touchLocation
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
        //selectedNodeVelocity = CGVector()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
