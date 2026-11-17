//
//  SharedInfo.swift
//  GoldenMoon
//
//  Created by Jorge Torres on 4/16/18.
//  Copyright © 2018 GeorgeSprites. All rights reserved.
//

import Foundation 
import SpriteKit

class SharedInfo {
    
    
    var startingLevel = "1"
    var starTrailsEnabled = false
    var enableDebugModeForStarTiming = false
    var levelData : [Level]? = nil
    //let dotTexture = SKTexture.init(imageNamed: "sybdit")
    //let scifiwepsound = SKAction.playSoundFileNamed("popo2", waitForCompletion: false)
    static var SharedInstance = SharedInfo();
    var dotTexture = SKTexture.init(imageNamed: "dot")
   // var dotcrossTexture = SKTexture.init(imageNamed: "cross-dot")
    var chevronTexture = SKTexture.init(imageNamed: "chevron")
    var safeAreaLayoutSize = CGSize()
    var backgroundColor : UIColor = .black
    let audioHandler = SoundHandler()
    var audioEnabled = false
    var playInitialSong = false
    var displayAds = false
    var default_camera_scale_level : Double = 1.0
    //Features
    var lassoFeature = false
    var initialSuperBoostKickOffFeature = false
    var initialSwingAutoRotation = false
    var astroidFeature = false
    var level1SpecialAnimationFeature = false
    var savedTrajectoryModeFeature = false
    var outOfBoundsBounceBackFeature = true
    var shipPath = true
    var onRailsPathFeature = false
    var createLevelBorder = false 
    var backgroundChangingColorFeature = false
    var dotCollectionFeature = false
    //
    
    var hasAlreadyAcceptedTutorialVideo = true
    
    var currentRestartCount = 0
    
    let dotColor : UIColor = .white

    var level_loader_speed_multipler = 0.01
    var speed_loading = true
    enum orientationModes {
    case portrait
    case landscapeLeft
    case landscapeRight
    }
    
    let tileSizeReference = SKTexture(imageNamed: "tiledetail")
    let boundaryCategory : UInt32 = 0x1 << 0;
    var generateTreesGrass = false
    var spawnOpponents = true
    var showPhysics = false
    var orientation_mode = orientationModes.portrait
    var showDrawCount = false
    var showFields = true
    var UIMenusEnabled = false
    var ignoreSavedMons = false
    var spawnNPCS = true
    var mapWidthSize = 0
    var spawnFollowBit = false
    var swipeMovementStyle = true
    var default_light_falloff = 1.5 
    var bottomMenuBarEnabled = false
    var saveVelocity = false
    var safeAreaInserts = UIEdgeInsets()
    var screenSize : CGSize = CGSize.init(width: 0, height: 0)
    var safeScreenSize: CGSize = CGSize.init(width: 0, height: 0)
    var edges : UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var tileSize = 32.0
    var asteroid_min_size : CGFloat = 10.0
    var asteroid_max_size : CGFloat = 30.0
    var asteroid_outline_size : CGFloat = 1.0
    var coin_scale_factor: CGFloat = 1.0
    var ship_particle_scale_factor : CGFloat = 1.0
    var randomAsteroidShapeTextures : [SKTexture] = []
    var intersitialAdManager = InterstitialAdManager()
    //Determines how fast the physics world kicks off after the initial boost, may make game too fast on small scale
    
    var after_boost_physics_world_speed : CGFloat  = 1.0
    
    var asteroid_sprite_atlas : SKTextureAtlas? = nil
    
    let userDefaults = UserDefaults.standard
    
    var explosionTextures : [SKTexture] = []
    
    func initStartingLevel(){
        self.startingLevel = userDefaults.string(forKey: "startingLevel") ?? "1"

    }
    
    func initializeVariables(){
        
        let explosionTexture = SKTexture.init(imageNamed: "dreamstime_xxl_304541455_01")
        let explosionTexture2 = SKTexture.init(imageNamed: "dreamstime_xxl_304541455_02")
        let explosionTexture3 = SKTexture.init(imageNamed: "dreamstime_xxl_304541455_03")
        let explosionTexture4 = SKTexture.init(imageNamed: "dreamstime_xxl_304541455_04")
        let explosionTexture5 = SKTexture.init(imageNamed: "dreamstime_xxl_304541455_05")
        let explosionTexture6 = SKTexture.init(imageNamed: "dreamstime_xxl_304541455_06")
        let explosionTexture7 = SKTexture.init(imageNamed: "dreamstime_xxl_304541455_07")
        let explosionTexture8 = SKTexture.init(imageNamed: "dreamstime_xxl_304541455_08")
        let explosionTexture9 = SKTexture.init(imageNamed: "dreamstime_xxl_304541455_09")
        let explosionTexture10 = SKTexture.init(imageNamed: "dreamstime_xxl_304541455_10")
    
        self.startingLevel = userDefaults.string(forKey: "startingLevel") ?? "1"
        //self.hasAlreadyAcceptedTutorialVideo = userDefaults.bool(forKey: "hasAcceptedLevel1Video")
        
        self.explosionTextures = [explosionTexture, explosionTexture2, explosionTexture3,explosionTexture4,explosionTexture5,explosionTexture6,explosionTexture7,explosionTexture8,explosionTexture9,explosionTexture10]
        
        let generateTreesGrassSavedData = userDefaults.bool(forKey: "generateTreesGrass")
        
        self.generateTreesGrass = generateTreesGrassSavedData
        
        let audioEnabledSavedData = userDefaults.bool(forKey: "AudioEnabled")
        self.audioEnabled = audioEnabledSavedData
        
        
        let spawnOpponentsSavedData = userDefaults.bool(forKey: "spawnOpponents")
        self.spawnOpponents = spawnOpponentsSavedData
        
        self.spawnNPCS = userDefaults.bool(forKey: "spawnNPCS")
        
        self.spawnFollowBit = userDefaults.bool(forKey: "spawnFollowBit")

        self.ignoreSavedMons = userDefaults.bool(forKey: "ignoreSavedMons")
        
        self.UIMenusEnabled = userDefaults.bool(forKey: "UIMenusEnabled")
        self.swipeMovementStyle = userDefaults.bool(forKey: "swipeMovementStyle")

        initCoinAnimation()
        initStarAnimation()
        loadAsteroidAssets()
    }
        
    
    
    
    func loadAsteroidAssets(){
        
        // Load the atlas by name (without extension)
        self.asteroid_sprite_atlas = SKTextureAtlas(named: "Asteroids")

        
    }
    
    func initStarAnimation(){
        
        
        
        
        let textureAtlas = SKTextureAtlas(named: "starRotation")
        // Create an array to hold the textures
        var frames: [SKTexture] = []
        
        // Load all 16 frames from the atlas
        for i in 1...9 {
            
            var textureName = ""
            
        
                textureName =   "star\(i)"
      
            
            frames.append(textureAtlas.textureNamed(textureName))
        }
        
        // Create the animation action
        let animation = SKAction.animate(with: frames, timePerFrame: 0.05, resize: true, restore: true)
        
        self.starAnimation = animation
        
    }
    
    func initCoinAnimation(){
        
        
        
        let textureAtlas = SKTextureAtlas(named: "Coin")
        // Create an array to hold the textures
        var frames: [SKTexture] = []
        
        // Load all 16 frames from the atlas
        for i in 1...9 {
            
            var textureName = ""
            
        
                textureName =   "coin\(i)"
      
            
            frames.append(textureAtlas.textureNamed(textureName))
        }
        
        // Create the animation action
        let animation = SKAction.animate(with: frames, timePerFrame: 0.05, resize: true, restore: true)
        
        self.coinAnimation = animation
    }
    
    
    var coinAnimation = SKAction()
    var starAnimation = SKAction()
    func setProperty(property: String , setTo: Bool){
        
        userDefaults.set(setTo, forKey: property)
        
        
        if(property == "AudioEnabled"){
            self.audioEnabled = setTo
            self.audioHandler.toggleAudio()
        }
        
    }
    
    
    func setProperty(property: String , setTo: String){
        
        userDefaults.set(setTo, forKey: property)
        
        
    }
    
    func retrivePropertyState(property: String)->Bool{
        
        if(property == "AudioEnabled"){
            
            return userDefaults.bool(forKey: property)
            
              
        } else {
            
            return false
        }
        
        
    }
    
}

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let all: UInt32 = UInt32.max
    static let gravityStar: UInt32 = 0b1// 1
    static let player: UInt32 = 0b10          // 2
    static let projective: UInt32 = 0b100
    static let earthplanet: UInt32 = 0b1000// 4
    static let whip: UInt32 = 0b10000        // 16
    static let playerProjectile: UInt32 = 0b100000      // 32
    static let enemy: UInt32 = 0b1000000     // 64
    static let astronaut: UInt32 = 0b10000000        // 128
    static let enemeyProjectile: UInt32 = 0b100000000     // 256
    static let player_detection: UInt32 = 0b1000000000 // 512
    static let asteroid: UInt32 = 0b10000000000   // 1024
    static let coin: UInt32 = 0b100000000000
    static let star: UInt32 = 0b1000000000000

    
}

func degreesToradians(_ degrees: Float) -> Float {
        return degrees * .pi / 180
  }



func distanceBetweenNodes(nodeA: SKNode, nodeB: SKNode) -> CGFloat {
    let dx = nodeB.position.x - nodeA.position.x
    let dy = nodeB.position.y - nodeA.position.y
    return sqrt(dx * dx + dy * dy)
}


func angleBetweenNodes(nodeA: SKNode, nodeB: SKNode) -> CGFloat {
    let dx = nodeB.position.x - nodeA.position.x
    let dy = nodeB.position.y - nodeA.position.y
    return atan2(dy, dx)
}

func normalizedDirection(from pointA: CGPoint, to pointB: CGPoint) -> CGPoint {
    let dx = pointB.x - pointA.x
    let dy = pointB.y - pointA.y
    let distance = sqrt(dx * dx + dy * dy)
    
    guard distance != 0 else {
        return CGPoint.zero // If both points are the same, return zero vector
    }
    
    let normalizedX = dx / distance
    let normalizedY = dy / distance
    
    return CGPoint(x: normalizedX, y: normalizedY)
}


func scalingFactor(fromVector vector: CGVector) -> CGFloat {
    let maxMagnitude: CGFloat = 500 // as derived above
    let magnitudeValue = magnitude(of: vector)
    let scale = 1 + (magnitudeValue / maxMagnitude) * 40
    return min(scale, 40) // Ensures the scale does not exceed 5
}

func magnitude(of vector: CGVector) -> CGFloat {
    return sqrt(vector.dx * vector.dx + vector.dy * vector.dy)
}

extension CGVector {
    func normalized() -> CGVector {
        let length = sqrt(dx * dx + dy * dy)
        return length > 0 ? CGVector(dx: dx / length, dy: dy / length) : CGVector(dx: 0, dy: 0)
    }
}



enum GameModes {
    
    
    case ship
    case missile
    case camera
    case shootByWire
    case settings 
    case roaming
    case dialog
    case battle 
}
