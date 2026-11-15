//
//  shootByWireMenu.swift
//  N Body No Problem
//
//  Created by Jorge Torres on 8/31/24.
//

import Foundation
import SpriteKit

class ShootByWireMenu : Menu {
    
    
    
    
    let movementJoystick =  AnalogJoystick(diameter: 200, colors: (UIColor.darkGray, UIColor.white))
    
    
    
     override func setup(){
        
        movementJoystick.position.x = (-SharedInfo.SharedInstance.screenSize.width / 2) + movementJoystick.diameter
        
        self.addChild(movementJoystick)
        
        

        
        
        
    }
    
    
}
