//
//  LevelPickerMenu.swift
//  N Body No Problem
//
//  Created by Jorge Torres on 12/24/24.
//

import Foundation
import SpriteKit

struct Level: Codable {
    let LevelID: Int
    var Unlocked: Bool
    var starsCompleted: Int
    let positionX: Int
    let positionY: Int
    let rotationInAngle: Int
    let Astros: [AstroData]
}

struct AstroData: Codable {
    let name: String
    let positionX: Int
    let positionY: Int
}


// Define the Challenge struct
struct Challenge: Codable {
    let ChallengeLabel: String
    let ChallengeType: ChallengeType
    let ChallengeGoal: String
    var UserCompleted: Bool
}

// Define the Level struct
struct LevelChallangeData: Codable {
    let Level: Int
    var Challenges: [Challenge]
}

enum ChallengeType: String, Codable {
    case timeUnder = "TimeUnder"
    case coinCollect = "CoinCollect"
    case noShipDamage = "NoShipDamage"
    case noShots = "NoShots"
    case challengeStar = "ChallengeStar"
    case boostUsage = "BoostUsage"
    // Add more cases as needed for other challenge types
}





class LevelPickerMenu: Menu {
    

    
    
    var levelButtons : [MiniLevelIndicator] = []
    let label_bkg = SKTexture.init(imageNamed: "mini-levelindicatorbkg")
    let menu = SKCropNode()
    var levelSelectorButtonPressedCallback : ((_ buttonName: String)->Void)? = nil
    var transparentBKG = SKSpriteNode()
    var challangeData : [LevelChallangeData]? = nil
    let close_button = JKButtonNode.init(backgroundNamed: "xbutton")
    let selectUIItem = SKSpriteNode.init(imageNamed: "select-selectmenu")
    let missionUIItem = SKSpriteNode.init(imageNamed: "mission-selectmenu")
    
    override func setup(){
        
        self.zPosition = 1000
        setupWithCurrentLevelData()
        
        
        transparentBKG = SKSpriteNode.init(color: .black, size: SharedInfo.SharedInstance.screenSize)
        
        
        transparentBKG.alpha = 0.5
        
        menu.addChild(transparentBKG)
        self.addChild(menu)
        
        let left_button = JKButtonNode.init(backgroundNamed: "arrow-left")
        
        
        let right_button = JKButtonNode.init(backgroundNamed: "arrow-right")
        
        
        self.addChild(close_button)
        close_button.zPosition = 1001
      
        close_button.position.y = -transparentBKG.size.height  / 2 + close_button.size.height
        
      
       
        
       // self.addChild(left_button)
      //  self.addChild(right_button)
        
        self.zPosition = 1000
       // crop.run(SKAction.repeatForever(SKAction.sequence([SKAction.rotate(byAngle: CGFloat(degreesToradians(75)), duration: 0.5), SKAction.wait(forDuration: 2.5)])))
        
        challangeData = loadLevelChallangesFromJSON()
        
    }
    
   
    
    
    func setupWithCurrentLevelData(){
        
        if (( SharedInfo.SharedInstance.levelData ) == nil) {
            
            SharedInfo.SharedInstance.levelData = loadLevelsFromLocalStore(from: "LevelData")
           
            //TODO: Add back in when wanting to load local data
            //Load from bundle resources for now while testing
            // SharedInfo.SharedInstance.levelData  = loadLevels(from: "LevelData")
            
            
            if (( SharedInfo.SharedInstance.levelData ) == nil) {
                
                print("No previous saved data found, loading from bundle resources")
                SharedInfo.SharedInstance.levelData = loadLevelsFromLocalStore(from: "LevelData")
            }
        }
        
        var savedPreviousPosition = CGPoint.zero

        missionUIItem.position.y = ( SharedInfo.SharedInstance.screenSize.height / 2) - missionUIItem.size.height * 2
        
        selectUIItem.position.y = ( SharedInfo.SharedInstance.screenSize.height / 2) - missionUIItem.size.height * 3


        self.addChild(missionUIItem)
        self.addChild(selectUIItem)
        
        
        
        let bounceEffect = SKAction.sequence([
            
            SKAction.scale(to: 1.2, duration: 0.1),
            SKAction.scale(to: 1.0, duration: 0.1),
            SKAction.wait(forDuration: 1.5)
            
        ])
        
        
        
        missionUIItem.run(SKAction.repeatForever(bounceEffect))
        selectUIItem.run(SKAction.repeatForever(bounceEffect))
        
        transparentBKG.zPosition = 999
        selectUIItem.zPosition = 1001
        missionUIItem.zPosition = 1000
    
        createLevelIndicators()
        lastUnlockedLevel = findLastUnlockedLevel(from: SharedInfo.SharedInstance.levelData!)!
        showThemFunkyAstrosWhiteBoy()
        
    }
    
    var lastUnlockedLevel = 0
    
    func createLevelIndicators(){
        
        let lastUnlockedLevel = findLastUnlockedLevel(from: SharedInfo.SharedInstance.levelData!)
        
        var levelIndex = 0
        var buffer_inbetween_levelindicators = 15
        for level in SharedInfo.SharedInstance.levelData! {
            
            
          
            if levelIndex >= 8 { return } // Limit to 8 rows for now, to have close button
            var levelIndicator = MiniLevelIndicator(texture: self.label_bkg, state: .normal)
            
            var isCurrentMission = false
            if(level.LevelID == lastUnlockedLevel ){
                isCurrentMission = true
               
        

            }
                
            levelIndicator.setup(withLevelID: level.LevelID, numberOfStarsCompelted: level.starsCompleted, isCurrentMission: isCurrentMission, levelData: level)
            
            

                levelIndicator.levelData = level
           
            levelIndicator.position.y = CGFloat(levelIndex) * -levelIndicator.size.height - CGFloat(buffer_inbetween_levelindicators * levelIndex) + missionUIItem.size.height * 3
               
                self.addChild(levelIndicator)
                levelIndicator.zPosition = 1003
                
              
                
                
             
                  
                
                
                levelIndicator.name = String(level.LevelID)
                levelIndicator.action = self.levelSelectorButtonPressed
                
                levelButtons.append(levelIndicator)
            
            if(level.Unlocked == true ){
                
                
            }
            else {
               // levelIndicator.alpha = 0.0
                levelIndicator.enabled = false
            }
             levelIndex = levelIndex + 1
        }
        
    }
    
    
    func showFromMissionFailed(){
        
        
        self.close_button.isHidden = true
        self.close_button.alpha = 0
        super.show()
        
        
        
        
    }
    
    override func show(){
        
        super.show()
        self.close_button.isHidden = false
        self.close_button.alpha = 1
    }
    
    func show(withLevelCompleted: String, withNumberOfStarsCompletedOnLevel: Int){
        
        self.close_button.isHidden = true
        self.close_button.alpha = 0
        SharedInfo.SharedInstance.levelData![Int(withLevelCompleted)!].Unlocked = true
        SharedInfo.SharedInstance.levelData![Int(withLevelCompleted)! - 1].starsCompleted = withNumberOfStarsCompletedOnLevel
        saveLevels(SharedInfo.SharedInstance.levelData!, to: "LevelData")
        SharedInfo.SharedInstance.setProperty(property: "startingLevel", setTo: String(Int(withLevelCompleted)! + 1))
        
        
        
        for indicator in levelButtons {
            indicator.removeFromParent()
            indicator.removeAllActions()
            indicator.removeAllChildren()
        }
        
        self.createLevelIndicators()
        self.showThemFunkyAstrosWhiteBoy()
        
        
        for indicator in levelButtons{
            
            if(indicator.levelID == Int(withLevelCompleted)){
                
                indicator.runAnimatedLevelCompletionAnimation()
            }
            
        }
        
        self.show()

    }
    
    func showThemFunkyAstrosWhiteBoy(){
        
        for indicator in self.levelButtons {
            
            if(indicator.levelData!.Unlocked && (indicator.levelData?.LevelID) != self.lastUnlockedLevel ){
                
                for astro in indicator.levelData!.Astros {
                    
                    let astroSprite = SKSpriteNode.init(imageNamed: astro.name)
                    astroSprite.position.x = CGFloat(astro.positionX)
                    astroSprite.position.y = CGFloat(astro.positionY)
                    astroSprite.setScale(0.5)
                    astroSprite.zPosition = 1002
                    self.addChild(astroSprite)
                    
                }
                
            }
            
        }
    }
    
    func levelSelectorButtonPressed(button: JKButtonNode )
    {
        
        if let callback = self.levelSelectorButtonPressedCallback {
            
            self.hide()
            callback(button.name!)
        }
        
        
    }

    
    func findLastUnlockedLevel(from levels: [Level]) -> Int? {
        var lastUnlockedLevelID: Int?

        for level in levels {
            if level.Unlocked {
                lastUnlockedLevelID = level.LevelID
            }
        }

        return lastUnlockedLevelID
    }
    
    
    func loadLevelChallangesFromJSON() -> [LevelChallangeData]? {
        // Locate the JSON file in the app bundle
        guard let url = Bundle.main.url(forResource: "LevelChallanges", withExtension: "json") else {
            print("JSON file not found.")
            return nil
        }

        do {
            // Load the data from the file
            let data = try Data(contentsOf: url)

            // Decode the JSON data into an array of Level structs
            let levels = try JSONDecoder().decode([LevelChallangeData].self, from: data)
            return levels
        } catch {
            print("Failed to load or decode JSON: \(error)")
            return nil
        }
    }
    
    
    func loadLevelsFromLocalStore(from filename: String) -> [Level]?{
        
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
              print("Failed to find \(filename).json in the bundle.")
              return nil
          }
          
          do {
              let data = try Data(contentsOf: url)
              let levels = try JSONDecoder().decode([Level].self, from: data)
              return levels
          } catch {
              print("Failed to load or decode \(filename).json: \(error)")
              return nil
          }
            
    }
    
    func loadLevels(from filename: String) -> [Level]? {
        guard let documentsDirectory = getDocumentsDirectory() else {
               print("Failed to get the documents directory.")
               return nil
           }
           
           let fileURL = documentsDirectory.appendingPathComponent(filename)
           
           do {
               let jsonData = try Data(contentsOf: fileURL)
               return try JSONDecoder().decode([Level].self, from: jsonData)
           } catch {
               print("Failed to load levels: \(error)")
               return nil
           }
    }
    
    func getDocumentsDirectory() -> URL? {
        let fileManager = FileManager.default
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    
    // MARK: - Save JSON Data
    func saveLevels(_ levels: [Level], to filename: String) {
        guard let documentsDirectory = getDocumentsDirectory() else {
             print("Failed to get the documents directory.")
             return
         }

         let fileURL = documentsDirectory.appendingPathComponent(filename)
         
         do {
             let jsonData = try JSONEncoder().encode(levels)
             try jsonData.write(to: fileURL)
             print("Levels saved to \(fileURL)")
         } catch {
             print("Failed to save levels: \(error)")
         }
    }
    
    
}
