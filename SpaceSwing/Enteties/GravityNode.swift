//
//  GravityStar.swift
//  N Body No Problem
//
//  Created by Jorge Torres on 12/12/24.
//

import Foundation
import SpriteKit

class GravityNode : SKSpriteNode {
    
    var converted_position: CGPoint = CGPoint.zero
    var radius: CGFloat = 350
    var default_strength: CGFloat = 150
    var minShrink: CGFloat = 0.05
    var strength: CGFloat = 0
    let lightNode = SKLightNode()
    var lightNode_falloff = 0.5

    
    func setup(){
        
        
        if let gravitationalForce = self.userData!["gravitationalForce"] as? Int {
            self.default_strength = CGFloat(gravitationalForce)
            
        }
        
        
            
        
        
        

        if let minimumShipShrinkValue = self.userData!["minShrink"] as? Float {
            
            self.minShrink = CGFloat(minimumShipShrinkValue)
            
        }
        
        
        self.zPosition = 101
        if let PKBodyRadiusSize = self.userData!["PKBodyRadiusSize"] as? Int {
            
            self.physicsBody? = SKPhysicsBody.init(circleOfRadius: CGFloat(PKBodyRadiusSize))
            self.physicsBody!.isDynamic = false
            self.physicsBody!.categoryBitMask =  PhysicsCategory.gravityStar

        }
        
        if let hasPathCircleWithRadius = self.userData!["hasPathCircleWithRadius"] as? Float {
            
            
            let circle = SKShapeNode(circleOfRadius: CGFloat(hasPathCircleWithRadius))
            
            circle.strokeColor = .white
            circle.lineWidth = 1
            circle.alpha = 0
            
            circle.run(SKAction.sequence([
                
                SKAction.wait(forDuration: 3),
                SKAction.fadeAlpha(to: 0.5, duration: 1)
                
            ]))
            self.addChild(circle)
            
        }
        
        applyBackgroundGradient()
        
        
        lightNode.categoryBitMask = 1
        lightNode.isEnabled = true
        lightNode.falloff = 0
        
        let starTrail = SKEmitterNode(fileNamed: "Smoke-yellow")!
        
        starTrail.name = "trail"
        //Removing for now, dont like the trails
            //self.addChild(starTrail)
                
            starTrail.position = CGPoint.init(x: 0, y: 0 )
            starTrail.targetNode = parent
        if let color = self.userData?["color"] as? String {
            
            
                
       
                
            let starSparks = SKEmitterNode(fileNamed: "SunSparks")!
            starSparks.zPosition = -1
            starSparks.targetNode = parent
                
            if ( color == "red" )
                {   lightNode.lightColor = .red
                    let colorSequence = SKKeyframeSequence(keyframeValues: [
                        SKColor.red,  // Start color: White
                        SKColor.orange,    // Midway color: Red (at 10%)
                        SKColor.white   // End color: Black (at 90%)
                    ], times: [
                        0.0,   // White at 0% (start)
                        0.5,   // Red at 10%
                        1.0    // Black at 90% (last 10% of the lifetime)
                    ])
                    starTrail.particleColorSequence = colorSequence
                    
                if let colorize = self.userData?["colorize"] as? Bool {
                 
                    let bkg = SKSpriteNode.init(imageNamed: "red-gradient")
                    bkg.zPosition = -30
                    bkg.alpha = 0.25
                    self.addChild(bkg)
                    
                } else {  (self).run(SKAction.colorize(with: .orange, colorBlendFactor: 0.5, duration: 0.0))
                }
                starSparks.particleColorSequence = colorSequence

                    
            } else if  ( color == "blue" ) {
                    
                    lightNode.lightColor = .systemBlue
                        let colorSequence = SKKeyframeSequence(keyframeValues: [
                            SKColor.white,  // Start color: White
                            SKColor.white,    // Midway color: Red (at 10%)
                            SKColor.white   // End color: Black (at 90%)
                        ], times: [
                            0.0,   // White at 0% (start)
                            0.9,   // Red at 10%
                            1.0    // Black at 90% (last 10% of the lifetime)
                        ])
                    starTrail.particleColorSequence = colorSequence
                
                //  (self).run(SKAction.colorize(with: .white, colorBlendFactor: 0.5, duration: 0.0))
                
                    starSparks.particleColorSequence = colorSequence

            }  else if ( color == "none") {
                
                lightNode.lightColor = .white
                let colorSequence = SKKeyframeSequence(keyframeValues: [
                    SKColor.white,  // Start color: White
                    SKColor.white,    // Midway color: Red (at 10%)
                    SKColor.clear   // End color: Black (at 90%)
                ], times: [
                    0.0,   // White at 0% (start)
                    0.1,   // Red at 10%
                    1.0    // Black at 90% (last 10% of the lifetime)
                ])
                
                starTrail.particleColorSequence = colorSequence
                starSparks.particleColorSequence = colorSequence
                starSparks.removeFromParent()
                starTrail.removeFromParent()
                
            } else if (color == "black"){
                
                lightNode.lightColor = .black
                starSparks.removeFromParent()
                starTrail.removeFromParent()
                
            }
            
            else if (color == "white"){
                
                lightNode.lightColor = .white
                    let colorSequence = SKKeyframeSequence(keyframeValues: [
                        SKColor.white,  // Start color: White
                        SKColor.white,    // Midway color: Red (at 10%)
                        SKColor.clear   // End color: Black (at 90%)
                    ], times: [
                        0.0,   // White at 0% (start)
                        0.9,   // Red at 10%
                        1.0    // Black at 90% (last 10% of the lifetime)
                    ])
                starTrail.particleColorSequence = colorSequence
            
            //  (self).run(SKAction.colorize(with: .white, colorBlendFactor: 0.5, duration: 0.0))
            
                starSparks.particleColorSequence = colorSequence

            }
            
            else  {
                //default to yellow color
                
                lightNode.lightColor = .yellow

                
                self.run(SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.run({
                   
                    self.addChild(starSparks)
                    
                
                })]))
                
                
                starSparks.particleScale = 0.5
                        let colorSequence = SKKeyframeSequence(keyframeValues: [
                            SKColor.yellow,  // Start color: White
                            SKColor.yellow,    // Midway color: Red (at 10%)
                            SKColor.white   // End color: Black (at 90%)
                        ], times: [
                            0.0,   // White at 0% (start)
                            0.1,   // Red at 10%
                            1.0    // Black at 90% (last 10% of the lifetime)
                        ])
                    (self).run(SKAction.colorize(with: .yellow, colorBlendFactor: 0.5, duration: 0.0))
                    starTrail.particleColorSequence = colorSequence
                    starSparks.particleColorSequence = colorSequence

                }
            
        } else {
            
                lightNode.lightColor = .yellow

                
                (self).run(SKAction.colorize(with: .yellow, colorBlendFactor: 0.5, duration: 0.0))


        }
         
        
        //lightNode.shadowColor = .clear
        //lightNode.ambientColor = .clear
        //lightNode.falloff = 1
        self.addChild(lightNode)
        
      
    
        
   
        
        if let node_animation = self.userData?["animation"] as? String {
        
            
            
            
            let animation = SpriteKitTextureLoader.shared.animation(
                inAtlas: "EarthRotationAnimation",
                range: 1...240,
                digits: 4,
                prefix: "EarthRotation_", timePerFrame: 0.041,
                resize: false,
                restore: true
            )
            
            //self.setScale(0.50)
            self.run(SKAction.repeatForever(animation))
        }
        
        
       
    }
    
    
    func applySunSparks(){
        
        
    }
    
    func colorizeStar(){
        
        
    }
    
    
    func applyStarTrail(){
        
        
    }
    
    var custom_scale = 1.0
    
    func applyBackgroundGradient(){
        
        let sun_light_texture = SKSpriteNode(imageNamed: "sun-light-colored")
        
        
        if let gradient_scale = self.userData?["custom_bkg_gradient_scale"] as? Float {
         
            sun_light_texture.setScale(CGFloat(gradient_scale))
            self.custom_scale = Double(gradient_scale)
            
        }
        
        
        self.addChild(sun_light_texture)
        
        sun_light_texture.zPosition = -1
        sun_light_texture.alpha = 0.3
    
        sun_light_texture.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.group([
                SKAction.scale(to: 1.2 * self.custom_scale, duration: 1.0),
                SKAction.fadeAlpha(to: 0.35, duration: CGFloat.random(in: 1.50...3.50))]),
            SKAction.wait(forDuration: CGFloat.random(in: 1.10...1.50)),
            SKAction.group([SKAction.scale(to: 1.0 * self.custom_scale , duration: 1.1), SKAction.fadeAlpha(to: 0.15, duration: CGFloat.random(in: 1.5...3.50))]),
            SKAction.wait(forDuration:  CGFloat.random(in: 1.10...1.50)),
            
            
        ])))
        
        
        if let color = self.userData?["color"] as? String {
       
            switch color {
                case "blue":
                sun_light_texture.run(SKAction.colorize(with: .systemBlue, colorBlendFactor: 1.0, duration: 0.5))
                case "yellow":
                sun_light_texture.run(SKAction.colorize(with: .systemYellow, colorBlendFactor: 1.0, duration: 0.5))
            case "white":
                sun_light_texture.run(SKAction.colorize(with: .white, colorBlendFactor: 1.0, duration: 0.5))
            case "orange":
                sun_light_texture.run(SKAction.colorize(with: .orange, colorBlendFactor: 1.0, duration: 0.5))
                default:
                sun_light_texture.run(SKAction.colorize(with: .blue, colorBlendFactor: 1.0, duration: 0.5))
            }
            
        }
        
        
        
    }
    
    func initialPlacementAnimation(){
        
        self.alpha = 1.0
        self.setScale(0.5)
        var speed_multipler = 0.15
        
        let scale_action = SKAction.scale(to: 1.5, duration: 1.0 * speed_multipler )
        
        scale_action.timingMode = .easeIn
        
        inhaleNodesAnimation()
      //  self.run(SKAction.fadeAlpha(to: 1.0, duration: 0.25 * speed_multipler ))
        self.run(SKAction.sequence([
            
            SKAction.scale(to: 0.25, duration: 1.0 * speed_multipler ),
            SKAction.wait(forDuration: 1.0 * speed_multipler),
            SKAction.scale(to: 2.5, duration: 1.0 * speed_multipler ),
            SKAction.scale(to: 0.5, duration: 0.5 * speed_multipler),
            SKAction.scale(to: 1.55, duration: 0.5 * speed_multipler),
            SKAction.scale(to: 0.7, duration: 0.5 * speed_multipler),
            SKAction.scale(to: 1.2, duration: 0.5 * speed_multipler),
            SKAction.scale(to: 0.9, duration: 1.0 * speed_multipler),
            SKAction.scale(to: 1.0, duration: 1.0 * speed_multipler)
            
            
        ]))
        
        let wait_time = 0.01
        
        let divison_factor = 150
        let strength_scale_factor = default_strength / CGFloat(divison_factor)

        
        run(SKAction.sequence([SKAction.wait(forDuration: wait_time), SKAction.repeat(SKAction.sequence([
            
        
            SKAction.run {
                self.strength = self.strength + strength_scale_factor
            
            }
        ]), count: divison_factor)]))
        
       
        if let gravitonalRadius = self.userData!["gravitonalRadius"] as? Int {
            
          //  self.radius = CGFloat(gravitonalRadius)
            
            self.radius = 0
            
            
            let final_radius = CGFloat(gravitonalRadius)
            
            let addition_amount = gravitonalRadius / divison_factor
            
            var scale_action : [SKAction] = []
            
            for i in 0...divison_factor {
                
                scale_action.append(
                    
                    contentsOf: [
                        
                        SKAction.sequence([
                            
                            SKAction.wait(forDuration: wait_time),
                            
                            SKAction.run {
                                self.radius += CGFloat(addition_amount)
                            }
                            
                        ])
                        
                        
                    ]
                    
                    )
                    
                
            }
            
            self.run(SKAction.sequence(scale_action))
            
            
            
        }
        
        
        
        /* Bounce in animation
         
         self.run(SKAction.sequence([
            SKAction.group([
            SKAction.fadeAlpha(to: 1.0, duration: 0.20),
            SKAction.scale(to: 1.35, duration: 0.20)
        ]),
            SKAction.scale(to: 0.75, duration: 0.10),
            SKAction.scale(to: 1.25, duration: 0.10),
            SKAction.scale(to: 1.0, duration: 0.10)]))
        */
    }
    
    
    func inhaleNodesAnimation(){
        
         
            
            
            var randomNodes : [SKSpriteNode] =  []
          
                
            for y in 1...100 {
            
                        let randomNode = SKSpriteNode.init(imageNamed: "ship-energy-bar")
                        
                        
                        randomNode.yScale = CGFloat.random(in: 0.1...0.5)
                        randomNode.xScale = CGFloat.random(in: 0.1...1)
                        
                        
                        
                        randomNode.position.y = -CGFloat.random(in: -(SharedInfo.SharedInstance.screenSize.height * 2 )...(SharedInfo.SharedInstance.screenSize.height * 2 ))
                        
                randomNode.position.x = -CGFloat.random(in: -(SharedInfo.SharedInstance.screenSize.width * 2 )...(SharedInfo.SharedInstance.screenSize.width * 2 ))
                
                
                        randomNodes.append(randomNode)
                        randomNode.alpha = 0.0
                        randomNode.zPosition = -1
                        
                self.parent!.addChild(randomNode)

                }
            
            
            
        let animation_speed = 0.25
            
            for node in randomNodes {
                
                
                //Lasso mode , rotate ship around star
                let dx = node.position.x - 0
                let dy = node.position.y -  -self.size.height / 4
                var angle = atan2(dy, dx)
                angle -= .pi / 2
                // Adjust to make the spaceship face the direction it's moving
                node.zRotation = angle
                node.alpha = CGFloat.random(in: 0.1...1.0)
                
                node.run(SKAction.sequence([SKAction.wait(forDuration: CGFloat.random(in: 0...0.25)), SKAction.group([ SKAction.move(to: CGPoint.init(x: 0, y:  0)  , duration: animation_speed), SKAction.fadeAlpha(to: 0, duration: animation_speed )]), SKAction.run {
                    node.removeFromParent()
                }]))
                
                
                
                
            }
            
            self.run(SKAction.sequence([ SKAction.wait(forDuration: animation_speed + 0.25),
                                         SKAction.run {
                randomNodes = []
            }]))
            
        }
        
        
    
}
