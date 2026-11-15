//
//  HelperMethods.swift
//  N Body No Problem
//
//  Created by Jorge Torres on 12/14/24.
//

import Foundation



func clampedForceVector(dx: CGFloat, dy: CGFloat, maxForce: CGFloat) -> CGVector {
    let magnitude = sqrt(dx * dx + dy * dy)
    
    // Check if the magnitude exceeds the maxForce
    if magnitude > maxForce {
        let scale = maxForce / magnitude
        return CGVector(dx: dx * scale, dy: dy * scale) // Scale the vector down
    } else {
        return CGVector(dx: dx, dy: dy) // No scaling needed
    }
}
