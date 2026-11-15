//
//  Asteroi.swift
//  SpaceSwing
//
//  Created by Jorge Torres on 1/8/25.
//

import Foundation
import SpriteKit

class Asteroid : SKSpriteNode {
    
    var radius: CGFloat = 15.0
    
    
    
    
    
    func setup(withDampingAmount: CGFloat = 0.0){
        
        

        let physicsNode = SKPhysicsBody.init(circleOfRadius: self.size.width / 2, center: .zero)
        
        self.physicsBody = physicsNode
        self.physicsBody?.categoryBitMask = PhysicsCategory.asteroid
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.collisionBitMask = PhysicsCategory.asteroid
        self.physicsBody?.mass = CGFloat(CFloat.random(in: 0...1000))
        self.physicsBody?.contactTestBitMask = PhysicsCategory.playerProjectile | PhysicsCategory.gravityStar
        //self.physicsBody?.fieldBitMask = PhysicsCategory.none
  
        if(withDampingAmount == 0.0){
            self.physicsBody?.linearDamping = CGFloat.random(in: 0...1000)
        } else {
            
            self.physicsBody?.linearDamping = withDampingAmount
        }
        
        self.zPosition = 100
        
        self.physicsBody!.applyImpulse(CGVector.init(dx: CGFloat.random(in: -50000...50000), dy: CGFloat.random(in: -50000...50000)))
        self.physicsBody?.applyForce(CGVector.init(dx: CGFloat.random(in: -50000...50000), dy: CGFloat.random(in: -50000...50000)))
        self.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(degreesToradians(Float(Int.random(in: -30...30)))), duration: 0.5)))
    }
    
    func asteroidHit(){
     
        //simple implemntation, split into two
        
        if(self.radius > 5  ) {
            
            //Only split if the radius is greater than 5, otherwise too small and destroy astroid
            
            
        let astroid1 = Asteroid(texture: SharedInfo.SharedInstance.randomAsteroidShapeTextures[Int.random(in: 1...9)])
        let astroid2 = Asteroid(texture: SharedInfo.SharedInstance.randomAsteroidShapeTextures[Int.random(in: 1...9)])
            astroid1.radius = self.radius / 2
            astroid2.radius = self.radius / 2
        astroid1.setup()
        astroid2.setup()
        astroid1.position = self.position
        astroid2.position = self.position
        
        self.parent!.addChild(astroid1)
        self.parent!.addChild(astroid2)
        
        }
        
        astroidDestroyed()
        
        
        
        //astroid destroyed and split
        
        
    }
    
    func astroidDestroyed(){
        
        self.physicsBody = nil
       
        
        if let particleEmmiter = SKEmitterNode(fileNamed: "AsteroidSparko"){
            //Do the SPARKO THANG
            particleEmmiter.setScale(0.25)
            particleEmmiter.particleLifetime = 0.05
         
        self.parent!.addChild(particleEmmiter)
            particleEmmiter.position = self.position
            particleEmmiter.targetNode = self.parent!
        }
        self.removeFromParent()
    }
    
   
      
}
