//
//  SVGHandler.swift
//  SpaceSwing
//
//  Created by Jorge Torres on 12/27/24.
//
struct starInfo : Codable{
    
    var ID: Int
    var xOffset: Int
    var yOffset: Int
    var modifiedSVGDuration: Float
    
}


struct TableRow: Codable {
    var id: Int
    var type: String
    var value: Float
}

struct StarTimerData: Codable {
    
    var starID: Int
    var timerData: [TableRow]
}



import Foundation


    
    func importPositionData (fileName: String)-> [starInfo]?{
        
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") else {
              print("Failed to find file: \(fileName).json in bundle.")
              return nil
          }

          do {
              // Load the JSON data
              let jsonData = try Data(contentsOf: fileURL)

              // Decode the data into an array of starInfo
              let positionData = try JSONDecoder().decode([starInfo].self, from: jsonData)
              return positionData
          } catch {
              print("Failed to load or decode JSON: \(error.localizedDescription)")
              return nil
          }
        
        
    }
    
    func importTimerData(from fileName: String) -> [StarTimerData]?
    {
        // Get the file URL from the app bundle
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("Failed to find file: \(fileName).json in bundle.")
            return nil
        }
        
        do {
            // Load the JSON data
            let jsonData = try Data(contentsOf: fileURL)
            
            // Decode the data into an array of StarTimerData
            let timerData = try JSONDecoder().decode([StarTimerData].self, from: jsonData)
            return timerData
        } catch {
            print("Failed to load or decode JSON: \(error.localizedDescription)")
            return nil
        }
    
}
