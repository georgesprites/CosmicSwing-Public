//
//  GameplayHandler.swift
//  N Body No Problem
//
//  Created by Jorge Torres on 8/11/24.
//

import Foundation
import SpriteKit



enum VelocityModes {
    case savedVelocityMode
    case staticMode
}

struct challangeTrackingData {
    var numberOfCoinsCollected : Int = 0
    var numberOfShotsFired: Int = 0
    var challangeStarCollected: Bool = false
    
}

class GameplayHandler : SKNode, SKPhysicsContactDelegate {
    
    
    //var starReference : [SKSpriteNode] = []
    var gravityNodes = [GravityNode]()
    var trajectoryLineIntersectionWithStarCallback : ((_ dotNode: SKNode?) -> Void)? = nil
    
    var playerCrashedStartedTriggered : (() -> Void )? = nil
    
    var playerCrashedTriggered : (() -> Void )? = nil
    var astroCapturedHandler : ((_ hasPassedLevel: Bool, _ challangeData: challangeTrackingData? ) -> Void)? = nil
    var playerTookHealthDamage: ((_ percentage: CGFloat ) -> Void)? = nil
    var startingPositionReferenceNode = SKNode()
    let shipGuide = SKSpriteNode.init(imageNamed: "angle-guide")
    var cameraHandler = CameraHandler()
    var shipHasBeenPlaced = false
    var playerDestroyed: (() -> Void)? = nil
    var playerDetectedTriggered: (()-> Void)? = nil
    var pausePhysicsWorldCallback:  (()-> Void)? = nil
    var currentSelectedEntity = ProjectileEntity()
    var statisMode = false
    var playerIsControllingRotation = false
    var startingLine = SKShapeNode()
    var currentGameMode : GameModes = .ship
    var requiredAstrosToNextLevel = 0
    var currentCapturedAstros = 0
    var hasPassedLevel = false
    var isInitialSwing = true
    var collectCoinCallback:  ((_ coinNode: SKNode)-> Void)? = nil
    var shipReference = MotherShip()
    var enemies : [Enemey] = []
    var gravityLines : [SKShapeNode] = []
    var maxOverallForce = 350.0
    var referenceNodes : [SKNode]  = []
    var starTimerNode = SKNode()
    let lassoNode = SKNode()
    var hasStartedShootingMode = false
    var weaponRange = 2.5
    //Challange Tracking
    var challangeData = challangeTrackingData()
    var onRailsFileName : String? = nil
    var astroids : [SKSpriteNode] = []
    var hasEnteredLassoMode = false
    var velocityMode : VelocityModes = .staticMode
    var initialBounceSpeed = 1.0
    var savedLevelNodes : [SKNode]? = nil
    var savedSceneLevelName = ""
    var default_camera_scale_level = 1.0
    var time_to_mission_failed_screen = 1.0
    
    //MARK: Setup and Initialization Functions
    
    func setup(withBounceSpeed : CGFloat){
        
        self.initialBounceSpeed = withBounceSpeed
    }
    
    
    
    
    
    
    func updateSceneNodes(withNodes: [SKNode], withSceneLevelName: String, callback: (()->Void)? = nil){
        
        
        
        
        
        if(SharedInfo.SharedInstance.speed_loading == false ) {
            
            SharedInfo.SharedInstance.level_loader_speed_multipler = 1.0
        }
        
        var level_loading_speed_multipler = 1.0 * SharedInfo.SharedInstance.level_loader_speed_multipler
        
        
            
            savedLevelNodes =  withNodes.map { $0.copy() as! SKNode }

            savedSceneLevelName = withSceneLevelName

        
            
          
            self.addChild(starTimerNode)
            
        
        
            var animation_sequence : [SKAction] = []
            var starInfo = importPositionData(fileName: "stars-level"+withSceneLevelName+"-position")
        
            let starTimerData = importTimerData(from: "star_timer_data-level"+withSceneLevelName)
        
            for node in withNodes {
            
                animation_sequence.append(contentsOf: [
                    
                    
                    
                    
                    SKAction.run {
                        
                       
                        
                        self.createObjectFromNode(node: node, withNodes: withNodes, starInfo, starTimerData)
                    
                    }
                    
                    
                ])
        }
        
        self.run(SKAction.sequence( animation_sequence)) 
        
            
        
            
            
            
            self.addChild(lassoNode)
            
        
        if let callbackFunction = callback {
            callbackFunction()
        }
    }
    
    var numberOfStars = 0
    func createObjectFromNode(node: SKNode, withNodes: [SKNode] ,  _ starInfo: [starInfo]? = nil, _ starTimerData: [StarTimerData]? = nil){
        
        
        
        if node.name == "referenceNodes"  {
            
                    self.referenceNodes.append(node)
            
        } else if node.name == "gravitystar"
            {
            
            numberOfStars = numberOfStars + 1
            if let starInfo {
                if let starTimerData {
                    createGravityStarFromNode(allNodes: withNodes, node: node,  starInfo,  starTimerData)

                }
            } else {
                createGravityStarFromNode(allNodes: withNodes, node: node )
                
                (node as! GravityNode).run(SKAction.sequence([
                    
                   
                    SKAction.run {
                        (node as! GravityNode).initialPlacementAnimation()
                    }
                    
                ]))
                
            }
                
            } else if node.name == "startingPositionReferenceNode" {
                
            
                    createStartingPosition(node: node)
            
                
            }
            else if let nodeName = node.name, nodeName.contains("astro") {
 
                createAstroFromNode(node: node, withNodes: withNodes)
                
                
            } else if node.name == "EnemeyAttackDrone" {
                
                createEnemeyAttackDroneFromNode(node: node)
               
                
            } else if node.name == "coin" {
                
                animateCoin(node: node)
            } else if node.name == "star" {
                
                aniamteStar(node: node)
            } else if (node.name == "asteroid"){
                createAsteroidNode(node: node)
                
            }
        
    }
    
    
  
    
    func createAsteroidNode(node: SKNode){
        
        
        let randomRadius = CGFloat.random(in: 10...80)
        
        
        
        let asteroid = Asteroid(texture: SharedInfo.SharedInstance.asteroid_sprite_atlas!.textureNamed("Asteroid" + String(Int.random(in: 1...10))))
        asteroid.radius = randomRadius
        asteroid.setup()
        
        // Randomly position the asteroid within the screen bounds
        let varianced_position = CGPoint.init(x: node.position.x + (CGFloat.random(in: -50...50)), y: node.position.y + (CGFloat.random(in: -50...50)))
        asteroid.position = varianced_position
        node.removeFromParent()
        self.addChild(asteroid)

        astroids.append(asteroid)
        
        
    }
    

    func aniamteStar(node: SKNode){
        
        let star = node as! Star
        star.setup()
        
    }
    
    func animateCoin(node: SKNode){
        
        let coin = node as! Coin
        coin.removeFromParent()
        self.addChild(coin)
        coin.setup(withNode: node)
        
    }

    func createGravityStarFromNode(allNodes: [SKNode], node: SKNode, _ withStarInfo: [starInfo]? = nil, _ withStarTimeData: [StarTimerData]? = nil){
        
        let gravityNode = (node as! GravityNode)
        gravityNode.removeFromParent()
        self.addChild(gravityNode)
        gravityNode.setup()
        
        
        gravityNodes.append(gravityNode)
    
        var starID = 0
        if let SVGPath = gravityNode.userData?["SVGPath"] as? String {
        
     
            var offsetX = 0
            var offsetY = 0
            var modifiedTimeSVG = 30.0
            if let ID = node.userData?["ID"] as? Int {
                
                starID = ID
          
            if let currentStarInfo = withStarInfo {
                
                offsetX =  currentStarInfo[ID].xOffset
                offsetY =  currentStarInfo[ID].yOffset
                modifiedTimeSVG =   Double(currentStarInfo[ID].modifiedSVGDuration)

                
            } else {
            
                offsetX =    gravityNode.userData?["offsetX"] as! Int
                offsetY =    gravityNode.userData?["offsetY"] as! Int
            }
            }
            
            applyPocketSVGPathToSprite(sprite: gravityNode, svgResourceName: SVGPath , duration: modifiedTimeSVG  , node: gravityNode, offsetX: CGFloat(offsetX), offsetY: CGFloat(offsetY))
        
        } else if let nodeForWhichStarWillGravitateAroundMothaFucka = gravityNode.userData?["movementAroundReferencePoint"] as? String {
            
            for node in allNodes {
                if ( node.name == nodeForWhichStarWillGravitateAroundMothaFucka ) {
                    
                    node.removeFromParent()
                    self.addChild(node)
                    gravityNode.removeFromParent()
                    let newGravityStarPosition = self.convert(gravityNode.position, to: node)
                    gravityNode.position = newGravityStarPosition
                    node.addChild(gravityNode)
                    node.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(degreesToradians(30)), duration: 3)))
                }
            }
            
        }
        
        else {
            
            //NO SVG Path found, apply a subtle up and down animation to the star instead
            //random wait time applied to cause variance if multiple stars
            
            let wait_time = 2.0
            
            gravityNode.run(SKAction.sequence([ SKAction.wait(forDuration: CGFloat.random(in: 0.0...1.0)), SKAction.repeatForever(SKAction.sequence([
                
                SKAction.moveBy(x: 0, y: 10, duration: wait_time),
                SKAction.moveBy(x: 0, y: -10, duration: wait_time)
            
            ]))]))
        }
        
        //DO SOME TIMING FUN BABY
        
        if let timingInfo = withStarTimeData {
            
            if (timingInfo.indices.contains(starID)) {
                
                //We've identified some timing action!! Yahooo
                
                let timingData = timingInfo[starID].timerData
                let skactions_timing_sequence = createTimingSKActionArrayFromTimingData(timingData: timingData, node: gravityNode)
                
                if(skactions_timing_sequence.count > 0){
                    starTimerNode.speed = 1.0
                    starTimerNode.run(SKAction.repeatForever(SKAction.sequence(skactions_timing_sequence)))
                } else {
                    print("No SKACTIONs created")
                }
                
            }
        }
        
        
        if let customActionString = node.userData?["runCustomAction"] as? String {
            
            if ( customActionString == "moveRightRepeat" ) {
                
                node.run(SKAction.repeatForever(
                    
                    SKAction.sequence([
                    SKAction.moveBy(x: SharedInfo.SharedInstance.screenSize.width, y: 0, duration: 20)
                    , SKAction.moveBy(x: -SharedInfo.SharedInstance.screenSize.width, y: 0, duration: 20)
                    
                    ])
                    ))
            }
        }
        
    }
        
    func createTimingSKActionArrayFromTimingData(timingData: [TableRow], node: SKNode)->[SKAction]{
            
            var skActionsToReturn : [SKAction] = []
            
            for timeData in timingData {
                
                if(timeData.type == "WaitForDuration"){
                    
                    skActionsToReturn.append(SKAction.wait(forDuration: TimeInterval(timeData.value)))
                    
                } else if (timeData.type == "SpeedSet"){
                    
                    skActionsToReturn.append(SKAction.run {
                        
                        if(SharedInfo.SharedInstance.enableDebugModeForStarTiming){
                            let timerIndicateNode = SKSpriteNode.init(color: .green, size: CGSize.init(width: 5, height: 5))
                            
                            timerIndicateNode.zPosition = 1005
                            timerIndicateNode.position = node.position
                            
                            node.parent!.addChild(timerIndicateNode)
                        }
                      
                            node.speed = CGFloat(timeData.value)
                        
                    })
                }
                
                
                
            }
            
            return skActionsToReturn
            
        }
        
    func createStartingPosition(node: SKNode){
        
        playerIsControllingRotation = true
        
        startingPositionReferenceNode = node
        startingPositionReferenceNode.name = "startingPositionReferenceNode"
        //node.physicsBody!.categoryBitMask =  PhysicsCategory.earthplanet
        startingPositionReferenceNode.removeFromParent()
        
        
        
        
        if let nonDefaultY = node.userData?["nonDefaultPositionY"] as? Int {
            
            startingPositionReferenceNode.position.y = CGFloat(nonDefaultY)
            
           
        } else {
            startingPositionReferenceNode.position.y = -SharedInfo.SharedInstance.screenSize.height / 2
        }
        if let alignmentMode = node.userData?["horizontalAlignment"] as? String {
            
            if(alignmentMode == "Right"){
                startingPositionReferenceNode.position.x = SharedInfo.SharedInstance.screenSize.width / 2
            } else if ( alignmentMode == "Left") {
                startingPositionReferenceNode.position.x = -SharedInfo.SharedInstance.screenSize.width / 2

                
            }
        }
        
        var startingPositionRotationAmount = 160
        var rotationAngleMax = 160
        var rotationAngleMin = 90
        
        if let startingPositionRotationAmount_fromNode = node.userData?["startingPositionRotationAmount"] as? Int {
            
            startingPositionRotationAmount = startingPositionRotationAmount_fromNode
        }
        
        
        if let rotationAngleMax_fromNode = node.userData?["rotationAngleMax"] as? Int {
            
            rotationAngleMax = rotationAngleMax_fromNode
        }
     
        if let rotationAngleMin_fromNode = node.userData?["rotationAngleMin"] as? Int {
            
            rotationAngleMin = rotationAngleMin_fromNode
        }
        
        var positionFromReferenceNode = 250
        
        if let positionFromReferenceNode_fromNode = node.userData?["positionFromReferenceNode"] as? Int {
            
            positionFromReferenceNode = positionFromReferenceNode_fromNode
        }
        
        self.addChild(startingPositionReferenceNode)
        
      
        
        
        
        shipReference = MotherShip.init(imageNamed: "spaceship")
        
        
        gravityNodes.append(shipReference)

        shipReference.setup(withGameNodeReference: self)
    
        
        //currentSelectedEntity = shipReference
    
       
       
        
       
        
        
         if let shipGhostParticles = SKEmitterNode(fileNamed: "shipGhost-white") {
             
           // shipReference.addChild(shipGhostParticles)
           //  shipGhostParticles.position = CGPoint.init(x: 0, y:-shipReference.size.height/2)
            // shipGhostParticles.targetNode = self
         }
        
        
        
        startingPositionReferenceNode.addChild(shipReference)
        
        shipGuide.name = "angle-guide"
        //shipGuide.setScale(0.05)
        shipGuide.position.y = -(SharedInfo.SharedInstance.screenSize.height/2 * 1.3)

        self.addChild(shipGuide)

       // shipReference.setScale(0.25)
        shipReference.position.y = CGFloat(positionFromReferenceNode)
        //shipReference.zRotation = CGFloat(degreesToradians(90))
        
        
        //place sound here
        let bounce_sound_with_sound_check = SKAction.run {
            var bounce_sound =  SharedInfo.SharedInstance.audioHandler.playSoundWithName(fileName: "boing-2-44164")
            self.startingPositionReferenceNode.run(bounce_sound)
        }
        
        //TODO: BOUNCE HERE
        
        if(SharedInfo.SharedInstance.initialSwingAutoRotation){
            
            let initialRotation = SKAction.rotate(byAngle: CGFloat(degreesToradians(-Float((startingPositionRotationAmount/2)))), duration: initialBounceSpeed / 2 )
            initialRotation.timingMode = .easeInEaseOut
            
            let bounce_left = SKAction.rotate(byAngle: CGFloat(degreesToradians(Float(startingPositionRotationAmount))), duration: initialBounceSpeed)
            bounce_left.timingMode = .easeInEaseOut
            let bounce_right = SKAction.rotate(byAngle: CGFloat(degreesToradians(-Float(startingPositionRotationAmount))), duration: initialBounceSpeed)
            bounce_right.timingMode = .easeInEaseOut
            
            self.shipReference.initialPosition = self.shipReference.position
            self.shipReference.savedZRotation = self.shipReference.zRotation
        startingPositionReferenceNode.run(SKAction.sequence([
            initialRotation,
            bounce_sound_with_sound_check,
            SKAction.repeatForever(SKAction.sequence([
            bounce_left,bounce_sound_with_sound_check,
            bounce_right,bounce_sound_with_sound_check
            ]))
        
        ] ), withKey: "StartingRotationAction")
            
            
        }
    }
    
    func createAstroFromNode(node: SKNode, withNodes: [SKNode]){
        
        node.removeFromParent()
        let astroNode = node as! Astro
        astroNode.setup()
        
        if let rotatationStarID = node.userData?["rotatesAroundStarID"] as? Int {
            
            for star_node in withNodes {
                
                if let starId = star_node.userData?["ID"] as? Int {
                    
                    let referenceNode = SKNode()
                    referenceNode.position = star_node.position
                    self.addChild(referenceNode)
                    referenceNode.addChild(node)
                    astroNode.setupHelpSign()
                    referenceNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(degreesToradians(30)), duration: 10)))
                }
                
            }
          
            
            
        } else {
            
            self.addChild(node)
            astroNode.setupHelpSign()
        }
        
        
    }
    
    func createEnemeyAttackDroneFromNode(node: SKNode){
        
        node.removeFromParent()
        self.addChild(node)
        let attackDrone = (node as! EnemeyAttackDrone)
        attackDrone.run(SKAction.fadeAlpha(to: 1.0, duration: 1))
        if let movementType = attackDrone.userData?["movementType"] as? String {
            
            
            
            
            if movementType == "starRotation" {
                
                if let starRotationID = attackDrone.userData?["starRotationID"] as? Int {
                    
                    for gravity_node in gravityNodes {
                        
                        
                        
                        if let starID = gravity_node.userData?["ID"] as? Int {
                            
                            if starID == starRotationID  {
                                
                                //Found star to rotate around
                                
                                
                                //create a holder node because stationary stars will go up and down a bit
                                let holderNode = SKNode()
                                
                                holderNode.position = gravity_node.position
                                
                                
                                node.position = self.convert(node.position, to: holderNode)
                                
                                self.addChild(holderNode)
                                
                                
                                attackDrone.removeFromParent()
                                holderNode.addChild(attackDrone)
                                
                                holderNode.zPosition = 2
                                
                                if let rotationDirection = attackDrone.userData?["rotationDirection"] as? String {
                                    
                                    if (rotationDirection == "Left") {
                                        holderNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: 30, duration: 50)))
                                    }
                                    else
                                    if (rotationDirection == "Right") {
                                        holderNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: -30, duration: 50)))
                                    }
                                    
                                } else {
                                    
                                    if let duration = attackDrone.userData?["rotationDuration"] as? Float {
                                        print("Using attacik    \(duration)")
                                        holderNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: 30, duration: TimeInterval(duration))))
                                    } else {
                                        print("not found")
                                        holderNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: 30, duration: 25)))

                                    }
                                    
                                }
                                
                            }
                            
                            
                            
                        }
                    }
                    
                    
                }
                
                (node.childNode(withName: "trail") as! SKEmitterNode).targetNode = self
                (node.childNode(withName: "trail2") as! SKEmitterNode).targetNode = self

                
            } else if (movementType == "stationary"){
                //create a holder node because stationary stars will go up and down a bit
                let holderNode = SKNode()
                
                
                
                
                node.position = self.convert(node.position, to: holderNode)
                
                self.addChild(holderNode)
                
                
                attackDrone.removeFromParent()
                holderNode.addChild(attackDrone)
                
                holderNode.zPosition = 2
                
              
                
                
            } else if(movementType == "specialAction"){
                
                
                
                if let fireParticles = SKEmitterNode(fileNamed: "Enemey-Trail-Red") {
                    
                    
                    attackDrone.addChild(fireParticles)
                    fireParticles.position = CGPoint.init(x: 0, y: 0 )
                    
                    fireParticles.targetNode = self
                    
                    
                    let colorSequence = SKKeyframeSequence(keyframeValues: [
                        SKColor.red,  // Start color: White
                        SKColor.red,    // Midway color: Red (at 10%)
                        SKColor.clear   // End color: Black (at 90%)
                    ], times: [
                        0.0,   // White at 0% (start)
                        0.5,   // Red at 10%
                        1.0    // Black at 90% (last 10% of the lifetime)
                    ])
                    
                    fireParticles.zPosition = -100
                    fireParticles.particleColorSequence = colorSequence
                    
                }
                
                if let specialActionID = attackDrone.userData?["specialActionID"] as? Int {
                    
                    if(specialActionID == 0){
                        
                        
                        let direction = CGVector(dx: cos(attackDrone.zRotation + .pi / 2) * 1000, dy: sin(attackDrone.zRotation + .pi / 2) * 1000)
                        let startingPostion = attackDrone.position
                        attackDrone.run(SKAction.repeatForever( SKAction.sequence([
                            SKAction.move(by:direction, duration: 20),
                            SKAction.move(to:startingPostion , duration: 0.001)
                         

                        ])
                        ))
                    }  else if(specialActionID == 1){
                        
                        attackDrone.run(SKAction.repeatForever( SKAction.sequence([
                            SKAction.move(to: CGPoint.init(x: -SharedInfo.SharedInstance.screenSize.width , y: attackDrone.position.y), duration: 20),
                            SKAction.move(to: CGPoint.init(x: SharedInfo.SharedInstance.screenSize.width , y: attackDrone.position.y) , duration: 0.01)
                         

                        ])
                        ))
                        
                    }
                    
                }
                
            }
            
            
        }
        
        
        //Found star to rotate around
        
    
        
        
    
        
        attackDrone.setupPhysicsNode()
        attackDrone.setupDetectionNode()
        enemies.append(attackDrone)
        
    }
    
    func createAstroidField(){
        
        
        
        
        
        let screenWidth = SharedInfo.SharedInstance.screenSize.width
        let screenHeight = SharedInfo.SharedInstance.screenSize.height

        // Create 50 asteroids
        for _ in 0..<50 {
            // Generate a random sized radius for the asteroid between 10 and 25
            let randomRadius = CGFloat.random(in: 1...15)
            
            // Create an asteroid with a random radius
            let asteroid = Asteroid(texture: SharedInfo.SharedInstance.randomAsteroidShapeTextures[Int.random(in: 1...9)])
            asteroid.radius = randomRadius
            asteroid.setup()
            
            // Randomly position the asteroid within the screen bounds
            let randomX = CGFloat.random(in: -screenWidth / 2...screenWidth / 2)
            let randomY = CGFloat.random(in: -(screenHeight / 2) + 500...screenHeight )
            asteroid.position = CGPoint(x: randomX, y: randomY)
            
       
            
            // Add the asteroid to the scene
            self.addChild(asteroid)
            
            // Append the asteroid to the array
            astroids.append(asteroid)
        }
        
        //continually create new astroids outside the screen
        self.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.wait(forDuration: 5),
            SKAction.run {
                
                
                
                
                let screenWidth = SharedInfo.SharedInstance.screenSize.width
                let screenHeight = SharedInfo.SharedInstance.screenSize.height

                // Create 5 asteroids
                for _ in 0..<5 {
                    // Generate a random sized radius for the asteroid between 10 and 25
                    let randomRadius = CGFloat.random(in: 1...15)
                    
                    // Create an asteroid with a random radius
                    let asteroid = Asteroid(texture: SharedInfo.SharedInstance.randomAsteroidShapeTextures[Int.random(in: 1...9)])
                    asteroid.radius = randomRadius
                    asteroid.setup(withDampingAmount: 10)
                    
                    let randomEdge = Int.random(in: 0...3)
                    let randomX: CGFloat
                    let randomY: CGFloat

                    switch randomEdge {
                    case 0: // Top of the screen
                        randomX = CGFloat.random(in: -screenWidth / 2...screenWidth / 2)
                        randomY = screenHeight / 2 + 100 // Adjust 100 to your desired offset
                    case 1: // Bottom of the screen
                        randomX = CGFloat.random(in: -screenWidth / 2...screenWidth / 2)
                        randomY = -screenHeight / 2 - 100
                    case 2: // Left of the screen
                        randomX = -screenWidth / 2 - 100
                        randomY = CGFloat.random(in: -screenHeight / 2...screenHeight / 2)
                    case 3: // Right of the screen
                        randomX = screenWidth / 2 + 100
                        randomY = CGFloat.random(in: -screenHeight / 2...screenHeight / 2)
                    default:
                        randomX = 0
                        randomY = 0
                    }
                    
                    asteroid.position = CGPoint(x: randomX, y: randomY)
                    
                    // Add the asteroid to the scene
                    self.addChild(asteroid)
                    
                    // Append the asteroid to the array
                    self.astroids.append(asteroid)
                }
                
            }
        
        ])))
        
        
    }


    //MARK: GameLoop Helper Functions
    func returnCurrentGameMode()->GameModes{
        return currentGameMode
    }
    
    func runWindStreaks(){
        
        if let windStreaks = SKEmitterNode(fileNamed: "windStreaks") {
            
            windStreaks.position = self.position
            self.shipReference.addChild(windStreaks)
            windStreaks.targetNode = self
            var count = 0
            let birth_rate = 500
            self.run(SKAction.repeat(SKAction.sequence([
            
                SKAction.wait(forDuration: 0.1),
                SKAction.run {
                    
                   print("updating... " + String(count) )
                    windStreaks.particleRotation = self.shipReference.zRotation
                   count = count + 70
                    
                 
                  
                    let direction = CGVector(
                        dx: cos(self.shipReference.zRotation + .pi / 2 + .pi),
                        dy: sin(self.shipReference.zRotation + .pi / 2 + .pi)
                    )
                    let distance: CGFloat = 5000.0

                    windStreaks.xAcceleration = direction.dx * distance
                    windStreaks.yAcceleration = direction.dy * distance
                    windStreaks.particleBirthRate = CGFloat(birth_rate - count)
                           
                    
                }
            ]), count: 30))
        }
        
        
    }

    func slowDownEnemeies(){
        
        for enemy in enemies {
            print("slowed down speed to .10 on enemey drone")
            //If enemey attack drone is rotating around star, it will rotate around a reference node
            //If enemey attack drone follows a set pattern, parent is set to gameplay handler
            //TODO: Check node info if follow direction is RotationAroundStar, otherwise set speed directly on node
            //Bug on Tail of enemey, speed is slowed down for attack drone but birth rate on emmiter does not change resulting in short tail
            
            if let enemy_parent =  enemy.parent {
                enemy_parent.speed = 0.10
            }
        }
        
    }
    
    func speedUpEnemies() {
        
        for enemy in enemies {
            if let enemy_parent =  enemy.parent {
                enemy_parent.speed = 1.00
            }
        }
    }
    
    func slowDownGravityNodes()
    
    {
        
        for gravityNode in gravityNodes {
            
            if gravityNode.name == "MotherShip" { continue }
            
            print("slowed down speed to .10 on enemey drone")
            //If enemey attack drone is rotating around star, it will rotate around a reference node
            //If enemey attack drone follows a set pattern, parent is set to gameplay handler
            //TODO: Check node info if follow direction is RotationAroundStar, otherwise set speed directly on node
            //Bug on Tail of enemey, speed is slowed down for attack drone but birth rate on emmiter does not change resulting in short tail
            
            if let nodeForWhichStarWillGravitateAroundMothaFucka = gravityNode.userData?["movementAroundReferencePoint"] as? String {
                
                gravityNode.parent!.speed = 0.10
                
            }
                gravityNode.speed = 0.10
            
        }
        
    }
    
    func speedUpGravityNodes(){
        
        
        for gravityNode in gravityNodes {
            if (gravityNode.name == "MotherShip") { continue }
            gravityNode.speed = 1.0
            
        }
        
    }
    
    func shrinkPlayerNearStar(){
        
        let maxDistance = 300.0
  
        var closestDistance = CGFloat.greatestFiniteMagnitude
               
        var reference_graivty_node : GravityNode? = nil
        
        
               // Find the closest star
               for gravity_node in gravityNodes {
                   
                
                   
                   if gravity_node.name == "MotherShip" { continue }
                   
                   var distance = 0.0
                    if let _ = gravity_node.userData?["movementAroundReferencePoint"] as? String {
                        let converted_poistion = gravity_node.parent!.convert( gravity_node
                            .position, to: self)
                        distance = hypot(shipReference.position.x - converted_poistion.x, shipReference.position.y - converted_poistion.y)

                        
                   } else {
                       distance = hypot(shipReference.position.x - gravity_node.position.x, shipReference.position.y - gravity_node.position.y)
                   }
                   
                   
                   if(distance < closestDistance){
                       reference_graivty_node = gravity_node
                   }
                   closestDistance = min(closestDistance, distance)
               }
               
               // If the asteroid is within maxDistance, scale it based on proximity to the closest star
               if closestDistance <= maxDistance {
                   let normalizedDistance = closestDistance / maxDistance
                   let scale = max(reference_graivty_node!.minShrink, normalizedDistance )
                   
                   
                   // Scale between 0.10 and 1.0
                   shipReference.setScale(scale)
               } else {
                   // Beyond maxDistance, set scale to 1.0
                   shipReference.setScale(1.0)
               }
           
        
    }
    
    func shrinkAstroidsNearStars(){
        
        let maxDistance = 300.0
        for asteroid in astroids {
               var closestDistance = CGFloat.greatestFiniteMagnitude
               
               // Find the closest star
               for starPosition in gravityNodes {
                   if starPosition.name == "MotherShip" { continue }
                   
                   if(starPosition.parent?.name == "referenceNode") {
                       
                       
                       let converted_star_position = starPosition.parent!.convert(starPosition.position, to: self)
                       
                       let distance = CGFloat(hypot(asteroid.position.x - converted_star_position.x, asteroid.position.y - converted_star_position.y))
                       closestDistance =  min(closestDistance, distance)

                       
                   } else {
                       
                       let distance = CGFloat(hypot(asteroid.position.x - starPosition.position.x, asteroid.position.y - starPosition.position.y))
                       closestDistance =  min(closestDistance, distance)

                   }
                   
                  
               }
               
               // If the asteroid is within maxDistance, scale it based on proximity to the closest star
               if closestDistance <= maxDistance {
                   let normalizedDistance = closestDistance / maxDistance
                   let scale = max(0.0, normalizedDistance) // Scale between 0.10 and 1.0
                   asteroid.setScale(scale)
               } else {
                   // Beyond maxDistance, set scale to 1.0
                   asteroid.setScale(1.0)
               }
           }
        
        
    }
    
    func drawGravityLines(){
        
        for gravityLine in gravityLines {
            gravityLine.removeFromParent()
           
        }
        gravityLines.removeAll()
        for planet in gravityNodes {
            
            
            if(planet.name == "MotherShip"){ continue }
            let path = CGMutablePath()
            path.move(to: planet.position)
            
            path.addLine(to: shipReference.position)
            let line = SKShapeNode(path: path)
            let maxDistance: CGFloat = 350 // Adjust this value as needed
            let distance = hypot(shipReference.position.x - planet.position.x,
                                    shipReference.position.y - planet.position.y)
            // Map distance to alpha value
            let alpha: CGFloat = max(0.0, 1.0 - (distance / maxDistance))
               
            
            let minLineWidth: CGFloat = 1.0
               let maxLineWidth: CGFloat = 5.0
               let lineWidth: CGFloat = minLineWidth + (maxLineWidth - minLineWidth) * alpha
               // Set line color with adjusted alpha
            line.lineWidth = lineWidth

            line.strokeColor = UIColor(white: 1.0, alpha: alpha)
            self.addChild(line)
            
            gravityLines.append(line)
        }
        
        
        
    }
    
    func playerHasBeenDetectedAtDetectionNode(enemeyNode: EnemeyAttackDrone){
        
        
        
        for child in children {
            
            let saved_rotation = child.zRotation
            
            
            if(child.name != "MotherShip"){
             //   child.zRotation = saved_rotation
              //  child.physicsBody?.isDynamic = false
                child.isPaused = true
                
            } else {
                
                child.zRotation = saved_rotation

            }
            

            
            
        }
        
        let savedCameraPosition = self.cameraHandler.position
        
        
           
                  
           self.run(SharedInfo.SharedInstance.audioHandler.playSoundWithName(fileName: "sonic-boom-sound-effect-240487"))
        
        
        let camera_animation_time = 0.25
  
        self.cameraHandler.run(
            SKAction.sequence([
                SKAction.group([
                    SKAction.move(to: shipReference.position, duration: camera_animation_time),
                    SKAction.scale(to: 0.85, duration: camera_animation_time)]),
                SKAction.run {
                  
                    let convertedEneemyDronPostion = self.convert(enemeyNode.position, from: enemeyNode.parent!)

                    var explosion_sound =  SharedInfo.SharedInstance.audioHandler.playSoundWithName(fileName: "xplosion-under-snow-sfx-230505")
            
                    let fireNode = SKSpriteNode.init(color: .red, size: CGSize.init(width: 5, height: 50 ))
                    fireNode.position = convertedEneemyDronPostion
            
                    let dx = self.shipReference.position.x - fireNode.position.x
                    let dy = self.shipReference.position.y - fireNode.position.y
            
            
                    let angle = atan2(dy, dx)
                    fireNode.zRotation = angle - .pi  / 2
             
                    self.addChild(fireNode)
            
                    fireNode.run(SKAction.move(to: self.shipReference.position, duration: 0.10),
                    
                                 completion:  {
                        

                        fireNode.removeFromParent()
                        self.cameraHandler.shakeCamera(duration: 0.20, 6.0)
                        self.shipReference.runExplisionAnimation()
                        self.shipReference.dischargeParticleAnimation()
                   
                        self.shipReference.texture = nil

                        
                    } )
            },
                SKAction.sequence([
                    SKAction.wait(forDuration: self.time_to_mission_failed_screen),
                    SKAction.run {
                        self.shipReference.removeFromParent()

                        self.playerCrashedTriggered?()
            
                }])]))
        
        
        
        
        
    }
             

    func playerHasCrashedIntoStar(){
        
        
        
            self.run(SharedInfo.SharedInstance.audioHandler.playSoundWithName(fileName: "explosion-effect-1"))
           
            
            
        
        
        
        playerCrashedStartedTriggered!()
        for child in children {
            
            
            child.physicsBody?.isDynamic = false
            if(child.name != "MotherShip"){
                child.isPaused = true
            }
            
            
        }
        
        let savedCameraPosition = self.cameraHandler.position
        
        
        
  
        self.cameraHandler.run(
            SKAction.sequence([
                SKAction.group([
                    SKAction.move(to: CGPoint.init(x: self.cameraHandler.position.x , y: shipReference.position.y), duration: 0.5)
                    ]),
                SKAction.run {
                    
                   // self.cameraHandler.shakeCamera(duration: 0.20, 6.0)
           
                    if let fireParticles = SKEmitterNode(fileNamed: "Sparko") {
    
                        fireParticles.position = self.shipReference.position
                        self.addChild(fireParticles)
                        fireParticles.targetNode = self
                                }
            
                    let xMark = SKSpriteNode.init(imageNamed: "xmarksthespot")
                    xMark.position = self.shipReference.position
                    self.addChild(xMark)
                    xMark.zPosition = 50
                    self.shipReference.runExplisionAnimation()
                            }])
        )
        
        
        //Wait time before running the Mission failed UI
        
        self.run(SKAction.sequence([SKAction.wait(forDuration: time_to_mission_failed_screen), SKAction.run {
        
            self.shipReference.removeFromParent()
            self.playerCrashedTriggered?()
            
        }]))
        
    }
                                                        
    func missileModeToggled(_ sender: JKButtonNode){
        
        if (currentGameMode != .missile ) {
            
            currentGameMode = .missile
            
            
            
            
            
        }  else {
            
            currentGameMode = .camera
        }
        
    }
    
    func shipModeToggled(_ sender: JKButtonNode) {
        
        if (currentGameMode != .ship
        ) {
            
            currentGameMode = .ship
            
            
            
            
            
        }  else {
            
            currentGameMode = .camera
        }
    }
    
    func runShipLaunchAnimation(){
        
        
        startingLine.removeFromParent()
        
        startingPositionReferenceNode.isPaused = false
        let speedmuliplier = 2.0
        //Small bounce back animtaition
        /*self.currentSelectedEntity.run(SKAction.sequence([ SKAction.scale(to: 0.15, duration: 0.05 * speedmuliplier),
            SKAction.scale(to: 0.35, duration: 0.025 * speedmuliplier),
            SKAction.scale(to: 0.15, duration: 0.025 * speedmuliplier),
            SKAction.scale(to: 0.25, duration: 0.025 * speedmuliplier)
                                                         ]))*/
        
        self.shipReference.recreatePhysicsBody()
        self.shipReference.physicsBody?.isDynamic = true
   
        if(!SharedInfo.SharedInstance.initialSuperBoostKickOffFeature){
            playerIsControllingRotation = false
        }
        
        let circleNodes = SKShapeNode(circleOfRadius: 50)
        circleNodes.lineWidth = 4
        circleNodes.strokeColor = .white
        circleNodes.position = shipReference.position
        self.addChild(circleNodes)
        circleNodes.zPosition = 100
        circleNodes.alpha = 0.4
        circleNodes.run(SKAction.group([
            
            SKAction.scale(to: 20, duration: 0.20),
            SKAction.fadeAlpha(to: 0.0, duration: 0.20)
        
        
        ]) )
        
        
        
        
        
        
    }
    
    func applyForce(to sprite: SKSpriteNode, vector: CGVector, _ multipler: CGFloat = 100.0) {
         
        
        
        
        let impulseVector = CGVector(dx: vector.dx * multipler, dy: vector.dy * multipler )  // Adjust multiplier as needed
       // sprite.physicsBody?.isDynamic = true
        sprite.physicsBody?.applyImpulse(impulseVector)
        
        
    }
    
    
    func playerLetGoBeforeFullForce(){
        
        
        
    }
    
    //MARK: Shooting Functions
    
    func shootByWireActivated( ){

    }
    
    func shootByWireAttackButtonStarted(){
        
        
        self.run(SKAction.repeatForever(
            SKAction.sequence([
            
            
        
            SKAction.run {
            
                
                let fireNode = SKSpriteNode.init(color: .white , size: CGSize.init(width: 2, height: 50))
                
                fireNode.physicsBody = SKPhysicsBody.init(rectangleOf: fireNode.size , center: CGPoint.zero)
                  
                fireNode.physicsBody?.categoryBitMask = PhysicsCategory.playerProjectile
                fireNode.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
                fireNode.physicsBody?.collisionBitMask = PhysicsCategory.none
                fireNode.physicsBody?.isDynamic = false
                fireNode.physicsBody?.usesPreciseCollisionDetection = true
                
                  // Rotate the sprite to face the target point
                
               
                
                
                self.addChild(fireNode)
                fireNode.position = self.shipReference.position
               
                // Calculate the direction based on the ship's zRotation
                let direction = CGVector(dx: cos(self.shipReference.zRotation + .pi / 2), dy: sin(self.shipReference.zRotation + .pi / 2))
                       
                       // Define the distance to move the node (e.g., 500 points)
                       let distance: CGFloat = 2000.0
                       let moveAction = SKAction.move(by: CGVector(dx: direction.dx * distance, dy: direction.dy * distance), duration: 1.0)
                       
                
               
                
                let angle = atan2(direction.dy, direction.dx)
                fireNode.zRotation = angle - .pi  / 2
                
                
                
                fireNode.run(moveAction)
                
                    //fireNode.run(moveAction)
                
            }, SKAction.wait(forDuration: 0.2) ] )
        ), withKey: "ShootByWireAction")
        
    }

    func shootOnceFired(button: JKButtonNode){
        
        challangeData.numberOfShotsFired = challangeData.numberOfShotsFired + 1

        
            hasStartedShootingMode = true
            
            let fireNode = SKSpriteNode.init(color: .cyan , size: CGSize.init(width: 2, height: 50))

        fireNode.physicsBody = SKPhysicsBody.init(rectangleOf: CGSize.init(width: 4, height: 60))
        fireNode.physicsBody?.affectedByGravity = false
        fireNode.physicsBody?.usesPreciseCollisionDetection = true
        fireNode.physicsBody?.allowsRotation = false
        fireNode.physicsBody?.isDynamic = true
    
        fireNode.physicsBody?.categoryBitMask = PhysicsCategory.playerProjectile
        fireNode.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        fireNode.physicsBody?.collisionBitMask = PhysicsCategory.none
        fireNode.physicsBody?.fieldBitMask = PhysicsCategory.none
        fireNode.position = self.shipReference.position
        
        // var shot_sound =  SharedInfo.SharedInstance.audioHandler.playSoundWithName(fileName: "retro-laser-1-236669"), pewpewpewpew, cute / 10
        
       // var shot_sound =  SharedInfo.SharedInstance.audioHandler.playSoundWithName(fileName: "sci-fi-weapon-shoot-firing-plasma-ku-02-233815") /// POH POH POH POH , sick / 10 , dis da one
        ///
        ///
        ///
        //var shot_sound =  SharedInfo.SharedInstance.audioHandler.playSoundWithName(fileName: "sci-fi-weapon-shoot-firing-plasma-pp-05-233829"), PWERPEW, strange ending reverb, heavy/10
        //var shot_sound =  SharedInfo.SharedInstance.audioHandler.playSoundWithName(fileName: "sci-fi-weapon-shoot-firing-pulse-tm-05-233825") Also pretty good, too much vibration but heavy
            // var shot_sound =  SharedInfo.SharedInstance.audioHandler.playSoundWithName(fileName: "scifi-gun-shoot-2-266418"), decent, sounds muffled, almost star warsy , maybe in a certain case could be useful
        
        var shot_sound =  SharedInfo.SharedInstance.audioHandler.playSoundWithName(fileName: "sci-fi-weapon-shoot-firing-plasma-ku-02-233815") 
        self.run(shot_sound)
        
        self.addChild(fireNode)

        
   
        
    
      
            // Calculate the direction based on the ship's zRotation
            let direction = CGVector(dx: cos(self.shipReference.zRotation + .pi / 2), dy: sin(self.shipReference.zRotation + .pi / 2))
                   
                   // Define the distance to move the node (e.g., 500 points)
        let distance: CGFloat = 1000.0 * weaponRange
        let moveAction = SKAction.move(by: CGVector(dx: direction.dx * distance, dy: direction.dy * distance), duration: weaponRange)
                   
            
           
            
            let angle = atan2(direction.dy, direction.dx)
            fireNode.zRotation = angle - .pi  / 2
            
            
            
            fireNode.run(moveAction)
    }
    
    func shootByWireAttackButtonEnded(){
        
        
        self.removeAction(forKey: "ShootByWireAction")
    }
    
    func shootByWireJoystickStarted(){
        
        playerIsControllingRotation = true
       
    }
    
    func shootByWireJoystickEnded(){
        
        playerIsControllingRotation = false
       
        
    }
    
    func shootByWireJoystickHandleMovement(data: AnalogJoystickData){
        
        
        shipReference.zRotation = data.angular
        
    }
    
    //MARK: GameScene Passthrough and Real-time Functions

    func handleSelectedObjectsZRotation(){
        
        
        if(!playerIsControllingRotation){
            
            
            if(!hasEnteredLassoMode){
            
                
           
                if let velocity = self.shipReference.physicsBody?.velocity {
                    // Calculate the angle from the velocity vector
                    let angle = atan2(velocity.dy, velocity.dx) - (CGFloat.pi / 2)
                    // Adjust the sprite's rotation
                    
                    
                    //TODO: There needs to be check before player launched here
                    self.shipReference.zRotation = angle
                } else {
                    //dont rotate the ship
                    
                    
                }
                
                    
                    
                }  else {
                    
                    //Lasso mode , rotate ship around star
                    let dx = shipReference.position.x - lassoNode.position.x
                    let dy = shipReference.position.y - lassoNode.position.y
                    var angle = atan2(dy, dx)
                    angle -= .pi
                    let correctionFactor: CGFloat = .pi / 36
                    // Adjust to make the spaceship face the direction it's moving
                    shipReference.zRotation = angle - correctionFactor
                    print("updating zrotation automagiallly...")
            }} else {
                
                
                
                         //0-3.14 left up, down
                //-3.14 to 0 down, up
            }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
       

        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        
        if secondBody.categoryBitMask == PhysicsCategory.player && firstBody.categoryBitMask == PhysicsCategory.gravityStar {
            //Player crashed into a star
            
            if let  playerDetectedTriggered {
                playerDetectedTriggered()
            }

            playerHasCrashedIntoStar()
            
            
        } else if ((secondBody.categoryBitMask == PhysicsCategory.playerProjectile && firstBody.categoryBitMask == PhysicsCategory.enemy) || (secondBody.categoryBitMask == PhysicsCategory.enemy && firstBody.categoryBitMask == PhysicsCategory.playerProjectile)) {
            
            //Player projectile hit enemey
            
            
            if let secondbody_node = secondBody.node {
                secondbody_node.removeFromParent()
            }
            if let firstbody_node = firstBody.node {
                firstbody_node.removeFromParent()
            }
            
            
        }
        
        else if ((secondBody.categoryBitMask == PhysicsCategory.enemeyProjectile && firstBody.categoryBitMask == PhysicsCategory.player) || (secondBody.categoryBitMask == PhysicsCategory.player && firstBody.categoryBitMask == PhysicsCategory.enemeyProjectile)) {
            
            //MARK: Enemey Projectile on Player

            
            if let fireParticles = SKEmitterNode(fileNamed: "miniSparko") {
                
                fireParticles.particleColor = .red
                fireParticles.particleColorSequence = nil
                fireParticles.name = "trail"
                fireParticles.position = secondBody.node!.position
                self.addChild(fireParticles)
                fireParticles.targetNode = self
            }
            
 
            
            shipReference.currentHealth = shipReference.currentHealth - 1
            
            if (shipReference.currentHealth == 0) {
                firstBody.node!.removeAllActions()
                secondBody.node!.removeAllActions()
                
                for enemy in enemies {
                    enemy.stopAttackOnPlayer()
                    
                }
                self.playerDestroyed?()
                
                
                
            }
            
            self.playerTookHealthDamage?(CGFloat(shipReference.currentHealth /  shipReference.totalHealth ))
            
            
        }
        
        else if ( secondBody.categoryBitMask == PhysicsCategory.player && firstBody.categoryBitMask == PhysicsCategory.earthplanet || secondBody.categoryBitMask == PhysicsCategory.earthplanet && firstBody.categoryBitMask == PhysicsCategory.player ) {
            
            
            //player hit earth planet
            
            
            
            
        } else if ( secondBody.categoryBitMask == PhysicsCategory.whip && firstBody.categoryBitMask == PhysicsCategory.gravityStar ) {
            
            //MARK: Trajector Line Intersects with GravityNode
            
            if let dotNode = secondBody.node {
                self.trajectoryLineIntersectionWithStarCallback?( dotNode )
            }
            
            
            
        }  else if ( secondBody.categoryBitMask == PhysicsCategory.player && firstBody.categoryBitMask == PhysicsCategory.astronaut || secondBody.categoryBitMask == PhysicsCategory.astronaut && firstBody.categoryBitMask == PhysicsCategory.player )  {
            
            //MARK: Astro Collected by Player

            
            currentCapturedAstros = currentCapturedAstros + 1
            
            
            if(currentCapturedAstros == requiredAstrosToNextLevel){
                
                self.pausePhysicsWorldCallback!()
                self.cameraHandler.run(
                    SKAction.sequence([
                    SKAction.scale(to: 0.8, duration: 0.05)
                    
                    ]))
                hasPassedLevel = true
                //set playercontrol to true or else zRotation method updates rotation to null due to dynamic false
                playerIsControllingRotation = true
                self.shipReference.physicsBody?.isDynamic = false

                
            }
            
            let node =  secondBody.node!
            
            let astro_node = node as! Astro
            
            
            astro_node.runCollectionAnimation(withPlayerPosition: self.shipReference.position)
            

            //wait 2 seconds for the AstroCollected Animation before passing level
            self.run(SKAction.sequence([
            
                SKAction.wait(forDuration: 1),
                SKAction.run {
                    self.astroCapturedHandler?(self.hasPassedLevel, self.challangeData)

                }
            ]))
            
            
            
            
            
        } else if ( secondBody.categoryBitMask == PhysicsCategory.player && firstBody.categoryBitMask == PhysicsCategory.player_detection || secondBody.categoryBitMask == PhysicsCategory.player_detection && firstBody.categoryBitMask == PhysicsCategory.player  ) {
            

            //MARK: Enemey Player Detection on Player

         
            
            if let  playerDetectedTriggered {
                playerDetectedTriggered()
            }

            
            var EnemeyNode = EnemeyAttackDrone()
            if(firstBody.categoryBitMask == PhysicsCategory.player_detection) {
                
                EnemeyNode = firstBody.node?.parent! as! EnemeyAttackDrone
                
            } else {
                
                EnemeyNode = secondBody.node?.parent! as! EnemeyAttackDrone
                
            }
            

            
            playerHasBeenDetectedAtDetectionNode(enemeyNode: EnemeyNode)
            
            
          
        } else if (  secondBody.categoryBitMask == PhysicsCategory.playerProjectile && firstBody.categoryBitMask == PhysicsCategory.asteroid || secondBody.categoryBitMask == PhysicsCategory.asteroid && firstBody.categoryBitMask == PhysicsCategory.playerProjectile
        
        ) {
            
            
            //MARK: Asteroid , Player Projectile Collision

            if(secondBody.categoryBitMask == PhysicsCategory.asteroid){
                
                if let asteroidNode = secondBody.node as? Asteroid {
                    
                    //Astroid got shot at needs to run some sort of descrution on asteroid
                    
                    
                    asteroidNode.asteroidHit()
                    var shot_sound =  SharedInfo.SharedInstance.audioHandler.playSoundWithName(fileName: "rock-destroy-6409")
                    self.run(shot_sound)
                    

               
               
                    //Remove the lazer
                    
                    if let lazerNode = firstBody.node {
                        lazerNode.removeFromParent()
                    }
                    
                    
                    
                }
                
            } else {
                
              
                
            }
            
        } else if (  secondBody.categoryBitMask == PhysicsCategory.gravityStar && firstBody.categoryBitMask == PhysicsCategory.asteroid || secondBody.categoryBitMask == PhysicsCategory.asteroid && firstBody.categoryBitMask == PhysicsCategory.gravityStar
                               
        )  {
            
            //MARK: Astroid Collision with Gravity Node
            
            
            if let asteroidNode = secondBody.node as? Asteroid {
                
                //Astroid collided with Star, destroy astroid
                
                asteroidNode.astroidDestroyed()
                
                
                
                
            }
        }
            else if (  secondBody.categoryBitMask == PhysicsCategory.player && firstBody.categoryBitMask == PhysicsCategory.asteroid || secondBody.categoryBitMask == PhysicsCategory.asteroid && firstBody.categoryBitMask == PhysicsCategory.player
                                   
            )  {
                
                //MARK: Astroid Collision with Gravity Node
                
                
                
                if let asteroidNode = secondBody.node as? Asteroid {
                    
                    //Astroid collided with Star, destroy astroid
                    
                    asteroidNode.astroidDestroyed()
                    
                    return
                    
                    
                }
            
            if let asteroidNode = firstBody.node as? Asteroid {
                
                //Astroid collided with Star, destroy astroid
                
                asteroidNode.astroidDestroyed()
                return
                
                
                
            }
            
            
            
            
            
            
        } else if (  secondBody.categoryBitMask == PhysicsCategory.coin && firstBody.categoryBitMask == PhysicsCategory.player || secondBody.categoryBitMask == PhysicsCategory.player && firstBody.categoryBitMask == PhysicsCategory.coin
                     
        ) {
            
            //MARK: Coin Collection
            
            
            var coin_collect_sound =  SharedInfo.SharedInstance.audioHandler.playSoundWithName(fileName: "retro-coin-4-236671")
                 
            
            if let coin = secondBody.node as? Coin{
                coin.runCollectionAnimation()
            }
            for i in 1...Int.random(in: 2...5) {
                
                let sparkle_position_range : CGFloat = 60
                let sparkle_sprite = SKSpriteNode.init(imageNamed: "sparkle")
                sparkle_sprite.alpha = CGFloat.random(in: 0.4...0.8)
                sparkle_sprite.setScale(CGFloat.random(in: 0.5...1.2))
                let spread_point = CGPoint.init(x: CGFloat.random(in: secondBody.node!.position.x - sparkle_position_range ... secondBody.node!.position.x + sparkle_position_range ) , y: CGFloat.random(in: secondBody.node!.position.y - sparkle_position_range ... secondBody.node!.position.y + sparkle_position_range ))
                sparkle_sprite.position = spread_point
                sparkle_sprite.zPosition = CGFloat.random(in: -1...5)
                sparkle_sprite.run(SKAction.sequence([ SKAction.scale(by: 1.2, duration: 0.1), SKAction.group([  SKAction.scale(to: 0.0, duration: CGFloat.random(in: 0.25...1)), SKAction.fadeAlpha(to: 0.0, duration: 0.5)])]), completion:  {
                    
                    sparkle_sprite.removeFromParent()
                    
                    
                    
                } )
                self.addChild(sparkle_sprite)
                
            }
                
            collectCoinCallback!(secondBody.node!)
                /*
            secondBody.node!.run(SKAction.fadeAlpha(to: 0.0, duration: 0.25), completion: {
                secondBody.node!.removeFromParent()

                
                
            } )*/
            

            
            self.run(coin_collect_sound)
            challangeData.numberOfCoinsCollected = challangeData.numberOfCoinsCollected + 1
            
        }
        else if (  secondBody.categoryBitMask == PhysicsCategory.star && firstBody.categoryBitMask == PhysicsCategory.player || secondBody.categoryBitMask == PhysicsCategory.player && firstBody.categoryBitMask == PhysicsCategory.star
                    
       ) {
           
            challangeData.challangeStarCollected = true
            secondBody.node!.removeFromParent()
           
       }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ( secondBody.categoryBitMask == PhysicsCategory.player && firstBody.categoryBitMask == PhysicsCategory.player_detection || secondBody.categoryBitMask == PhysicsCategory.player_detection && firstBody.categoryBitMask == PhysicsCategory.player  ) {
            
            //Detected player inside player detection
            
        }
    }
    
    func update(_ currentTime: TimeInterval){
       
        
    }
    
    var savedVelocity : CGVector = CGVector(dx: 0, dy: 0)
    var savedAngularVelocity = 1.0
    func savePlayerVelocity(){
        savedVelocity = self.shipReference.physicsBody!.velocity
        savedAngularVelocity = self.shipReference.physicsBody!.angularVelocity
    }
    
    
    var forceVector = CGVector.zero
    var savePlayersZRotation = 0.0
    func touchesBeganPassthrough(_ touches: Set<UITouch>, with event: UIEvent?, withScene: SKScene) {
        
        savePlayersZRotation = self.shipReference.zRotation

        lassoNode.zPosition = 1001
      
        if(!shipHasBeenPlaced){
                
            if(SharedInfo.SharedInstance.initialSwingAutoRotation == true ) {
                startingPositionReferenceNode.removeAction(forKey: "StartingRotationAction")
                
            }   else {
                    
               // currentSelectedEntity = shipReference
                    
            }
                
            if(SharedInfo.SharedInstance.initialSuperBoostKickOffFeature){
                    
                    //Need to remove the ship reference away from the holder node we use for initial rotation movement and onto the gameplay handler, transpose position and rotation
                    let savedPosition = shipReference.position
                    shipReference.removeFromParent()
                    let newPosition = convert(savedPosition, from: startingPositionReferenceNode)
                    shipReference.position = newPosition
                    self.addChild(shipReference)
                    
                    shipReference.zRotation = startingPositionReferenceNode.zRotation
                    shipReference.isPaused = false
                    shipHasBeenPlaced = true
                    shipReference.boostChargeUpAnimation()
                    
                    
                
                    
                    
                }  else  {
                
                
                for gravity_node in gravityNodes {
                    if(gravity_node.name == "MotherShip") { continue }
                    gravity_node.isPaused = true
                    starTimerNode.isPaused = true
                }
                
                
                shipGuide.run(SKAction.fadeAlpha(to: 0.0, duration: 0.135))
                
                //startingPositionReferenceNode.isPaused = true
                
             
                
                    let savedPosition = shipReference.position
                    shipReference.removeFromParent()
                    let newPosition = convert(savedPosition, from: startingPositionReferenceNode)
                    shipReference.position = newPosition
                    self.addChild(shipReference)
                    shipReference.zRotation = startingPositionReferenceNode.zRotation
                    shipReference.isPaused = false
                    shipHasBeenPlaced = true
                    shipReference.boostChargeUpAnimation()
                
                if let fireParticles = SKEmitterNode(fileNamed: "Smoke") {
                    
                    
                    fireParticles.name = "trail"
                    shipReference.addChild(fireParticles)
                    fireParticles.position = CGPoint.init(x: 0, y:  -shipReference.size.height )
                    
                    fireParticles.targetNode = self
                    
                    
                    
                    if(SharedInfo.SharedInstance.initialSwingAutoRotation == false ) {
                        if let touch = touches.first {
                            
                            let touchLocation = touch.location(in: self)
                           // shipReference.position.x = touchLocation.x
                            
                        }
                        
                        
                        
                    } else {
    
                        
                        //Need to remove the ship reference away from the holder node we use for initial rotation movement and onto the gameplay handler, transpose position and rotation
                        let savedPosition = shipReference.position
                        shipReference.removeFromParent()
                        let newPosition = convert(savedPosition, from: startingPositionReferenceNode)
                        shipReference.position = newPosition
                        self.addChild(shipReference)
                        shipReference.zRotation = startingPositionReferenceNode.zRotation
                    }
                    
                }
                }
            }
        
            
           
    }
    
    func touchesMovedPassthrough(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    func touchesEndedPassthrough(savedVelocity: CGVector, savedAngularVelocity: CGFloat, triggeredByInitial: Bool){
        
        
        
        if(isInitialSwing){
            
            if(SharedInfo.SharedInstance.initialSuperBoostKickOffFeature && triggeredByInitial){
                runShipLaunchAnimation()
               
                shipReference.isPaused = false
                isInitialSwing = false
                runWindStreaks()
            } else {
                
                runShipLaunchAnimation()
                runWindStreaks()
            }
       
        } else {
            
                
                runShipLaunchAnimation()
               
               

        }
        
    }
    
    
    
    func playerBounceBackOnX(){
        
        if(self.shipReference.physicsBody!.velocity.dx > 0){
            self.shipReference.physicsBody!.velocity.dx =   -self.shipReference.physicsBody!.velocity.dx
        } else {
            
            self.shipReference.physicsBody?.velocity.dx = (self.shipReference.physicsBody?.velocity.dx)! * -1
            
        }
        
    }
    
    func playerBounceBackY(){
        if(self.shipReference.physicsBody!.velocity.dy > 0){
            self.shipReference.physicsBody!.velocity.dy =   -self.shipReference.physicsBody!.velocity.dy
        } else {
            
            self.shipReference.physicsBody?.velocity.dy = (self.shipReference.physicsBody?.velocity.dy)! * -1
            
        }
        
    }
    
 
    
    
    //MARK: Level Restart Functions
    
    func restartLevel(callback: @escaping ()->Void){
        
    
        currentCapturedAstros = 0
        if let particles = self.shipReference.childNode(withName: "ShipPathTaken"){
            particles.removeFromParent()
            recursiveRemovalOfNodeChildren(node: self)
            self.addChild(particles)
            particles.zPosition = 10001
            particles.alpha = 0.1
        } else {
            recursiveRemovalOfNodeChildren(node: self)

            
        }
        self.gravityNodes = []
        self.cameraHandler.run(SKAction.group([ SKAction.scale(to: self.default_camera_scale_level * 1.0, duration: 0.3), SKAction.move(to: CGPoint.zero, duration: 0.3) ]))
        
        self.isInitialSwing = true
        self.shipHasBeenPlaced = false
        self.updateSceneNodes(withNodes: savedLevelNodes!, withSceneLevelName: savedSceneLevelName, callback: callback)
      
    }
    
    func recursiveRemovalOfNodeChildren(node: SKNode){
        
        for child_node in node.children {
            
            recursiveRemovalOfNodeChildren(node: child_node)
            child_node.removeAllChildren()
            
        }
        
        node.removeAllChildren()
        
    }
    
}
