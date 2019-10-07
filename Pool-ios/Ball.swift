//
//  Ball.swift
//  Pool-ios
//
//  Created by Jesse Struck on 10/6/19.
//  Copyright © 2019 Jesse Struck. All rights reserved.
//

import Foundation
import SpriteKit

class Ball: SKShapeNode {
    let boundaryCategoryMask: UInt32 = 0x1 << 1
    let nodeCategoryMask: UInt32 = 0x1 << 2
    
    override init() {
        super.init()
        //position = CGPoint(x: 0, y: -400)
        physicsBody = SKPhysicsBody(circleOfRadius: 40)
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = true
        physicsBody?.isDynamic = true
        physicsBody?.restitution = 1.0
        physicsBody?.linearDamping = CGFloat(0.8)
        physicsBody?.collisionBitMask = nodeCategoryMask // 0b0001
        //physicsBody?.contactTestBitMask = nodeCategoryMask
        //physicsBody?.categoryBitMask = nodeCategoryMask // 0b0001
                
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
