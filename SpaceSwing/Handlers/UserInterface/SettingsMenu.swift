//
//  SettingsMenu.swift
//  N Body No Problem
//
//  Created by Jorge Torres on 12/19/24.
//

import Foundation
import SpriteKit

class SettingsMenu: Menu {
    
    let menu = SKSpriteNode.init(imageNamed: "settings-menu")
    let restartButton = JKButtonNode.init(backgroundNamed: "restart-button-ui")
    let closeButton = JKButtonNode.init(backgroundNamed: "xbutton")
    let audioEnabledSetting = SettingWithToggle()
    let showLevelPickerButton =  JKButtonNode.init(backgroundNamed: "mission-map-settings-UI")
    
    let noAdsButton = JKButtonNode.init(backgroundNamed: "NoAdsBanner")
    
    
    
    override func setup() {
        
        
        var blackBackground = SKSpriteNode.init(color: .black, size: SharedInfo.SharedInstance.screenSize)
        self.addChild(blackBackground)
        blackBackground.alpha = 0.5
        blackBackground.zPosition = 999
        
        closeButton.zPosition = 1000
        self.addChild(menu)
        menu.zPosition = 1000
        self.addChild(closeButton)
        closeButton.position.y = -self.menu.size.height / 2 - closeButton.size
            .height / 2
        
        audioEnabledSetting.setup(withLabelText: "", managedPropertyName: "AudioEnabled")
        self.addChild(audioEnabledSetting)
        audioEnabledSetting.position.x = -self.menu.size.width / 2 + audioEnabledSetting.toggle.size.width / 2
        audioEnabledSetting.toggle.position.x = self.menu.size.width - audioEnabledSetting.toggle.size.width * 1.5
        audioEnabledSetting.position.y = 100
    
        noAdsButton.position.y = restartButton.position.y - ( ( restartButton.size.height ) * 1.3 )
        noAdsButton.zPosition = 1001
        
        menu.addChild(noAdsButton)
        
        menu.addChild(restartButton)
      
        noAdsButton.action = { [weak self] sender in
            Task { @MainActor in
                
                await IAPManager.shared.loadProducts()
                await IAPManager.shared.buyRemoveAds()

                // Update your settings UI

                // Optional: disable/hide button after purchase
                if IAPManager.shared.adsRemoved {
                    sender.isUserInteractionEnabled = false
                    sender.alpha = 0.5
                }
            }
        }
        
     
        showLevelPickerButton.zPosition = 1001
        showLevelPickerButton.position.y = restartButton.position.y - ( ( restartButton.size.height * 2 ) * 1.3 )
        self.addChild(showLevelPickerButton)
        
        
        restartButton.zPosition = 1006
        restartButton.position.y = 0
      
        
        
    }
    
    func buyNoAds (button: JKButtonNode) async {
        
        
        await IAPManager.shared.buyRemoveAds()
        
    }
    
    
    
    
    
    
    
    
    
}
