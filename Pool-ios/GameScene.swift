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
    var screenHeight: CGFloat = 0.0
    
    private var colorBall : SKShapeNode?
    private var cueBall : SKShapeNode?
    private var eightBall : SKShapeNode?
    private var bumperFrame : CGRect?
    private var selectedNode = SKShapeNode()
    
    let ballRadius: CGFloat = 40
    let pocketRadius: CGFloat = 60
    var selectedNodeVelocity = CGVector(dx: 0.0, dy: 0.0)
    var selectedNodeTouchesMovedCount = 0
    let linearDamping = CGFloat(0.8)
    var poolBallArray: [Ball] = []
    
    private var player1 = Player(name: "1", score: 0)
    private var player2 = Player(name: "2", score: 0)
    private var currentPlayer = Player()
    
    
    override func didMove(to view: SKView) {
        currentPlayer = player1
        self.physicsWorld.contactDelegate = self
        self.screenSize = viewSizeInLocalCoordinates()
        self.view?.isPaused = false
        self.screenWidth = abs(screenSize.width)
        self.screenHeight = abs(screenSize.height)
        bumperFrame = CGRect(x:-screenSize.width/2,
                             y:screenSize.height/2,
                             width: screenWidth,
                             height: screenHeight)
        physicsBody = SKPhysicsBody(edgeLoopFrom: bumperFrame! )
        physicsBody!.categoryBitMask = nodeCategoryMask
        
        setupPocketNodes()
        setupBallNodes()

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA.node
        let bodyB = contact.bodyB.node
        let bodyBVelocity = bodyB!.physicsBody!.velocity
        bodyB!.physicsBody!.isDynamic = false
        let removeBall = SKAction.sequence([.wait(forDuration: 0.01),
                                            .removeFromParent()])
        bodyB?.run(removeBall)
        if (bodyB!.name == "0") {
            generateCueBall()
        } else if bodyB!.name == "8" {
            for b in self.children {
                if b is Ball {
                    b.removeFromParent()
                }
            }
            cueBall?.removeFromParent()
            setupBallNodes()
        }
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
        addChild(pocket)
    }
    
    func generateCueBall() {
        self.cueBall = createBall(atPoint: CGPoint(x: 0, y: -400),
                                  name: "0",
                                  color: .white,
                                  type: .NONE)
        let reset = SKAction.sequence([.wait(forDuration: 1),
                                       .move(to: CGPoint(x: 0, y: -400), duration: 0)])
        self.cueBall!.run(reset)
        addChild(self.cueBall!)
    }
    
    func setupBallNodes() {
        self.poolBallArray.removeAll()
        let colors = [.yellow as UIColor, .blue, .red, .purple, .orange, .green, .brown]
        
        // Generate cue ball
        generateCueBall()
        
        // Generate 8-ball
        self.eightBall = createBall(atPoint: CGPoint(x: 0, y: 0),
                                      name: String(8),
                                      color: .black,
                                      type: .NONE)
        
        // Generate solids
        for (i, color) in colors.enumerated() {
            if (i == 4) {self.poolBallArray.append(self.eightBall as! Ball)}
            self.poolBallArray.append(createBall(atPoint: CGPoint(x: 0, y: 0),
                                                 name: String(i+1),
                                                 color: color,
                                                 type: .SOLID))
        }
        
        //Generate stripes
        for (i, color) in colors.enumerated() {
            self.poolBallArray.append(createBall(atPoint: CGPoint(x: 0, y: 0),
                                                 name: String(i+8+1),
                                                 color: color,
                                                 type: .STRIPE))
        }
        
        resetBallPositions()
    }
    
    func resetBallPositions() {
        let sp : Int = Int(self.ballRadius*2)-10
        let poolBallProperties = [
                  CGPoint(x: 0,             y: sp*2)
                , CGPoint(x: -(sp/2),       y: sp*3)
                , CGPoint(x: sp/2,          y: sp*3)
                , CGPoint(x: -sp,           y: sp*4)
                , CGPoint(x: 0,             y: sp*4)
                , CGPoint(x: sp,            y: sp*4)
                , CGPoint(x: -(sp/2+sp),    y: sp*5)
                , CGPoint(x: -(sp/2),       y: sp*5)
                , CGPoint(x: (sp/2),        y: sp*5)
                , CGPoint(x: sp/2+sp,       y: sp*5)
                , CGPoint(x: -(sp*2),       y: sp*6)
                , CGPoint(x: -sp,           y: sp*6)
                , CGPoint(x: 0,             y: sp*6)
                , CGPoint(x: sp,            y: sp*6)
                , CGPoint(x: sp*2,          y: sp*6)
        ]
        for (i, p) in poolBallProperties.enumerated() {
            let ball = poolBallArray[i]
            ball.position = p
            ball.run(.move(to: p, duration: 0))
            addChild(ball)
        }
    }
    
    func createBall(atPoint pos : CGPoint, name : String, color : UIColor, type: Ball.BallType) -> Ball {
        let ball = Ball(circleOfRadius: ballRadius)
        ball.name = name
        ball.fillColor = color
        ball.ballType = type
        ball.position = pos
        return ball
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            self.view?.isPaused = false
            let touchedNode = self.atPoint(location)
            if (touchedNode is Ball) {
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
            let previousTouchLocation = t.previousLocation(in: self)
            let touchedNode = selectedNode
            selectedNodeVelocity = updateNodeVelocity(timeInterval:0.05, touchedNode: touchedNode, location: touchLocation, previousLocation: previousTouchLocation)
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
            let touchedNode = selectedNode
            if (touchedNode is Ball) {
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
        selectedNodeTouchesMovedCount = 0
    }
    
    override func update(_ currentTime: TimeInterval) {
//        Called before each frame is rendered
    }
    

}
