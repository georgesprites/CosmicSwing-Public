//
//  MiniLevelIndicato.swift
//  SpaceSwing
//
//  Created by Jorge Torres on 1/15/25.
//

import Foundation
import SpriteKit

class MiniLevelIndicator: JKButtonNode {
    
        var levelID = 0
        var numberOfStarsCompleted =  0
    
        var starLeft = SKSpriteNode()
        var starCenter = SKSpriteNode()
        var starRight = SKSpriteNode()
        var starLeftDark = SKSpriteNode()
        var starCenterDark = SKSpriteNode()
        var starRightDark = SKSpriteNode()
        
        var levelData : Level? = nil
    
    func setup(withLevelID: Int, numberOfStarsCompelted: Int, isCurrentMission: Bool = false, levelData: Level ){
            
            
            self.numberOfStarsCompleted = numberOfStarsCompelted
            self.levelID = withLevelID
            
            
            
         
           // label.position.y = -self.size.height / 8
           
        if(levelData.Unlocked == true ) {
            
            
            let label = SKSpriteNode.init(imageNamed:  String(withLevelID))
            label.zPosition = 1001
        
            self.addChild(label)
            label.position.x = -self.size.width / 2 + 50
            
            
            if(isCurrentMission) {
                
                let newLabel = SKSpriteNode.init(imageNamed: "new-iimage")
                newLabel.position.x = self.size.width / 2 - (newLabel.size.width  )
                newLabel.zPosition = 1001
                self.addChild(newLabel)
                newLabel.run(SKAction.repeatForever(
                    
                    SKAction.sequence([
                        
                        SKAction.scale(to: 1.1, duration: 0.1),
                        SKAction.scale(by: 0.9, duration: 0.1)
                        
                        
                    ] )
                    
                ))
                return
                
            }
            
            let blackStarTexture = SKTexture.init(imageNamed: "star-black")
            let completedStarTexture = SKTexture.init(imageNamed: "Star")
            
            let leftStarMargin = 20.0
            
            var star1Texture = SKTexture()
            if(numberOfStarsCompelted >= 3){
                star1Texture = completedStarTexture
            } else  {
                star1Texture = blackStarTexture
                
            }
            
                starCenterDark = SKSpriteNode.init(texture: star1Texture)
            self.addChild(starCenterDark)
          //  starExample.position.y = self.size.height / 2 + starExample.size.height / 2 + 5
                starCenterDark.position.x = self.size.width / 2 - (starCenterDark.size.width * 2) - 10
                starCenterDark.zPosition = 1001

            var star2Texture = SKTexture()
            if(numberOfStarsCompelted >= 1){
                star2Texture = completedStarTexture
            } else  {
                star2Texture = blackStarTexture
                
            }
            
            starLeftDark = SKSpriteNode.init(texture: star2Texture)
            self.addChild(starLeftDark)

          //  starExample2.position.y = self.size.height / 2 + 10
                starLeftDark.position.x = self.size.width / 2 - (starCenterDark.size.width * 3) - 10

                starLeftDark.zPosition = 1001

            var star3Texture = SKTexture()
            if(numberOfStarsCompelted >= 2){
                star3Texture = completedStarTexture
            } else  {
                star3Texture = blackStarTexture
                
            }
            
             starRightDark = SKSpriteNode.init(texture: star3Texture)
                self.addChild(starRightDark)

       //     starExample3.position.y = self.size.height / 2 + 10
                starRightDark.position.x = self.size.width / 2 - (starCenterDark.size.width ) - 10
                starRightDark.zPosition = 1001
            
            
            
        } else if (isCurrentMission){
            
        } else {
            
            
            let label = SKSpriteNode.init(imageNamed:  "lockicon")
            label.zPosition = 1001
        
            self.addChild(label)
            
        }
        }
        
    
    func runAnimatedLevelCompletionAnimation(){
        
        starLeftDark.texture = SKTexture.init(imageNamed: "star-black")
        starRightDark.texture = SKTexture.init(imageNamed: "star-black")
        starCenterDark.texture = SKTexture.init(imageNamed: "star-black")
        
        if(numberOfStarsCompleted == 3){
            
            
            let newStar = SKSpriteNode.init(imageNamed: "Star")
            newStar.setScale(2.3)
            newStar.position = starCenterDark.position
            newStar.zRotation = starCenterDark.zRotation
            newStar.zPosition = 1002
            newStar.alpha = 0.0
            newStar.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.group([SKAction.scale(to: 1.3, duration: 0.5), SKAction.fadeAlpha(to: 1.0, duration: 0.25)])]))
            self.addChild(newStar)
            
            
            
        }
        
        
        if(numberOfStarsCompleted >= 2){
            
            
            let newStar = SKSpriteNode.init(imageNamed: "Star")
            newStar.setScale(2.3)
            newStar.position = starRightDark.position
            newStar.zRotation = starRightDark.zRotation
            newStar.zPosition = 1002
            newStar.alpha = 0.0
            newStar.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),SKAction.group([SKAction.scale(to: 1.0, duration: 0.5), SKAction.fadeAlpha(to: 1.0, duration: 0.25)])]))
            self.addChild(newStar)
            
        }
        
        
        if(numberOfStarsCompleted >= 1){
            
            
            let newStar = SKSpriteNode.init(imageNamed: "Star")
            newStar.setScale(2.3)
            newStar.position = starLeftDark.position
            newStar.zRotation = starLeftDark.zRotation
            newStar.zPosition = 1002
            newStar.alpha = 0.0
            newStar.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),SKAction.group([SKAction.scale(to: 1.0, duration: 0.5), SKAction.fadeAlpha(to: 1.0, duration: 0.25)])]))
            self.addChild(newStar)
            
        }
        
        self.run(SKAction.sequence([ SKAction.wait(forDuration: 1.0), SKAction.scale(to: 0.55, duration: 0.05), SKAction.scale(to: 1.35, duration: 0.10), SKAction.scale(to: 1.0, duration: 0.05)]))
        
        
        
    }
    
    
    
}
