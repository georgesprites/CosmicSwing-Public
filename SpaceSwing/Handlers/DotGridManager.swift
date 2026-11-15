//
//  DotGridManager.swift
//  N Body No Problem
//
//  Created by Jorge Torres on 4/21/24.
//

import Foundation
import SpriteKit

class DotGridManager: SKSpriteNode {
    
    
    var dots = [DotNode]()
    var dotSpacing: CGFloat = 40
    var gridSize: CGSize = CGSize.init(width: 60, height: 110)
    var dotSize = CGSize(width: 5.0, height: 5.0)
    var collectedDotCallback : (() -> Void)? = nil
    
    var allDotsCompletedAnimationCallback : (() -> Void)? = nil
    func setupDots( scene: SKScene, withCameraPos: CGPoint, withDotSpacing: Int = 40, dotGridSize: CGSize = CGSize.init(width: 60, height: 110), passed_dotSize: Int = 5 ) {
        
        dotSize = CGSize.init(width: CGFloat(passed_dotSize), height: CGFloat(passed_dotSize))
        
        gridSize = dotGridSize
        
        dotSpacing = CGFloat(withDotSpacing)
        let coreWidth = 800.0
        let coreHeight = 2000.0
        
            // Clear existing dots from the parent node
            for dot in dots {
                dot.removeFromParent()
            }
            
            dots.removeAll()
            
            let centerX = scene.frame.midX
            let centerY = scene.frame.midY
            let numDotsX = Int(gridSize.width)
            let numDotsY = Int(gridSize.height)
            
            // Define the boundaries within which dots will have uniform spacing
            let halfCoreWidth = coreWidth / 2.0
            let halfCoreHeight = coreHeight / 2.0
            
            // Define the exponential growth rate and the width of the transition area
            let growthRate: CGFloat = 0.2  // This is the base growth rate
            let transitionWidth: CGFloat = 200.0  // Width of the gradual transition area

            for x in 0..<numDotsX {
                for y in 0..<numDotsY {
                    // Position index starting from the middle of the grid
                    let deltaX = CGFloat(x - numDotsX / 2)
                    let deltaY = CGFloat(y - numDotsY / 2)
                    
                    let absDeltaX = abs(deltaX)
                    let absDeltaY = abs(deltaY)
                    
                    // Determine if the dot is outside the core area and in the transition area
                    let distanceOutsideCoreX = max(0, absDeltaX - halfCoreWidth / dotSpacing)
                    let distanceOutsideCoreY = max(0, absDeltaY - halfCoreHeight / dotSpacing)
                    
                    let factorX = distanceOutsideCoreX / transitionWidth
                    let factorY = distanceOutsideCoreY / transitionWidth
                    
                    // Smooth transition factor using a sigmoid-like function (tanh)
                    let smoothFactorX = tanh(factorX)
                    let smoothFactorY = tanh(factorY)
                    
                    // Apply exponential factor gradually transitioning to full growth rate
                    let expFactorX = exp(growthRate * smoothFactorX * distanceOutsideCoreX)
                    let expFactorY = exp(growthRate * smoothFactorY * distanceOutsideCoreY)
                    
                    // Calculate final positions
                    let finalX = centerX + deltaX * dotSpacing * expFactorX
                    let finalY = centerY + deltaY * dotSpacing * expFactorY
                    
                    // Create the dot node and add to the scene
                    let dot = DotNode(color: SharedInfo.SharedInstance.dotColor, size: dotSize)
                        self.addChild(dot)
                    dot.runInitialAnimation(initialPosition: CGPoint(x: finalX, y: finalY), withCameraPos: withCameraPos)
                 
                    
                    dots.append(dot)
                   
                }
            }
        
       
        }
    
    
    func vector(from startPoint: CGPoint, to endPoint: CGPoint) -> CGVector {
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        return CGVector(dx: dx, dy: dy)
    }
    
    
    func hyperSpaceNextLevelTransition(withCameraPos: CGPoint){
        for dot in dots {
          
            
            
            let randWaitTIme = Double.random(in: 0.0 ... 0.5)

            let randSpeedTIme = Double.random(in: 0.0 ... 0.5)
            
            let movementVector = vector(from: withCameraPos, to: dot.position)

            
            dot.run(SKAction.sequence([
                SKAction.wait(forDuration: randWaitTIme),
                SKAction.group([ SKAction.fadeAlpha(to: 0.0, duration: randSpeedTIme),             SKAction.move(by: CGVector.init(dx: movementVector.dx * 20, dy: movementVector.dy * 20), duration: randSpeedTIme), SKAction.scale(to: 5.0, duration: randSpeedTIme) ])
    
            ,  SKAction.run {
                dot.removeFromParent()
            }]))
            
            
            
        }
        
        dots = []
    }
    
    func updateDotPositions(gravityNodes: [GravityNode], playerPos: CGPoint, shouldCollectDots: Bool) {
        
        
        var index = 0
        for dot in dots  {
            
            let distance = hypot(playerPos.x - dot.position.x, playerPos.y - dot.position.y)
            

            
                
            
            if let ogDotPosition = dot.originalPosition {
            var totalShift = CGVector(dx: 0, dy: 0)
            
            var totalDisplacement = 0.0
            for gravity_node in gravityNodes {
                let dx = gravity_node.converted_position.x - ogDotPosition.x
                let dy = gravity_node.converted_position.y - ogDotPosition.y
                let distance = sqrt(dx * dx + dy * dy)
                
                if distance < gravity_node.radius && distance > 0 {  // Ensure distance is not zero to avoid division by zero
                    var displacementFactor = gravity_node.strength * (1 - (distance / gravity_node.radius))
                    if (displacementFactor > distance){
                        displacementFactor = distance
                    }
                    totalShift.dx += (dx / distance) * displacementFactor
                    totalShift.dy += (dy / distance) * displacementFactor
                    
                    let displacementratio = displacementFactor / distance
                    totalDisplacement = displacementratio + totalDisplacement
                    
                    // Apply the calculated shift from the original position
                   
                    
                }}
                
                
                
                if(distance < 45 && dot.hasBeenCollected == false && dot.canBeCollected && shouldCollectDots && SharedInfo.SharedInstance.dotCollectionFeature ){
                    
                    dot.hasBeenCollected = true
                    dot.runningColectionAnimation = true
                    let savedScalex = dot.xScale
                    let savedScaley = dot.yScale
                    
                    
                    dot.run(SKAction.sequence([SKAction.scale(to: 3.0, duration: 0.25), SKAction.run {
                        dot.runningColectionAnimation = false
                        if let callback = self.collectedDotCallback {
                            
                            callback()
                        }
                    }]))
                    
                    let miniDot = SKSpriteNode.init(texture: SharedInfo.SharedInstance.dotTexture)
                    
                    miniDot.position = dot.position
                    let animation_duration = 0.25
                    miniDot.setScale(0.25)
                    miniDot.run(SKAction.group([
                        SKAction.move(to: playerPos, duration: animation_duration),
                        SKAction.fadeAlpha(to: 0, duration: animation_duration),
                        SKAction.scale(to: 0.0, duration: animation_duration)
                    
                    ]))
                    
                
                    
                    
                           
                    self.run(SharedInfo.SharedInstance.audioHandler.playSoundWithName(fileName: "popo4"))
                 
                 
                    
                    self.addChild(miniDot)
                    
                    dot.texture = SharedInfo.SharedInstance.dotTexture
                }
            
                
                if((totalDisplacement < dot.default_dot_scale - 0.50) && dot.runningColectionAnimation == false ){
                    
                    dot.canBeCollected = true
                    dot.setScale(dot.default_dot_scale - totalDisplacement)
                  
                    if(dot.running_phasein_animation == false ){
                    dot.run(SKAction.fadeAlpha(to: dot.default_dot_alpha, duration: 0.25))
                    }
                    
                } else {
                    //dot.setScale(0.0)
                    
                    dot.canBeCollected = false
                    dot.run(SKAction.fadeAlpha(to: 0.0, duration: 0.25))
                }
                
            dot.position = CGPoint(x: ogDotPosition.x + totalShift.dx,
                                   y: ogDotPosition.y + totalShift.dy)
                dot.lightingBitMask = 1

            }
          
            
            index = index + 1
        }
    }
  
    var number_of_dots_checked_in = 0
    
    func explodeStarsInRelationToPosition(collapse_position: CGPoint,  blastDistance: CGFloat = 1000, duration: TimeInterval = 0.30) {
        
        
        for dot in dots {

                // Current position in its parent's coordinate space
                let starPos = dot.position

                // Vector from player -> star
                let dx = starPos.x - collapse_position.x
                let dy = starPos.y - collapse_position.y
                let len = max(sqrt(dx*dx + dy*dy), 0.001)

                // Normalize + add a little randomness so it looks organic
                let nx = dx / len
                let ny = dy / len

                let jitterAngle = CGFloat.random(in: -0.35...0.35)
                let cosA = cos(jitterAngle)
                let sinA = sin(jitterAngle)

                let jx = nx * cosA - ny * sinA
                let jy = nx * sinA + ny * cosA

                let dist = blastDistance * CGFloat.random(in: 0.7...1.3)

                let target = CGPoint(x: starPos.x + jx * dist,
                                     y: starPos.y + jy * dist)

                // Actions
                let move = SKAction.move(to: target, duration: duration)
                move.timingMode = .easeOut

                let fade = SKAction.fadeAlpha(to: 0.0, duration: duration * 0.9)
                fade.timingMode = .easeOut

                // Optional juice (safe for any SKNode)
                let rotate = SKAction.rotate(byAngle: CGFloat.random(in: -0.8...0.8), duration: duration)


                // Stagger very slightly for a wave feel
                let delay = SKAction.wait(forDuration: TimeInterval(CGFloat.random(in: 0.0...0.06)))

                dot.run(.sequence([
                    delay,
                    .group([move])
                ]), withKey: "starExplode")
            }
        
    }
    
    func pointDotsToPosition(collapse_position: CGPoint , withTimeFactor: CGFloat = 0.5) {
        
        
        
        for dot in self.dots {
            
            dot.beforeImplosionPostion = dot.position
            dot.beforeImplosionAlpha = dot.alpha
            var in_frame = false
            
            if dot.position.x <  SharedInfo.SharedInstance.screenSize.width   && dot.position.x > -SharedInfo.SharedInstance.screenSize.width  && dot.position.y < SharedInfo.SharedInstance.screenSize.height  && dot.position.y > -SharedInfo.SharedInstance.screenSize.height  {
                
                in_frame = true
            }
            
            if (in_frame == false) {
                
                continue
            }
            
            number_of_dots_exploded = number_of_dots_exploded + 1
            
            let duration_random: TimeInterval = CGFloat.random(in: (0.001 * withTimeFactor)...(0.25 * withTimeFactor))
             
            var move_to_action = SKAction.move(to: collapse_position, duration: duration_random)
            
            var bubble_effect =  SKAction.sequence([ SKAction.scale(by: CGFloat.random(in: 2...6), duration: CGFloat.random(in: 0.1...0.5)), SKAction.scale(to: CGFloat.random(in: 1...2), duration: CGFloat.random(in: 0.1...0.5))])
            
            dot.removeAllActions()
            dot.run(SKAction.sequence([
                SKAction.wait(forDuration: CGFloat.random(in: (0.001  * withTimeFactor)...(0.5  * withTimeFactor) )),
                bubble_effect,
                SKAction.wait(forDuration: CGFloat.random(in: (0.001  * withTimeFactor)...(0.5  * withTimeFactor))),
                SKAction.group([
                    SKAction.colorize(with: .white, colorBlendFactor: 1.0, duration: duration_random),
                    move_to_action,
                    SKAction.scale(to: 1.0, duration: duration_random),
                    SKAction.fadeAlpha(to: 0.0, duration: CGFloat.random(in: (0.5 * withTimeFactor)...(1 *  withTimeFactor)))
                ]),
                                      
                                        SKAction.run {
                                            
                                            
                                            self.dotCompletedPointToAnimation()
                                            
                                        }
                                      ]))
            
            
            
            
            
        }
        
        var wait_index = 0.0
        for i in 0..<200 {
            wait_index = wait_index + 0.001
            DispatchQueue.main.asyncAfter(deadline: .now() + (0.005 * Double(i))) {
                let streak_node = SKSpriteNode(color: .white, size: CGSize(width: Int.random(in: 50...100), height: Int.random(in: 1...5)))
                
                let randomX = CGFloat.random(in: (-SharedInfo.SharedInstance.screenSize.width * 2)...SharedInfo.SharedInstance.screenSize.width * 2 )
                let randomY = CGFloat.random(in: (-SharedInfo.SharedInstance.screenSize.height * 2)...SharedInfo.SharedInstance.screenSize.height * 2 )
                streak_node.position = CGPoint(x: randomX, y: randomY)

                let dx = collapse_position.x - streak_node.position.x
                let dy = collapse_position.y - streak_node.position.y
                streak_node.zRotation = atan2(dy, dx)
                
                streak_node.setScale(CGFloat.random(in: 0.5...2))
                self.addChild(streak_node)
                
                self.alpha = CGFloat.random(in: 0.1...1.5)
                
                let animation_duration  = CGFloat.random(in: 0...0.25)
                streak_node.run(
                    
                    SKAction.sequence([
                    
                        SKAction.wait(forDuration: (0.1 + wait_index) ),
                        
                    SKAction.group([
                    SKAction.fadeAlpha(to: 1.0, duration: animation_duration),
                    SKAction.scale(to: 0.0, duration: animation_duration),
                    SKAction.move(to: collapse_position, duration: animation_duration)
                ]) ]) )
            }
        }
        
        
    }

    
    var number_of_dots_exploded = 0
    
    func dotCompletedPointToAnimation(){
        
        number_of_dots_checked_in = number_of_dots_checked_in + 1
        
        if(number_of_dots_checked_in == number_of_dots_exploded){
            
            number_of_dots_checked_in = 0
            for dot in dots {
                dot.running_phasein_animation = true
                
                let random_delay = CGFloat.random(in: 0.0...0.3)
                
                dot.run( SKAction.sequence([
                    
                    SKAction.wait(forDuration: 0.1), // Wait a bit before exploding to allow the ship launch animation to sync
                    
                    SKAction.group([
                        
                        SKAction.colorize(withColorBlendFactor: 0.0, duration: random_delay),
                        SKAction.move(to: dot.beforeImplosionPostion, duration: random_delay),
                        SKAction.fadeAlpha(to: dot.beforeImplosionAlpha, duration: random_delay)
                    ])
                   , SKAction.run {
                    dot.running_phasein_animation = false
                }]))
            
               }
            
            
            self.run(SKAction.sequence([
                SKAction.wait(forDuration: 0.25),
                SKAction.run {
                    
                    self.allDotsCompletedAnimationCallback!()

                }
                
                
            ]))
            number_of_dots_exploded = 0
        }
        
    }
    
    
    func addDot(at position: CGPoint, nextNode: SKNode) -> SKSpriteNode {
        let dot = SKSpriteNode(color: .white, size: CGSize(width: 10, height: 10))  // Appearance as a line
        dot.position = position
        dot.lightingBitMask = 1
        let dx = nextNode.position.x - position.x
        let dy = nextNode.position.y - position.y
        let angle = atan2(dy, dx)
        dot.zRotation = angle  // Set rotation to point towards the next node

        addChild(dot)
        return dot
    }
    
    func updateDotPosition( dot: SKSpriteNode, position: CGPoint, nextNode: SKNode){

        dot.position = position
        dot.lightingBitMask = 1
        let dx = nextNode.position.x - position.x
        let dy = nextNode.position.y - position.y
        let angle = atan2(dy, dx)
        dot.zRotation = angle  // Set rotation to point towards the next node
    }
    
}
