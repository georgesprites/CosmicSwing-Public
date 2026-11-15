//
//  backgroundStarManager.swift
//  SpaceSwing
//
//  Created by Jorge Torres on 1/30/25.
//

import Foundation
import SpriteKit

class BackgroundStarManager: SKNode {
    
    
    func setup(withMinSizeRange: ClosedRange<CGFloat>, withMaxSizeRange: ClosedRange<CGFloat>){
        
        
        let bkgStarTexture = SKTexture.init(imageNamed: "bkgstar")
        for _ in 0 ... Int.random(in: 40...50){
            
            let bkgStar = SKSpriteNode.init(texture: bkgStarTexture)
            let randomPoistion = CGPoint.init(x: CGFloat.random(in: -SharedInfo.SharedInstance.screenSize.width/2 ... SharedInfo.SharedInstance.screenSize.width/2), y: CGFloat.random(in: -SharedInfo.SharedInstance.screenSize.height/2...SharedInfo.SharedInstance.screenSize.height))
            bkgStar.position = randomPoistion
            
            bkgStar.alpha = 0
            
            bkgStar.run(SKAction.sequence([SKAction.wait(forDuration: CGFloat.random(in: 0...1.0)),  SKAction.repeatForever(SKAction.sequence([
            
                SKAction.group([
                    SKAction.scale(to: (CGFloat.random(in: withMinSizeRange)), duration: 0.5), SKAction.fadeAlpha(to: 0.0, duration: 0.5)]),
                
                SKAction.wait(forDuration: Double.random(in: 1...5)),
                
                SKAction.group([
                
                SKAction.scale(to: (CGFloat.random(in: withMaxSizeRange)), duration: 0.5),
                SKAction.fadeAlpha(to: 1.0, duration: 0.5)
                ])
            ]))]))
            
            //bkgStar.run(SKAction.colorize(with: colors.randomElement()!, colorBlendFactor: 0.3, duration: 0.01))
            bkgStar.zPosition = 101
            self.addChild(bkgStar)

            
            
        }
        
        
    }
}
