//
//  CameraHandler.swift
//  N Body No Problem
//
//  Created by Jorge Torres on 8/11/24.
//

import Foundation
import SpriteKit

class CameraHandler: SKCameraNode {
    
    var isCameraZoomToggled = false
    var scaleSize = 2.0
    func zoomTogglePressed(_ button: JKButtonNode){
        
        
        if(isCameraZoomToggled){
           // cameraReference.run(SKAction.scale(to: 1.0, duration: cameraZoomSpeed))
            //cameraReference.run(SKAction.moveBy(x: 0, y: -self.size.height / 2, duration: cameraZoomSpeed))
            self.setScale(2.0 * scaleSize)
           // cameraReference.position.y = cameraReference.position.y - self.size.height / 2
            isCameraZoomToggled = false
        } else {
           // cameraReference.run(SKAction.scale(to: 2.0, duration: cameraZoomSpeed))
            //cameraReference.run(SKAction.moveBy(x: 0, y: self.size.height / 2, duration: cameraZoomSpeed))
            
            self.setScale(1.0 * scaleSize )
          //  cameraReference.position.y = cameraReference.position.y + self.size.height / 2
            isCameraZoomToggled = true
        }
    }
    
    
    func shakeCamera(duration:Float, _ amplitudeMultipler: CGFloat = 3.0) {
        
    
        let amplitudeX:Float = Float(25 * amplitudeMultipler);
        let amplitudeY:Float = Float(25 * amplitudeMultipler) ;
           let numberOfShakes = duration / 0.02;
           var actionsArray: [SKAction] = [];
        
           for index in 1...Int(numberOfShakes) {
               // build a new random shake and add it to the list
               let moveX = Float(arc4random_uniform(UInt32(amplitudeX))) - amplitudeX / 2;
               let moveY = Float(arc4random_uniform(UInt32(amplitudeY))) - amplitudeY / 2;
               let shakeAction = SKAction.moveBy(x: CGFloat(moveX), y: CGFloat(moveY), duration: 0.02);
               shakeAction.timingMode = SKActionTimingMode.easeOut;
               actionsArray.append(shakeAction);
               actionsArray.append(shakeAction.reversed());
           }

           let actionSeq = SKAction.sequence(actionsArray);
            self.run(actionSeq);
       }
    
    
}
