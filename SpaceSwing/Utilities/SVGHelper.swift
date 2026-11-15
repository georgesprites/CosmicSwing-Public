//
//  SVGHelper.swift
//  N Body No Problem
//
//  Created by Jorge Torres on 12/9/24.
//

import Foundation
import PocketSVG
import SpriteKit
import CoreGraphics

func parsePocketSVGPath(for resourceName: String, offsetX: CGFloat, offsetY: CGFloat) -> CGPath? {
    guard let url = Bundle.main.url(forResource: resourceName, withExtension: "svg") else {
        print("Error: SVG file not found.")
        return nil
    }
    
    // Use PocketSVG to parse the SVG file and extract CGPath
    let svgPaths = SVGBezierPath.pathsFromSVG(at: url)
    guard let originalPath = svgPaths.first?.cgPath else {
        print("Error: Failed to extract path from SVG.")
        return nil
    }
    
    
    // 1. Get the bounding box of the path
    let boundingBox = originalPath.boundingBox
    
    // 2. Offset the path to align with (0, 0)
    var offsetTransform = CGAffineTransform(translationX: -boundingBox.origin.x + offsetX, y: -boundingBox.origin.y + offsetY)
    guard let offsetPath = originalPath.copy(using: &offsetTransform) else {
        print("Error: Failed to offset path.")
        return nil
    }
    
    // 3. Flip the path vertically around its height
    var flipTransform = CGAffineTransform(scaleX: 1.0, y: -1.0)
        
    guard let flippedPath = offsetPath.copy(using: &flipTransform) else {
        print("Error: Failed to flip path.")
        return nil
    }
    
    return flippedPath
}


func debugPath(_ path: CGPath, position: CGPoint, node: SKNode) {
    let shapeNode = SKShapeNode(path: path)
    shapeNode.strokeColor = .green
    shapeNode.lineWidth = 2
    shapeNode.alpha = 0.3
    node.addChild(shapeNode)
}

func applyPocketSVGPathToSprite(sprite: SKSpriteNode, svgResourceName: String, duration: TimeInterval, node: SKNode, offsetX: CGFloat = 0, offsetY: CGFloat = 0, debug: Bool = false, delay: Int = 0 ) {
    guard let path = parsePocketSVGPath(for: svgResourceName, offsetX: offsetX, offsetY: offsetY) else {
        print("Failed to parse SVG path.")
        return
    }
    if(debug){
    debugPath(path, position: sprite.position, node: node)
    }
    
    let rotatedPath = rotatePathBy90Degrees(path)
    // Follow the path relative to the sprite's current position
    let followPathAction = SKAction.follow(rotatedPath!, asOffset: false , orientToPath: false, duration: duration)
    sprite.run( SKAction.sequence([SKAction.wait(forDuration: TimeInterval(delay)), SKAction.repeatForever(followPathAction) ]) )
}


func rotatePathBy90Degrees(_ path: CGPath) -> CGPath? {
    // 1. Get the bounding box of the path
    let boundingBox = path.boundingBox
    
    // 2. Define a rotation transform
    // Rotate by 90 degrees (π/2 radians) around the bounding box center
    let rotationAngle = CGFloat.pi / 2 // 90 degrees in radians
    let centerX = boundingBox.midX
    let centerY = boundingBox.midY

    // Translate to the origin, rotate, then translate back
    var transform = CGAffineTransform(translationX: -centerX, y: -centerY) // Move center to origin
    transform = transform.rotated(by: rotationAngle) // Apply rotation
    transform = transform.translatedBy(x: centerX, y: centerY) // Move back to original position

    // 3. Apply the rotation transform to the path
    return path.copy(using: &transform)
}
