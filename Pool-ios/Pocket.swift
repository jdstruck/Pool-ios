//
//  Ball.swift
//  Pool-ios
//
//  Created by Jesse Struck on 10/6/19.
//  Copyright © 2019 Jesse Struck. All rights reserved.
//

import Foundation
import SpriteKit

class Pocket: SKShapeNode {
    let boundaryCategoryMask: UInt32 = 0x1 << 1
    let nodeCategoryMask: UInt32 = 0x1 << 2
    let pocketCategoryMask: UInt32 = 0x1 << 3
    
    override init() {
        super.init()
        //position = CGPoint(x: 0, y: -400)
//        physicsBody = SKPhysicsBody(circleOfRadius: 30)
//        physicsBody?.affectedByGravity = false
//        physicsBody?.allowsRotation = false
//        physicsBody?.isDynamic = false
//        physicsBody?.restitution = 1.0
//        physicsBody?.linearDamping = CGFloat(0.8)
//        physicsBody?.collisionBitMask = nodeCategoryMask // 0b0001
//        physicsBody?.contactTestBitMask = nodeCategoryMask
//        physicsBody?.categoryBitMask = nodeCategoryMask // 0b0001
                
    }
    func initializeBall(radius: CGFloat, name: String, color: UIColor, position: CGPoint) {
        self.name = name
        self.fillColor = color
        self.position = position
        physicsBody = SKPhysicsBody(circleOfRadius: radius/2)
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        physicsBody?.isDynamic = false
        physicsBody?.restitution = 1.0
        physicsBody?.linearDamping = CGFloat(0.8)
        physicsBody?.collisionBitMask = nodeCategoryMask // 0b0001
        physicsBody?.contactTestBitMask = nodeCategoryMask
        physicsBody?.categoryBitMask = nodeCategoryMask // 0b0001
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
// 6s+  nativeBounds (0.0, 0.0, 1080.0, 1920.0) bounds (0.0, 0.0, 414.0, 736.0) nativeScale 2.6 scale 3.0
// ^emu nativeBounds (0.0, 0.0, 1242.0, 2208.0) bounds (0.0, 0.0, 414.0, 736.0) nativeScale 3.0 scale 3.0
// ul (372, -665)
// ur (372, 665)
// ll (-372, -665)
// lr (372, -665)
// ll (-372, -665)
// ll (-372, -665)
// 11pm nativeBounds (0.0, 0.0, 1242.0, 2688.0) bounds (0.0, 0.0, 414.0, 896.0) nativeScale 3.0 scale 3.0
// ul (-300, -665)
// ur (300, 665)
// ll (-300, -665)
// lr (300, -665)
// ll (-300, -665)
// ll (-300, -665)
