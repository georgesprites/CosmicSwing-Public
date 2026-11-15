//
//  Astro.swift
//  SpaceSwing
//
//  Created by Jorge Torres on 2/1/25.
//

import Foundation
import SpriteKit

class Astro: SKSpriteNode {
    
    var scaleFactor = 1.0
    
    func setup(){
        
        
        self.position.y = self.position.y + 25
        //self.run(SKAction.group([SKAction.moveBy(x: 0, y: -25, duration: 1.0),  SKAction.fadeAlpha(to: 1.0, duration: 0.5)]))
        
        
        self.run(SKAction.sequence([ SKAction.wait(forDuration: CGFloat.random(in: 0.01...0.25)),
            SKAction.group([
            SKAction.fadeAlpha(to: 1.0, duration: 0.20),
            SKAction.scale(to: 1.35, duration: 0.20)
        ]),
            SKAction.scale(to: 0.75, duration: 0.10),
            SKAction.scale(to: 1.25, duration: 0.10),
            SKAction.scale(to: 1.0, duration: 0.10)]))
        var bounding_box_scale_factor = 0.8
        self.physicsBody = SKPhysicsBody.init(rectangleOf: CGSize.init(width: self.size.width * bounding_box_scale_factor , height:  self.size.height * bounding_box_scale_factor))
        self.physicsBody!.categoryBitMask = PhysicsCategory.astronaut
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.isDynamic = false
        self.physicsBody!.contactTestBitMask = PhysicsCategory.player
        
        let astro_bubble = SKSpriteNode.init(imageNamed: "astro-bubble")
        //node.addChild(astro_bubble)
        astro_bubble.setScale(1.25)
        let lightNode = SKLightNode()
        lightNode.categoryBitMask = 1
        lightNode.falloff = SharedInfo.SharedInstance.default_light_falloff
        lightNode.ambientColor = .clear
        lightNode.shadowColor = .clear
       
        if let isLightEnabled =  self.userData?["isLightEnable"] as? Bool {
         
            if(!isLightEnabled){
                
            } else {
                self.addChild(lightNode)

            }
        } else {
            self.addChild(lightNode)
        }
        
        print("Starting custom aanimation func")
        
        setupCustomAnimations()
        
      
        
        self.zPosition = 101
        
      //  self.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(degreesToradians(-30)), duration: 10)))
        
        
        
        self.run(SKAction.repeatForever(
            
            SKAction.sequence([
                
                SKAction.scale(to: 1.1, duration: 0.1),
                SKAction.wait(forDuration: 0.1),
                SKAction.scale(to: 0.9, duration: 0.1),
                SKAction.wait(forDuration: 2)
                
            ])
            
        ))
        
        /*
        self.run(SKAction.move(by: CGVector(dx: SharedInfo.SharedInstance.screenSize.width / 2 , dy: 0), duration: 5))
        self.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.group([SKAction.scaleX(to: -1, duration: 0.1),
                           SKAction.moveBy(x: -SharedInfo.SharedInstance.screenSize.width, y: 0, duration:  10 )
                          ]),
            
            SKAction.group([SKAction.scaleX(to: 1, duration: 0.1),
                           SKAction.moveBy(x: SharedInfo.SharedInstance.screenSize.width, y: 0, duration:  10 )
                          ])
        
        ])))
         */
        
    }
    
    func setupCustomAnimations(){
        
        
        
        if self.name == "astro-BobbyBikeman"{
            
            
            
            let textureAtlas = SKTextureAtlas(named: "Astro-BobbyBikeman-Riding")
         
            var frames : [SKTexture] = []
            for i in 1...6 {
                
                var textureName = ""
                
            
                    textureName =   "Astro-BobbyBikeman-Riding-000" + String(i)
          
                
                frames.append(textureAtlas.textureNamed(textureName))
            }
            
            // Create the animation action
            let cyclingAnimation = SKAction.animate(with: frames, timePerFrame: 0.10, resize: false, restore: true)
            
            
            
            
            let textureAtlas2 = SKTextureAtlas(named: "Astro-BobbyBikeman-Waving")
         
            var frames2 : [SKTexture] = []
            for i in 1...6 {
                
                var textureName = ""
                
            
                    textureName =   "Astro-BobbyBikeman-Waving-000" + String(i)
          
                
                frames2.append(textureAtlas2.textureNamed(textureName))
            }
            
            // Create the animation action
            let wavingAnimation = SKAction.animate(with: frames2, timePerFrame: 0.10, resize: false, restore: true)
            
            
            self.run(SKAction.repeatForever(
                
                SKAction.sequence([
                    
                    SKAction.repeat(cyclingAnimation, count: 10),
                    SKAction.repeat(wavingAnimation, count: 2)
                    
                    
                ])
                
                ))
            
        
            
        } else {
            
            
            //Default to the pervious method of animation
            
            
            if let textureAtlasName =  self.userData?["animationName"] as? String {
            let textureAtlasPrefix =  self.userData?["animationName_Prefix"] as! String
            let textureAtlasEndFrame =  self.userData?["animationEndFrame"] as! Int

            
            
            let textureAtlas = SKTextureAtlas(named: textureAtlasName)
            // Create an array to hold the textures
            var frames: [SKTexture] = []
            
            // Load all 16 frames from the atlas
            for i in 1...textureAtlasEndFrame {
                
                var textureName = ""
                
            
                    textureName =   textureAtlasPrefix+"\(i)"
          
                
                frames.append(textureAtlas.textureNamed(textureName))
            }
            
            // Create the animation action
            let animation = SKAction.animate(with: frames, timePerFrame: 0.10, resize: false, restore: true)
            self.run(SKAction.repeatForever(animation))
            }
            
            
        }
    }
    
    func setupHelpSign(){
        
        
        
        let helpSign = SKSpriteNode.init(imageNamed: "help-sign-1")
        
        
        
        
        let textureAtlas = SKTextureAtlas(named: "HelpSign")
      
        var frames: [SKTexture] = []
        
        frames.append(textureAtlas.textureNamed("help-sign-1"))
        frames.append(textureAtlas.textureNamed("help-sign-2"))
        frames.append(textureAtlas.textureNamed("help-sign-3"))
        frames.append(textureAtlas.textureNamed("help-sign-4"))

        
        let animation = SKAction.animate(with: frames, timePerFrame: 0.10, resize: true, restore: false)
        
        
        helpSign.run(SKAction.repeatForever(animation))
        
        
        helpSign.position = self.position
        helpSign.position.x = helpSign.position.x + helpSign.size.height / 2
        self.parent!.addChild(helpSign)

        helpSign.run(SKAction.repeatForever( SKAction.sequence([
            
            
            SKAction.moveBy(x: 0, y: 75, duration: 0.25),
            
            SKAction.group([
            SKAction.scale(to: 1.0, duration: 0.25),
            SKAction.fadeAlpha(to: 1.0, duration: 0.25)
            ]),
            SKAction.scale(to: 1.25, duration: 1.5),
           
            
            SKAction.group([
            SKAction.scale(to: 0.0, duration: 0.1),
            SKAction.fadeAlpha(to: 1.0, duration: 0.1)
            ])
            ,
            SKAction.wait(forDuration: 5),
            SKAction.moveBy(x: 0, y: -75, duration: 0.50),
        
        ])))
        
    }
    
    func runCollectionAnimation(withPlayerPosition: CGPoint){
        
        

        var astro_collected_sound =  SharedInfo.SharedInstance.audioHandler.playSoundWithName(fileName: "achievement-video-game-type-1-230515")
     
        var telport_sound_effect =
        SharedInfo.SharedInstance.audioHandler.playSoundWithName(fileName: "747184-clif-creates-warp_A00CVdH2")
     
        self.run(SKAction.sequence([ astro_collected_sound, SKAction.wait(forDuration: 0.50), telport_sound_effect ]))
     
        self.run(SKAction.sequence([
        
            SKAction.scale(to: 1.25, duration: 0.15),
            SKAction.scale(to: 1.0, duration: 0.15),
            SKAction.wait(forDuration: 0.15),
            SKAction.run {
                
                if let shipGhostParticles = SKEmitterNode(fileNamed: "astroCollectedParticles") {
                    
                    shipGhostParticles.position = self.position
                    self.parent!.addChild(shipGhostParticles)
                    
                    shipGhostParticles.targetNode = self.parent!
                    
                }
                
            },
            SKAction.group([
                SKAction.moveBy(x: 0, y: 50, duration: 0.5),
            SKAction.fadeAlpha(to: 0.0, duration: 0.5)
            ])
        ]))
        
        
        self.physicsBody = nil
    }
}
