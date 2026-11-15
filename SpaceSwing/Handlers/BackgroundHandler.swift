//
//  BackgroundHandler.swift
//  N Body No Problem
//
//  Created by Jorge Torres on 5/24/24.
//
//
//  CameraNodeParallax.swift
//
//  Created by gitmalong
//
//

import Foundation
import SpriteKit

class BackgroundHandler: SKSpriteNode {
    
    var backgroundColorIndex = 0
    let colors = [UIColor.red, UIColor.yellow, UIColor.blue, UIColor.cyan, UIColor.white, UIColor.black, UIColor.magenta, UIColor.orange]
    
    let backgroundStarHandlerNode_small = BackgroundStarManager()
    let backgroundStarHandlerNode_med = BackgroundStarManager()
    let backgroundStarHandlerNode_large = BackgroundStarManager()
    let backgroundStarStreakHandler = BackgroundStarStreakHandler()
    var layer1 = SKSpriteNode()
    var backgroundName : String
    init(texture: SKTexture?, color: UIColor, size: CGSize, backgroundName: String, backgroundColor: String?) {
        
        backgroundColorIndex = Int.random(in: 0...colors.count - 1 )
        var colorizeBackground = false
        if let backgroundColor {
            colorizeBackground = true
        }
        
        self.backgroundName = ""
        
        super.init(texture: nil, color: .clear , size:CGSize.zero )
        if(backgroundName != "none" ){
            let bkgGradient = SKSpriteNode.init(texture: SKTexture.init(imageNamed: backgroundName))
            
            if colorizeBackground { } else {
                self.addChild(bkgGradient)}
            
            if(SharedInfo.SharedInstance.backgroundChangingColorFeature){
                let color_changing_duration = 10.0
            bkgGradient.run(SKAction.repeatForever(SKAction.sequence([
                                                                           
                SKAction.run {
                    bkgGradient.run(SKAction.colorize(with: self.colors[self.backgroundColorIndex], colorBlendFactor: 0.5, duration: color_changing_duration))
                    
                    
                    // self.layer1.run(SKAction.colorize(with: self.colors[self.backgroundColorIndex], colorBlendFactor: 0.5, duration: 5))
                    
                    if(self.backgroundColorIndex < self.colors.count - 1) {
                        self.backgroundColorIndex = self.backgroundColorIndex + 1} else {
                            self.backgroundColorIndex = 0
                        }}
                  , SKAction.wait(forDuration: color_changing_duration)])))
            
            }
            bkgGradient.zPosition = -2
            bkgGradient.setScale(2.0)
        }
       // bkgGradient.run(SKAction.colorize(with: .black, colorBlendFactor: 0.7, duration: 0.01))

        
       // SKSpriteNode.init(imageNamed: "starslayer1")
       // layer2 = SKSpriteNode.init(imageNamed: "starslayer2")
        
        layer1 = SKSpriteNode.init(imageNamed: "bkg1")
        
            // self.addChild(layer1)
        self.addChild(backgroundStarHandlerNode_small)
        self.addChild(backgroundStarHandlerNode_med)
        self.addChild(backgroundStarHandlerNode_large)
        //self.lightingBitMask = 1
        self.zPosition = -100
        layer1.zPosition = -1
        layer1.setScale(0.50)
        layer1.zRotation = CGFloat(degreesToradians(90 ))
        layer1.position.y = 260
        layer1.alpha = 0.40
        
        
        if colorizeBackground {
            self.run(.colorize(with:   .red, colorBlendFactor: 1.0, duration: 0.01))
        
        }
        
               
    }
    
    func setup(){
        
        self.size = SharedInfo.SharedInstance.screenSize
        backgroundStarHandlerNode_small.setup(withMinSizeRange: CGFloat(0.1)...CGFloat(0.2) , withMaxSizeRange: CGFloat(0.2)...CGFloat(0.3))
        backgroundStarHandlerNode_med.setup(withMinSizeRange: CGFloat(0.2)...CGFloat(0.3) , withMaxSizeRange: CGFloat(0.3)...CGFloat(0.4))
        backgroundStarHandlerNode_large.setup(withMinSizeRange: CGFloat(0.5)...CGFloat(0.6) , withMaxSizeRange: CGFloat(0.6)...CGFloat(1.7))
        backgroundStarStreakHandler.runStreak()
        self.addChild(backgroundStarStreakHandler)
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    /* call this method whenever your cameras position changes */
    public func triggerChange(newCameraPosition:CGPoint,oldCameraPosition:CGPoint) {
            // Move your parallax backgrounds
            let positionChangeX = newCameraPosition.x-oldCameraPosition.x
            let positionChangeY = newCameraPosition.y-oldCameraPosition.y
            let changeX = positionChangeX*relativeSpeedToCamera.dx
            let changeY = positionChangeY*relativeSpeedToCamera.dy
            layer1.position = CGPointMake(layer1.position.x+changeX,layer1.position.y+changeY)
    }
    
    private var relativeSpeedToCamera:CGVector = CGVector(dx: -0.025, dy: -0.025)
    private var relativeSpeedToCamera2:CGVector = CGVector(dx: -0.025, dy: -0.025)
    private var relativeSpeedToCamera_med:CGVector = CGVector(dx: -0.05, dy: -0.05)// in relation to camera nodes speed
    private var relativeSpeedToCamera_large:CGVector = CGVector(dx: -0.10, dy: -0.10)// in relation to camera nodes speed

    
    
    
    
    /* call this method whenever your cameras position changes */
    public func triggerChange2(newCameraPosition:CGPoint,oldCameraPosition:CGPoint) {
            // Move your parallax backgrounds
            let positionChangeX = newCameraPosition.x-oldCameraPosition.x
            let positionChangeY = newCameraPosition.y-oldCameraPosition.y
            let changeX = positionChangeX*relativeSpeedToCamera2.dx
            let changeY = positionChangeY*relativeSpeedToCamera2.dy
        let changeX_med = positionChangeX*relativeSpeedToCamera_med.dx
        let changeY_med = positionChangeY*relativeSpeedToCamera_med.dy
        let changeX_large = positionChangeX*relativeSpeedToCamera_large.dx
        let changeY_large = positionChangeY*relativeSpeedToCamera_large.dy
        
        
        backgroundStarHandlerNode_small.position = CGPointMake(backgroundStarHandlerNode_small.position.x+changeX,backgroundStarHandlerNode_small.position.y+changeY)
        
        backgroundStarHandlerNode_med.position = CGPointMake(backgroundStarHandlerNode_med.position.x+changeX_med,backgroundStarHandlerNode_med.position.y+changeY_med)
        
        backgroundStarHandlerNode_large.position = CGPointMake(backgroundStarHandlerNode_large.position.x+changeX_large,backgroundStarHandlerNode_large.position.y+changeY_large)
        
    }
    
    
    
    

    
}
