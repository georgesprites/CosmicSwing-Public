//
//  InitialTouchLocationIndicator.swift
//  N Body No Problem
//
//  Created by Jorge Torres on 12/14/24.
//

import Foundation
import SpriteKit

class InitialTouchLocationIndicatorNode: SKNode
{
    
    let circle = SKShapeNode.init(circleOfRadius: 50 )
    let textIndicator = SKLabelNode(text: "0")
    var awesomeDashIndicators : [MoveIndicator] = []
    var awesomeCropNode = SKCropNode()
    var currentEngineMaxValue = 0
    var lockedPosition = CGPoint()

    func setup() {
        
        self.addChild(circle)
        circle.alpha = 0.5
        circle.lineWidth = 3
        
        self.addChild(textIndicator)
        textIndicator.alpha = 1.0
        
        textIndicator.horizontalAlignmentMode = .center
        textIndicator.verticalAlignmentMode = .center
        
        textIndicator.fontName = "AvenirNext-Bold"
        
        createDashIndicatorsOfBoost()
        
        let awesomeCropNodeInidcatior = SKSpriteNode.init(imageNamed: "donut")
        //self.addChild(awesomeCropNodeInidcatior)
        
        awesomeCropNode.maskNode = SKSpriteNode.init(imageNamed: "donut")
        self.addChild(awesomeCropNode)
       
        
        
    }
    
    
    func createDashIndicatorsOfBoost(){
        
        
        
        for number_of_indicators in 1...100{
            
            let dashIndicator = MoveIndicator.init(color: .white, size: CGSize.init(width: 20, height: 2))
            
            
            dashIndicator.zRotation = CGFloat(degreesToradians(3.6 * Float(number_of_indicators)))
            
            let distance = CGFloat(50.0)
            
            let dx = cos(dashIndicator.zRotation) * distance
            let dy = sin(dashIndicator.zRotation) * distance
            
            dashIndicator.maxPosition =  CGPoint.init(x:  cos(dashIndicator.zRotation) * distance, y:  sin(dashIndicator.zRotation) * distance)
            dashIndicator.usingMaxPosition = CGPoint.init(x:  cos(dashIndicator.zRotation) * (distance * 1.25), y:  sin(dashIndicator.zRotation) * (distance * 1.25 ))
            
            awesomeDashIndicators.append(dashIndicator)
            
            awesomeCropNode.addChild(dashIndicator)
            
        }
        
    }
    
    func moveIndicatorsWithAction( indicator: MoveIndicator, distance: CGFloat, duration: TimeInterval, direction: Int) {
    
        
        
            var moveAction = SKAction()
            
            if direction == 1 {
                // Move outward: calculate offset using zRotation
              
                moveAction = SKAction.move(to: indicator.maxPosition, duration: duration)
            } else if direction == -1 {
                // Move back to original position (CGPoint.zero)
                moveAction = SKAction.move(to: CGPoint.zero, duration: duration)
            }
            // Run the action on the indicator
            indicator.run(moveAction)
        
    }
    
    func moveIndicatorsWithUsingAction( indicator: MoveIndicator, distance: CGFloat, duration: TimeInterval, direction: Int) {
    
        
        
            var moveAction = SKAction()
            
            if direction == 1 {
                // Move outward: calculate offset using zRotation
              
                moveAction = SKAction.move(to: indicator.usingMaxPosition, duration: duration)
            } else if direction == -1 {
                // Move back to original position (CGPoint.zero)
                moveAction = SKAction.move(to: indicator.maxPosition, duration: duration)
            }
            // Run the action on the indicator
            indicator.run(moveAction)
        
    }
    
    
    func playerDeterminingEnginerPowerToUse(value: Int){
        
        
        //value is 1 - 100
        //index is 0-99
        
        
        
        var indexValue = value - 1
        if(indexValue < 0){
            indexValue = 0
        }
        let stringValue = String(value)
        
        if(indexValue < currentEngineMaxValue) {
            
            for indicatorIndex in (indexValue)...currentEngineMaxValue{
                moveIndicatorsWithUsingAction(indicator: awesomeDashIndicators[indicatorIndex], distance: 50, duration: 0.05 , direction: -1)
            }
            
            
        }
        else if( indexValue > currentEngineMaxValue){
            for indicatorIndex in 0...(indexValue){
                moveIndicatorsWithUsingAction(indicator: awesomeDashIndicators[indicatorIndex ], distance: 50, duration: 0.05, direction: 1)
                
                
                
            }
        }
        
        if(value == 100 && currentEngineMaxValue != 99){
            circle.fillColor = SKColor.white
            circle.alpha = 1
            
            let duration = 0.1
            let scaleAction =
            
      
            SKAction.repeatForever(SKAction.sequence(
                
              
            [
                SKAction.scale(to: 1.5, duration: duration),
                SKAction.scale(to: 0.5, duration: duration)
                
            ]
            
        ))
            circle.speed = 1.0
            var index = 0
            
            let cycleDuration = duration * 2.0
            let step = cycleDuration / Double(awesomeDashIndicators.count)
            
            for indicator in awesomeDashIndicators {
                
                //waittime = Double(index) * 0.0011
                let waitTime = Double(index) * step

                indicator.run(SKAction.sequence([
                    
                    SKAction.wait(forDuration: waitTime),
                    scaleAction
                    
                ]), withKey: "scaleup")
                
                index = index + 1
            }
            
           // circle.run(scaleAction, withKey: "scaleup")
            textIndicator.fontColor = SKColor.black
            textIndicator.run( SKAction.repeatForever(SKAction.sequence(
                
                
                [
                    //SKAction.wait(forDuration: 0.5),
                    SKAction.scale(to: 1.1, duration: 0.1),
                    SKAction.scale(to: 1.0, duration: 0.1)
                    
                ]
                
            )), withKey: "scaleup")
            
        } else if (currentEngineMaxValue != 99){
            
            resetIndicators()
            
        }
        
        currentEngineMaxValue = indexValue
        self.textIndicator.text = stringValue
        
    }
        
        
    func resetIndicators(){
        for indicator in awesomeDashIndicators {
            indicator.removeAction(forKey: "scaleup")
            indicator.setScale(1.0)
            
        }
        circle.fillColor = SKColor.clear
        textIndicator.fontColor = SKColor.white
        textIndicator.removeAction(forKey: "scaleup")
        circle.removeAction(forKey: "scaleup")
        textIndicator.setScale(1.0)
        circle.setScale(1.0)

        circle.speed = 1.0
        
    }
    
    func setEnginePower(value: Int) {
        
        
        //value is 1 - 100
        //index is 0-99
        
        
        
        var indexValue = value - 1
        if(indexValue < 0){
            indexValue = 0 
        }
        let stringValue = String(value)
        
        if(indexValue < currentEngineMaxValue) {
            
            for indicatorIndex in (indexValue)...99{
                moveIndicatorsWithAction(indicator: awesomeDashIndicators[indicatorIndex], distance: 50, duration: 0.00 , direction: -1)
            }
            
            
        }
        else if( indexValue > currentEngineMaxValue){
            for indicatorIndex in 0...(indexValue){
                moveIndicatorsWithAction(indicator: awesomeDashIndicators[indicatorIndex ], distance: 50, duration: 0.00, direction: 1)
            }
        }
        
        currentEngineMaxValue = indexValue
        self.textIndicator.text = stringValue
        
    }
    
}
