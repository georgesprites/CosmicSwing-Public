//
//  SettingWithToggle.swift
//  N Body No Problem
//
//  Created by Jorge Torres on 12/19/24.
//

import Foundation
import SpriteKit

class SettingWithToggle: SKNode {
    
    
    let label = SKLabelNode.init(text: "")
    let toggle = JKButtonNode.init(backgroundNamed: "toggle-off")
    let toggleOnTexture = SKTexture.init(imageNamed: "toggle-on")
    let toggleOffTexture = SKTexture.init(imageNamed: "toggle-off")
    
    
    func setup(withLabelText: String, managedPropertyName: String){
        
        self.name = "settingsMenu"
        label.text = withLabelText
        self.addChild(label)
        label.verticalAlignmentMode = .top
        label.horizontalAlignmentMode = .left
        label.fontSize = 18
        label.fontName = "Andale Mono"
        label.zPosition = 1001
        toggle.zPosition = 1001
        
        self.addChild(toggle)
        toggle.action = settingToggled
        toggle.managedProperty = managedPropertyName
        
        let currentState = SharedInfo.SharedInstance.retrivePropertyState(property: managedPropertyName)
        
        setButtonTextureWithProperty(button: toggle, state: currentState)
        
        
    }
    
    
    func setButtonTextureWithProperty(button: JKButtonNode, state: Bool ){
        button.toggleState = state
        if (state){
            button.texture = toggleOnTexture
        } else {
            button.texture = toggleOffTexture
        }
    }
    
    func settingToggled(button: JKButtonNode){
        
        
        if (button.toggleState) {
            button.toggleState = false
            button.texture = toggleOffTexture
            SharedInfo.SharedInstance.setProperty( property: button.managedProperty, setTo: button.toggleState )
            
            
        } else {
            button.toggleState = true
            button.texture = toggleOnTexture
            SharedInfo.SharedInstance.setProperty( property: button.managedProperty, setTo: button.toggleState )
            
        }
        
       
    }
    
}
