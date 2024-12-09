//
//  CSGameContext.swift
//  circle_snap
//
//  Created by Duy Nguyen on 10/24/24.
//

import Foundation
import SpriteKit

class CSGameContext: ObservableObject {
    var score: Int = 0
    var progress: Double = Double.random(in: 0..<1)
    var randomNodeAngle: Double = Double.random(in: 0..<360)
    var rotationSpeed: Double = 0.005
    var lastClickProgress: Double = 0.0
    
    var currentCondition: ConditionType = .none
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
        rotationSpeed = 0.05
        currentCondition = .none
        isInConditionPatch = false
        isGlowing = false
        isBarVisible = true
        scale = 1.0
        shakeOffset = 0.0
    }
}
