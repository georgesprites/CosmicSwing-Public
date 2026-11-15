
import Foundation
import SpriteKit

let colors = [UIColor.gray, UIColor.red, UIColor.yellow, UIColor.blue, UIColor.green, UIColor.cyan, UIColor.white, UIColor.black, UIColor.magenta, UIColor.orange, UIColor.darkGray]

class DotNode: SKSpriteNode {
    var originalPosition: CGPoint?

    let default_dot_scale = 1.5
    var default_dot_alpha = 1.0
    var running_phasein_animation = false
    var canBeCollected = false
    var hasBeenCollected = false
    var beforeImplosionAlpha = 0.0 
    var runningColectionAnimation = false
    var beforeImplosionPostion = CGPoint() 
    func calculateDurationBetweenPoints(_ a: CGPoint, _ b: CGPoint, maxDistance: CGFloat, maxDuration: Double) -> Double {
        let distance = hypot(b.x - a.x, b.y - a.y)
        let normalizedDistance = min(distance / maxDistance, 1.0)
        let invertedDistance = 1.0 - normalizedDistance
        return Double(invertedDistance) * maxDuration
    }
    
    init(color: UIColor, size: CGSize) {
        
        default_dot_alpha = CGFloat.random(in: 0.1...1.0)
        let colorChance = Int.random(in: 1...10)
        var backgroundColorIndex = 0
        
        
        if colorChance == 1 {
            backgroundColorIndex = Int.random(in: 1...10)

        }
        
        
        
        super.init(texture: SharedInfo.SharedInstance.dotTexture, color: color, size: size)
       // self.position = withCameraPos
        self.name = "dot"
        self.alpha = default_dot_alpha
        /*
        let randWaitTIme = Double.random(in: 0.0 ... 0.5)

        let randSpeedTIme = 0.5//Double.random(in: 0.0 ... 0.5)
        
        let overshootPosition = CGPoint(x: initialPosition.x * 3.05, y: initialPosition.y * 3.50)
        let overshootPositionReversed = CGPoint(x: initialPosition.x * 0.90, y: initialPosition.y * 0.90)
        self.position = overshootPosition

        
      
        self.alpha = 0.0
        let finalAlphaVal = Double.random(in: 0.0 ... 1.0)
        self.setScale(4.0)
        self.run(SKAction.sequence([
           
            SKAction.group([ SKAction.fadeAlpha(to: finalAlphaVal, duration: 0.5), SKAction.scale(to: 0.8, duration: randSpeedTIme),            SKAction.move(to: overshootPositionReversed, duration: randSpeedTIme) ]),
            SKAction.group([
                SKAction.move(to: initialPosition, duration: 0.2), 
                SKAction.scale(to: 1.0, duration: 0.2)]),
                SKAction.run {
                   
                        let randomInt = Int.random(in: 0...3)
                            if(randomInt == 0){
                         
                            self.run(SharedInfo.SharedInstance.scifiwepsound)
                        }
                    
                self.originalPosition = initialPosition
                self.position = initialPosition
                
                }]))
         */
        
        
        // self.lightingBitMask = 1
        
        

    }
    
    func runInitialAnimation( initialPosition: CGPoint, withCameraPos: CGPoint ){
       
        //Dot starts below its final position and rises up
        
        self.alpha = 0
        self.position = initialPosition
        self.position.y -= 100
        let randomWaitTime =  CGFloat.random(in: 0.5...2.0)
        self.run(
            SKAction.sequence([
                
              
            SKAction.group([
            SKAction.move(by: CGVector.init(dx: 0, dy: 100), duration: randomWaitTime)
            
            
            ])

                ,
                SKAction.run {
                    //Set the origionalPosition once done, this activates the dot for GVG
                    self.originalPosition = initialPosition

                }
        ]))
        
        /* Dots start at  the center, and then expand out to their positions
        self.position = withCameraPos
        self.alpha = 0.0
        self.setScale(0.0)
        let aniduration = 0.5
        
        let waittime = calculateDurationBetweenPoints(withCameraPos, initialPosition, maxDistance: 1000, maxDuration:1.0)

        let randomWaitTime = CGFloat.random(in: 0.0...0.3)
        let alphaRand = CGFloat.random(in: 0.1...default_dot_alpha)

        let moveAction = SKAction.move(to: initialPosition, duration: waittime)
        moveAction.timingMode = .easeOut

        self.run(SKAction.sequence([
            SKAction.wait(forDuration: randomWaitTime),
           
            SKAction.group([
                SKAction.fadeAlpha(to: default_dot_alpha, duration: waittime),
                moveAction,
                SKAction.scale(to: default_dot_scale, duration: waittime)]),
                SKAction.run {
                   
                        let randomInt = Int.random(in: 0...3)
                            if(randomInt == 0){
                         
                            //self.run(SharedInfo.SharedInstance.scifiwepsound)
                        }
                    
                self.originalPosition = initialPosition
                self.position = initialPosition
                
                }]))
         
         */
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
