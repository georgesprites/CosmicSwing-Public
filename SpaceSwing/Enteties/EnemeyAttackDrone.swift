//
//  EnemeyScout.swift
//  N Body No Problem
//
//  Created by Jorge Torres on 5/26/24.
//

import Foundation
import SpriteKit

class EnemeyAttackDrone: Enemey {
    

    var savedPlayerPosition = CGPoint.zero
    var savedPlayerVelocity = CGVector.zero
    var playerDetectionDistance = 100.0
    var misslespeed = 1000.0
    
   
    override  init(texture: SKTexture?, color: UIColor, size: CGSize) {
          
        
        //Isnt used, decoder is used since created from SKCene
        let texture = SKTexture(imageNamed: "redtriangle")
        // Call the superclass's initializer
        super.init(texture: texture, color: UIColor.clear, size: texture.size())

       // self.physicsBody = SKPhysicsBody.init(rectangleOf: self.size)
        self.name = "EnemeyAttackDrone"
       // self.physicsBody!.categoryBitMask = PhysicsCategory.enemy
        //self.physicsBody!.mass = 100
        //self.physicsBody?.contactTestBitMask =  PhysicsCategory.playerProjectile | PhysicsCategory.player
        //self.physicsBody?.isDynamic = false
        //self.physicsBody?.usesPreciseCollisionDetection = true
            createEmmiters()
      }
      
      // Required initializer
      required init?(coder aDecoder: NSCoder) {
          // Initialize the new property before calling super
          
          // Call the superclass's required initializer
          super.init(coder: aDecoder)
          createEmmiters()
          
    
      }
    
    func createEmmiters(){
        
        if let fireParticles = SKEmitterNode(fileNamed: "Smoke") {
            
            
            fireParticles.name = "trail"
            // fireParticles.particleColor = .red
            self.addChild(fireParticles)
            fireParticles.position = CGPoint.init(x: -25, y: -50 )
            
            
            let colorSequence = SKKeyframeSequence(keyframeValues: [
                SKColor.red,  // Start color: White
                SKColor.red,    // Midway color: Red (at 10%)
                SKColor.clear   // End color: Black (at 90%)
            ], times: [
                0.0,   // White at 0% (start)
                0.5,   // Red at 10%
                1.0    // Black at 90% (last 10% of the lifetime)
            ])
            
            fireParticles.zPosition = 150
            fireParticles.particleColorSequence = colorSequence
            
        }
        
        
        if let fireParticles2 = SKEmitterNode(fileNamed: "Smoke") {
            
            
            fireParticles2.name = "trail2"
            // fireParticles.particleColor = .red
            self.addChild(fireParticles2)
            fireParticles2.position = CGPoint.init(x: 25, y: -50 )
            
            
            let colorSequence = SKKeyframeSequence(keyframeValues: [
                SKColor.red,  // Start color: White
                SKColor.red,    // Midway color: Red (at 10%)
                SKColor.clear   // End color: Black (at 90%)
            ], times: [
                0.0,   // White at 0% (start)
                0.5,   // Red at 10%
                1.0    // Black at 90% (last 10% of the lifetime)
            ])
            
            fireParticles2.zPosition = 150
            fireParticles2.particleColorSequence = colorSequence
            
        }
        
    }
    
    func createTriangle(at position: CGPoint, size: CGFloat, color: UIColor) -> SKShapeNode {
        // Create a path for the triangle
        let path = CGMutablePath()
        
        // Define triangle points
        let topPoint = CGPoint(x: 0, y: size)                 // Top vertex
        let bottomLeft = CGPoint(x: -size / 2, y: 0)          // Bottom left vertex
        let bottomRight = CGPoint(x: size / 2, y: 0)          // Bottom right vertex
        
        // Move to the starting point and draw the triangle
        path.move(to: topPoint)
        path.addLine(to: bottomLeft)
        path.addLine(to: bottomRight)
        path.closeSubpath() // Connect back to the starting point
        
        // Create an SKShapeNode with the triangle path
        let triangle = SKShapeNode(path: path)
        triangle.fillColor = color    // Fill color
        triangle.strokeColor = color  // Stroke color
        triangle.lineWidth = 1.0      // Border thickness
        
        triangle.physicsBody = SKPhysicsBody(polygonFrom: path)
        triangle.physicsBody!.isDynamic = false
        
            
        
        return triangle
    }
            
            
    func setupPhysicsNode(){
        
        
        self.physicsBody = SKPhysicsBody.init(rectangleOf: self.size)
        self.name = "EnemeyAttackDrone"
        self.physicsBody!.categoryBitMask = PhysicsCategory.enemy
        self.physicsBody!.mass = 100
        self.physicsBody?.contactTestBitMask =  PhysicsCategory.playerProjectile | PhysicsCategory.player
        self.physicsBody?.isDynamic = false
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    func setupDetectionNode() {
        
        if let enemeyType = self.userData?["enemeyType"] as? String {
            
            if (enemeyType == "Cone"){
                
                let coneSize = 150.0
                let detectionTriangle = createTriangle(at: CGPoint.zero, size: coneSize, color: UIColor.red)
                detectionTriangle.strokeColor = .red
                detectionTriangle.lineWidth = 4
                detectionTriangle.zRotation = CGFloat(degreesToradians(180))
                
                detectionTriangle.position.y = self.size.height / 2 + coneSize
                detectionTriangle.physicsBody!.contactTestBitMask = PhysicsCategory.player
                detectionTriangle.physicsBody!.categoryBitMask = PhysicsCategory.player_detection
                detectionTriangle.alpha = 0.025
                self.addChild(detectionTriangle)
            }
            else if (enemeyType == "Sniper") {
                
                let detectionLine = SKSpriteNode.init(color: .red, size: CGSize.init(width: 3, height: 3000))
                
                detectionLine.physicsBody = SKPhysicsBody(rectangleOf: CGSize.init(width: 3, height: 3000))
                detectionLine.position.y = 1500
                detectionLine.physicsBody!.isDynamic = false
                detectionLine.physicsBody!.contactTestBitMask = PhysicsCategory.player
                detectionLine.physicsBody!.categoryBitMask = PhysicsCategory.player_detection
                
                let wait_time = 4.0
                
                if let waitDelay =  self.userData?["sniperStartDelay"] as? Float {
                    
                    
                    detectionLine.run(SKAction.sequence([ SKAction.wait(forDuration: TimeInterval(waitDelay)), SKAction.repeatForever(SKAction.sequence( [SKAction.fadeAlpha(to: 0.0, duration: 0.5), SKAction.run {
                        detectionLine.physicsBody!.contactTestBitMask = PhysicsCategory.none
                        detectionLine.physicsBody!.categoryBitMask = PhysicsCategory.none
                    }, SKAction.wait(forDuration: wait_time), SKAction.fadeAlpha(to: 1.0, duration: 0.5),SKAction.run {
                        detectionLine.physicsBody!.contactTestBitMask = PhysicsCategory.player
                        detectionLine.physicsBody!.categoryBitMask = PhysicsCategory.player_detection
                    },  SKAction.wait(forDuration: wait_time)]))]))
                    
                } else {
                
                detectionLine.run(SKAction.repeatForever(SKAction.sequence( [SKAction.fadeAlpha(to: 0.0, duration: 0.5), SKAction.run {
                    detectionLine.physicsBody!.contactTestBitMask = PhysicsCategory.none
                    detectionLine.physicsBody!.categoryBitMask = PhysicsCategory.none
                }, SKAction.wait(forDuration: wait_time), SKAction.fadeAlpha(to: 1.0, duration: 0.5),SKAction.run {
                    detectionLine.physicsBody!.contactTestBitMask = PhysicsCategory.player
                    detectionLine.physicsBody!.categoryBitMask = PhysicsCategory.player_detection
                },  SKAction.wait(forDuration: wait_time)])))
                
                }
                    
                self.addChild(detectionLine)
                
                
            }
            
            } else {
                
              let detectionCircle = SKShapeNode(circleOfRadius: playerDetectionDistance  )
            detectionCircle.strokeColor = .red
            detectionCircle.lineWidth = 8
            let detectionCirclePhysicsBody = SKPhysicsBody.init(circleOfRadius: playerDetectionDistance , center: CGPoint.zero)
            detectionCirclePhysicsBody.isDynamic = false
                detectionCircle.physicsBody?.fieldBitMask = PhysicsCategory.none
            detectionCirclePhysicsBody.contactTestBitMask = PhysicsCategory.player
                detectionCirclePhysicsBody.collisionBitMask = PhysicsCategory.none
            detectionCirclePhysicsBody.categoryBitMask = PhysicsCategory.player_detection
                
                detectionCircle.physicsBody = detectionCirclePhysicsBody
            detectionCircle.alpha = 0.15
                detectionCircle.zPosition = 1001
            self.addChild(detectionCircle)
            }
        
        let lightNode = SKLightNode()
        lightNode.categoryBitMask = 1
        lightNode.falloff = SharedInfo.SharedInstance.default_light_falloff
        lightNode.lightColor = .systemRed
        lightNode.ambientColor = .clear
        lightNode.shadowColor = .clear
       // self.addChild(lightNode)
        
        let enemeyGlow = SKSpriteNode.init(imageNamed: "enemeyGlow")
        self.addChild(enemeyGlow)
        enemeyGlow.zPosition = 2
        enemeyGlow.setScale(13)
        enemeyGlow.alpha = 0.04
    }
    
    override func detectIfPlayerVisibleToNode(playerPosition: CGPoint, playerVelocity: CGVector){
        
        savedPlayerPosition = playerPosition
        savedPlayerVelocity = playerVelocity
        super.detectIfPlayerVisibleToNode(playerPosition: playerPosition, playerVelocity: playerVelocity)
        
        if (self.distanceToPlayer < playerDetectionDistance && hasLockedOnToPlayer == false ) {
            
            
            startAttacktOPlayer(playerPosition: playerPosition)
            
        } else if (self.distanceToPlayer < playerDetectionDistance && hasLockedOnToPlayer == true  )
        {
            let dx = playerPosition.x - self.position.x
            let dy = playerPosition.y - self.position.y
              let angle = atan2(dy, dx)
              
              // Rotate the sprite to face the target point
            self.zRotation = angle - .pi  / 2
        } else if ( self.distanceToPlayer >= playerDetectionDistance && hasLockedOnToPlayer == true ) {
            
            hasLockedOnToPlayer = false
            self.removeAction(forKey: "AttackAction")
        }
        
    }
    override func stopAttackOnPlayer() {
        removeAction(forKey: "AttackAction")
    }
    
    override func startAttacktOPlayer(playerPosition: CGPoint) {
        
        hasLockedOnToPlayer = true
       
        self.run(SKAction.sequence([SKAction.run {
            
            let fireNode = SKSpriteNode.init(color: .red, size: CGSize.init(width: 5, height: 50 ))
            fireNode.position = self.position
         
            fireNode.physicsBody = SKPhysicsBody.init(rectangleOf: fireNode.size , center: CGPoint.zero)
              
            fireNode.physicsBody?.categoryBitMask = PhysicsCategory.enemeyProjectile
            fireNode.physicsBody?.contactTestBitMask = PhysicsCategory.player
            
            fireNode.physicsBody?.isDynamic = false 
            fireNode.physicsBody?.usesPreciseCollisionDetection = true
            
              // Rotate the sprite to face the target point
            
            let dx = self.savedPlayerPosition.x - fireNode.position.x
            let dy = self.savedPlayerPosition.y - fireNode.position.y
            
            
            let angle = atan2(dy, dx)
            fireNode.zRotation = angle - .pi  / 2

            let distance = sqrt(dx * dx + dy * dy)
            let timeToReach = distance / self.misslespeed
            
           
            
            let predictedPlayerPosition = CGPoint(
                x: self.savedPlayerPosition.x, //+ self.savedPlayerVelocity.dx, //* timeToReach,
                y: self.savedPlayerPosition.y //+ self.savedPlayerVelocity.dy //* timeToReach
               )
            
            let predictedDx = predictedPlayerPosition.x - fireNode.position.x
            let predictedDy = predictedPlayerPosition.y - fireNode.position.y
            
                // Normalize the direction vector to get a unit vector
            let magnitude = sqrt(predictedDx * predictedDx + predictedDy * predictedDy)
            let direction = CGPoint(x: predictedDx / magnitude, y: predictedDy / magnitude)
    

                // Calculate the movement vector by scaling the direction vector by the desired speed
            let moveVector = CGPoint(x: direction.x * self.misslespeed, y: direction.y * self.misslespeed)

            self.parent!.addChild(fireNode)
            fireNode.run(SKAction.move(by: CGVector(dx: moveVector.x, dy: moveVector.y), duration: 0.5))
            
            
        }]), withKey: "AttackAction")
        
        
    }
    
    func sendAFockinLazerTowardsPlayer(lazaPosition: CGPoint, withBigBossNode: SKNode){
        
       
       
     
            
            let fireNode = SKSpriteNode.init(color: .red, size: CGSize.init(width: 5, height: 50 ))
            fireNode.position = lazaPosition
         
            fireNode.physicsBody = SKPhysicsBody.init(rectangleOf: fireNode.size , center: CGPoint.zero)
              
            fireNode.physicsBody?.categoryBitMask = PhysicsCategory.enemeyProjectile
            fireNode.physicsBody?.contactTestBitMask = PhysicsCategory.player
            
            fireNode.physicsBody?.isDynamic = false
            fireNode.physicsBody?.usesPreciseCollisionDetection = true
            
              // Rotate the sprite to face the target point
            
            let dx = self.savedPlayerPosition.x - fireNode.position.x
            let dy = self.savedPlayerPosition.y - fireNode.position.y
            
            
            let angle = atan2(dy, dx)
            fireNode.zRotation = angle - .pi  / 2

    

                // Calculate the movement vector by scaling the direction vector by the desired speed
            let moveVector = CGPoint(x: dx * self.misslespeed, y:dy * self.misslespeed)

        withBigBossNode.addChild(fireNode)
      
        fireNode.run(SKAction.move(by: CGVector(dx: moveVector.x, dy: moveVector.y), duration: 5.00))
            
            
    
        
        
        
    }
    
    func endAttackOnPlayer(){
        
    }
    
    
    func attackPlayerAtLocation(){
        
        
    }
    
    
}
