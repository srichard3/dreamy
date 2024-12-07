//
//  CSGameContext.swift
//  circle_snap
//
//  Created by Duy Nguyen on 10/24/24.
//

import Foundation
import SpriteKit

class GameContext {
    var score: Int = 0
    var progress: Double = 0.0
    var randomNodeAngle: Double = 0.0
    var animationSpeed: Double = 5.0
    var lastClickProgress: Double = 0.0
    
    var currentCondition: GameCondition = .none
    var isInConditionPatch: Bool = false
    var conditionPatchStartAngle: Double = 0.0
    
    var isGlowing: Bool = false
    var isBarVisible: Bool = true
    
    // Animation and interaction properties
    var scale: CGFloat = 1.0
    var shakeOffset: CGFloat = 0.0
    
    func reset() {
        score = 0
        progress = 0.0
        randomNodeAngle = Double.random(in: 0..<360)
        animationSpeed = 5.0
        currentCondition = .none
        isInConditionPatch = false
        isGlowing = false
        isBarVisible = true
        scale = 1.0
        shakeOffset = 0.0
    }
}
