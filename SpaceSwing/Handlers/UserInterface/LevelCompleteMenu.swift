//
//  LevelCompleteMenu.swift
//  Foldobo
//
//  Created by Jorge Torres on 4/7/24.
//

import Foundation
import SpriteKit


class LevelCompleteMenu: Menu {
    
    var stars : [SKSpriteNode] = []
    let menu = SKSpriteNode.init(imageNamed: "levelcomplete")
    let routeLabel = SKLabelNode()
    let routeName = SKLabelNode()
    let elpasedTimeLabel = SKLabelNode(text: "0' 00''")
    let challangeLabel1 = ChallangeLabelWithStar()
    let challangeLabel2 = ChallangeLabelWithStar()
    let challangeLabel3 = ChallangeLabelWithStar()
    
    let upperStarLeft = SKSpriteNode.init(imageNamed: "star-blank-big-left")
    let upperStarRight = SKSpriteNode.init(imageNamed: "star-blank-big-left")
    let upperStarCenter = SKSpriteNode.init(imageNamed: "star-blank-big-middle")
    
    var achievementLabels : [SKLabelNode] = []
    var continueButton =  JKButtonNode(backgroundNamed: "continuebuttton")
    var continueDelegateMethod : (()->Void)? = nil
    
    let missionBanner = SKSpriteNode.init(imageNamed: "mission-banner")
    let completeBanner = SKSpriteNode.init(imageNamed: "complete-banner")
    let starmiddle = SKSpriteNode.init(imageNamed: "star-middlev2")
    let starleft = SKSpriteNode.init(imageNamed: "star-middlev2")
    let starright = SKSpriteNode.init(imageNamed: "star-middlev2")
    let astros_saved_banner = SKSpriteNode.init(imageNamed: "astros-saved-banner")
    let astros_saved_input = SKSpriteNode.init(imageNamed: "astros-saved-inputbox")
    let stopwatch = SKSpriteNode.init(imageNamed: "stopwatch")
    let stopwatch_bkg = SKSpriteNode.init(imageNamed: "challange-bkg-star")
    let challanges = SKSpriteNode.init(imageNamed: "challanges")
    let challange_star_1 = SKSpriteNode.init(imageNamed: "challange-star-v2")
    let challange_bkg_star = SKSpriteNode.init(imageNamed: "challange-bkg-star")
    let challange_star_2 = SKSpriteNode.init(imageNamed: "challange-star-v2")
    let challange_bkg_star_2 = SKSpriteNode.init(imageNamed: "challange-bkg-star")
    let challange_star_3 = SKSpriteNode.init(imageNamed: "challange-star-v2")
    let challange_bkg_star_3 = SKSpriteNode.init(imageNamed: "challange-bkg-star")
    
    var animationCompletedCallbackFunction : (()->Void)? = nil 
    
    func setup(withChallangeData: [Challenge]){
        
      
        
        starmiddle.position.y = starmiddle.size.height / 1.5
        starmiddle.zPosition = -1
        self.addChild(starmiddle)
        starmiddle.alpha = 0.0
        
        starleft.position.y = starmiddle.size.height / 1.75
        starleft.position.x = -starmiddle.size.width / 1.25
        starleft.zPosition = -1
        starleft.zRotation = CGFloat(degreesToradians(30))
        starleft.setScale(0.75)
        starleft.alpha = 0.0
        self.addChild(starleft)
        
        starright.position.y = starmiddle.size.height / 1.75
        starright.position.x = starmiddle.size.width / 1.25
        starright.zPosition = -1
        starright.zRotation = CGFloat(degreesToradians(-30))
        starright.setScale(0.75)
        starright.alpha = 0.0
        self.addChild(starright)
        
        self.addChild(missionBanner)
        missionBanner.position.x = -SharedInfo.SharedInstance.screenSize.width
        missionBanner.position.y = 50
        completeBanner.position.y = -completeBanner.size.height / 1.30
        completeBanner.position.x = SharedInfo.SharedInstance.screenSize.width
        self.addChild(completeBanner)
        
        let exclamationMark = SKSpriteNode.init(imageNamed: "complete-exlacamion")
        exclamationMark.position.x = completeBanner.size.width / 2
        exclamationMark.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.scale(to: 1.1, duration: 0.1),
            SKAction.scale(to: 1.0, duration: 0.1)
        ])))
        exclamationMark.zPosition = 1
        completeBanner.addChild(exclamationMark)
        
        astros_saved_banner.position.y = completeBanner.position.y - completeBanner.size.height / 1.2
        astros_saved_banner.position.x = -SharedInfo.SharedInstance.screenSize.width
        self.addChild(astros_saved_banner)
        
        
        
        astros_saved_input.position.y = astros_saved_banner.position.y - astros_saved_banner.size.height / 2 -  astros_saved_input.size.height / 1.75
        
        astros_saved_input.position.x = SharedInfo.SharedInstance.screenSize.width
        
        self.addChild(astros_saved_input)
        
        
        
        
        stopwatch.position.y = astros_saved_input.position.y - astros_saved_input.size.height / 2 -  stopwatch.size.height / 1.75
        
        stopwatch.position.x =  -SharedInfo.SharedInstance.screenSize.width / 2 + (SharedInfo.SharedInstance.screenSize.width / 7)
        
        stopwatch.position.x = stopwatch.position.x - SharedInfo.SharedInstance.screenSize.width
        
        stopwatch.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.scale(to: 1.1, duration: 0.1),
            SKAction.scale(to: 1.0, duration: 0.1)
        ])))
        
        self.addChild(stopwatch)
        stopwatch.zPosition = 1
        
        

        stopwatch_bkg.position.y = stopwatch.position.y
        stopwatch_bkg.position.x = SharedInfo.SharedInstance.screenSize.width
        self.addChild(stopwatch_bkg)
        
        challanges.position.y = stopwatch.position.y - stopwatch.size.height / 2 -  challanges.size.height / 1.75
        
        challanges.position.x = SharedInfo.SharedInstance.screenSize.width
        self.addChild(challanges)
        
    
        challange_star_1.position.y = challanges.position.y - challanges.size.height / 2 -  challange_star_1.size.height / 1.75
        challange_star_1.zPosition = 1
        challange_star_1.position.x =    -SharedInfo.SharedInstance.screenSize.width / 2 + challange_star_1.size.width * 1.6
        challange_star_1.position.x = challange_star_1.position.x -  SharedInfo.SharedInstance.screenSize.width
        self.addChild(challange_star_1)
        
      
        challange_bkg_star.position.y = challange_star_1.position.y
        challange_bkg_star.position.x = SharedInfo.SharedInstance.screenSize.width
        self.addChild(challange_bkg_star)
        
          
        
        
        
        challange_star_2.position.y = challange_star_1.position.y - challange_star_1.size.height / 2 -  challange_star_2.size.height / 1.75
        challange_star_2.zPosition = 1
        challange_star_2.position.x =    -SharedInfo.SharedInstance.screenSize.width / 2 + challange_star_2.size.width * 1.6
        challange_star_2.position.x = challange_star_2.position.x -  SharedInfo.SharedInstance.screenSize.width
        self.addChild(challange_star_2)
        
        
        challange_bkg_star_2.position.y = challange_star_2.position.y
        challange_bkg_star_2.position.x = SharedInfo.SharedInstance.screenSize.width
        self.addChild(challange_bkg_star_2)
        
        
        
        
        challange_star_3.position.y = challange_star_2.position.y - challange_star_2.size.height / 2 -  challange_star_2.size.height / 1.75
        challange_star_3.zPosition = 1
        challange_star_3.position.x =    -SharedInfo.SharedInstance.screenSize.width / 2 + challange_star_3.size.width * 1.6
        
        challange_star_3.position.x = challange_star_3.position.x -  SharedInfo.SharedInstance.screenSize.width
        self.addChild(challange_star_3)
        
        
        challange_bkg_star_3.position.y = challange_star_3.position.y
        challange_bkg_star_3.position.x = SharedInfo.SharedInstance.screenSize.width
        self.addChild(challange_bkg_star_3)
        
     
        self.zPosition = 1000

        continueButton.alpha = 0.0
        continueButton.zPosition = 101
        continueButton.position.y = challange_bkg_star_3.position.y - challange_bkg_star_3.size.height / 2 - continueButton.size.height / 1.7
        continueButton.action = self.continueButtonPressed
        self.addChild(continueButton)
        continueButton.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.scale(to: 1.2, duration: 0.05),
            SKAction.scale(to: 1.0, duration: 0.05),
            SKAction.scale(to: 1.2, duration: 0.05),
            SKAction.scale(to: 1.0, duration: 0.05),
            SKAction.wait(forDuration: 0.5)
        
        ])))
        
        
        
        
        
        
    }
    
    override func hide(){
        self.alpha = 0.0
    }
    
    var startTime = Date()
    var completedTimeIn = TimeInterval()
    private var elapsedTimeString: String = "0"// Total elapsed time
    
    func setElapsedTime()  {
       
        var counterTime = TimeInterval(0)
        // Calculate elapsed time in seconds (including fractional part for milliseconds)
        completedTimeIn = Date().timeIntervalSince(startTime)
        
        
     
        let totalCount = Int(completedTimeIn / 0.01)
          
        
        self.run(SKAction.repeat( SKAction.sequence([SKAction.run {
            
            counterTime += 0.01
            
          
            let randomThirdDigit = Int.random(in: 0...9)          // Random third digit (0-9)

            let totalMilliseconds = Int(counterTime * 100) % 100
            let minutes = Int(counterTime) / 60
            let seconds = Int(counterTime) % 60
                
                // Format as MM:SS
                 
            
            self.elapsedTimeString =  String(format: "%d' %02d'' %02d%d", minutes, seconds, totalMilliseconds, randomThirdDigit)
            
            self.elpasedTimeLabel.text = self.elapsedTimeString
            
        }, SKAction.wait(forDuration: 0.0020)]), count: Int(totalCount)), completion: {
            
            
            self.elpasedTimeLabel.run(SKAction.sequence([
                SKAction.scale(to: 1.3, duration: 0.10),
                SKAction.scale(to: 0.05, duration: 0.025),
                SKAction.scale(to: 1.1, duration: 0.010),
                SKAction.scale(to: 0.9, duration: 0.025),
                SKAction.scale(to: 1.1, duration: 0.010),
                SKAction.scale(to: 1.0, duration: 0.010)
            
            ]))
        } )
        
        
        
        let minutes = Int(completedTimeIn) / 60
        let seconds = Int(completedTimeIn) % 60
            
            // Format as MM:SS
             
        
     
    }
        
    func presentContinueButton(){
        self.continueButton.alpha = 1.0
    }
    
    func continueButtonPressed(button: JKButtonNode){
        
        self.hide()
     
        
    }
    
    func setupTimer(withChallangeData: [Challenge]){
        
        
    }
    
    func setupLabels(withChallangeData: [Challenge]){
        
        
        
        stopwatch_bkg.addChild(elpasedTimeLabel)
        elpasedTimeLabel.fontSize = 25
        elpasedTimeLabel.fontName = "Andale Mono"
        elpasedTimeLabel.zPosition = 1001
        elpasedTimeLabel.fontColor = .white
        elpasedTimeLabel.verticalAlignmentMode = .center
        
        
        
        
        challange_bkg_star.addChild(challangeLabel1)
        challangeLabel1.setupLabel(withText: withChallangeData[0].ChallengeLabel)
        
        
        challange_bkg_star_2.addChild(challangeLabel2)
        challangeLabel2.setupLabel(withText: withChallangeData[1].ChallengeLabel)
        
  
      
    
        challange_bkg_star_3.addChild(challangeLabel3)
        challangeLabel3.setupLabel(withText: withChallangeData[2].ChallengeLabel)

     

        
       
        
    }
  
    func menuTriggered(withChallangeData: [Challenge]?, astroSprites: [SKSpriteNode]) {
        
        if let challangeData = withChallangeData { setupLabels(withChallangeData: challangeData) } 
        //self.show()}
        
        showing = true
        let animation_wait_time_between_items_scale_factor = 0.10
        self.alpha = 1.0
        let bubble_effect = SKAction.sequence([
            SKAction.scale(to: 1.2, duration: 0.1),
            SKAction.scale(to: 1.0, duration: 0.1)
        ])
        
        let default_timer = 0.10
        
        var metalic_ui_sound =  SharedInfo.SharedInstance.audioHandler.playSoundWithName(fileName: "atmospheric-metallic-swipe-12-195753")
               
        self.run(metalic_ui_sound)
        
        var fanfare =  SharedInfo.SharedInstance.audioHandler.playSoundWithName(fileName: "success-48018")
               
        self.run(fanfare)
        
        var pop_sound = SharedInfo.SharedInstance.audioHandler.playSoundWithName(fileName: "ui-pop-up-243471")
        
        missionBanner.run(SKAction.sequence([SKAction.moveBy(x: SharedInfo.SharedInstance.screenSize.width, y: 0, duration: default_timer),bubble_effect ]))
        
        completeBanner.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.moveBy(x: -SharedInfo.SharedInstance.screenSize.width, y: 0, duration: default_timer), bubble_effect]))
        
        self.run(SKAction.sequence([
            SKAction.wait(forDuration: 4.0 * animation_wait_time_between_items_scale_factor),
            
            SKAction.moveBy(x: 0, y: 100, duration: default_timer)
        ]))
        
        astros_saved_banner.run(SKAction.sequence([SKAction.wait(forDuration: 4.0 * animation_wait_time_between_items_scale_factor), metalic_ui_sound, SKAction.moveBy(x: SharedInfo.SharedInstance.screenSize.width, y: 0, duration: default_timer), bubble_effect]))
        
        astros_saved_input.run(SKAction.sequence([SKAction.wait(forDuration: 4.5 * animation_wait_time_between_items_scale_factor), pop_sound, SKAction.moveBy(x: -SharedInfo.SharedInstance.screenSize.width, y: 0, duration: default_timer),bubble_effect,
                                                  SKAction.run {
            self.astrosCollectedAnimation(withAstrosSprites: astroSprites)
        }
                                                 
                                                 ]))
        
        
        self.run(SKAction.sequence([
            SKAction.wait(forDuration: 6.0 * animation_wait_time_between_items_scale_factor),
            
            SKAction.moveBy(x: 0, y: 100, duration: default_timer)
        ]))
        
        stopwatch.run(SKAction.sequence([SKAction.wait(forDuration: 6.0 * animation_wait_time_between_items_scale_factor), metalic_ui_sound, SKAction.moveBy(x: SharedInfo.SharedInstance.screenSize.width, y: 0, duration: default_timer),bubble_effect]))
        
        
        
        stopwatch_bkg.run(SKAction.sequence([SKAction.wait(forDuration: 6.1 * animation_wait_time_between_items_scale_factor), pop_sound, SKAction.moveBy(x: -SharedInfo.SharedInstance.screenSize.width, y: 0, duration: default_timer),bubble_effect, SKAction.run {
            self.setElapsedTime()

        }]))
        
        self.run(SKAction.sequence([
            SKAction.wait(forDuration: 8.0 * animation_wait_time_between_items_scale_factor),
            
            SKAction.moveBy(x: 0, y: 50, duration: default_timer)
        ]))
        
        challanges.run(SKAction.sequence([SKAction.wait(forDuration: 8.0 * animation_wait_time_between_items_scale_factor), metalic_ui_sound, SKAction.moveBy(x: -SharedInfo.SharedInstance.screenSize.width, y: 0, duration: default_timer),bubble_effect]))
        
        self.run(SKAction.sequence([
            SKAction.wait(forDuration: 8.5 * animation_wait_time_between_items_scale_factor),
            
            SKAction.moveBy(x: 0, y: 150, duration: default_timer * 3 )
        ]))
        
        challange_star_1.run(SKAction.sequence([SKAction.wait(forDuration: 8.5 * animation_wait_time_between_items_scale_factor), metalic_ui_sound, SKAction.moveBy(x: SharedInfo.SharedInstance.screenSize.width, y: 0, duration: default_timer),bubble_effect]))
        challange_bkg_star.run(SKAction.sequence([SKAction.wait(forDuration: 8.6 * animation_wait_time_between_items_scale_factor), pop_sound, SKAction.moveBy(x: -SharedInfo.SharedInstance.screenSize.width, y: 0, duration: default_timer),bubble_effect, SKAction.run {
            self.challangeLabel1.animateText()
        }]))
        
      
        
        starleft.run(SKAction.sequence([
            SKAction.wait(forDuration: 8.5 * animation_wait_time_between_items_scale_factor),
            SKAction.fadeAlpha(to: 1.0, duration: default_timer),
            SKAction.sequence([
                SKAction.scale(to: 1.0, duration: 0.1),
                SKAction.scale(to: 0.75, duration: 0.1)
            ])
        ]))
        
        starmiddle.run(SKAction.sequence([
            SKAction.wait(forDuration: 8.5 * animation_wait_time_between_items_scale_factor),
            SKAction.fadeAlpha(to: 1.0, duration: default_timer),
            SKAction.sequence([
                SKAction.scale(to: 1.0, duration: 0.1),
                SKAction.scale(to: 0.75, duration: 0.1)
            ])
        ]))
        
        starright.run(SKAction.sequence([
            SKAction.wait(forDuration: 8.5 * animation_wait_time_between_items_scale_factor),
            SKAction.fadeAlpha(to: 1.0, duration: default_timer),
            SKAction.sequence([
                SKAction.scale(to: 1.0, duration: 0.1),
                SKAction.scale(to: 0.75, duration: 0.1)
            ])
        ]))
        
       /* self.run(SKAction.sequence([
            SKAction.wait(forDuration: 8.5 * animation_wait_time_between_items_scale_factor),
            
            SKAction.moveBy(x: 0, y: 50, duration: default_timer)
        ]))*/
        
        challange_star_2.run(SKAction.sequence([SKAction.wait(forDuration: 8.5 * animation_wait_time_between_items_scale_factor),SKAction.moveBy(x: SharedInfo.SharedInstance.screenSize.width, y: 0, duration: default_timer),bubble_effect]))
        challange_bkg_star_2.run(SKAction.sequence([SKAction.wait(forDuration: 8.6 * animation_wait_time_between_items_scale_factor), SKAction.moveBy(x: -SharedInfo.SharedInstance.screenSize.width, y: 0, duration: default_timer),bubble_effect, SKAction.run {
            self.challangeLabel2.animateText()
        }]))
        
        /*
        self.run(SKAction.sequence([
            SKAction.wait(forDuration: 8.5 * animation_wait_time_between_items_scale_factor),
            
            SKAction.moveBy(x: 0, y: 50, duration: default_timer)
        ]))*/
        
        challange_star_3.run(SKAction.sequence([SKAction.wait(forDuration: 8.5 * animation_wait_time_between_items_scale_factor),SKAction.moveBy(x: SharedInfo.SharedInstance.screenSize.width, y: 0, duration: default_timer),bubble_effect]))
        
      
      
        challange_bkg_star_3.run(SKAction.sequence([SKAction.wait(forDuration: 8.6 * animation_wait_time_between_items_scale_factor), SKAction.moveBy(x: -SharedInfo.SharedInstance.screenSize.width, y: 0, duration: default_timer),bubble_effect, SKAction.run {
            self.challangeLabel3.animateText()
        }]))
        
        
        self.run(SKAction.sequence([ SKAction.wait(forDuration: 9 * animation_wait_time_between_items_scale_factor), SKAction.run {
            self.animationCompletedCallbackFunction!()
        }]))
        
        
                       
    }
    
    
    
    func astrosCollectedAnimation(withAstrosSprites: [SKSpriteNode]){
        
        let newAstro = SKSpriteNode.init(imageNamed: "astro" + withAstrosSprites[0].name!)
        self.addChild(newAstro)
        newAstro.alpha = 0.0
        newAstro.zPosition = 1001
        newAstro.setScale(1.5)
        //newAstro.setScale(0.8)
        newAstro.position.y = astros_saved_input.position.y
        let duration = 1.00
        newAstro.run(SKAction.group([SKAction.scale(to: 0.8, duration: duration), SKAction.fadeAlpha(to: 1.0, duration: duration)]))
        
        //going to assume 3 astro limit for now
        if ( withAstrosSprites.indices.contains(2)){
            
            //start with 3 for fun, adjustmnet needed for 2
            let newAstro2 = SKSpriteNode.init(imageNamed: "astro" + withAstrosSprites[1].name!)
            self.addChild(newAstro2)
            newAstro2.alpha = 0.0
            newAstro2.zPosition = 1001
            newAstro2.setScale(1.5)
            //newAstro.setScale(0.8)
            newAstro2.position.y = astros_saved_input.position.y
            newAstro2.position.x = -newAstro.size.width/2 - 10
            let duration = 1.00
            newAstro2.run(SKAction.group([SKAction.scale(to: 0.8, duration: duration), SKAction.fadeAlpha(to: 1.0, duration: duration)]))
            
            
            
            let newAstro3 = SKSpriteNode.init(imageNamed: "astro" + withAstrosSprites[2].name!)
            self.addChild(newAstro3)
            newAstro3.alpha = 0.0
            newAstro3.zPosition = 1001
            newAstro3.setScale(1.5)
            //newAstro.setScale(0.8)
            newAstro3.position.y = astros_saved_input.position.y
            newAstro3.position.x = newAstro.size.width/2 + 10
            newAstro3.run(SKAction.group([SKAction.scale(to: 0.8, duration: duration), SKAction.fadeAlpha(to: 1.0, duration: duration)]))
            
            
        } else if ( withAstrosSprites.indices.contains(1)) {
            
            //start with 3 for fun, adjustmnet needed for 2
            let newAstro2 = SKSpriteNode.init(imageNamed: "astro" + withAstrosSprites[1].name!)
            self.addChild(newAstro2)
            newAstro2.alpha = 0.0
            newAstro2.zPosition = 1001
            newAstro2.setScale(1.5)
            //newAstro.setScale(0.8)
            newAstro2.position.y = astros_saved_input.position.y
            newAstro2.position.x = newAstro.size.width/3 - 10
            newAstro.position.x = -newAstro.size.width/3 - 10
            let duration = 1.00
            newAstro2.run(SKAction.group([SKAction.scale(to: 0.8, duration: duration), SKAction.fadeAlpha(to: 1.0, duration: duration)]))
            
            
            
            
        }
    }
    
    func starsCollectedAnimation(withChallangeData: [Challenge]){
        
        let collectedStarLeft = SKSpriteNode.init(imageNamed: "star-filled-big-left")
        let collectedStarRight = SKSpriteNode.init(imageNamed: "star-filled-big-left")
        let collectedStarCenter = SKSpriteNode.init(imageNamed: "star-filled-big-middle")
        
        
        var completedCount = 0
        for data in withChallangeData {
            if(data.UserCompleted){
                completedCount = completedCount + 1
            }
        }
        
        
        if(completedCount >= 1){
        
        self.addChild(collectedStarLeft)
        }
        
        if(completedCount >= 2){
            self.addChild(collectedStarRight)
        }
        
        if(completedCount == 3){
            self.addChild(collectedStarCenter)
        }
        collectedStarLeft.alpha = 0.0
        collectedStarRight.alpha = 0.0
        collectedStarCenter.alpha = 0.0
        
        collectedStarLeft.position = upperStarLeft.position
        collectedStarLeft.zRotation = upperStarLeft.zRotation
        
        collectedStarRight.position = upperStarRight.position
        collectedStarRight.zRotation = upperStarRight.zRotation
        
        collectedStarCenter.position = upperStarCenter.position
        collectedStarCenter.zRotation = upperStarCenter.zRotation
        
        collectedStarLeft.setScale(1.5)
        
        collectedStarRight.setScale(1.5)
        collectedStarCenter.setScale(1.5)
        
        collectedStarLeft.run(SKAction.group([SKAction.fadeAlpha(to: 1.0, duration: 0.5), SKAction.scale(to: 1.0, duration: 1.0)]))
        
        
        collectedStarRight.run(SKAction.group([SKAction.fadeAlpha(to: 1.0, duration: 0.5), SKAction.scale(to: 1.0, duration: 1.0)]))
        
        collectedStarCenter.run(SKAction.group([SKAction.fadeAlpha(to: 1.0, duration: 0.5), SKAction.scale(to: 1.0, duration: 1.0)]))
        
    }
    
    
    override func show () {
        
        
                
            showing = true
            self.alpha = 1.0
           
       
            
       
        
    }
}
