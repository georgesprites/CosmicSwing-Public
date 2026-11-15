//
//  ChallangeLabelWithStar.swift
//  N Body No Problem
//
//  Created by Jorge Torres on 12/19/24.
//

import Foundation
import SpriteKit

class ChallangeLabelWithStar: SKNode {
    
    
    let star = SKSpriteNode.init(imageNamed: "star-blank")
    let label = SKLabelNode()
    var wantedText = ""
    func setupLabel(withText: String){
        
        self.addChild(label)
        star.zPosition = 1001
        label.fontSize = 18
        label.fontName = "Andale Mono"
        label.zPosition = 1001
        label.fontColor = .white
        wantedText = withText
        label.verticalAlignmentMode = .center
        label.text = ""
        label.horizontalAlignmentMode = .center
        
    }
    
    func animateText(withCompletion: Bool = false){
        
        let starFilled = SKSpriteNode.init(imageNamed: "star-filled")
        
        starFilled.alpha = 0.0
        starFilled.setScale(1.5)
        starFilled.run(SKAction.group([SKAction.fadeAlpha(to: 1.0, duration: 0.5), SKAction.scale(to: 1.0, duration: 0.5)]))
       
        if(withCompletion){
            self.addChild(starFilled)
        
        }
        let delay = 0.05
        var displayedText = ""
          var currentIndex = 0

          // Create SKAction to loop through characters
          let animationAction = SKAction.sequence([
              SKAction.run {
                  let index = self.wantedText.index(self.wantedText.startIndex, offsetBy: currentIndex)
                  displayedText.append(self.wantedText[index])
                  self.label.text = displayedText
                  currentIndex += 1
              },
              SKAction.wait(forDuration: delay)
          ])
          
          // Run the action as many times as there are characters
          label.run(SKAction.repeat(animationAction, count: self.wantedText.count))
        
    }
    
}
