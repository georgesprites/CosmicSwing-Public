//
//  Star.swift
//  SpaceSwing
//
//  Created by Jorge Torres on 1/11/25.
//

import Foundation
import SpriteKit

class Star: SKSpriteNode {
    
    
    
    func setup(){
      
        
        self.run(SKAction.sequence([ SKAction.wait(forDuration: CGFloat.random(in: 0.01...0.20)) ,  SKAction.repeatForever(SharedInfo.SharedInstance.starAnimation)]))
        
        let physicsBody = SKPhysicsBody(circleOfRadius: 10)
        physicsBody.categoryBitMask = PhysicsCategory.star
        physicsBody.collisionBitMask = PhysicsCategory.none
        physicsBody.contactTestBitMask = PhysicsCategory.player
        physicsBody.fieldBitMask = PhysicsCategory.none
        physicsBody.affectedByGravity = false
        physicsBody.allowsRotation = false
        self.physicsBody = physicsBody
        
        
    }
}
