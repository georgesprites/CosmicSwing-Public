//
//  BackgroundCometStreakHandler.swift
//  SpaceSwing
//
//  Created by Jorge Torres on 1/31/25.
//

import Foundation
import SpriteKit

class BackgroundStarStreakHandler : SKNode {
    
    
    var random_wait_duration_time = 0.1
    func runStreak(){
        
       
                
        if let starStreakPartiles = SKEmitterNode(fileNamed: "starStreak") {
                    
                  
                    starStreakPartiles.name = "starStreakPartiles"
                    
                    starStreakPartiles.position = CGPoint.init(x: (SharedInfo.SharedInstance.screenSize.width * 2)  + 250, y:   CGFloat.random(in: -(SharedInfo.SharedInstance.screenSize.height * 2)  ... (SharedInfo.SharedInstance.screenSize.height * 2) ))
                    
                    starStreakPartiles.run(SKAction.sequence([ SKAction.moveBy(x: -(SharedInfo.SharedInstance.screenSize.width * 2) - 250, y: -(SharedInfo.SharedInstance.screenSize.width * 2) - 250 , duration: CGFloat.random(in: 0.1...2)), SKAction.wait(forDuration: 5), SKAction.run {
                        starStreakPartiles.removeFromParent()
                    }]))
                starStreakPartiles.alpha = 0.5
            starStreakPartiles.zPosition = -1
                    self.addChild(starStreakPartiles)
                    self.random_wait_duration_time = Double.random(in: 0.5...5)
                    self.run(SKAction.sequence([
                            SKAction.wait(forDuration: random_wait_duration_time),
                            SKAction.run {
                            self.runStreak()
                                }
                        ]))
                    starStreakPartiles.targetNode = self
                }
                
            
        
    }
}
