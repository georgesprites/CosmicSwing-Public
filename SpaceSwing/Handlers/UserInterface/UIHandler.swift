//
//  UIHandler.swift
//  N Body No Problem
//
//  Created by Jorge Torres on 8/11/24.
//

import Foundation
import SpriteKit

enum DialogMode {
    
    case initialDialogMode
    case endingDialogMode
}


class UIHandler: SKNode {
    
    let bottomMenuBar = BottomMenuBar()
    var astros : [SKSpriteNode] = []
    var textbackgroundReferece = SKSpriteNode()
    var healthBar = SKSpriteNode()
    let shootByWireMenu = ShootByWireMenu()
    var getCurrentGameModeHandler: (()->GameModes)?
    var touchBlockerScreen = SKSpriteNode()

    let completion = LevelCompleteMenu()
    let missionFailedUI = MissionFailedMenu()
    
    let initialTouchLocationIndicator = InitialTouchLocationIndicatorNode()
    let movedTouchLocationIndicator = SKShapeNode.init(circleOfRadius: 50)
   let settingsMenu = SettingsMenu()
    
    let pauseButton = JKButtonNode.init(backgroundNamed: "pause-button")
    let dialogInterface = DialogInterface()
    var dialogModeCompletedCallback: (()->Void)? = nil
    var endDialogModeCompletedCallback: (()->Void)? = nil
    var diagnosticAndIgnitationSystemSwitches = DiagnosticAndIgnitationSystemSwitches()
    var isReadyToReceiveTouches = false
    var hasInitialDialog = false
    var hasEndingDialog = false
    var dialogMode : DialogMode = .initialDialogMode
    let levelPickerMenu = LevelPickerMenu()
    let coinCount = SKLabelNode()
    let coinIcon = SKSpriteNode.init(imageNamed: "coin1")
    var saveLevelID = ""
    
    var shootByWireButton = JKButtonNode.init(backgroundNamed: "Shootbywirebutton")
    
    func setup(withAstroNames: [String], withLevelID: String, withSubsequentSwingEnabled: Bool, isShootingEnabled: Bool){
        
        self.saveLevelID = withLevelID
        
        var index = 0.0
        for astro in withAstroNames {
            self.zPosition = 1000
            let astro_outline = SKSpriteNode.init(imageNamed: "astro-outline")
            astro_outline.setScale(0.5)
            self.addChild(astro_outline)
        
        astro_outline.position.y = SharedInfo.SharedInstance.screenSize.height / 2 - astro_outline.size.height
        
            let leftCorner = -SharedInfo.SharedInstance.screenSize.width / 2 + ( astro_outline.size.width * 2 )
            let offset = (index * astro_outline.size.width)
            astro_outline.position.x = leftCorner - offset
            astro_outline.name = astro
            astros.append(astro_outline)
            
            index = index + 1.0
        }
        
        let leftCorner = -SharedInfo.SharedInstance.screenSize.width / 2 + ( coinIcon.size.width * 2.5 )
        
        coinIcon.position = CGPoint.init(x: leftCorner, y: SharedInfo.SharedInstance.screenSize.height / 2 - coinIcon.size.height * 4)
        self.addChild(coinIcon)
        
        
        pauseButton.position.y = SharedInfo.SharedInstance.screenSize.height / 2 - pauseButton.size.height / 1.5
        
        pauseButton.position.x = SharedInfo.SharedInstance.screenSize.width / 2 - pauseButton.size.width * 1.5
        
        self.addChild(pauseButton)
        
        shootByWireButton.alpha = 1.0
        
        shootByWireButton.position.y = -SharedInfo.SharedInstance.screenSize.height / 2 + shootByWireButton.size.height / 1.5
        
        shootByWireButton.position.x = SharedInfo.SharedInstance.screenSize.width / 2 - shootByWireButton.size.width 
       
        if(isShootingEnabled){
            self.addChild(shootByWireButton)
        
        }
        
        
        self.shootByWireMenu.movementJoystick.buttonReference = shootByWireButton
        bottomMenuBar.setup()
        bottomMenuBar.zPosition = 1000
        
        if(SharedInfo.SharedInstance.bottomMenuBarEnabled) {
            self.addChild(bottomMenuBar)
        }

        
        self.handleDialog()
        self.setupHealthBar()
        
        
        missionFailedUI.setup()
        missionFailedUI.alpha = 0.0
        missionFailedUI.hide()
        missionFailedUI.zPosition = 1000
        self.addChild(missionFailedUI)
        
        shootByWireMenu.setup()
        
        shootByWireMenu.position.y = -SharedInfo.SharedInstance.self.screenSize.height  + (shootByWireMenu.movementJoystick.diameter )
        
        self.addChild(shootByWireMenu)
        
        
            self.addChild(initialTouchLocationIndicator)
            self.addChild(movedTouchLocationIndicator)
        
        initialTouchLocationIndicator.setup()
        
        initialTouchLocationIndicator.alpha = 1.0
        
        
        initialTouchLocationIndicator.position.y = -SharedInfo.SharedInstance.screenSize.height / 2 + 100 / 1.5
        
        initialTouchLocationIndicator.position.x = -SharedInfo.SharedInstance.screenSize.width / 2 + 100 * 1.5
        
        initialTouchLocationIndicator.lockedPosition = initialTouchLocationIndicator.position
        
        movedTouchLocationIndicator.alpha = 0.0
        
        settingsMenu.setup()
        settingsMenu.alpha = 0.0
        settingsMenu.hide()
        self.addChild(settingsMenu)
        settingsMenu.showLevelPickerButton.action = self.showLevelPicker
        missionFailedUI.showLevelPickerButton.action = self.showLevelPicker
        dialogInterface.setup(withLevelName: "Level" + withLevelID, hasInitialDialog: hasInitialDialog, hasEndingDialog: hasEndingDialog)
     
        dialogInterface.background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            
            dialogInterface.position.y = ((-SharedInfo.SharedInstance.screenSize.height / 2) / SharedInfo.SharedInstance.default_camera_scale_level ) + (( dialogInterface.background.size.height / 2) / SharedInfo.SharedInstance.default_camera_scale_level)
            
        } else {
            
            dialogInterface.position.y = ((-SharedInfo.SharedInstance.screenSize.height / 2) ) + (( dialogInterface.background.size.height / 2) )
            
            
        }
         
    
        self.addChild(dialogInterface)
        dialogInterface.alpha = 0.0
        
        
        isReadyToReceiveTouches = true
        
        
        levelPickerMenu.alpha = 0.0
         levelPickerMenu.hide()
        self.addChild(levelPickerMenu)
        levelPickerMenu.setup()
        
        levelPickerMenu.zPosition = 1002
    
        
        if let loadedChallangeData = self.levelPickerMenu.challangeData {
            
            for levelChallangeData in loadedChallangeData {
                
                if (levelChallangeData.Level == Int(self.saveLevelID)){
                    completion.setup(withChallangeData: levelChallangeData.Challenges)
                }
            }
        }
        
       // completion.alpha = 0.0
        //completion.hide()
        //completion.zPosition = 1000
        self.addChild(completion)

        
        diagnosticAndIgnitationSystemSwitches.setup()
        self.addChild(diagnosticAndIgnitationSystemSwitches)
        diagnosticAndIgnitationSystemSwitches.position.x = -50
        diagnosticAndIgnitationSystemSwitches.setScale(0.80)
        diagnosticAndIgnitationSystemSwitches.position.y = -SharedInfo.SharedInstance.screenSize.height / 2 + diagnosticAndIgnitationSystemSwitches.background.size.height / 2 + 20
        diagnosticAndIgnitationSystemSwitches.alpha = 0.0
        diagnosticAndIgnitationSystemSwitches.allSwitchesToggledCallback = self.allSwitchesToggledCallback
        
        self.completion.animationCompletedCallbackFunction = self.levelCompletionCallbackFunction
        
    }
   
   
    
    func dialogModeTouchInitiated(){
        
        if(isReadyToReceiveTouches){
            
            if(self.dialogMode == .initialDialogMode){
                
                presentNextDialog()}
            else {
                presentEndingDialog()
            }
        }
    }
    func allSwitchesToggledCallback(){
        
        self.dialogSuspended = false
        
        self.diagnosticAndIgnitationSystemSwitches.alpha = 0.0
        self.dialogInterface.alpha = 1.0
        presentNextDialog()
        
    }
    
    
    func showLevelPickerFromMissionFailedMenu(){
        
        self.missionFailedUI.hide()
        self.levelPickerMenu.showFromMissionFailed()
        
        
    }
    
    
    func showLevelPicker(button: JKButtonNode){
        self.settingsMenu.hide()
        self.levelPickerMenu.show()
    }
   
    var currentDialogIndex = 0
    
    
    var dialogSuspended = false
    
    func resetAstroUI(){
        
        
        for astro in astros {
            
            astro.texture = SKTexture(imageNamed: "astro-outline")
            astro.setScale(0.5)
          
            
            
            
        }
    }
    
    


    func presentNextDialog(){
        let dialog_sound_effect =  SharedInfo.SharedInstance.audioHandler.playSoundWithName(fileName: "pop-on-269286")
        
        
    
        
        self.run(dialog_sound_effect)
        
        
        
        
        if(currentDialogIndex == 0 ) {
            
            dialogInterface.alpha = 1.0

        }
        
        if(dialogSuspended == false ) {
        
        
            if(currentDialogIndex == self.dialogInterface.amountOfInitialDialog){
            
            if let callback = dialogModeCompletedCallback {
                callback()
            }
            
            dialogInterface.alpha = 0.0
            return
            
                //testing commits
        }
            
            if let dialog_sound = dialogInterface.initialDialog![currentDialogIndex].dialog_sound {
                
                let dialog_babble_sound_effect =  SharedInfo.SharedInstance.audioHandler.playSoundWithName(fileName: dialog_sound)
                self.run(dialog_babble_sound_effect)
                
            }
            
        
            
        if( dialogInterface.initialDialog![currentDialogIndex].characterName.contains("specialAction") ) {
            
            
                self.dialogSuspended = true
            self.dialogInterface.alpha = 0.0
            self.diagnosticAndIgnitationSystemSwitches.alpha = 1.0
            
            
           

            
            
            
        } else {
            self.dialogInterface.updateDialogBox(dialogInfo: dialogInterface.initialDialog![currentDialogIndex])
            
            
            
            //withText: dialogInterface.initialDialog![currentDialogIndex].dialog, withCharacterName: dialogInterface.initialDialog![currentDialogIndex].characterName)
        }
        currentDialogIndex = currentDialogIndex + 1
        }
    }
    
    
    var currentEndingDialogIndex = 0
    
    
    func presentEndingDialog(){
        
            
        var dialog_sound_effect =  SharedInfo.SharedInstance.audioHandler.playSoundWithName(fileName: "pop-on-269286")
        
        self.run(dialog_sound_effect)
        
            if(currentEndingDialogIndex == 0 ) {
                
                dialogInterface.alpha = 1.0

            }
            
        if(currentEndingDialogIndex == dialogInterface.amountOfEndingDialog){
                
                if let callback = endDialogModeCompletedCallback {
                    callback()
                }
                
                dialogInterface.alpha = 0.0
                return
            }
            
        
        if let endingDialog = dialogInterface.endingDialog {
            self.dialogInterface.updateDialogBox(dialogInfo: endingDialog[currentEndingDialogIndex])
            
        }
        else {
            if let callback = endDialogModeCompletedCallback {
                callback()
            }
        }
             
            
           
            
        currentEndingDialogIndex = currentEndingDialogIndex + 1
            
        
        
        
        
    }
  
    func setupHealthBar(){
        
        healthBar = SKSpriteNode.init(color: .red, size: CGSize.init(width: SharedInfo.SharedInstance.screenSize.width , height: 10))
        
        
        
        healthBar.position.y =   (SharedInfo.SharedInstance.screenSize.height / 2) - healthBar.size.height - SharedInfo.SharedInstance.safeAreaInserts.top
        
        //Removing health bar for now
        //self.addChild(healthBar)
        healthBar.anchorPoint = CGPoint.init(x: 0, y: 0.5)
        
        healthBar.position.x = healthBar.position.x -  healthBar.size.width / 2
        
    }
    
    func playerTookHealthHit(percentage: CGFloat){
        
        healthBar.run(SKAction.scaleX(to: percentage, duration: 1.0))
    }
    
    func handleDialog(){
        textbackgroundReferece = SKSpriteNode.init(color: UIColor.gray, size: CGSize.init(width: SharedInfo.SharedInstance.screenSize.width , height: 200))
        
        textbackgroundReferece.position.y = -SharedInfo.SharedInstance.screenSize.height / 2 + textbackgroundReferece.size.height / 2
       // self.addChild(textbackgroundReferece)
    }
    
    func createDialogText(){
        
        
        
    }
    
    
    var numberOfCollectedAstros = 0
    func runCapturedAstro( hasPassedLevel: Bool, challangegData: challangeTrackingData? )
    {
        
        let astro = SKSpriteNode.init(imageNamed: "astro")
        astro.position = self.astros[numberOfCollectedAstros].position
        astro.alpha = 0.0
        self.addChild(astro)
        let initialfadein = SKAction.group([SKAction.scale(to: 0.5, duration: 0.25), SKAction.fadeAlpha(to: 1.0, duration: 0.25)])
        
           

           
        
        
        let popOut = SKAction.sequence([SKAction.scale(to: 0.8, duration: 0.05), SKAction.scale(to: 0.5, duration: 0.05) ])
        astro.run( SKAction.sequence([initialfadein, popOut]) )
        
        if(hasPassedLevel){
            
            
            

            var compiledChallangeData : [Challenge]? = nil
            
            if let loadedChallangeData = self.levelPickerMenu.challangeData {
                
                for levelChallangeData in loadedChallangeData {
                    
                    if (levelChallangeData.Level == Int(self.saveLevelID)){
                        
                        compiledChallangeData = levelChallangeData.Challenges
                        //Found the current levels challange data
                        
                        // Compare it to the completed challange data
                        
                        
                        //Switch depending on the type of challange data
                        
                        var currentIndex = 0
                        
                        for challange in levelChallangeData.Challenges {
                            
                            switch challange.ChallengeType {
                                
                            case .timeUnder:
                                
                                let goalToBeat = Double(challange.ChallengeGoal)
                                let completedIn = self.completion.completedTimeIn
                                if completedIn <= goalToBeat! {
                                    compiledChallangeData![currentIndex].UserCompleted = true
                                    print("Challenge completed! Finished in \(completedIn) seconds, goal was \(goalToBeat ?? 0.0) seconds.")
                                   } else {
                                       print("Challenge failed. Finished in \(completedIn) seconds, goal was \(goalToBeat ?? 0.0) seconds.")
                                   }
                                
                                
                                
                            case .coinCollect:
                                
                                let goalToBeat = Int(challange.ChallengeGoal)
                               
                                
                                if  challangegData!.numberOfCoinsCollected >= goalToBeat! {
                                    
                                   
                                    compiledChallangeData![currentIndex].UserCompleted = true
                                   } else {
                                       

                                   }
                                
                                
                                break
                                
                            case .noShipDamage:
                                
                                //Not sure if will implement
                                break
                                
                            case .noShots:
                                
                                
                                let goalToBeat = Int(challange.ChallengeGoal)
                               
                                
                                if  challangegData!.numberOfShotsFired <= goalToBeat! {
                                    
                                    compiledChallangeData![currentIndex].UserCompleted = true
                                   } else {
                                       

                                   }
                                
                                break
                            case .challengeStar:
                                
                             
                               
                                
                                if  (challangegData!.challangeStarCollected) {
                                    
                                    compiledChallangeData![currentIndex].UserCompleted = true
                                   } else {
                                       
                                    
                                   }
                                
                                break
                            case .boostUsage:
                                
                                //Not sure yet
                                break
                            }
                            
                            currentIndex = currentIndex + 1
                        }
                        
                        
                        
                        
                    }
                }
                
            }
            
            //
            
            
           

            
            self.run(SKAction.sequence(
                
                
                [
                    SKAction.run {
                
                
                
                var level_completed_sound =  SharedInfo.SharedInstance.audioHandler.playSoundWithName(fileName: "brass-new-level-151765")
                     
             
                   
                          
                   //self.run(level_completed_sound)
                   
                   //Present the completion screen and next level
                   //Continue button only for now
                   
               // self.completion.menuTriggered(withChallangeData: compiledChallangeData)
                        
                        self.completion.menuTriggered(withChallangeData: compiledChallangeData, astroSprites: self.astros)
                        
                      
                        
                
            }]))
            
            
       
        }
        numberOfCollectedAstros = numberOfCollectedAstros + 1
    }
    
    func levelCompletionCallbackFunction(){
        
    
                self.presentEndingDialog()
           
    }
    
    func missionFailed(){
        
        
        self.missionFailedUI.menuTriggered()
        
        
        
    }
    
    func shootByWireActivated() {
        
        shootByWireMenu.run(SKAction.moveBy(x: 0, y: SharedInfo.SharedInstance.screenSize.height, duration: 0.5))
        
    }
    
    func shootByWireDissmissed(){
        
        
        shootByWireMenu.run(SKAction.moveBy(x: 0, y: -SharedInfo.SharedInstance.screenSize.height, duration: 0.5))
    }
    
    
    
}
