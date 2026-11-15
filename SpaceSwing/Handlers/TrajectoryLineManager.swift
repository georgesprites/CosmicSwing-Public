//
//  TrajectoryLineManager.swift
//  N Body No Problem
//
//  Created by Jorge Torres on 8/11/24.
//

import Foundation
import SpriteKit

class TrajectoryLineManager: SKNode {
    
    var nodesArray: [SKNode] = []
    var dotNodes: [SKSpriteNode] = []
    var updateTrajectory = false
    let lineSegmentWidth = 10
    let lineSegmentHeight = 5
    var segmentCount = 15
    var scaleFactor = 1.5
    
    func updateTrajectoryLine() {
        guard let firstNode = self.nodesArray.first else { return }
        
        if updateTrajectory {
               // Clear existing dots from the scene
            for dot in self.dotNodes {
                   dot.removeFromParent()
               }
            self.dotNodes = []

               // Prepare to collect new dots
               var nextNode: SKNode? = nil  // This will be the node each dot points to

            for (index, node) in self.nodesArray.enumerated().reversed() {
                   if self.dotNodes.count < segmentCount {
                       
                       /*
                        
                        Archived method to add trajectory node trying to calculate next node
                        Removing due to bug around rotation not being right with a jittery sprite moving along the path
                        
                       if self.nodesArray.indices.contains(index - 1 ) {
                           nextNode = self.nodesArray[index - 1]
                       } else {
                           nextNode = self.nodesArray[0]
                       }
                       let dot = self.addTrajectoryPathDot(at: node.position, nextNode:  nextNode ?? node)
                       self.dotNodes.append(dot)
                       */
                       
                       let segment = addTrajectoryPathSegmentWithVelocity(at: node.position, velocity: node.physicsBody!.velocity)
                       
                       segment.setScale(scaleFactor)
                       self.dotNodes.append(segment)
                       
                       
                       
                   }
                   nextNode = node  // Update nextNode to the current node for the next iteration
               }

            updateTrajectory = false
           }
      
       }
    
    func scale(value: CGFloat, fromRange sourceRange: ClosedRange<CGFloat>, toRange targetRange: ClosedRange<CGFloat>) -> CGFloat {
        let sourceMin = sourceRange.lowerBound
        let sourceMax = sourceRange.upperBound
        let targetMin = targetRange.lowerBound
        let targetMax = targetRange.upperBound
        
        // Map value from source range to target range
        return targetMin + ((value - sourceMin) / (sourceMax - sourceMin)) * (targetMax - targetMin)
    }
    
    func activateTrajectoryLine(savedVelocity: CGVector, forceVector: CGVector, savedAngularVelocity : CGFloat, nodeReference: SKNode, sceneReference: GameScene, withScaledValue: Int, useSavedVelocity: Bool){
        
        
        //self.segmentCount = Int(scale(value: CGFloat(withScaledValue), fromRange: 1...100, toRange: 1...15))

        self.scaleFactor = CGFloat(scale(value: CGFloat(withScaledValue), fromRange: 1...100, toRange: 1.0...1.5))
        
        self.removeAction(forKey: "NodePattern")

        
        
        self.run(SKAction.repeatForever(SKAction.sequence([  SKAction.run {
            
            
            var color = UIColor.white
            
            
            let node = SKSpriteNode.init(texture: nil, color: color, size: CGSize.init(width: 50, height: 50))
            
            self.addChild(node)
            
            node.physicsBody = SKPhysicsBody.init(rectangleOf: CGSize.init(width: 15, height: 30))
            node.physicsBody?.fieldBitMask = PhysicsCategory.gravityStar
            node.physicsBody?.isDynamic = true
            node.physicsBody?.collisionBitMask = PhysicsCategory.none
            node.physicsBody?.contactTestBitMask = PhysicsCategory.gravityStar | PhysicsCategory.earthplanet
            node.physicsBody?.categoryBitMask = PhysicsCategory.whip
            
        /*    if(SharedInfo.SharedInstance.saveVelocity ){
                node.physicsBody!.velocity = savedVelocity
                node.physicsBody!.angularVelocity = savedAngularVelocity
            }*/
            
            if(useSavedVelocity){
                node.physicsBody!.velocity = savedVelocity
                node.physicsBody!.angularVelocity = savedAngularVelocity
            } 
            
            node.physicsBody!.mass = 100
            
            
            node.position = nodeReference.position
            node.alpha = 0.0
            node.run(SKAction.sequence([SKAction.wait(forDuration: 0.6), SKAction.run {
                
                if let nodo =  self.nodesArray.first {
                    node.removeFromParent()
                    self.nodesArray.removeFirst()
                }
                
            }]))
            self.nodesArray.append(node)
            
            sceneReference.applyForce(to: node, vector: forceVector)
            
        }, SKAction.wait(forDuration: 0.016)])), withKey: "NodePattern")
        
        
        
    }
    
    func trajectoryLineIntersectedWithStar(dotNode: SKNode?){
        
        
        var count = 0
        for nodo in self.nodesArray {
            if let second = dotNode
            {
            if (nodo == dotNode){
                
                self.nodesArray.remove(at: count)
                nodo.removeAllActions()
                nodo.removeFromParent()
                break
                
            }
            
            count = count + 1
            }
        }
        if count > 0 {
            for currentIndex in 0...count  {
                
                if let nodo = self.nodesArray.first {
                nodo.removeAllActions()
                nodo.removeFromParent()
                self.nodesArray.removeFirst()
                }
            }}
        
    }
    
    func removeTrajectoryLine(){
        
        
        for dot in self.nodesArray {
            dot.removeAllActions()
            dot.removeFromParent()
            
        }
        
        for dot in self.dotNodes {
            
            dot.run(SKAction.sequence([
                SKAction.group([SKAction.scale(to: 1.5, duration: 0.25), SKAction.fadeAlpha(by: 0.0, duration: 0.25)]),
                SKAction.run {
                    dot.removeFromParent()
                }
            
            ]))
        }
        
    
        self.nodesArray = []
        self.removeAction(forKey: "NodePattern")
        
        
    }
    
    
    func addTrajectoryPathSegmentWithVelocity(at position: CGPoint, velocity: CGVector) -> SKSpriteNode {
        
        let dot = SKSpriteNode(texture: SharedInfo.SharedInstance.chevronTexture)
        dot.position = position
        
        // Predict the next position using velocity
        let predictedNextPosition = CGPoint(x: position.x + velocity.dx, y: position.y + velocity.dy)
        
        let dx = predictedNextPosition.x - position.x
        let dy = predictedNextPosition.y - position.y
        let angle = atan2(dy, dx)
        
        dot.zRotation = angle
        self.addChild(dot)
        return dot
    }
    
    
    func addTrajectoryPathDot(at position: CGPoint, nextNode: SKNode) -> SKSpriteNode {
        
        /*
         
         Archived method to add trajectory node trying to calculate next node
         Removing due to bug around rotation not being right with a jittery sprite moving along the path
         */ 
        
        let dot = SKSpriteNode.init(texture: SharedInfo.SharedInstance.chevronTexture)
        
        //SKSpriteNode(color: .white, size: CGSize(width: lineSegmentWidth, height: lineSegmentHeight))  // Appearance as a line
        dot.position = position
        
        
        
        let dx = nextNode.position.x - position.x
        let dy = nextNode.position.y - position.y
        let angle = atan2(dy, dx)
        dot.zRotation = angle  // Set rotation to point towards the next node
        
     self.addChild(dot)
        return dot
    }
    
}
