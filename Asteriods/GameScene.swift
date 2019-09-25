//
//  GameScene.swift
//  TestGame
//
//  Created by Jesse Struck on 9/23/19.
//  Copyright © 2019 Jesse Struck. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
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
    
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w*0)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi/2), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    func createShape(atPoint pos : CGPoint) {
        
        let startx = CGFloat.random(in: -(screenWidth)/2 ..< (screenWidth/2)-50 )
        let starty = CGFloat.random(in: -(screenHeight)/2 ..< (screenHeight/2))
        let sizeFactor = Int.random(in: 1 ... 4)
        let numPoints = Int.random(in: 8 ... 20)
        let edgeAngle: Double = Double(360 / numPoints)
                
        var points: [CGPoint] = []
        
        for index in 0 ..< numPoints {
            let x: Double
            let y: Double
            let edgeLength = Double.random(in: 10 ... 30) * Double(sizeFactor)
            
            switch(index) {
            case 1 ... numPoints - 2:
                x = edgeLength * cos(2 * Double.pi * Double(index)/Double(numPoints))
                y = edgeLength * sin(2 * Double.pi * Double(index)/Double(numPoints))
                print(sizeFactor, numPoints, edgeLength, String(edgeAngle) + "\n" + String(x), y)
            default: x = 0; y = 0
            }
            points.append(CGPoint(x: x, y: y))
        }
        
        let linearShapeNode = SKShapeNode(points: &points, count: points.count)
        linearShapeNode.position = pos //CGPoint(x: startx, y: starty);
        
        linearShapeNode.physicsBody = SKPhysicsBody(edgeChainFrom: linearShapeNode.path!)
        linearShapeNode.physicsBody?.mass = 100
        linearShapeNode.physicsBody?.restitution = 0.75
        linearShapeNode.physicsBody?.collisionBitMask = 0b0001
        linearShapeNode.physicsBody?.categoryBitMask = 0b0001
        
        linearShapeNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.random(in: -2 ... 2), duration: TimeInterval.random(in: 1 ... 2))))
        linearShapeNode.run(SKAction.repeatForever(SKAction.moveBy(x: CGFloat.random(in: -100 ... 100), y: CGFloat.random(in: -100 ... 100), duration: TimeInterval.random(in: 1 ... 3))))
        self.addChild(linearShapeNode);
        //print(startx, starty);
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
        createShape(atPoint: pos)
        
        //print(screenWidth, screenHeight)
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
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
    }
}
