//
//  Coin.swift
//  SpaceSwing
//
//  Created by Jorge Torres on 1/10/25.
//

import Foundation
import SpriteKit


class Coin: SKSpriteNode {
    var scaleFactor = 3.0
    
    func setup(withNode: SKNode){
      
        
        
        self.run(SKAction.sequence([ SKAction.wait(forDuration: CGFloat.random(in: 0.01...0.20)) ,  SKAction.repeatForever(SharedInfo.SharedInstance.coinAnimation)]))
        
       
        scaleFactor = SharedInfo.SharedInstance.coin_scale_factor
        
        let physicsBody = SKPhysicsBody(circleOfRadius: 10 * scaleFactor)
        physicsBody.categoryBitMask = PhysicsCategory.coin
        physicsBody.collisionBitMask = PhysicsCategory.none
        physicsBody.contactTestBitMask = PhysicsCategory.player
        physicsBody.fieldBitMask = PhysicsCategory.none
        physicsBody.affectedByGravity = false
        physicsBody.allowsRotation = false
        self.physicsBody = physicsBody
        self.zPosition = 100
        self.setScale(0.0)
        self.alpha = 0.0 
        self.run(SKAction.sequence([ SKAction.wait(forDuration: CGFloat.random(in: 0.01...0.25)),
            SKAction.group([
            SKAction.fadeAlpha(to: 1.0, duration: 0.25),
            SKAction.scale(to: 1.5 * scaleFactor , duration: 0.25)
        ]),
            SKAction.scale(to: 0.75  * scaleFactor  , duration: 0.10),
            SKAction.scale(to: 1.35  * scaleFactor  , duration: 0.10),
            SKAction.scale(to: 1.0  * scaleFactor  , duration: 0.10)]))
    }
    
    func runCollectionAnimation(){
        
        if let shipGhostParticles = SKEmitterNode(fileNamed: "coinSparko") {
            
            shipGhostParticles.position = self.position
            self.parent!.addChild(shipGhostParticles)
            
            shipGhostParticles.targetNode = self.parent!
        }
    }
}
