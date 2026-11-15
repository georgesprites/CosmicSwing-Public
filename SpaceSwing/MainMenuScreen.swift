
import SpriteKit
import GameplayKit
import PocketSVG
import CoreGraphics

class MainMenuScreen: SKScene {

    let logoReference = SKSpriteNode.init(imageNamed: "CosmicSwingLogo")
    let tapToPlayReference = SKLabelNode()
    
    var startedGame = false
    
    
    var space_quotes = [
        "The universe is under no obligation to make sense to you. \n\n  Neil deGrasse Tyson." ,
        "”Exploration is wired into our brains. If we can see the horizon, we want to know what’s beyond.” \n\n  Buzz Aldrin",
        
        "Two possibilities exist: either we are alone in the Universe or we are not. Both are equally terrifying.\n\n   Arthur C. Clarke",
        
        
        "Space is big. You just won't believe how vastly, hugely, mind-bogglingly big it is. I mean, you may think it's a long way down the road to the chemist's, but that's just peanuts to space. \n\n   Douglas Adams"
        
        
        
        
    ]
    
    override func didMove(to view: SKView) {
        
        
        
        // Atlases you want preloaded
        SpriteKitTextureLoader.shared.preloadAtlases(["EarthRotationAnimation"], warmTextures: true, completion: {})

        
        
     
       // self.addChild(logoReference)
        self.backgroundColor = .black
       
        self.beginIntro()

        
     
        
    }
    
    func beginIntro(){
        
        
         
         if (startedGame == false ) {
             
             startedGame = true

             
             
             let textureAtlas = SKTextureAtlas(named: "LogoAnimation")
             
             // Create an array to hold the textures
             var frames: [SKTexture] = []
         
             // Load all 16 frames from the atlas
             for i in 1...8 {
             
                 var textureName = ""
             
                 var append = ""
            
                 
                 
                 frames.append(textureAtlas.textureNamed("logo" +  String(format: "%0d", i)))
             }
         
             // Create the animation action
             let animation = SKAction.animate(with: frames, timePerFrame: 0.050, resize: true, restore: false)
             //self.setScale(0.50)
             
             self.addChild(logoReference)
             logoReference.run(animation)
             logoReference.run(SKAction.sequence([
                
                SKAction.wait(forDuration: 2),
                SKAction.fadeAlpha(to: 0.0, duration: 1.0)
                
             ]))
             
             //let quote = SKLabelNode()

           //  let quote = MSKAnimatedLabel(text: "”Exploration is wired into our brains. If we can see the horizon, we want to know what’s beyond.” – Buzz Aldrin/")
             
             let quote = MSKAnimatedLabel(text: space_quotes[Int.random(in: 0...space_quotes.count - 1)],
                                          horizontalAlignment: .center,
                                          durationPerCharacter: 0.05,
                                          fontSize:  25,
                                          marginVertical:  50.0,
                                          fontColor:  .white,
                                          fontName:  "Heiti TC",
                                          skipSpaces: true,
                                          labelWidth: self.size.width - 300 ,
                                          finishTypingOnTouch:  false)
            // quote.text = "”Exploration is wired into our brains. If we can see the horizon, we want to know what’s beyond.” – Buzz Aldrin"
             
             
            // quote.fontName = "Heiti TC"
             
            // quote.lineBreakMode = .byWordWrapping
            // quote.numberOfLines = 10
            // quote.preferredMaxLayoutWidth = self.size.width - 100
             
            // quote.fontSize = 15
            // quote.position.y = -self.size.height / 4
            // quote.verticalAlignmentMode = .center
         
             quote.alpha = 0.0
             quote.run(SKAction.fadeAlpha(to: 1.0, duration: 0.8))
             
             quote.position.y = 0
            // self.addChild(quote)
             
             
             quote.run(SKAction.sequence(
                [
                    
                    SKAction.wait(forDuration: 8),
                    SKAction.fadeAlpha(to: 0.0, duration: 2)
                    
                ]
                
             ))
             
             self.run(SKAction.wait(forDuration: 3), completion:
                         
                         {
                 
                 let scene = SKScene(fileNamed: "Level" + SharedInfo.SharedInstance.startingLevel )
                     scene!.scaleMode = .aspectFill
                 
                 self.view?.presentScene(scene!, transition: .fade(withDuration: 1))
//                 self.view?.presentScene(scene!)
                 
                 
             } )
             
             
         }
         
        
        
        
    }
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        beginIntro()
        
        
    }
    
 
    
  

    
    
    
}
