//
//  MotherShip.swift
//  N Body No Problem
//
//  Created by Jorge Torres on 5/22/24.
//

import Foundation
import SpriteKit
import AudioToolbox




class MotherShip: GravityNode {
    
    var savedPosition = CGPoint()
    var savedZRotation = CGFloat()
    var initialPosition = CGPoint()
    var isLockedOn = false
    var totalHealth = 2
    var currentHealth  = 2
    let shipBackgroundLight = SKSpriteNode.init(imageNamed: "player-circular-gradient")
    var shipOutline = SKSpriteNode(imageNamed: "shipoutline")
    let chargeNode = SKShapeNode.init(circleOfRadius: 5)
    var velocityLine = SKSpriteNode.init(color: .systemGreen, size: CGSize.init(width: 5, height: 1000))
    var isCharging = false
    var scaledValue = 1
    
    
    var enginePower = 100
    // In your ship class (SKSpriteNode)
    private let warpCols = 1
    private let warpRows = 1
    private lazy var identityWarp: SKWarpGeometryGrid = {
        // Normalized coords: (0,0)=bottom-left, (1,1)=top-right
        let src: [vector_float2] = [
            .init(0,0), .init(1,0),
            .init(0,1), .init(1,1)
        ]
        return SKWarpGeometryGrid(columns: warpCols, rows: warpRows,
                                  sourcePositions: src, destinationPositions: src)
    }()

    func setupChargeWarp() {
        self.warpGeometry = identityWarp
    }
    
    let colors = [UIColor.red, UIColor.yellow, UIColor.blue, UIColor.green, UIColor.cyan, UIColor.gray, UIColor.white, UIColor.black, UIColor.magenta, UIColor.orange]
    
    
    func deductEnginePowerDueToSwing(reductionAmount: Int){
        
        enginePower = enginePower - reductionAmount
        if(enginePower < 0 ){
            //shouldnt happen, but just in case we will floor to 0
            enginePower = 0
        }
    }
    
    func enginePowerCollected(){
        
        enginePower = enginePower + 5
        
        if(enginePower > 100){
            enginePower = 100
            //max cap of 100 ( for now)
        }
        
    }
    
    func getMaxCurrentForce()->Double {
        
        return Double(enginePower) * 3.5
        
    }
    
    
    func setup(withGameNodeReference: SKNode){
        
      
        self.name = "MotherShip"
        self.strength = 250
        self.radius = 100
        shipBackgroundLight.alpha = 0.20
        shipBackgroundLight.zPosition = -1
        shipBackgroundLight.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.scale(to: 1.10, duration: 0.5),
            SKAction.scale(to: 0.80, duration: 0.5)
        
        ])))
        setupChargeWarp()
        self.addChild(shipBackgroundLight)
        
        
        self.physicsBody = SKPhysicsBody.init(rectangleOf:  CGSize.init(width: shipOutline.size.width / 2 , height: shipOutline.size.height / 2 ))
        self.physicsBody?.fieldBitMask = PhysicsCategory.gravityStar
        self.physicsBody!.categoryBitMask = PhysicsCategory.player
        self.physicsBody!.mass = 100
        self.physicsBody?.contactTestBitMask =  PhysicsCategory.gravityStar | PhysicsCategory.earthplanet | PhysicsCategory.player_detection
        self.physicsBody?.isDynamic = false
        self.physicsBody?.usesPreciseCollisionDetection = true 
       //self.run(SKAction.colorize(with: .cyan, colorBlendFactor: 1.0, duration: 0.0))
        let lightNode = SKLightNode()
        lightNode.lightColor = .white
        lightNode.categoryBitMask = 1
        lightNode.falloff = SharedInfo.SharedInstance.default_light_falloff
        lightNode.ambientColor = .clear
        lightNode.shadowColor = .clear
        
        if let lightEnabled =  self.userData?["lightEnabled"] as? Bool{
            
            
            self.addChild(lightNode)
            
        }
        
        //self.addChild(chargeNode)
        chargeNode.position = CGPoint.init(x: 0, y:  -self.size.height )
        //chargeNode.alpha
        chargeNode.fillColor = .white
      
        chargeNode.alpha = 0.0
        //  self.addChild(shipOutline)
        shipOutline.alpha = 0.25
        shipOutline.zPosition = -1
        shipOutline.setScale(0.5)
        shipOutline.position.y = -20
        self.addChild(velocityLine)
        velocityLine.alpha = 0.0
        self.texture = nil
        velocityLine.position.y = velocityLine.size.height / 2
        
   
   
            
            let textureAtlas = SKTextureAtlas(named: "ShipAnimation")
           
            // Create an array to hold the textures
            var frames: [SKTexture] = []
            
            // Load all 16 frames from the atlas
            for i in 1...9 {
                
                var textureName = ""
                
            
                    textureName =   "000\(i)"
          
                
                frames.append(textureAtlas.textureNamed(textureName))
            }
            
            // Create the animation action
            let animation = SKAction.animate(with: frames, timePerFrame: 0.10, resize: true, restore: true)
        self.run(SKAction.repeatForever(animation))
        self.zPosition = 1005
        
        
        if let shipGhostParticles = SKEmitterNode(fileNamed: "shipGhost") {
            
            self.addChild(shipGhostParticles)
            shipGhostParticles.name = "trailParticles"
            shipGhostParticles.position = CGPoint.init(x: 0, y:-self.size.height/2)
            shipGhostParticles.targetNode = withGameNodeReference
            shipGhostParticles.particleScale = 0.01
            
        }
       
        
   
        
    }
    
    func zRotationBasedOnMovement(forceVector: CGVector){
        
        let angle = atan2(forceVector.dy, forceVector.dx) - (CGFloat.pi / 2)
        self.zRotation = angle
    }
    
    
     func recreatePhysicsBody(){
        
        self.physicsBody!.mass = 100

        self.physicsBody?.fieldBitMask =  PhysicsCategory.gravityStar
        self.physicsBody?.categoryBitMask = PhysicsCategory.player
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
    }
    
    
    func lockedOnEnemeyDestroyed(){
        
    }
    
    func lazerShoot(_ vector: CGPoint){
     
        
      
      
    }
    
   
    
    func toggleVelocityMode(toMode mode: VelocityModes, withZRotation: CGFloat)
{
        
        if(mode == .savedVelocityMode){
            velocityLine.alpha = 1.0
           
            self.zRotation = withZRotation
            
        } else if (mode == .staticMode) {
            
            velocityLine.alpha = 0.0

        }
    
    
    }
    
    
    func boostChargeUpAnimation(){
        
        
        
        self.isCharging = true
       // chargeNode.alpha = 1.0
   
        
        
        if let emmitter = self.childNode(withName: "trailParticles") as? SKEmitterNode {
          
            //emmitter.particleBirthRate = 0
            
            emmitter.position =     CGPoint.init(x: 0, y: -self.size.height/10)
           // emmitter.xAcceleration = 0
            emmitter.alpha = 0.0
            emmitter.particleBirthRate = 0
            
            
        }
  
        
        SharedInfo.SharedInstance.audioHandler.startChargeLoop()
        
        
        
       // self.chargeNode.run(SKAction.scale(to: 0.75, duration: 0.01))

        
        
     //   var charge_sound_blast_off =  SharedInfo.SharedInstance.audioHandler.playSoundWithName(fileName: "sci-fi-charge-up-37395")
        
     //   self.run(charge_sound_blast_off)
     
        /*shipOutline.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.scale(by: 1.5, duration: 0.1),
            SKAction.scale(by: 1 / 1.5, duration: 0.1)])))*/
        
    }
    
    func stopChargingUp(){
        
        velocityLine.alpha = 0.0

        self.isCharging = false
        let duration = 0.15
     
        

    
    }
    
    
    var previousScaledValue = 0
    
    func startChargeFlash(scaledValue: Int = 100) {
        
        SharedInfo.SharedInstance.audioHandler.updateChargeLoop(scaledValue: scaledValue)
        
        updateChargeWarpCenterStretch(scaledValue: scaledValue)
        
        
        if(scaledValue == 100 && previousScaledValue != scaledValue ) {
        // Optional: use scaledValue to make high charge flash faster
        let clamped = max(1, min(scaledValue, 100))
        let t = CGFloat(clamped) / 100.0           // 0.01–1.0
            let flashDuration: TimeInterval = 0.12
        // At low charge: ~0.12s, at full: ~0.048s (faster flash)

        // Turn fully white
        let flashOnBlue = SKAction.colorize(
            with: .systemBlue,
            colorBlendFactor: 1.0,
            duration: flashDuration
        )
        
            let flashOnRed = SKAction.colorize(
                with: .systemRed,
                colorBlendFactor: 1.0,
                duration: flashDuration
            )
            
        // Back to original texture colors
        let flashOff = SKAction.colorize(
            withColorBlendFactor: 0.0,
            duration: flashDuration
        )

        let sequence = SKAction.sequence([flashOnBlue, flashOff, flashOnRed, flashOff])
        let loop = SKAction.repeatForever(sequence)

        // Avoid stacking multiple loops
        self.removeAction(forKey: "chargeFlash")
        self.run(loop, withKey: "chargeFlash")
        
        self.run(SKAction.repeatForever( SKAction.sequence([
                
                SKAction.scale(to: 2.6, duration: 0.05),
                SKAction.scale(to: 2.0, duration: 0.05)
                
            ])), withKey: "scaleAction")
        previousScaledValue = scaledValue
        } else if ( previousScaledValue != scaledValue ) {
            
            
            
            let pullFrace = CGFloat(scaledValue) / 100.0   // 0.01 → 1.0
            let shipScale = 1.0 + pullFrace
            
            self.setScale(shipScale)
            
            self.removeAction(forKey: "chargeFlash")
            self.removeAction(forKey: "scaleAction")
            let flashOff = SKAction.colorize(
                withColorBlendFactor: 0.0,
                duration: 0.01
            )
            
            self.run(flashOff)
            previousScaledValue = scaledValue
        }
    }
    
    
    func resetChargeWarp() {
        self.removeAction(forKey: "chargeWarp")
        let a = SKAction.warp(to: identityWarp, duration: 0.10)
        a!.timingMode = .easeOut
        self.run(a!, withKey: "chargeWarp")
    }
    
    func runExplisionAnimation(){
        
        
        let explosionNode = SKSpriteNode.init(imageNamed: "shipexplosion001")
        explosionNode.position = self.position
       
        explosionNode.setScale(0.5)
        if let parent = self.parent {
            
            parent.addChild(explosionNode)
        
        }
        let plode_animation = SpriteKitTextureLoader.shared.animation(
            inAtlas: "ShipExplosion",
            range: nil,
            digits: 3,
            prefix: "shipexplosion",
            timePerFrame: 0.04,
            resize: true,
            restore:  false
            
        )
        
        self.removeAllActions()
        self.removeFromParent()
        explosionNode.run(plode_animation, completion: {
            
            explosionNode.texture = nil
            explosionNode.removeFromParent()
        })
        
        
        
        
    }
    
    var restPosition: CGPoint = .zero

    /// Max visual pull-back distance (outer circle radius)
    let maxPullDistance: CGFloat = 200.0   //
    
    
    func handleForceVector(vector: CGVector, scaledValue: Int) {
        // 1–100 → 0–1 fraction
        let clamped = max(1, min(scaledValue, 100))
        let pullFraction = CGFloat(clamped) / 100.0

        // Normalize direction
        let mag = sqrt(vector.dx * vector.dx + vector.dy * vector.dy)
        guard mag > 0 else { return }

        let dirX = vector.dx / mag
        let dirY = vector.dy / mag

        // Pull *backwards* from shot direction
        let pullDistance = maxPullDistance * pullFraction
        let offset = CGPoint(x: -dirX * pullDistance,
                             y: -dirY * pullDistance)

        // Target is ALWAYS relative to restPosition,
        // so we never go outside the max circle
        let targetPos = CGPoint(x: restPosition.x + offset.x,
                                y: restPosition.y + offset.y)

        // Squash/stretch (optional)
        let maxStretch: CGFloat = 0.20
        let stretchAmount = pullFraction * maxStretch
        let scaleX = 1.0 + stretchAmount
        let scaleY = 1.0 - stretchAmount * 0.5

        // Slight tilt toward pull direction (optional)
        let maxTilt: CGFloat = .pi / 15
           let tilt = pullFraction * maxTilt

           // If your texture faces "up", subtract π/2
           let forwardAngle = atan2(vector.dy, vector.dx) - .pi / 2
           let angle = forwardAngle

        let duration: TimeInterval = 0.08
        let moveAction = SKAction.move(to: targetPos, duration: duration)
        let scaleAction = SKAction.scaleX(to: scaleX, y: scaleY, duration: duration)
        let rotateAction = SKAction.rotate(toAngle: angle,
                                           duration: duration,
                                           shortestUnitArc: true)

        moveAction.timingMode   = .easeOut
        scaleAction.timingMode  = .easeOut
        rotateAction.timingMode = .easeOut
     
        
        
        startChargeFlash(scaledValue: scaledValue)
        self.run(.group([ rotateAction]))
    }
    
    func chargeParticlesAnimation(initialParticleScaleFactor: Int = 0){
        
        
        var randomNodes : [SKSpriteNode] =  []
        for x in 1...4{
            
                for y in 1...4 {
            
                    let randomNode = SKSpriteNode.init(imageNamed: "ship-energy-bar")
                    
                    
                    randomNode.yScale = CGFloat.random(in: 0.1...0.5)
                    randomNode.xScale = CGFloat.random(in: 0.1...1)
                    
                    
                    self.parent!.addChild(randomNode)
                    
                    randomNode.position.y = -CGFloat.random(in: -(SharedInfo.SharedInstance.screenSize.height * 2 )...(SharedInfo.SharedInstance.screenSize.height/2))
                    
                    randomNode.position.x = CGFloat.random(in: -SharedInfo.SharedInstance.screenSize.width...SharedInfo.SharedInstance.screenSize.width)
                    
                    randomNodes.append(randomNode)
                    randomNode.alpha = 0.0
                    randomNode.zPosition = -1
                }
        }
        
        
        
        
        let animation_speed = 0.15
        
        for node in randomNodes {
            
            
            //Lasso mode , rotate ship around star
            let dx = node.position.x - self.position.x
            let dy = node.position.y -  self.position.y
            var angle = atan2(dy, dx)
            angle -= .pi / 2
            // Adjust to make the spaceship face the direction it's moving
            node.zRotation = angle
            node.alpha = CGFloat.random(in: 0.1...1.0)
            
            node.run(SKAction.sequence([SKAction.wait(forDuration: CGFloat.random(in: 0...0.25)), SKAction.group([ SKAction.move(to: CGPoint.init(x: self.position.x, y:  self.position.y )  , duration: animation_speed), SKAction.fadeAlpha(to: 0, duration: animation_speed * 0.9)]), SKAction.run {
                node.removeFromParent()
            }]))
            
            
            
            
        }
        
        self.run(SKAction.sequence([ SKAction.wait(forDuration: animation_speed + 0.25),
                                     SKAction.run {
            randomNodes = []
        }]))
        
    }
    
    func dischargeParticleAnimation(){
        
        
        var randomNodes : [SKSpriteNode] =  []
        for x in 1...2{
            
                for y in 1...2 {
            
                    let randomNode = SKSpriteNode.init(imageNamed: "ship-energy-bar")
                    
                    
                    randomNode.yScale = CGFloat.random(in: 0.1...0.5)
                    randomNode.xScale = CGFloat.random(in: 0.1...1)
                    
                    
                    if let parent = self.parent {
                        parent.addChild(randomNode)

                    }
                    randomNode.position = self.position
                    
                    randomNodes.append(randomNode)
                    randomNode.alpha = 1.0
                    randomNode.zPosition = -1
                }
        }
        
        
        
        
        let animation_speed = 0.15
        
        for node in randomNodes {
            
            
            
            
            
            //randomNode.setScale(0.25)
            let randomPositionY  = -CGFloat.random(in: -(SharedInfo.SharedInstance.screenSize.height * 2 )...(SharedInfo.SharedInstance.screenSize.height/2))
            
            let randomPositionX = CGFloat.random(in: -SharedInfo.SharedInstance.screenSize.width...SharedInfo.SharedInstance.screenSize.width)
            //Lasso mode , rotate ship around star
            let dx = randomPositionX - self.position.x
            let dy = randomPositionY - self.position.y
            var angle = atan2(dy, dx)
            angle -= .pi / 2
            // Adjust to make the spaceship face the direction it's moving
            node.zRotation = angle
            node.alpha = CGFloat.random(in: 0.1...1.0)
            
            
            
            
            node.run(SKAction.sequence([SKAction.wait(forDuration: CGFloat.random(in: 0...0.25)), SKAction.group([ SKAction.move(to: CGPoint.init(x: randomPositionX, y: randomPositionY )  , duration: animation_speed), SKAction.fadeAlpha(to: 0, duration: animation_speed * 0.9)]), SKAction.run {
                node.removeFromParent()
            }]))
            
            
            
            
        }
        
        self.run(SKAction.sequence([ SKAction.wait(forDuration: animation_speed + 0.25),
                                     SKAction.run {
            randomNodes = []
        }]))
        
    }
    
  
    
    var currentScaleFactor = 1
    
    func enableShipPath(){
        if(SharedInfo.SharedInstance.shipPath){
                if let fireParticles = SKEmitterNode(fileNamed: "DottedSmoke") {
                                     
                                     
                  fireParticles.name = "ShipPathTaken"
                   fireParticles.zPosition = 99
                   self.addChild(fireParticles)
                    fireParticles.position = CGPoint.init(x: 0, y:  0 )
                    fireParticles.targetNode = self.parent!
                    fireParticles.isPaused = false
                    fireParticles.particleBirthRate = 100
                                        
          }}
                 
    }
    
    func disableShipPath(){
        let particles = self.childNode(withName: "ShipPathTaken") as? SKEmitterNode
        particles?.isPaused = false
        particles?.numParticlesToEmit = 0
        particles?.particleBirthRate = 0
        
    }
    
    func scaleChargeNodeAnimation(){
        
        var scale = 1

        self.run(SKAction.repeat(SKAction.sequence([  SKAction.run { [self] in
                      
          self.scaleChargeNode(byFactor: scale, initialParticleScaleFactor: scale)
                            scale = scale + 1
                        }, SKAction.wait(forDuration: 0.0050) ]), count: 50))
        
        self.shipOutline.run(SKAction.scale(to: 2.0, duration: 0.45), completion: {})

    }
    
    func scaleChargeNode(byFactor: Int, initialParticleScaleFactor: Int = 0 ){
        
        
        // Ensure the input is clamped between 1 and 100
          let clampedValue = min(max(byFactor, 1), 100)

          // Scale the clamped value to the range 0.1 to 1.0
          let clamedScaleValue =  0.2 + (Double(clampedValue - 1) / 99.0) * (1.0 - 0.1)
        

        
        if(currentScaleFactor != byFactor) {
            
            
            self.chargeNode.run(SKAction.scale(to: CGFloat(byFactor) * 0.075, duration: 0.05))
            
           
            if ( currentScaleFactor < byFactor ) {
                //add particles
                chargeParticlesAnimation(initialParticleScaleFactor: initialParticleScaleFactor)
                
                
            } else {
                dischargeParticleAnimation()
                //remove particles
            }
            
            currentScaleFactor = byFactor
            
        }
        
       
    }
    
    func boostCartoonAnimation(){
        
        
        let textureAtlas = SKTextureAtlas(named: "ShipCartoonStyleLaunch")
        // Create an array to hold the textures
        var frames: [SKTexture] = []
        
        // Load all 16 frames from the atlas
        for i in 1...13 {
            
            var textureName = ""
            
            if(i < 10 ){
                textureName =   "playershio0\(i)" }
            else { textureName =  "playershio\(i)" }
            
            frames.append(textureAtlas.textureNamed(textureName))
        }
        
        // Create the animation action
        let animation = SKAction.animate(with: frames, timePerFrame: 0.05, resize: true, restore: true)
        
        // Repeat the animation forever
      //  let repeatAnimation = SKAction.repeatForever(animation)
        
        // Run the animation on the sprite
       self.run(animation)
        
    }
    
    func flyingAnimation() {
         // Load the texture atlas
         let textureAtlas = SKTextureAtlas(named: "ShipAnimation")
         
         // Create an array to hold the textures
         var frames: [SKTexture] = []
         
         // Load all 16 frames from the atlas
         for i in 1...9 {
             let textureName = "000\(i)"
             frames.append(textureAtlas.textureNamed(textureName))
         }
         
         // Create the animation action
         let animation = SKAction.animate(with: frames, timePerFrame: 0.025, resize: true, restore: false)
         
         // Repeat the animation forever
         let repeatAnimation = SKAction.repeatForever(animation)
         
         // Run the animation on the sprite
        
        self.run(repeatAnimation, withKey: "shipOutlineAnimation")
        
     }
    
    
    func hyperShipAnimation() {
        
        // Load the texture atlas
        let textureAtlas = SKTextureAtlas(named: "HyperShipAnimation")
        
        // Create an array to hold the textures
        var frames: [SKTexture] = []
        
        // Load all 16 frames from the atlas
        for i in 1...8 {
            let textureName = "shipoutline0\(i)"
            frames.append(textureAtlas.textureNamed(textureName))
        }
        
        // Create the animation action
        let animation = SKAction.animate(with: frames, timePerFrame: 0.025, resize: true, restore: false)
        
        // Repeat the animation forever
        let repeatAnimation = SKAction.repeatForever(animation)
        
        // Run the animation on the sprite
        self.run(repeatAnimation, withKey: "shipOutlineAnimation")

        
        
    }
    
    
    
    
    func updateChargeWarpCenterStretch(scaledValue: Int) {
        let clamped = max(1, min(scaledValue, 100))
       
        
        let t = CGFloat(clamped) / 100.0   // 0.0 → 1.0

           // 1x → 3x
           let multiplier = 1.0 + 3.0 * t
            let radius_multiplier = 1.0 + 10000.0 * t
        
           self.strength = baseStrength * multiplier
           self.radius   = baseRadius   * radius_multiplier
        
        
    }
    
   
    let baseStrength: CGFloat = 250
    let baseRadius: CGFloat = 100
    
    func shipLaunchedAnimation(){
        
        
        var charge_sound =  SharedInfo.SharedInstance.audioHandler.playSoundWithName(fileName: "blastv2")
        
        
        
       self.run(charge_sound, withKey: "chargingSound")
        
        self.run(SKAction.sequence([
            SKAction.wait(forDuration: 1.5),
            SKAction.run {
                
                SharedInfo.SharedInstance.audioHandler.stopChargeLoop()
                self.removeAction(forKey: "scaleAction")
                self.removeAction(forKey: "chargeFlash")
                
                self.run(SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.0))

                self.run(SKAction.scale(to: 1.0, duration: 0.0))

                
            }
            
            
        ]))
        
        let startStrength = self.strength
        let startRadius   = self.radius

        let endStrength = baseStrength
        let endRadius   = baseRadius * 10

        var easeStrengthLoop = [SKAction]()
        
        let loopAmount = 20.0
        
        var strenghtdivisionRate = (startStrength - endStrength) / loopAmount
        var radiusdivisionRate = (startRadius - endRadius) / loopAmount

        
        
        for i in 1...Int(loopAmount) {
            
            easeStrengthLoop.append(contentsOf: [
                
                SKAction.wait(forDuration: 0.01),
                SKAction.run {
                    
                    
                    self.strength = self.strength - strenghtdivisionRate
                    self.radius = self.radius - radiusdivisionRate
                }
                
            ])
            
        }
        
        
        
        
        self.run(SKAction.sequence( easeStrengthLoop ), withKey: "easeMotherShipBack")
        
        
        
        resetChargeWarp()
        
        let textureAtlas = SKTextureAtlas(named: "ShipLaunchCartoon")
        // Create an array to hold the textures
        var initialAnimation: [SKTexture] = []
        
        // Load all 16 frames from the atlas
        for i in 1...26 {
            
            var textureName = ""
            
            if(i < 10 ){
                textureName =   "Ship_000\(i)"
            } else {
                textureName =   "Ship_00\(i)"

            }
            
            initialAnimation.append(textureAtlas.textureNamed(textureName))
        }
        
        
        for i in 0...6 {
            
            let circle = SKShapeNode.init(circleOfRadius: 2000)
            circle.strokeColor = .white
            circle.lineWidth = CGFloat(Int.random(in: 40...150))
            circle.alpha = CGFloat.random(in: 0.5...1)
            circle.position = self.position
            self.parent?.addChild(circle)
            let randomDuration =  CGFloat.random(in: 0.05...0.2)
            circle.run(SKAction.sequence([
                SKAction.wait(forDuration: Double(i) * 0.3 ),
                SKAction.group([
                    
                    SKAction.scale(to: 0, duration: randomDuration),
                    SKAction.fadeAlpha(to: CGFloat.random(in: 0...0.5), duration: randomDuration)
                ]),
                SKAction.run {
                    circle.removeFromParent()
                }
                
                
            ]))
            
        }
     
        self.run(SKAction.sequence([
            SKAction.wait(forDuration: 1.85),
            SKAction.run {
                 
                
                if let emmitter = self.childNode(withName: "trailParticles") as? SKEmitterNode {
                  
                    
                    emmitter.position = CGPoint.init(x: 0, y: -(self.size.height / 2) )
                    
                            
                            emmitter.alpha = 1.0
                            emmitter.particleBirthRate = 100

                          
                    
                    
                }
            }
            
            
        ]))
        self.run(SKAction.scale(to: 1.0, duration: 0.25))
        // Create the animation action
        let animation = SKAction.animate(with: initialAnimation, timePerFrame: 0.11 , resize: true, restore: false)
        
        
        self.run(animation, completion: {
            
            
            self.flyingAnimation()
          
            
            
            
        } )
        
        
      
        
        stopChargingUp()
        
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { }


        //  self.chargeNode.removeAllActions()
        self.chargeNode.run(SKAction.scale(to: 0.0, duration: 0.5), completion: {self.chargeNode.removeAllActions()})
        
        
        
        
   
        
        
        
        var randomNodes : [SKSpriteNode] =  []
        for _ in 1...10{
            
                for _ in 1...10 {
            
                    let randomNode = SKSpriteNode.init(color: .white, size: CGSize.init(width: Int.random(in: 1...8), height: Int.random(in: 30...50)) )
                    self.addChild(randomNode)
                    
                    randomNode.position = CGPoint.init(x: 0, y:  -self.size.height )
                    
                    randomNodes.append(randomNode)
                    
                    randomNode.alpha = CGFloat.random(in: 0.5...1)
                    
                }
        }
        
        
        
        let animation_speed = 0.10
        for node in randomNodes {
            
            
            
            
            let movePosition = CGPoint.init(x: CGFloat.random(in: -SharedInfo.SharedInstance.screenSize.width/2...SharedInfo.SharedInstance.screenSize.width/2) * 6, y: -CGFloat.random(in: (SharedInfo.SharedInstance.screenSize.height/16)...(SharedInfo.SharedInstance.screenSize.height/2) * 6))
            
            
            
            //Lasso mode , rotate ship around star
            let dx = node.position.x - movePosition.x
            let dy = node.position.y - movePosition.y
            var angle = atan2(dy, dx)
            angle -= .pi / 2
            // Adjust to make the spaceship face the direction it's moving
            node.zRotation = angle
            
            node.run(SKAction.sequence([SKAction.wait(forDuration: CGFloat.random(in: 0...0.01)), SKAction.group([ SKAction.move(to: movePosition, duration: animation_speed), SKAction.scale(to: Double(Int.random(in: 5...10)), duration: animation_speed),  SKAction.fadeAlpha(to: 0.0, duration: animation_speed)])]))
        }
        
     //   boostCartoonAnimation()
        
    }
}
