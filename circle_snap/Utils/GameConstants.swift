//
//  GameConstants.swift
//  circle_snap
//
//  Created by Duy Nguyen on 11/4/24.
//

import SwiftUI

struct GameConstants {
    static let circleRadius: CGFloat = 155.0
    static let nodeRadius: CGFloat = 22
    static let timerInterval: TimeInterval = 0.0001
    static let shakeDuration: Double = 0.05
    static let scaleAnimationDuration: Double = 0.2
    
    static let speedUpModifier: Double = 0.10
    
    static let weatherEventDuration: TimeInterval = 20.0  // Weather changes every 20 seconds
    static let weatherPatchSize: Double = 45.0  // Size of weather patch in degrees
    
    // Wind effect constant
    static let windSpeedMultiplier: Double = 1.5   // Speed up factor in wind
}
    


