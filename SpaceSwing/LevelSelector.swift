import SpriteKit
import GameplayKit

class LevelSelector: SKScene {
    
    
   
    
    
    
    override func didMove(to view: SKView) {
        
        
        
    }
    
  
  
   
    func setSceneOptions(){
        self.view?.showsDrawCount = true
        self.scene?.view?.showsPhysics = SharedInfo.SharedInstance.showPhysics 
        self.scene?.view?.showsFields = false
        
    }
    
    
 
 
    
}
