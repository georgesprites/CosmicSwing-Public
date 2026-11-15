//
//  DiagnosticAndIgnitationSystemSwitches.swift
//  SpaceSwing
//
//  Created by Jorge Torres on 1/4/25.
//

import Foundation
import SpriteKit

class DiagnosticAndIgnitationSystemSwitches : SKNode {
    
    var background = SKSpriteNode()
    var hasEnabledAllSwitches = false
    
    var switchToggles : [JKButtonNode] = []
    var allSwitchesToggledCallback: (()->Void)? = nil 
    func setup(){
        
        
        let switch1 = JKButtonNode.init(backgroundNamed: "switch1")
        self.addChild(switch1)
        switchToggles.append(switch1)
        switch1.action = self.switchPressed
        
        
        
        let switch2 = JKButtonNode.init(backgroundNamed: "switch1")
        self.addChild(switch2)
        switchToggles.append(switch2)
        switch2.action = self.switchPressed

        switch2.position.x = -switch1.size.width
        
        let switch3 = JKButtonNode.init(backgroundNamed: "switch1")
        self.addChild(switch3)
        switch3.position.x = -switch1.size.width * 2
        switchToggles.append(switch3)
        switch3.action = self.switchPressed

        let switch4 = JKButtonNode.init(backgroundNamed: "switch1")
        self.addChild(switch4)
        switchToggles.append(switch4)
        switch4.action = self.switchPressed

        switch4.position.x = switch1.size.width

        let switch5 = JKButtonNode.init(backgroundNamed: "switch1")
        self.addChild(switch5)
        switch5.position.x = switch1.size.width * 2
        switch5.action = self.switchPressed

        switchToggles.append(switch5)

      
        
        
        
        
        let startButton = JKButtonNode.init(backgroundNamed: "bigbutton-off")
   
        startButton.action = self.bigButtonPressed
        
        startButton.position.x = switch1.size.width * 2.5 + startButton.size.width / 2
        startButton.position.y = -switch1.size.height / 2
        self.addChild(startButton)
        
        

        background = SKSpriteNode.init(imageNamed: "diag-bkg")
        self.addChild(background)
        background.position.y = -switch1.size.height / 2
        background.position.x = switch1.size.width

        background.zPosition = -1
        
        
        
        let slidersuper = SKSlider.sliderWithBackgroundImage(
            "slider",
            iconImage: "slidericon",
            target: self,
            action: #selector(sliderValueChanged)
        )
       
               
      
        self.addChild(slidersuper)
        slidersuper.position.y = -switch5.size.height / 2 - slidersuper.sliderBackground.size.height / 2
    }
    
    func switchPressed(button: JKButtonNode){
        

        
        if(button.toggleState == false ){
            button.toggleState = true
            button.texture = SKTexture.init(imageNamed: "toggle-on")
        } else {
            button.toggleState = false
            button.texture = SKTexture.init(imageNamed: "switch1")
        }
        
        checkIfAllSwitchesToggled()
        
        
        
    }
    
    func bigButtonPressed(button: JKButtonNode){
        
        if(button.toggleState == false ){
            button.toggleState = true
            button.texture = SKTexture.init(imageNamed: "ignitButton")
        } else {
            button.toggleState = false
            button.texture = SKTexture.init(imageNamed: "bigbutton-off")
        }
        
        checkIfAllSwitchesToggled()
        
    }
    
    func checkIfAllSwitchesToggled(){
        
        var allToggled = true
        for switchToggle in switchToggles {
            
            if(switchToggle.toggleState == false ){
                allToggled = false
            }
        }
        
        
        
        if(allToggled){
            
            
            if let callback = allSwitchesToggledCallback {
                callback() 
            }
            
            
        }
        
        
    }
    @objc func sliderValueChanged() {

    }
    
    
}
