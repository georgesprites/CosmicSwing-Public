//
//  File.swift
//  N Body No Problem
//
//  Created by Jorge Torres on 12/21/24.
//

import Foundation
import SpriteKit

// Model to represent a single dialog entry
struct Dialog: Codable {
    let index: Int
    let characterName: String
    let animation: String?
    let dialog: String
    let dialog_sound: String? 
    let characterPlacement: String?
}

// Model to represent the entire JSON structure
struct DialogData: Codable {
    let InitialDialog: [Dialog]
    let EndingDialog: [Dialog]
}

class DialogInterface: SKNode {
    
    
    var characterTalking = SKSpriteNode()
    var dialogLabel = MSKAnimatedLabel()
    var background = SKSpriteNode.init(imageNamed: "DialogBox")
    var initialDialog : [Dialog]? = nil
    var endingDialog : [Dialog]? = nil
    var currentCharacter : String = ""
    var amountOfInitialDialog = 0
    var amountOfEndingDialog = 0
    var dialogBoxAnimation : SKAction? = nil
    var currentAnimation = ""
    
    func setup(withLevelName: String, hasInitialDialog: Bool, hasEndingDialog: Bool){
        
     
            
        
        
        
         
        let textureAtlas = SKTextureAtlas(named: "DialogAnimation")
        // Create an array to hold the textures
        var frames: [SKTexture] = []
         
        // Load all 16 frames from the atlas
        for i in 1...50 {
             
        var textureName = ""
             
        var append = ""
                 
        textureName =   "DialogBox_" +  String(format: "%04d", i)
                frames.append(textureAtlas.textureNamed(textureName))
             }
         
     
        dialogBoxAnimation = SKAction.animate(with: frames, timePerFrame: 0.075, resize: true, restore: true)
        
        self.addChild(background)
        self.zPosition = 1050
        background.zPosition = 1001
        background.position.x = 50
        background.position.y = 25
        
        if(hasInitialDialog){
            
            initialDialog = loadDataFromFileName(from: withLevelName + "-Dialog")?.InitialDialog
            
            for dialog in initialDialog! {
                amountOfInitialDialog = amountOfInitialDialog + 1
            }
            
            let characterName = initialDialog![0].characterName
            let dialog_animation = initialDialog![0].animation
            characterTalking = SKSpriteNode.init(imageNamed: characterName)
            
            var frames: [SKTexture] = []
            if let animationName = dialog_animation {
                
            let textureAtlas = SKTextureAtlas(named: animationName)
                    // Create an array to hold the textures
                
                    // Load all 16 frames from the atlas
                self.currentAnimation = animationName
                var index = 1
                for textureName in textureAtlas.textureNames {
                    
                    
                   
                    
                    if(index < 10) {
                    frames.append(textureAtlas.textureNamed(textureName.dropLast() + String(index)))
                    } else
                    {
                        frames.append(textureAtlas.textureNamed(textureName.dropLast().dropLast() + String(index)))
                        
                    }
                    index = index + 1
                }
                
                
                } else  {
                    
                    self.currentAnimation = characterName

                    
                    let textureAtlas = SKTextureAtlas(named: characterName)
                    // Create an array to hold the textures
                
                    // Load all 16 frames from the atlas
                    
                var index = 1
                for textureName in textureAtlas.textureNames {
                    
                    
                   
                    
                    if(index < 10) {
                    frames.append(textureAtlas.textureNamed(textureName.dropLast() + String(index)))
                    } else
                    {
                        frames.append(textureAtlas.textureNamed(textureName.dropLast().dropLast() + String(index)))
                        
                    }
                    index = index + 1
                }
                
                
                }
                
            
        
            let animation = SKAction.animate(with: frames, timePerFrame: 0.075, resize: true, restore: true)
       
            characterTalking.run(SKAction.repeatForever(animation))
            characterTalking.setScale(2.0)
            currentCharacter = initialDialog![0].characterName
            
            characterTalking.position.x = -self.background.size.width / 2 + characterTalking.size.width / 4
            characterTalking.position.y = characterTalking.size.height / 12

            
            characterTalking.zPosition = 1000
            self.addChild(characterTalking)
            
            
            dialogLabel = MSKAnimatedLabel(text: "”Exploration is wired into our brains. If we can see the horizon, we want to know what’s beyond.” – Buzz Aldrin",
                                         horizontalAlignment: .left,
                                         durationPerCharacter: 0.025,
                                         fontSize:  40,
                                         marginVertical:  40,
                                         fontColor:  .black,
                                         fontName:  "Mat-Saleh",
                                         skipSpaces: true,
                                         labelWidth: self.background.size.width / 1.7 ,
                                         finishTypingOnTouch:  false)
            
            dialogLabel.zPosition = 1002
            
            dialogLabel.position.x = -self.background.size.width / 2 + 200
            dialogLabel.position.y = (self.background.size.height / 3.5)
            
            
            self.addChild(dialogLabel)
            
            
        }
        
        
        if(hasEndingDialog){
            
            endingDialog = loadDataFromFileName(from: withLevelName + "-Dialog")?.EndingDialog
            
            
            for dialog in endingDialog! {
                amountOfEndingDialog = amountOfEndingDialog + 1
            }
            
            
            
            
            
        }
        
        
        
    }
    
    
    func updateDialogBox( dialogInfo: Dialog) {
        
        let dialogAnimationSwitchSpeed = 0.10
        self.background.removeAllActions()
        background.run(SKAction.repeatForever(dialogBoxAnimation!))
        if(dialogInfo.characterName != currentCharacter) {
            self.background.removeAllActions()
            background.run(SKAction.repeatForever(dialogBoxAnimation!))

            let newCharacterTexture = SKTexture.init(imageNamed: dialogInfo.characterName)
            var character_position_x = -SharedInfo.SharedInstance.screenSize.width / 2 + newCharacterTexture.size().width / 2
          
            if let characterPlacement = dialogInfo.characterPlacement {
                if(characterPlacement == "left") {
                    
                    character_position_x = SharedInfo.SharedInstance.screenSize.width / 2  - newCharacterTexture.size().width / 2
                
                }
                self.background.run(SKAction.sequence([
                
                    SKAction.scaleX(to: -1.1, y: 1.1, duration: 0.1),
                    SKAction.scaleX(to: -0.9, y: 0.9, duration: 0.1),
                    SKAction.scaleX(to: -1.0, y: 1.0, duration: 0.1)
                    
                ]), completion: {
                    
                    self.background.run(SKAction.repeatForever(SKAction.sequence([
                        SKAction.scaleX(to: -1.025, y: 1.025, duration: 2.0),
                        SKAction.scaleX(to: -0.975, y: 0.975, duration: 2.0)
                        
                        
                    
                    ])))
                    
                })
                
                dialogLabel.position.x = -self.background.size.width  + 350

                
            } else {
                
                
                dialogLabel.position.x = -self.background.size.width / 2 + 200

                self.background.run(SKAction.sequence([
                
                    SKAction.scale(to: 1.1, duration: 0.1),
                    SKAction.scale(to: 0.9, duration: 0.1),
                    SKAction.scale(to: 1.0, duration: 0.1)
                ]), completion: {
                    
                    self.background.run(SKAction.repeatForever(SKAction.sequence([
                        SKAction.scale(to: 1.025, duration: 2.5),
                        SKAction.scale(to: 0.975, duration: 2.5)
                    
                    ])))
                    
                })
            }

            
            
            self.characterTalking.run(SKAction.sequence([
            
                SKAction.moveBy(x: 0, y: -300, duration: dialogAnimationSwitchSpeed),
                SKAction.run {
                    self.characterTalking.texture = newCharacterTexture
                    self.characterTalking.size = newCharacterTexture.size()
                    
                },
                
                SKAction.group([
                    
                SKAction.moveTo(x: character_position_x, duration: dialogAnimationSwitchSpeed),
                SKAction.moveBy(x: 0 , y: 300, duration: dialogAnimationSwitchSpeed)
                ])
            
            ]))
            
            self.background.run(SKAction.sequence([
                SKAction.moveBy(x: 0, y: -300, duration: dialogAnimationSwitchSpeed),
                SKAction.moveBy(x: 0, y: 300, duration: dialogAnimationSwitchSpeed)
            
            ]))
       
            
            currentCharacter = dialogInfo.characterName
        } else {
            
            if let dialogAnimation = dialogInfo.animation {
                
                var frames = [SKTexture]()
                if currentAnimation != dialogAnimation {
                    
                    
                    
                let textureAtlas = SKTextureAtlas(named: dialogAnimation)
                        // Create an array to hold the textures
                    
                        // Load all 16 frames from the atlas
                    self.currentAnimation = dialogAnimation
                    var index = 1
                    for textureName in textureAtlas.textureNames {
                        
                        
                       
                        
                        if(index < 10) {
                        frames.append(textureAtlas.textureNamed(textureName.dropLast() + String(index)))
                        } else
                        {
                            frames.append(textureAtlas.textureNamed(textureName.dropLast().dropLast() + String(index)))
                            
                        }
                        index = index + 1
                    }
                    
                    
                        let animation = SKAction.animate(with: frames, timePerFrame: 0.075, resize: true, restore: true)
                   
                        characterTalking.run(SKAction.repeatForever(animation))
                }

                
            }
            
            
            if let characterPlacement = dialogInfo.characterPlacement {
                if(characterPlacement == "left") {
                    
                    
                
                }
                self.background.run(SKAction.sequence([
                
                    SKAction.scaleX(to: -1.1, y: 1.1, duration: 0.1),
                    SKAction.scaleX(to: -0.9, y: 0.9, duration: 0.1),
                    SKAction.scaleX(to: -1.0, y: 1.0, duration: 0.1)
                    
                ]), completion: {
                    
                    self.background.run(SKAction.repeatForever(SKAction.sequence([
                        SKAction.scaleX(to: -1.025, y: 1.025, duration: 2.0),
                        SKAction.scaleX(to: -0.975, y: 0.975, duration: 2.0)
                        
                        
                    
                    ])))
                    
                })
                
            } else {
                
                self.background.run(SKAction.sequence([
                
                    SKAction.scale(to: 1.1, duration: 0.1),
                    SKAction.scale(to: 0.9, duration: 0.1),
                    SKAction.scale(to: 1.0, duration: 0.1)
                ]), completion: {
                    
                    self.background.run(SKAction.repeatForever(SKAction.sequence([
                        SKAction.scale(to: 1.025, duration: 2.5),
                        SKAction.scale(to: 0.975, duration: 2.5)
                    
                    ])))
                    
                })
            }

        }
        
        self.dialogLabel.update(text: dialogInfo.dialog)
       
    }
    
    
    func loadDataFromFileName(from DialogResourceName: String) -> DialogData? {
        if let url = Bundle.main.url(forResource: DialogResourceName, withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            if let dialogs = parseInitialDialog(from: String(data: data, encoding: .utf8)!) {
                return dialogs
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func parseInitialDialog(from jsonString: String) -> DialogData? {
        
     
        
        let jsonData = Data(jsonString.utf8)
        let decoder = JSONDecoder()
        do {
            let initialDialogData = try decoder.decode(DialogData.self, from: jsonData)
            return initialDialogData
        } catch {
            print("Failed to decode JSON: \(error)")
            return nil
        }
    }
    
    
    
}
