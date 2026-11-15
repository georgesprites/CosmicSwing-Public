import SpriteKit
import GameplayKit
import AudioToolbox

import GoogleMobileAds
import AVFoundation

class GameScene: SKScene, FullScreenContentDelegate {
    
    
    
    var backgroundHandler : BackgroundHandler? = nil
    private var videoNode: SKVideoNode!
       private var playerLooper: AVPlayerLooper!

    var dotGridManager = DotGridManager()
    let trajectoryLineManager = TrajectoryLineManager()
    var gameplayHandler = GameplayHandler()
    var uiHandler = UIHandler()
    var planetPoints : [(position: CGPoint, radius: CGFloat)] = []
    var initialTouchLocation: CGPoint?
    var followShip = false
    
    var frameSkipper = 0
    var movevmeentreleaseLocation : CGPoint?
    var isCameraZoomToggled = false
    let cameraZoomSpeed = 0.05
    let force_multiplier = 2.0
    let maxForce: CGFloat = 350
    var dialogMode = false
    var levelYUpperLimit = 0
    var levelYLowerLimit = 0
    var isSubsequentSwingsEnabled = false
    var isShootingEnabled = false
    var initialEnemeyPosition : CGPoint = CGPoint.zero

    var blockInitialSuperBoostTouches = false
    //How much boost is used in first swing
    let initialSwingBoostMaxAmount = 250.0
    var tapIcon : SKSpriteNode? = nil
    var playerHasCrashedDueToZoomOut = false
    var savedScaledValue = 0
    var scaledValueTimerElapsedTime : TimeInterval = 0
    private var startTime: Date?
    var hasToggledVelocityModes = false
    var useSavedVelocity = false
    var playerRunningSwingAnimation = false
    var waitOneExtraTocuhesEndedIndex = 0
    var playerLaunchedCameraShakeDuration : Float = 0.20
    var playerLaunchedCameraShakeAmplitude : CGFloat = 100.0
    var physics_world_speed = 1.00
    
    
    
    var level_force_multiplier : Float = 100.0
    
    
    //MARK: Initialization
    override func didMove(to view: SKView) {
        //Lock the screen from touches to make sure no crashy
        
        
        
        
        var savedSceneOnlyNodes = self.children
        isPauseMenuShowing = true
        
        
        if(SharedInfo.SharedInstance.speed_loading == false ) {
            
            SharedInfo.SharedInstance.level_loader_speed_multipler = 1.0
        }
        
        var level_loading_speed_multipler = 1.0 * SharedInfo.SharedInstance.level_loader_speed_multipler
        
        if let hasInitialDialog = self.userData?["hasInitialDialog"] as? Bool {
            
            if(hasInitialDialog){
                dialogMode = true
          
                uiHandler.hasInitialDialog = true
                

                
                
            }
            
        }
        
        
        if let default_camera_scale_level = self.userData?["default_camera_scale_level"] as? Float {
            
            self.gameplayHandler.default_camera_scale_level = Double(default_camera_scale_level)
            
            self.gameplayHandler.cameraHandler.setScale(CGFloat(default_camera_scale_level))
            
            SharedInfo.SharedInstance.default_camera_scale_level =  Double(default_camera_scale_level) 
            
        }
        
        
        
       
        if let physics_world_speed_fromNode = self.userData?["physicsWorldSpeedDefault"] as? Float {
            
            self.physics_world_speed = Double(physics_world_speed_fromNode)
            
        }
        
        if let after_boost_physics_world_speed = self.userData?["after_boost_physics_world_speed"] as? Float {
            
            SharedInfo.SharedInstance.after_boost_physics_world_speed = CGFloat(after_boost_physics_world_speed)
            
        }
        
        
        
        
        
        if let onRailsGameType = self.userData?["onRailsGameType"] as? Bool {
            SharedInfo.SharedInstance.initialSuperBoostKickOffFeature = false
            SharedInfo.SharedInstance.initialSwingAutoRotation = false
            if(onRailsGameType){
                SharedInfo.SharedInstance.onRailsPathFeature = true
                
                
                self.gameplayHandler.onRailsFileName = self.userData!["onRailsFileName"] as? String
                
                
                
            }
           
            
        }
        
        
        
        if let initialPlayerBounceSpeed  = self.userData?["initialPlayerBounceSpeed"] as? Float {
            self.gameplayHandler.setup(withBounceSpeed: CGFloat(initialPlayerBounceSpeed))
        }
        
        
        if let initialSwingAutoRotation  = self.userData?["initialSwingAutoRotation"] as? Bool {
            SharedInfo.SharedInstance.initialSwingAutoRotation = initialSwingAutoRotation
        }
        
        if let initialSuperBoostKickOffFeature  = self.userData?["initialSuperBoostKickOffFeature"] as? Bool {
            SharedInfo.SharedInstance.initialSuperBoostKickOffFeature = initialSuperBoostKickOffFeature
        }
        
        
        if let asteroidMinSize   = self.userData?["asteroidMinSize"] as? Float {
            SharedInfo.SharedInstance.asteroid_min_size = CGFloat(asteroidMinSize)
        }
        
        
        if let asteroidMaxSize   = self.userData?["asteroidMaxSize"] as? Float {
            SharedInfo.SharedInstance.asteroid_max_size = CGFloat(asteroidMaxSize)
        }
        
        
        
        if let asteroidOutlineSize = self.userData?["asteroidOutlineSize"] as? Float {
            SharedInfo.SharedInstance.asteroid_outline_size = CGFloat(asteroidOutlineSize)
            
            
        }
        
        
        
        if let coin_scale_factor = self.userData?["coin_scale_factor"] as? Float {
            SharedInfo.SharedInstance.coin_scale_factor = CGFloat(coin_scale_factor)
            
            
        }
        
        
        if let subsequentSwingsEnabled = self.userData?["isSubsequentSwingsEnabled"] as? Bool {
            self.isSubsequentSwingsEnabled = subsequentSwingsEnabled
        } else {
            self.isSubsequentSwingsEnabled = true
        }
      
        
        if let isShootingEnabledValue = self.userData?["isShootingEnabled"] as? Bool {
            self.isShootingEnabled = isShootingEnabledValue
        } else {
            self.isShootingEnabled = true
        }
        
        if let hasEndingDialog = self.userData?["hasEndingDialog"] as? Bool {
            
            if(hasEndingDialog){
              
                uiHandler.hasEndingDialog = true
            }
            
        }
        
        
        
        if let upperYLimit = self.userData?["levelYUpperLimit"] as? Int {
            
            
            self.levelYUpperLimit = upperYLimit
        } else {
            
            self.levelYUpperLimit = 1000
        }
         
        
        
        SharedInfo.SharedInstance.initializeVariables()
        SharedInfo.SharedInstance.safeAreaLayoutSize = self.view!.safeAreaLayoutGuide.layoutFrame.size
        SharedInfo.SharedInstance.screenSize = self.size
        SharedInfo.SharedInstance.safeAreaInserts =  self.view!.safeAreaInsets
        
        if let lowerYLimit = self.userData?["levelYLowerLimit"] as? Int {
            
            self.levelYLowerLimit = lowerYLimit
            
        } else {
            self.levelYLowerLimit = Int(-SharedInfo.SharedInstance.screenSize.height / 2)

            
        }
        
        var backgroundName = "none"
        
        if let backgroundName_fromNode = self.userData?["backgroundName"] as? String { 
            backgroundName = backgroundName_fromNode
            
            
        }
        
        
        if let local_level_force_multiplier = self.userData?["level_force_multiplier"] as? Float {
            level_force_multiplier = local_level_force_multiplier
        }
        
        backgroundHandler = BackgroundHandler(texture: nil, color: UIColor.clear, size: CGSize.zero, backgroundName: backgroundName, backgroundColor: self.userData?["backgroundColor"] as? String)
        
        self.addChild(self.gameplayHandler.cameraHandler)
        self.addChild(backgroundHandler!)
        self.addChild(gameplayHandler)
        self.addChild(trajectoryLineManager)
        
        self.run(SKAction.sequence([
            
            SKAction.wait(forDuration: 10 * level_loading_speed_multipler ),
            
            SKAction.run {
                
                self.gameplayHandler.cameraHandler.addChild(self.uiHandler)
            }
            
            
        ]))
  
        self.addChild(dotGridManager)
        uiHandler.bottomMenuBar.cameraButton?.action = self.gameplayHandler.cameraHandler.zoomTogglePressed
        
        self.physicsWorld.contactDelegate = self.gameplayHandler
        
        setSceneOptions()
        
        self.backgroundColor = SharedInfo.SharedInstance.backgroundColor
        
        
        
        self.camera = self.gameplayHandler.cameraHandler
        
        SharedInfo.SharedInstance.audioHandler.playInitialSound()
        
        
        var astroNames : [String] = []
        
        for child in children {
            
            if let nodeName = child.name, nodeName.contains("astro") {
                
                
                
                // Extract everything after "astro"
                if let range = nodeName.range(of: "astro") {
                    var suffix = String(nodeName[range.upperBound...]) // Get the part after "astro"
                    
                    if suffix.isEmpty {
                        suffix = "John"
                    }
                    astroNames.append(suffix)
                }
                
                
                
            }}
        
        uiHandler.dialogModeCompletedCallback = self.dialogModeCompletedCallback
        uiHandler.endDialogModeCompletedCallback = self.endDialogCompletedCallbackGoToNextLevel
        
        uiHandler.setup(withAstroNames: astroNames, withLevelID: self.name!, withSubsequentSwingEnabled: self.isSubsequentSwingsEnabled, isShootingEnabled: isShootingEnabled)
        
        backgroundHandler!.setup()
      
       
        
        self.run(SKAction.sequence([
            
            SKAction.wait(forDuration: 2.5 * level_loading_speed_multipler),
            SKAction.run {
                
                
                
                if let dotSpacing = self.userData?["dotSpacing"] as? Int {
                    
                    
                    if let dotSize = self.userData?["dotSize"] as? Int {
                        
                        if let dotGridSizeHeight = self.userData?["dotGridSizeHeight"] as? Int {
                            
                            
                                 if let dotGridSizeWidth = self.userData?["dotGridSizeWidth"] as? Int {
                                     
                                     //Going to assume DotSize, Height and Width are already defined as new properties
                                     
                                     
                                     self.dotGridManager.setupDots( scene: self, withCameraPos: self.gameplayHandler.cameraHandler.position, withDotSpacing: dotSpacing,  dotGridSize: CGSize.init(width: CGFloat(dotGridSizeWidth), height: CGFloat(dotGridSizeHeight)), passed_dotSize: dotSize)
                                     
                            
                        }
                           
                            
                            
                            
                        }
                      
                        
                    } else {
                        
                        //dot Spacing is defined but dotSize is not
                        
                        
                        self.dotGridManager.setupDots( scene: self, withCameraPos: self.gameplayHandler.cameraHandler.position, withDotSpacing: dotSpacing)
                    }
                    
                    
                } else {
                
                    self.dotGridManager.setupDots( scene: self, withCameraPos: self.gameplayHandler.cameraHandler.position)
                    
                }
                
                
            }
            
        ]))
        

        
        self.dotGridManager.allDotsCompletedAnimationCallback = self.allDotsCompletedAnimationCallbackHandler
        //Create astroid textures
        
        
        for i in 0...10 {
            
            createRandomAsteroidShapes()
        }
        
        self.run(SKAction.sequence([SKAction.wait(forDuration: 5.0 * level_loading_speed_multipler ), SKAction.run {
            

            
            self.gameplayHandler.updateSceneNodes(withNodes: savedSceneOnlyNodes, withSceneLevelName: self.name!)
            //Lock the screen from touches to make sure no crashy
            self.isPauseMenuShowing = false
            
            
            
        }]))
        
        
        
        physicsWorld.gravity = CGVector(dx:0, dy: 0);
        
        
        self.uiHandler.completion.continueButton.action = self.continueButtonPressed
        self.uiHandler.missionFailedUI.restartButton.action = self.restartLevelButtonPressed
        
        
        gameplayHandler.trajectoryLineIntersectionWithStarCallback = self.trajectoryLineManager.trajectoryLineIntersectedWithStar
        
        gameplayHandler.playerCrashedTriggered = self.playerCrashedTriggered
        gameplayHandler.playerCrashedStartedTriggered = self.playerCrashedStartedTriggered
        gameplayHandler.playerDetectedTriggered = self.playerDetectedAtEnemeyDetectionNodeTriggered
        
        gameplayHandler.astroCapturedHandler = self.astroCapturedHander
        
        gameplayHandler.requiredAstrosToNextLevel = self.userData?["astrosRequiredForNextLevel"] as! Int
        
        gameplayHandler.playerTookHealthDamage = uiHandler.playerTookHealthHit
        
        gameplayHandler.playerDestroyed = self.playerDestroyed
        
        uiHandler.bottomMenuBar.missileButton?.action = gameplayHandler.missileModeToggled
        
        uiHandler.bottomMenuBar.shipButton?.action =
        gameplayHandler.shipModeToggled
        
        
        uiHandler.bottomMenuBar.lazerButton?.action = self.shootByWireButtonPressed
        
        
        
        uiHandler.shootByWireMenu.movementJoystick.trackingHandler =
        self.gameplayHandler.shootByWireJoystickHandleMovement
        
        uiHandler.shootByWireMenu.movementJoystick.beginHandler =
        self.gameplayHandler.shootByWireJoystickStarted
        
        uiHandler.shootByWireMenu.movementJoystick.stopHandler =
        self.gameplayHandler.shootByWireJoystickEnded
        
        
        
        uiHandler.getCurrentGameModeHandler = self.gameplayHandler.returnCurrentGameMode
        
        uiHandler.bottomMenuBar.cameraButton?.action = self.catchButtonAction
        uiHandler.bottomMenuBar.settingsButton?.action = self.catchButtonAction
        
        uiHandler.settingsMenu.restartButton.action = self.restartLevelButtonPressed
        
        uiHandler.pauseButton.action = self.pauseButtonPressed
        uiHandler.settingsMenu.closeButton.action = self.closeButtonOnSettingsMenuPressed
        uiHandler.levelPickerMenu.close_button.action = self.closeButtonOnSettingsMenuPressed
        
        dotGridManager.collectedDotCallback = self.enginePowerCollectedCallback
        
        
        if let hasInitialDialog = self.userData?["hasInitialDialog"] as? Bool {
          
            
            uiHandler.dialogModeTouchInitiated()

            self.run(SKAction.sequence([
                
                
              
                    
                    
                    
                SKAction.wait(forDuration: 10 * level_loading_speed_multipler ),
                SKAction.run {
                    //self.uiHandler.dialogModeTouchInitiated()
                    self.uiHandler.completion.show()
                }
                
            ]))
           
            
        }
        
        uiHandler.levelPickerMenu.levelSelectorButtonPressedCallback = self.levelSelected
       
        uiHandler.shootByWireButton.action = shotFired
        
      
        
       
        self.physicsWorld.speed = 5

        
        if(SharedInfo.SharedInstance.createLevelBorder){
         createBorder()
        } 
        
        //Testing failed menu
       //self.uiHandler.missionFailedUI.show()
        
        
        
        if(SharedInfo.SharedInstance.astroidFeature){
            
            self.gameplayHandler.createAstroidField()
            
        }
      

        
        self.gameplayHandler.pausePhysicsWorldCallback = self.pausePhysicsWorldCallback
        
        self.gameplayHandler.collectCoinCallback = self.collectCoinCallback
        
        
        InterstitialAdManager.shared.load()
        
        
        
        if(self.name! == "1"){
                
            tapIcon = SKSpriteNode(imageNamed: "tap-simple")
            tapIcon?.position.x = (SharedInfo.SharedInstance.screenSize.width / 2) - (tapIcon!.size.width / 2) - 10
            
            tapIcon!.zPosition = 5000
            tapIcon?.run(SKAction.repeatForever(SKAction.sequence([
                
                SKAction.wait(forDuration: 0.5),
                SKAction.move(by: CGVector.init(dx: 0, dy: -200), duration: 1),
                SKAction.move(by: CGVector.init(dx: 0, dy: 200), duration: 0.0001)
                
                
            ])))
            
            self.addChild(tapIcon!)
            
            if(SharedInfo.SharedInstance.hasAlreadyAcceptedTutorialVideo == false){
            tapIcon?.alpha = 0
            uiHandler.alpha = 0
            let backgroundBlur = SKSpriteNode.init(color: .black, size: CGSize.init(width: self.size.width * 2, height: self.size.height * 2 ))
            self.addChild(backgroundBlur)
                backgroundBlur.name = "backgroundBlur"
            backgroundBlur.zPosition = 5000
        //    backgroundBlur.alpha = 0.9
            
            
            
            guard let url = Bundle.main.url(forResource: "Tutorial", withExtension: "mp4") else {
                       print("Video not found")
                       return
                   }
                   
                   let asset = AVAsset(url: url)
                   let item = AVPlayerItem(asset: asset)
                   
                   let queuePlayer = AVQueuePlayer()
                   playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: item)
                   
                   videoNode = SKVideoNode(avPlayer: queuePlayer)
                  
                   videoNode.zPosition = 5001
                   
                   addChild(videoNode)
                   
                   queuePlayer.play()
            
        
        let tutorial_banner = SKSpriteNode.init(imageNamed: "tutorial.png")
        self.addChild(tutorial_banner)
        tutorial_banner.position.y = self.size.height / 2
        tutorial_banner.zPosition = 5002
                tutorial_banner.name = "tutorial_banner"
            let accept_button = JKButtonNode.init(backgroundNamed: "accept")
            accept_button.enabled = false
            accept_button.position.y = -self.size.height / 2
            accept_button.zPosition = 5003
            accept_button.alpha = 0
            accept_button.run(SKAction.repeatForever(
                
                SKAction.sequence([
                    SKAction.scale(to: 1.0, duration: 0.2),
                    SKAction.scale(to: 1.2, duration: 0.2)
                    
                ])
            ))
            accept_button.run(SKAction.sequence([
                SKAction.wait(forDuration: 12),
                SKAction.run {
                    accept_button.enabled = true
                    accept_button.alpha = 1
                }
                
            ]))
            self.addChild(accept_button)
                accept_button.name = "accept_button"
            accept_button.action = level1acceptButtonPressed
                
        }
            
        }
        
    }
    
    
  
    func level1acceptButtonPressed(button: JKButtonNode) {
        
        
        let acceptButton = self.childNode(withName: "accept_button") as! JKButtonNode
        acceptButton.enabled = false
        acceptButton.alpha = 0.0
        
        SharedInfo.SharedInstance.setProperty(property: "hasAcceptedLevel1Video", setTo: true)
        let backgroundBlur = self.childNode(withName: "backgroundBlur")
        backgroundBlur?.run(SKAction.fadeAlpha(to: 0, duration: 0.5))
        backgroundBlur?.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.run {
                backgroundBlur?.removeFromParent()
            }
            
        ]))
        
        tapIcon?.alpha = 1.0
        uiHandler.alpha = 1.0
        let tutbanner =  self.childNode(withName: "tutorial_banner")
        tutbanner?.run(SKAction.sequence([
            SKAction.fadeAlpha(to: 0.0, duration: 0.5),
            SKAction.run {
                tutbanner?.removeFromParent()
            }
            
        ]))
        
        videoNode.run(SKAction.sequence([
            SKAction.fadeAlpha(to: 0.0, duration: 1.0),
            SKAction.run {
                tutbanner?.removeFromParent()
            }
            
        ]))
    }
    
    func playerCrashedStartedTriggered() {
        
        
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { }
        updateDotPositionFlag = false

        
        let textureAtlas = SKTextureAtlas(named: "ShipExplosion")
        
        // Create an array to hold the textures
        var frames: [SKTexture] = []
    
        // Load all 16 frames from the atlas
        for i in 1...7 {
        
            var textureName = ""
        
            var append = ""
       
            
            
            textureName =   "shipexplosion00" +  String(format: "%03d", i)
            frames.append(textureAtlas.textureNamed(textureName))
        }
    
        // Create the animation action
        let animation = SKAction.animate(with: frames, timePerFrame: 0.041, resize: false, restore: true)
        //self.setScale(0.50)
        let animation_node = SKSpriteNode()
        animation_node.position = self.gameplayHandler.shipReference.position
        self.addChild(animation_node)
        animation_node.run(animation)
        
        self.gameplayHandler.cameraHandler.shakeCamera(duration: 0.5, 10)
        
        
    }
    
    func createRandomAsteroidShapes(){
     
            let newShape = SKShapeNode()
              // Ensure size is within the valid range
            let clampedSize = max(SharedInfo.SharedInstance.asteroid_min_size, SharedInfo.SharedInstance.asteroid_max_size)
              
              // Create the asteroid's jagged path
              let path = CGMutablePath()
              let numberOfPoints = Int.random(in: 8...12)
              let angleIncrement = (2 * CGFloat.pi) / CGFloat(numberOfPoints)
              
              for i in 0..<numberOfPoints {
                  // Randomize the radius for jagged edges
                  let radius = clampedSize * CGFloat.random(in: 0.75...1.25)
                  let angle = angleIncrement * CGFloat(i)
                  
                  let x = radius * cos(angle)
                  let y = radius * sin(angle)
                  
                  if i == 0 {
                      path.move(to: CGPoint(x: x, y: y))
                  } else {
                      path.addLine(to: CGPoint(x: x, y: y))
                  }
              }
              path.closeSubpath()
              
              // Assign the path to the shape node
        newShape.path = path
              
              // Style the asteroid
        newShape.fillColor = .black
        newShape.strokeColor = .white
        newShape.lineWidth = SharedInfo.SharedInstance.asteroid_outline_size
       
            
        let texture = view!.texture(from: newShape)
        SharedInfo.SharedInstance.randomAsteroidShapeTextures.append(texture!)
           
        }
    
    func createSKAtlasFromAstroidTexture(){
        
        
        var skAtlas = SKTextureAtlas()
        
        
    }
    
    func collectCoinCallback(node: SKNode){
        
        let convertedPosition = node.parent!.convert(node.position, to: self.gameplayHandler.cameraHandler)
    
        
        node.removeFromParent()
        
        node.position = convertedPosition
       

        self.gameplayHandler.cameraHandler.addChild(node)
        
        
        node.run(SKAction.sequence([
            SKAction.scale(to:  1.2, duration: 0.05),
            SKAction.group([
                SKAction.scale(to: 1, duration: 0.5),
                SKAction.fadeAlpha(to: 0.0, duration: 0.6),
                SKAction.move(to: self.uiHandler.coinIcon.position, duration: 0.5)]),
        
            SKAction.run {
                self.uiHandler.coinIcon.run(SKAction.sequence([
                    SKAction.scale(to: 1.1, duration: 0.1),
                    SKAction.scale(to: 1.0, duration: 0.1)
                ]))
                node.removeFromParent()
            }]))
        
        
        
    }
    func setSceneOptions(){
        self.view?.showsDrawCount = true
        self.scene?.view?.showsPhysics = SharedInfo.SharedInstance.showPhysics
        self.scene?.view?.showsFields = false
        
    }
    
    var savedPhysicsWorldSpeed = 0.0
    func pausePhysicsWorldCallback(){
        
        self.savedPhysicsWorldSpeed = self.physics_world_speed
        self.physicsWorld.speed = 0.0
    }
    
    func unPausePhysicsWorldCallback(){
        
        
        
        
    }
    func createBorder(){
        
        let levelBorder = CGMutablePath()
        levelBorder.move(to: CGPoint.init(x: CGFloat( (-SharedInfo.SharedInstance.safeAreaLayoutSize.width  ) * 1.3), y: CGFloat(self.levelYLowerLimit)))
                         
        levelBorder.addLine(to: CGPoint.init(x: CGFloat( (SharedInfo.SharedInstance.safeAreaLayoutSize.width  ) * 1.3), y: CGFloat(self.levelYLowerLimit)))
        
        
        levelBorder.addLine(to: CGPoint.init(x: CGFloat( (SharedInfo.SharedInstance.safeAreaLayoutSize.width  ) * 1.3), y: CGFloat(self.levelYUpperLimit)))
        
        
        levelBorder.addLine(to: CGPoint.init(x: CGFloat( (-SharedInfo.SharedInstance.safeAreaLayoutSize.width  ) * 1.3), y: CGFloat(self.levelYUpperLimit)))
        
        levelBorder.addLine(to: CGPoint.init(x: CGFloat( (-SharedInfo.SharedInstance.safeAreaLayoutSize.width  ) * 1.3), y: CGFloat(self.levelYLowerLimit)))
        
        
        let borderSprite = SKShapeNode.init(path: levelBorder)
        borderSprite.strokeColor = .red
        borderSprite.lineWidth = 5
        borderSprite.alpha = 0.2
        self.addChild(borderSprite)
    
        
        
    }
    
    
    //MARK: Gameloop Handlers
    
    func astroCapturedHander( hasPassedLevel: Bool, challangegData: challangeTrackingData? ){
        
        self.uiHandler.runCapturedAstro(hasPassedLevel: hasPassedLevel, challangegData: challangegData)
        
        if(hasPassedLevel){
            //set Dialog mode to true to freeze up the touches
            self.dialogMode = true
            self.uiHandler.dialogMode = .endingDialogMode
            self.uiHandler.pauseButton.enabled = false
            self.uiHandler.pauseButton.alpha = 0.0
            
        }
    }

    
    
    func shotFired(button: JKButtonNode){
    
    
            self.removeAction(forKey: "GradualSpeedUpOnInitialLaunch")
            self.removeAction(forKey: "shootingSpeeedup")
            self.physicsWorld.speed = 0.10
            
        self.gameplayHandler.slowDownEnemeies()
        
        
            self.run(SKAction.sequence([SKAction.wait(forDuration: 5), SKAction.run {
                self.physicsWorld.speed = 1.0
                
                self.gameplayHandler.speedUpEnemies()
                
                self.gameplayHandler.hasStartedShootingMode = false
                
                self.uiHandler.initialTouchLocationIndicator.alpha = 1.0
                
                self.uiHandler.shootByWireMenu.position.y = -SharedInfo.SharedInstance.self.screenSize.height

                
            }]), withKey: "shootingSpeeedup")
            
            
            
        self.uiHandler.initialTouchLocationIndicator.alpha = 0.0
        
        self.uiHandler.shootByWireMenu.position.y = -SharedInfo.SharedInstance.self.screenSize.height / 2 + ( self.uiHandler.shootByWireMenu.movementJoystick.diameter )

        self.gameplayHandler.shootOnceFired(button: button)
        
    }
    
    func dialogModeCompletedCallback(){
        
        
            self.dialogMode = false

        
        
    }
    
    func enginePowerCollectedCallback(){
        
        
        
        gameplayHandler.shipReference.enginePowerCollected()
        self.uiHandler.initialTouchLocationIndicator.setEnginePower(value: gameplayHandler.shipReference.enginePower)
        
        
        
    }
    
    
    func closeButtonOnSettingsMenuPressed(button: JKButtonNode ){
        
        isPauseMenuShowing = false
        
        for child in gameplayHandler.children {
            child.isPaused = false
            if let pkbody = child.physicsBody {
                pkbody.restorePhysicsState()  // Restore the saved state
                
            }
            
            for inner_child in child.children {
                
                inner_child.isPaused = false
                if let pkbody = inner_child.physicsBody {
                    pkbody.restorePhysicsState()  // Restore the saved state
                    
                }
                
            }
            
        }
        
        self.uiHandler.settingsMenu.hide()
        self.uiHandler.levelPickerMenu.hide()
        
    }
    
    func catchButtonAction(button: JKButtonNode) {
        
        
    }
    func shootByWireButtonPressed(button: JKButtonNode ) {
        
        gameplayHandler.shootByWireActivated()
        self.uiHandler.shootByWireActivated()
        
    }
    
    
    
  
    var isPauseMenuShowing = false
    func pauseButtonPressed(button: JKButtonNode){
        
        isPauseMenuShowing = true
        
        for child in gameplayHandler.children {
            child.isPaused = true
            if let pkbody = child.physicsBody {
                pkbody.savePhysicsState()  // Save the current state
                pkbody.isDynamic = false
            }
            
            for inner_child in child.children {
                
                inner_child.isPaused = true
                if let pkbody = inner_child.physicsBody {
                    pkbody.savePhysicsState()  // Save the current state
                    pkbody.isDynamic = false
                }
                
            }
            
        }
        
        self.uiHandler.settingsMenu.isPaused = false 
        self.uiHandler.settingsMenu.show()
        
        
    }
    
    func restartCompleted(){
        dialogMode = false

    }
    
    func restartLevel(){
        
        
        //activate Dialog mode while resetup to avoid updates
        dialogMode = true
        blockInitialSuperBoostTouches = false
        self.uiHandler.missionFailedUI.hide()
        self.uiHandler.numberOfCollectedAstros = 0
        self.uiHandler.resetAstroUI()
        self.uiHandler.settingsMenu.hide()
        self.uiHandler.pauseButton.alpha = 1.0
        self.physicsWorld.speed = 5

        self.gameplayHandler.restartLevel(callback: self.restartCompleted)
        isPauseMenuShowing = false
        updateDotPositionFlag = true
        
        //Used to block additional touches from entering while the ship is moving 
        detectedFirstTouch = false
        detectedTouchesEnded = false

        
    }
    
    func restartLevelButtonPressed(button: JKButtonNode){
        
        

        SharedInfo.SharedInstance.currentRestartCount += 1

           let shouldShowAd = (SharedInfo.SharedInstance.currentRestartCount % 2) == 0

            let restartGame: () -> Void = { [weak self] in
                self?.restartLevel()
            }

           if shouldShowAd {
               
               if (SharedInfo.SharedInstance.displayAds == true) {
                   InterstitialAdManager.shared.show(
                    from: self.view!.window!.rootViewController!,
                    completion: restartGame
                   )} else { restartGame() }
           } else {
               restartGame()
           }
        
        
    }
    
    func continueButtonPressed(button: JKButtonNode){
        
        self.uiHandler.completion.hide()
        self.uiHandler.levelPickerMenu.close_button.alpha = 0.0
        self.uiHandler.levelPickerMenu.show(withLevelCompleted: self.name!, withNumberOfStarsCompletedOnLevel: 3)
        
        
    var continue_button_pressed_sound_effect =  SharedInfo.SharedInstance.audioHandler.playSoundWithName(fileName: "success-48018_GewaRA3l.mp3")
   
    self.run(continue_button_pressed_sound_effect)
    }
    
    func endDialogCompletedCallbackGoToNextLevel(){
        
        
      
        self.uiHandler.completion.presentContinueButton()
        
        
    }
    
    func levelSelected(withLevelName: String){
        
        
        
        let scene = SKScene(fileNamed: "Level" + withLevelName)
        
        
        self.dotGridManager.hyperSpaceNextLevelTransition(withCameraPos: self.gameplayHandler.cameraHandler.position)
        
        for child in self.children {
            if (child.name != "dot"){
                
                child.run(SKAction.fadeAlpha(to: 0.0, duration: 0.3))
            }
        }
        
        
        if let emitter =  (self.gameplayHandler.shipReference.childNode(withName: "trail") as? SKEmitterNode)
        {
            emitter.removeAllChildren()
            emitter.removeFromParent()
        }
        self.gameplayHandler.shipReference.removeAllChildren()
        self.gameplayHandler.shipReference.run(SKAction.fadeAlpha(to: 0.0, duration: 0.3))
        self.gameplayHandler.startingPositionReferenceNode.alpha = 0.0
        
        self.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.run {
            
            if let scene = scene {
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene)
            }
           
            
        }]))
        
    }
    
    var missionFailed = false
    
    func playerCrashedTriggered(){
        
        
        missionFailed = true
        self.isPauseMenuShowing = true
        self.uiHandler.missionFailedUI.menuTriggered()
        self.uiHandler.pauseButton.alpha = 0.0
        
        
    }
    
    
    func playerDetectedAtEnemeyDetectionNodeTriggered(){
        
        
        
        
        self.playerRunningSwingAnimation = true
        
        self.physicsWorld.speed = 0.01
        
    }
    
    
    func playerDestroyed(){
        
       /* gameplayHandler.speed = 0.005
        for children in gameplayHandler.children {
            
            children.speed = 0.005
            
            for child in children.children {
                child.speed = 0.005
            }
        }
        self.scene?.speed = 0.005
        self.physicsWorld.speed = 0.00
        self.cameraHandler.speed = 100
        //self.scene?.isPaused = true
        */
        
        let savedCameraPos = self.gameplayHandler.cameraHandler.position
       // self.gameplayHandler.shipReference.speed = 0.00001
      //  let savedRotation = self.gameplayHandler.shipReference.zRotation
        // self.gameplayHandler.shipReference.physicsBody?.isDynamic = false
        self.view?.scene?.physicsWorld.speed = 0.0001
      // self.gameplayHandler.shipReference.physicsBody?.pinned = true
        //self.gameplayHandler.shipReference.zRotation  = savedRotation
        self.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.15)
,
            SKAction.run {
              
                
                self.gameplayHandler.cameraHandler.run(
                    
                    SKAction.sequence([
                    SKAction.group([
                       // SKAction.scale(to:  self.gameplayHandler.default_camera_scale_level *  0.75, duration: 0.10),
                        SKAction.move(to: CGPoint.init(x: self.gameplayHandler.cameraHandler.position.x , y: self.gameplayHandler.shipReference.position.y ) , duration: 0.10)
                    ]),
                    
                    SKAction.run {
                        //self.gameplayHandler.cameraHandler.shakeCamera(duration: 0.16)
                    },
                    
                    SKAction.group([
                        SKAction.scale(to: 1.00, duration: 0.05)
                   // SKAction.move(to: savedCameraPos, duration: 0.05)
                    ])
                    
                    ])
                )
                
               
                
                self.run(SKAction.repeat(SKAction.sequence([SKAction.run {
                    (self.gameplayHandler.shipReference.childNode(withName: "trail") as! SKEmitterNode).advanceSimulationTime(1)
                }, SKAction.wait(forDuration: 0.05)]), count: 10), withKey: "AdvanceSim")
               

                
            },
            SKAction.wait(forDuration: 0.05)
            ,
            
            SKAction.run {
                
                //Game Over, ship health is at 0
            
                if let fireParticles = SKEmitterNode(fileNamed: "Sparko") {
                    
                    
                    fireParticles.name = "trail"
                    
                    fireParticles.position = self.gameplayHandler.shipReference.position
                    
                    self.gameplayHandler.addChild(fireParticles)
                    
                    
                    fireParticles.targetNode = self
                }
                
                self.gameplayHandler.shipReference.removeFromParent()
                self.gameplayHandler.shipReference.removeAllActions()
            }
        ]))
        
        
    }
    

    
    //MARK: Touche Handlers
    
 
    var detectedFirstTouch = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if(isPauseMenuShowing == true ){ return }
        
            //Start the timer as the player has begun touching screen
            startTime = Date()
        
                
        if (dialogMode == true ){
            uiHandler.dialogModeTouchInitiated()
            return
        }
        
        
        if (detectedFirstTouch == true ) {
            return
        }
        
        self.removeAction(forKey: "GradualSpeedUpOnInitialLaunch")
        
        if( isSubsequentSwingsEnabled){ self.physicsWorld.speed = 5 }
        
        
        if(self.gameplayHandler.isInitialSwing && SharedInfo.SharedInstance.initialSuperBoostKickOffFeature){
            
            self.initialSwingActions(touches, with: event)
        
            
        } else if (SharedInfo.SharedInstance.initialSuperBoostKickOffFeature == false)
        {
            
            
            
            detectedFirstTouch = true
            gameplayHandler.shipReference.parent?.isPaused = true
            if let touch = touches.first {
                initialTouchLocation = touch.location(in: self)
                
                self.uiHandler.initialTouchLocationIndicator.run(SKAction.move(to: self.convert(initialTouchLocation!, to: self.gameplayHandler.cameraHandler), duration: 0.10))
            }
            
            
            let savedPosition = self.gameplayHandler.shipReference.position
           
            self.gameplayHandler.shipReference.savedPosition = savedPosition
            //self.gameplayHandler.shipReference.savedZRotation =  self.gameplayHandler.shipReference.zRotation
           
            self.gameplayHandler.shipReference.removeFromParent()
            let newPosition = convert(savedPosition, from:  self.gameplayHandler.startingPositionReferenceNode)
            self.gameplayHandler.shipReference.position = newPosition
            
            
            self.gameplayHandler.shipReference.restPosition = newPosition
            
            self.gameplayHandler.addChild( self.gameplayHandler.shipReference)
            
                 self.gameplayHandler.shipReference.zRotation =  self.gameplayHandler.startingPositionReferenceNode.zRotation
            self.gameplayHandler.shipReference.isPaused = false
           // self.gameplayHandler.shipHasBeenPlaced = true
            self.gameplayHandler.shipReference.boostChargeUpAnimation()

           
            self.gameplayHandler.shipGuide.run(SKAction.fadeAlpha(to: 0.0, duration: 0.135))
            
                self.gameplayHandler.slowDownGravityNodes()
            self.gameplayHandler.slowDownEnemeies()
            
            for node in self.children {
                if (node.name == "Enemigo") {
                    node.isPaused = true
                    node.physicsBody!.isDynamic = false
                }
            }
            
            if let touch = touches.first {
                initialTouchLocation = touch.location(in: self)
                
                if(!SharedInfo.SharedInstance.lassoFeature) {
                    
                    self.uiHandler.initialTouchLocationIndicator.run(SKAction.move(to: self.convert(initialTouchLocation!, to: self.gameplayHandler.cameraHandler), duration: 0.10))
                    
                    
                    
                    
                    self.uiHandler.initialTouchLocationIndicator.alpha = 1.0
                    
                }}
            
        }
        else if ( isSubsequentSwingsEnabled  && dialogMode == false ){
            
            self.subsequentSwingActions(touches, with: event)
            
            
        }
                    
    }
    
  
    
    
    func initialSwingActions(_ touches: Set<UITouch>, with event: UIEvent?){
        
    
        dialogMode = true
        
        
       if(SharedInfo.SharedInstance.initialSuperBoostKickOffFeature && blockInitialSuperBoostTouches == false ){
                      
                      
         blockInitialSuperBoostTouches = true
                         
        
           
        self.gameplayHandler.touchesBeganPassthrough(touches, with: event, withScene: self)
                            
        
           
        playerRunningSwingAnimation = true
                 
        self.gameplayHandler.shipReference.scaleChargeNodeAnimation()
           updateDotPositionFlag = false
           var normalized_poistion = self.gameplayHandler.convert(self.gameplayHandler.shipReference.position, to: self.dotGridManager)
           self.dotGridManager.pointDotsToPosition(collapse_position: self.gameplayHandler.shipReference.position)
        var camera_wait_time = 2.50
           
        animateCameraOnLaunch(withWaitTime: camera_wait_time)
       
           
        self.gameplayHandler.slowDownEnemeies()
           self.gameplayHandler.slowDownGravityNodes()
        //Run Launch Actions
           self.run(SKAction.wait(forDuration: camera_wait_time), completion: {
               
               self.runGradualPhysicsWorldHighToLowSpeedAnimation()
               
               self.gameplayHandler.touchesEndedPassthrough(savedVelocity: self.gameplayHandler.savedVelocity, savedAngularVelocity: self.gameplayHandler.savedAngularVelocity, triggeredByInitial: true)
               
               
               let zRotation = self.gameplayHandler.shipReference.zRotation + .pi / 2
               let direction = CGVector(dx: cos(zRotation), dy: sin(zRotation))
               var forceVector = CGVector(dx: direction.dx  * 1000  ,dy: direction.dy  * 1000  )
               forceVector = clampedForceVector(dx: forceVector.dx , dy: forceVector.dy, maxForce: self.initialSwingBoostMaxAmount)
               
               self.gameplayHandler.shipReference.deductEnginePowerDueToSwing(reductionAmount: 100)
               
               self.uiHandler.initialTouchLocationIndicator.setEnginePower(value: 0)
               
               self.applyForce(to: self.gameplayHandler.shipReference, vector: forceVector, CGFloat(self.level_force_multiplier))
               
               self.gameplayHandler.shipReference.enableShipPath()
               
               self.gameplayHandler.playerIsControllingRotation = false
               
               
               
               
               self.gameplayHandler.speedUpEnemies()
               self.gameplayHandler.speedUpGravityNodes()
           } )
                              
          } else {
              
              if let touch = touches.first {
                  initialTouchLocation = touch.location(in: self)
              }
                      
              self.uiHandler.initialTouchLocationIndicator.run(SKAction.move(to: self.convert(initialTouchLocation!, to: self.gameplayHandler.cameraHandler), duration: 0.10))
              
              
              
              
              self.uiHandler.initialTouchLocationIndicator.alpha = 1.0
                //Dont increase the physics world speed if we're doing intial super boost kick off because we just going to kick off
               self.physicsWorld.speed = 5
                      
           }
        
        if(self.playerRunningSwingAnimation == false)
                 
         {
            self.gameplayHandler.touchesBeganPassthrough(touches, with: event, withScene: self)
           }
     
                  
              
    }
    
    func animateCameraOnLaunch(withWaitTime: CGFloat){
        //Camera Actions
        self.gameplayHandler.cameraHandler.run(SKAction.sequence([
            
            
            SKAction.scale(to:  self.gameplayHandler.default_camera_scale_level *  2.55, duration: withWaitTime),
            SKAction.scale(to:  self.gameplayHandler.default_camera_scale_level * 0.5 , duration: 0.05),
            SKAction.scale(to: self.gameplayHandler.default_camera_scale_level, duration: 0.05),
           
                SKAction.run {
                self.gameplayHandler.cameraHandler.shakeCamera(duration: self.playerLaunchedCameraShakeDuration, self.playerLaunchedCameraShakeAmplitude)},
            SKAction.wait(forDuration: TimeInterval(self.playerLaunchedCameraShakeDuration))
                                                                                   
           ]), completion: { self.playerRunningSwingAnimation = false } )
           
    }
    
    func runGradualPhysicsWorldHighToLowSpeedAnimation(){
        

        var count = 0.0
        
        
        self.physicsWorld.speed = self.physics_world_speed + SharedInfo.SharedInstance.after_boost_physics_world_speed
        
        
        
        self.run(SKAction.repeat( SKAction.sequence([ SKAction.run {
            
            self.physicsWorld.speed = self.physics_world_speed
            
            self.physicsWorld.speed = (self.physics_world_speed + SharedInfo.SharedInstance.after_boost_physics_world_speed) - count
            count = count + 0.03
             
             
            
        }, SKAction.wait(forDuration: 0.005)]), count: 100), withKey: "GradualSpeedUpOnInitialLaunch")
    }
    
    func subsequentSwingActions(_ touches: Set<UITouch>, with event: UIEvent?){
        
                    
                    self.gameplayHandler.slowDownEnemeies()
                    self.gameplayHandler.touchesBeganPassthrough(touches, with: event, withScene: self)
                    
                    for node in self.children {
                        if (node.name == "Enemigo") {
                            node.isPaused = true
                            node.physicsBody!.isDynamic = false
                        }
                    }
                    
                    if let touch = touches.first {
                        initialTouchLocation = touch.location(in: self)
                        
                        if(!SharedInfo.SharedInstance.lassoFeature) {
                            
                            self.uiHandler.initialTouchLocationIndicator.run(SKAction.move(to: self.convert(initialTouchLocation!, to: self.gameplayHandler.cameraHandler), duration: 0.10))
                            
                            
                            
                            
                            self.uiHandler.initialTouchLocationIndicator.alpha = 1.0
                            
                        } else {
                            
                            //Lasso feature here
                        }
                        
                        
                    }
                    
                
    }
    

    var previousScaledValue = 0
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        

        if (dialogMode == true){ return }
        
        
        if ( isPauseMenuShowing == true ) { return }
        
        if (self.gameplayHandler.shipHasBeenPlaced == true ) {
            return
        }
        
        if let touch = touches.first, let initialLocation = initialTouchLocation {
                
                
            movevmeentreleaseLocation = touch.location(in: self)

            self.uiHandler.movedTouchLocationIndicator.position = self.convert(movevmeentreleaseLocation!, to: self.gameplayHandler.cameraHandler)
            self.uiHandler.movedTouchLocationIndicator.alpha = 1.0
            self.uiHandler.movedTouchLocationIndicator.zPosition = 100


            let cameraScale = self.gameplayHandler.cameraHandler.xScale  // ✅ add this

            var forceVector = CGVector(
                dx: (self.initialTouchLocation!.x - self.movevmeentreleaseLocation!.x) * force_multiplier / cameraScale, // ✅ updated
                dy: (self.initialTouchLocation!.y - self.movevmeentreleaseLocation!.y) * force_multiplier / cameraScale  // ✅ updated
            )


            if(SharedInfo.SharedInstance.initialSwingAutoRotation == false ||  self.gameplayHandler.isInitialSwing == false )  {
                
                if( self.gameplayHandler.velocityMode == .staticMode || SharedInfo.SharedInstance.savedTrajectoryModeFeature == false){
                    
                    if(detectedFirstTouch == true){
                        print("Updating ZRotation on Touches Moved")
                        self.gameplayHandler.shipReference.zRotationBasedOnMovement(forceVector: forceVector)
                    }
                }
            }


            forceVector = clampedForceVector(
                dx: forceVector.dx,
                dy: forceVector.dy,
                maxForce: self.gameplayHandler.shipReference.getMaxCurrentForce()
            )


            // ✅ FIX distance to account for camera scale
            let rawDistance = hypot(
                movevmeentreleaseLocation!.x - initialLocation.x,
                movevmeentreleaseLocation!.y - initialLocation.y
            )

            let distance = rawDistance / cameraScale  // ✅ key fix


            var scaledValue = min(
                max(Int(distance / (maxForce / 99)) + 1, 1),
                100
            )


            // ✅ FIX multiplier (1.0 → 1.5 instead of 2.0)
            let normalized = Double(scaledValue - 1) / 99.0
            let cameraMultiplier = 1.0 + (normalized * 0.5)
            
            self.gameplayHandler.cameraHandler.setScale(CGFloat(
                SharedInfo.SharedInstance.default_camera_scale_level
                ) * cameraMultiplier)
            
                    if(scaledValue < 0 ) {
                        
                        //toggle Velocity mode
                        
                        if(hasToggledVelocityModes == false){
                            hasToggledVelocityModes = true
                            
                            if(self.gameplayHandler.velocityMode == .savedVelocityMode){
                                self.gameplayHandler.velocityMode = .staticMode
                                
                            } else {
                                self.gameplayHandler.velocityMode = .savedVelocityMode
                            }
                            
                            if(SharedInfo.SharedInstance.savedTrajectoryModeFeature){
                                self.gameplayHandler.shipReference.toggleVelocityMode(toMode: self.gameplayHandler.velocityMode, withZRotation: self.gameplayHandler.savePlayersZRotation)
                                
                            }
                        }
                        
                        
                        
                    } else {
                        
                        hasToggledVelocityModes = false
                        
                        if(scaledValue > self.gameplayHandler.shipReference.enginePower){
                            scaledValue = self.gameplayHandler.shipReference.enginePower
                        }
                        
                        self.gameplayHandler.shipReference.scaledValue = scaledValue
                        savedScaledValue = scaledValue
                        
                        self.uiHandler.initialTouchLocationIndicator.playerDeterminingEnginerPowerToUse(value: scaledValue)
                        gameplayHandler.shipReference.scaleChargeNode(byFactor: scaledValue)
                        
                        
                        
                        
                        if(self.gameplayHandler.velocityMode == .staticMode || SharedInfo.SharedInstance.savedTrajectoryModeFeature == false) {
                            useSavedVelocity = false
                        } else {
                            useSavedVelocity = true
                        }
                        
                        // Apply the force
                         
                        
                        forceVector = clampedForceVector(dx: forceVector.dx , dy: forceVector.dy , maxForce: self.gameplayHandler.shipReference.getMaxCurrentForce()  )
                        let distance = hypot(movevmeentreleaseLocation!.x - initialLocation.x, movevmeentreleaseLocation!.y - initialLocation.y)
                        
                        
                        
                        
                        
                        self.gameplayHandler.shipReference.handleForceVector(vector: forceVector, scaledValue: scaledValue) 
                        
                        trajectoryLineManager.activateTrajectoryLine(savedVelocity: self.gameplayHandler.savedVelocity, forceVector: forceVector, savedAngularVelocity: self.gameplayHandler.savedAngularVelocity, nodeReference:  self.gameplayHandler.shipReference, sceneReference: self, withScaledValue: scaledValue, useSavedVelocity: useSavedVelocity)
                        
                       
                        
                        if(scaledValue == 100 ){
                            trajectoryLineManager.alpha = 100

                        } else {
                            trajectoryLineManager.alpha = 0

                        }
                    }
           
            previousScaledValue = scaledValue

                
                
            }
        
        
        self.trajectoryLineManager.updateTrajectoryLine()

        self.trajectoryLineManager.updateTrajectory = true
        self.trajectoryLineManager.removeAction(forKey: "trajectoryLineUpdateVeryOfficalName")
        
        let trajectoryLineVeryOfficalSequenceNameUpdate = SKAction.sequence([
            
            SKAction.wait(forDuration: 0.01),
            SKAction.run {
                self.trajectoryLineManager.updateTrajectoryLine()
            }
            
        ])
        self.trajectoryLineManager.run(SKAction.repeat(trajectoryLineVeryOfficalSequenceNameUpdate, count: 5), withKey: "trajectoryLineUpdateVeryOfficalName")

        
    }
    

    var detectedTouchesEnded = false

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        

        if(dialogMode == false  && isPauseMenuShowing == false){
            
            if(self.name! == "1" && waitOneExtraTocuhesEndedIndex == 1){
                    
                    if let tapIcon {
                        
                        tapIcon.removeFromParent()
                    }
            }
                
            
            if (self.gameplayHandler.shipHasBeenPlaced == true ) {
                return
            }
            
            
            if (self.detectedTouchesEnded == true ) {
                
                return
            }
            
            
            
            
           
            waitOneExtraTocuhesEndedIndex = waitOneExtraTocuhesEndedIndex + 1
        self.uiHandler.movedTouchLocationIndicator.alpha = 0.0
        self.uiHandler.initialTouchLocationIndicator.run(SKAction.move(to: uiHandler.initialTouchLocationIndicator.lockedPosition, duration: 0.10))
        
            
            
            
        for node in self.children {
            if (node.name == "Enemigo") {
                node.isPaused = false
                node.physicsBody!.isDynamic = true
            }
        }
        
        //let sound = SKAction.playSoundFileNamed("blast-37988", waitForCompletion: false)
        //  self.run(sound)
        
        
        self.trajectoryLineManager.removeTrajectoryLine()
        
        self.gameplayHandler.statisMode = false
        
        
        
        
        if let touch = touches.first, let initialLocation = initialTouchLocation {
            
            
            
            followShip = true
            
            
            movevmeentreleaseLocation = touch.location(in: self)
            
            var forceVector = CGVector(dx: (self.initialTouchLocation!.x - self.movevmeentreleaseLocation!.x) * force_multiplier, dy: (self.initialTouchLocation!.y - self.movevmeentreleaseLocation!.y) * force_multiplier)
           
            
            
                
                self.gameplayHandler.speedUpEnemies()
                
                if(!SharedInfo.SharedInstance.lassoFeature && self.savedScaledValue == 100) {
                
                
                
                playerRunningSwingAnimation = true
                
               
                let savedCameraPosition = self.gameplayHandler.cameraHandler.position
                    
                    
             
                
                    self.gameplayHandler.cameraHandler.run(SKAction.move(to: self.gameplayHandler.shipReference.position, duration: 1.5))
                
                self.gameplayHandler.shipReference.isPaused = true
                    updateDotPositionFlag = false

                
                    self.run(SharedInfo.SharedInstance.audioHandler.playSoundWithName(fileName: "happy-message-ping-351298"))
                   
                    
                 
                    // Adjust this until it matches your "straight ahead" direction.
                    // Try: 0, 90, -90, 180
                    let offsetDegrees: CGFloat = +90

                    
                    
                    self.gameplayHandler.cameraHandler.run(SKAction.sequence([
                        
                        SKAction.group([
                        SKAction.scale(to:  self.gameplayHandler.default_camera_scale_level *  0.75, duration: 1.50),
                        SKAction.wait(forDuration: 2.0),
                        
                        
                        SKAction.run({
                        
                        
                        
                        //Animation right before ship launches
                        
                        self.gameplayHandler.shipReference.shipLaunchedAnimation()
                        self.dotGridManager.pointDotsToPosition(collapse_position: self.gameplayHandler.shipReference.position)
                        self.gameplayHandler.shipReference.isPaused = false

                        
                        
                    })]) , SKAction.run {
                    self.gameplayHandler.cameraHandler.shakeCamera(duration: self.playerLaunchedCameraShakeDuration, self.playerLaunchedCameraShakeAmplitude)
                }, SKAction.group([ SKAction.scale(to:  self.gameplayHandler.default_camera_scale_level , duration: 0.05), SKAction.move(to: savedCameraPosition, duration: 0.05)])]), completion: { [self] in
                    self.gameplayHandler.shipReference.isPaused = false
                    self.playerRunningSwingAnimation = false
                    var count = 0.0
                    self.physicsWorld.speed = 1.00
                    
                    self.run(SKAction.repeat( SKAction.sequence([ SKAction.run {
                        
                        
                        
                        self.physicsWorld.speed = 1.00 - count
                        count = count + 0.01
                        
                    }, SKAction.wait(forDuration: 0.02)]), count: 50), withKey: "GradualSpeedUpOnInitialLaunch")
                    
                    self.gameplayHandler.shipReference.enableShipPath()

                    self.gameplayHandler.shipHasBeenPlaced = true 
                    self.gameplayHandler.touchesEndedPassthrough(savedVelocity: self.gameplayHandler.savedVelocity, savedAngularVelocity: self.gameplayHandler.savedAngularVelocity,triggeredByInitial: false)
                    
                    var distance = hypot(self.movevmeentreleaseLocation!.x - initialLocation.x, movevmeentreleaseLocation!.y - initialLocation.y)
                    
                    
                 
                    
                    
                    
                    
                    if(SharedInfo.SharedInstance.saveVelocity ){
                        self.gameplayHandler.shipReference.physicsBody?.velocity = self.gameplayHandler.savedVelocity
                        self.gameplayHandler.shipReference.physicsBody?.angularVelocity = self.gameplayHandler.savedAngularVelocity
                    }
                    
                    
                    if(self.gameplayHandler.velocityMode == .savedVelocityMode && SharedInfo.SharedInstance.savedTrajectoryModeFeature == true){
                
                        self.gameplayHandler.shipReference.physicsBody?.velocity = self.gameplayHandler.savedVelocity
                        self.gameplayHandler.shipReference.physicsBody?.angularVelocity = self.gameplayHandler.savedAngularVelocity
                    } else {
                        
                    }
                    
                    
                    
                    forceVector = clampedForceVector(dx: forceVector.dx, dy: forceVector.dy, maxForce: self.gameplayHandler.shipReference.getMaxCurrentForce())
                    
                    
                    self.physicsWorld.speed = 2.00
                    
                    self.run(SKAction.repeat( SKAction.sequence([ SKAction.run {
                        
                        
                        
                        self.physicsWorld.speed = 2.00 - count
                        count = count + 0.02
                        
                    }, SKAction.wait(forDuration: 0.01)]), count: 50), withKey: "GradualSpeedUpOnInitialLaunch")
                    // Apply the force
                    self.gameplayHandler.shipReference.physicsBody?.isDynamic = true
                   
                    
                   
                  
                    
                    self.applyForce(to: self.gameplayHandler.shipReference, vector: forceVector, CGFloat(level_force_multiplier))
                    
                    self.gameplayHandler.shipReference.deductEnginePowerDueToSwing(reductionAmount: self.savedScaledValue)
                    self.uiHandler.initialTouchLocationIndicator.setEnginePower(value: gameplayHandler.shipReference.enginePower)
               
                    useSavedVelocity = false
                    
                    
                    self.gameplayHandler.playerIsControllingRotation = false

                } )
                    
                    detectedTouchesEnded = true

                    self.uiHandler.initialTouchLocationIndicator.resetIndicators()

                
                
                
                } else {
                    
                    //Not 100, reset
                    

                    self.gameplayHandler.playerIsControllingRotation = true
                    self.gameplayHandler.shipGuide.run(SKAction.fadeAlpha(to: 1.0, duration: 0.135))
                    self.gameplayHandler.shipReference.removeFromParent()
                    self.gameplayHandler.startingPositionReferenceNode.addChild(self.gameplayHandler.shipReference)
                    self.gameplayHandler.shipReference.position = self.gameplayHandler.shipReference.savedPosition
                    
                    print("Updating ZRotation on Touches End")
                    detectedFirstTouch = false
                    
               
                    
                    
                   // let savedAction = self.gameplayHandler.startingPositionReferenceNode.action(forKey: "StartingRotationAction")
                    
                    //self.gameplayHandler.startingPositionReferenceNode.removeAllActions()
                    
                    
                    //self.gameplayHandler.startingPositionReferenceNode.run(savedAction!, withKey: "StartingRotationAction")
                    
                    //self.gameplayHandler.shipReference.zRotation = 0.0
                    self.gameplayHandler.shipReference.run(SKAction.rotate(toAngle: self.gameplayHandler.shipReference.savedZRotation, duration: 0.1))
                    //self.gameplayHandler.startingPositionReferenceNode.zRotation = 0.0
                    self.gameplayHandler.startingPositionReferenceNode.isPaused = false
                    self.gameplayHandler.shipReference.disableShipPath()
                   
                    
                    
                    self.gameplayHandler.cameraHandler.run(SKAction.scale(to: (SharedInfo.SharedInstance.default_camera_scale_level), duration: 0.1)
                                           )
                   if let smokeEmmiter = self.gameplayHandler.shipReference.childNode(withName: "trailParticles") as? SKEmitterNode {
                        
                        
                          
                    
                        smokeEmmiter.alpha = 1.0
                        smokeEmmiter.particleBirthRate = 100
                            
                            
                        
                    }
                    

                }
            
        }
        
        for gravity_node in self.gameplayHandler.gravityNodes {
            if(gravity_node.name == "MotherShip") { continue}
            gravity_node.isPaused = false
            self.gameplayHandler.starTimerNode.isPaused = false
        }
        }
        
    }
    
    
    func applyForce(to sprite: SKSpriteNode, vector: CGVector, _ multipler: CGFloat = 100.0) {

        let impulseVector = CGVector(dx: vector.dx * multipler, dy: vector.dy * multipler )  // Adjust multiplier as needed
       // sprite.physicsBody?.isDynamic = true
     
     
        sprite.physicsBody?.applyImpulse(impulseVector)
        
        
    }
    
    func allDotsCompletedAnimationCallbackHandler(){
        
        self.updateDotPositionFlag = true
        
    }
    
    
   
    override func update(_ currentTime: TimeInterval) {
        
        
        super.update(currentTime)
        self.gameplayHandler.update(currentTime)
        self.gameplayHandler.shrinkAstroidsNearStars()

        
        if (followShip && self.gameplayHandler.shipReference.position.y > SharedInfo.SharedInstance.safeAreaLayoutSize.height / 4  ) {
            // Called before each frame is rendered
            
            //  cameraReference.position.y = self.gameplayHandler.shipReference.position.y
        }
        
        if (!self.gameplayHandler.statisMode || SharedInfo.SharedInstance.lassoFeature) {
            self.gameplayHandler.handleSelectedObjectsZRotation()
        }
        
   
            var savedCameraPosition = self.gameplayHandler.cameraHandler.position
            
            
            if(self.gameplayHandler.shipHasBeenPlaced){  
                
                self.gameplayHandler.cameraHandler.position.y = self.gameplayHandler.shipReference.position.y + (SharedInfo.SharedInstance.safeAreaLayoutSize.height / 4)
            }
            
            self.backgroundHandler!.triggerChange(newCameraPosition: self.gameplayHandler.cameraHandler.position, oldCameraPosition: savedCameraPosition)
            self.backgroundHandler!.triggerChange2(newCameraPosition: self.gameplayHandler.cameraHandler.position, oldCameraPosition: savedCameraPosition)
        
        
        if( (self.gameplayHandler.shipReference.position.y > CGFloat(levelYUpperLimit) || self.gameplayHandler.shipReference.position.y < CGFloat(levelYLowerLimit)) &&             playerHasCrashedDueToZoomOut == false ) {
            
            playerHasCrashedDueToZoomOut = true
            if(SharedInfo.SharedInstance.outOfBoundsBounceBackFeature){
                self.gameplayHandler.playerBounceBackY()} else {
                    self.gameplayHandler.playerHasCrashedIntoStar()
                    }
            
            
          
            
        }
        
            if (self.gameplayHandler.shipReference.position.x > (SharedInfo.SharedInstance.safeAreaLayoutSize.width/2  *  self.gameplayHandler.default_camera_scale_level)  || self.gameplayHandler.shipReference.position.x  < -SharedInfo.SharedInstance.safeAreaLayoutSize.width/2 *  self.gameplayHandler.default_camera_scale_level    ) {
            
                let shipX = abs(self.gameplayHandler.shipReference.position.x)
                let shipY = abs(self.gameplayHandler.shipReference.position.y)

                let safeWidth = SharedInfo.SharedInstance.safeAreaLayoutSize.width
                let safeHeight = SharedInfo.SharedInstance.safeAreaLayoutSize.height

                // Find the required scale in each axis
                let requiredScaleX = (shipX * 1.5) / safeWidth
                let requiredScaleY = (shipY * 1.5) / safeHeight

                // Take the larger to ensure full containment
                let requiredScale = max(requiredScaleX, requiredScaleY, self.gameplayHandler.default_camera_scale_level)

                // Only apply if out of bounds and not animating
                if  playerRunningSwingAnimation == false {
                    self.gameplayHandler.cameraHandler.removeAllActions()
                    self.gameplayHandler.cameraHandler.setScale(requiredScale)
                }
                
           /* if(amount > 1.38 && playerHasCrashedDueToZoomOut == false ){
              
                //set 2.0 as the highest amount to scale out camera
                amount = 1.38
                self.playerHasCrashedDueToZoomOut = true
                
                
               
                         
                
                //start a timer to reset the check so that we're not continually bouncing player across updates
                self.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.run {
                    
                    
                    self.playerHasCrashedDueToZoomOut = false

                }]))
                
                if(SharedInfo.SharedInstance.outOfBoundsBounceBackFeature) {
                    self.gameplayHandler.playerBounceBackOnX()
                } else {
                    self.gameplayHandler.playerHasCrashedIntoStar()
                }
                
            }
            
            //Camera handler zoom out
*/
            if(playerRunningSwingAnimation == false ){
                
                
           
                if(self.gameplayHandler.cameraHandler.position.x != 0 ) {
                    
                    self.gameplayHandler.cameraHandler.run(SKAction.moveTo(x: 0, duration: 0.01))
                    
                }
            }
           
            
            
        }  else {
             
           
        }
        
            //Stop deleting and recreating nodes on every single fing update
           // self.gameplayHandler.gravityNodes = []

            for gravity_node in self.gameplayHandler.gravityNodes {
                
             
                    
                if let gravityNodeParent = gravity_node.parent {
                    if (gravityNodeParent.name == "referenceNode"){
                        
                        //Only need to convert the position with reference nodes, other stars are already parent of gameplay handler
                        gravity_node.converted_position = self.gameplayHandler.convert(gravity_node.position, from: gravity_node.parent!)
                        
                      
                    } else if (gravityNodeParent.name == "startingPositionReferenceNode" )
                    {
                        //Only need to convert the position with reference nodes, other stars are already parent of gameplay handler
                        gravity_node.converted_position = self.gameplayHandler.convert(gravity_node.position, from: gravity_node.parent!)
                        
                        gravity_node.converted_position.y = gravity_node.converted_position.y - 320
                        gravity_node.converted_position.x = gravity_node.converted_position.x - 75
                    } else
                    {
                        
                        gravity_node.converted_position = gravity_node.position
                        
                        
                    }
                }
               
                   
                    
                if(self.gameplayHandler.shipReference.isCharging && self.gameplayHandler.shipHasBeenPlaced){
                    
                    //TODO: Rework player grav scaling when charging due to not recreating grav nodes anymore
                   //self.gameplayHandler.gravityNodes.append(GravityNode(position: self.gameplayHandler.shipReference.position , radius: 2.5 * Double(self.gameplayHandler.shipReference.scaledValue), strength: CGFloat((1.5 * Double(self.gameplayHandler.shipReference.scaledValue))), maxShrink: 0.01))
                    
                }
                
                
            }
        
            
        
      
        if frameSkipper % 2 == 0 {
            
      
            if(!self.gameplayHandler.statisMode){
             
               
                
                if(self.gameplayHandler.shipHasBeenPlaced){
                    
                        
                    
                    self.gameplayHandler.shrinkPlayerNearStar()
                    
                }
            }
            
           
            
           
      
            
        }
        
        if frameSkipper % 50 == 0 {
            
          //  self.trajectoryLineManager.updateTrajectory = true
            //self.trajectoryLineManager.updateTrajectoryLine()
            
            print("ZRotation:  \(self.gameplayHandler.shipReference.zRotation)")
            frameSkipper = 0
            print("ZRotation for: \(self.gameplayHandler.startingPositionReferenceNode.zRotation)" )
        }
        
       
        
        frameSkipper = frameSkipper + 1
        
            
       
     
        
        if ( updateDotPositionFlag ) {
            self.dotGridManager.updateDotPositions(gravityNodes: self.gameplayHandler.gravityNodes, playerPos: self.gameplayHandler.shipReference.position, shouldCollectDots: self.gameplayHandler.shipHasBeenPlaced)
        
        }
    }
    
    var updateDotPositionFlag = true
    
    
    
    
}
