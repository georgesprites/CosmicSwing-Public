//
//  LevelCompleteMenu.swift
//  Foldobo
//
//  Created by Jorge Torres on 4/7/24.
//

import Foundation
import SpriteKit


class MissionFailedMenu: Menu {
    
    let menu = SKSpriteNode.init(imageNamed: "mission-failed-ui")
    
    var restartButton =  JKButtonNode(backgroundNamed: "retry-button")
    let showLevelPickerButton =  JKButtonNode.init(backgroundNamed: "mission-map-button")

    var homeButton =  JKButtonNode(backgroundNamed: "home-button-ui")
    
    var mission_top_banner = SKSpriteNode.init(imageNamed: "mission-failed-mission-button")
    var mission_failed_banner = SKSpriteNode(imageNamed: "failed-button-mission")
    
    
    override func setup(){
        
        
       
 
    
        self.setScale(1.10)
        self.zPosition = 100000
        
        
        self.addChild(mission_top_banner)
        self.addChild(mission_failed_banner)
        mission_top_banner.position.y = 150
        mission_failed_banner.position.y = 20
        restartButton.zPosition = 100000
        restartButton.position.y =  -restartButton.size.height
        restartButton.action = self.restartButtonPressed
        
        showLevelPickerButton.zPosition = 100000
        showLevelPickerButton.position.y =  -restartButton.size.height * 2 - 20
   
        
        restartButton.run(SKAction.repeatForever(SKAction.sequence([
            
            SKAction.scale(to: 1.1, duration: 0.2),
            SKAction.scale(to: 1, duration: 0.2)
            
        ])))
        
        showLevelPickerButton.run(SKAction.repeatForever(SKAction.sequence([
            
            SKAction.wait(forDuration: 5),
            SKAction.scale(to: 1.2, duration: 0.05),
            SKAction.scale(to: 1, duration: 0.05),
            SKAction.scale(to: 1.2, duration: 0.05),
            SKAction.scale(to: 1, duration: 0.05)
            
        ])))
        
        self.addChild(restartButton)
        self.addChild(showLevelPickerButton)
        
       
        
        
        homeButton.zPosition = 101
        homeButton.position.y =  -homeButton.size.height / 3
        homeButton.position.x =  -homeButton.size.height / 2 - 10
        homeButton.action = self.homeButtonPressed
     //   self.addChild(homeButton)
        
        
    }
    
  
    
    func restartButtonPressed(button: JKButtonNode){
        
        self.hide()
     
      
    }
    
    func homeButtonPressed(button: JKButtonNode){
        
        self.hide()
     
      
    }
  
    override func menuTriggered(){
        
        self.show()
        
        
        
        
        
        self.run(SharedInfo.SharedInstance.audioHandler.playSoundWithName(fileName: "vine-boom-392646"))
               

               
    }
    
    override func show(){
        
        let animation_duration =  0.25
        let waitTimeBetweenScale = 0.25
        
        
        
        mission_top_banner.position.x = mission_top_banner.position.x  - 500
        mission_top_banner.run(SKAction.moveBy(x: 500, y: 0, duration: animation_duration))
        
        
        mission_failed_banner.position.x = mission_failed_banner.position.x  + 500
        mission_failed_banner.run(
            SKAction.sequence([SKAction.wait(forDuration: 0.25 * waitTimeBetweenScale),  SKAction.moveBy(x: -500, y: 0, duration: animation_duration )]))
            
            
        
        let wait_time_for_restart_and_levelpicker = 2.0
        
        restartButton.position.x = restartButton.position.x  - SharedInfo.SharedInstance.screenSize.width
        restartButton.run(
            SKAction.sequence([SKAction.wait(forDuration: wait_time_for_restart_and_levelpicker * waitTimeBetweenScale ),  SKAction.moveBy(x: SharedInfo.SharedInstance.screenSize.width , y: 0, duration: animation_duration )]))
            
            
        
        
        showLevelPickerButton.position.x = showLevelPickerButton.position.x  + SharedInfo.SharedInstance.screenSize.width
        showLevelPickerButton.run((
            SKAction.sequence([SKAction.wait(forDuration: wait_time_for_restart_and_levelpicker * waitTimeBetweenScale),  SKAction.moveBy(x: -SharedInfo.SharedInstance.screenSize.width , y: 0, duration: animation_duration )])))
        
        super.show()
    }
    
    
}
