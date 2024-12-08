//
//  GameConstants.swift
//  circle_snap
//
//  Created by Mario Lopez on 12/6/24.
//

import Foundation
import SwiftUI
import SpriteKit


struct GameConstants {
    static let circleTrackRadius: CGFloat = 150.0
    static let circleTrackWidth: CGFloat = 50.0
    static let nodeRadius: CGFloat = 22.5
    static let timerInterval: TimeInterval = 0.0001
    static let shakeDuration: Double = 0.05
    static let scaleAnimationDuration: Double = 0.2
    
    static let speedUpModifier: Double = 0.10
    
    static let conditionEventDuration: TimeInterval = 10.0
    static let conditionPatchSize: Double = 80.0
    
    
    static let windSpeedMultiplier: Double = 1.5
    static let sandSpeedMultiplier: Double = 0.5
    
    static let iceMinAdjustment = 0.3
    static let iceMaxAdjustment = 1.4
    
    static let conditions: [ConditionType] = [.wind, .ice, .sand, .fog]
}
    
