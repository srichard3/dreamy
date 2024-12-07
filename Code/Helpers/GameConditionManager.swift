//
//  GameConditionsManager.swift
//  circle_snap
//
//  Created by Duy Nguyen on 12/7/24.
//

import Foundation

class GameConditionManager {
    func updateCondition(for context: GameContext) {
        context.currentCondition = GameConstants.conditions.randomElement()!
        context.conditionPatchStartAngle = Double.random(in: 0..<360)
    }
    
    func applyConditionEffects(progress: Double, context: GameContext) -> Double {
        var progressChange = progress
        
        guard context.isInConditionPatch else {
            context.isBarVisible = true
            return progressChange
        }
        
        switch context.currentCondition {
        case .wind:
            progressChange *= GameConstants.windSpeedMultiplier
        case .sand:
            progressChange *= GameConstants.sandSpeedMultiplier
        case .ice:
            let isPositiveProgress = Bool.random()
            let adjustment = Double.random(in: GameConstants.iceMinAdjustment...GameConstants.iceMaxAdjustment)
            progressChange *= isPositiveProgress ? adjustment : -adjustment
        case .fog:
            context.isBarVisible = false
        case .none:
            break
        }
        
        return progressChange
    }
    
    func isAngleInRange(_ angle: Double, start: Double, end: Double) -> Bool {
        if start <= end {
            return angle >= start && angle <= end
        } else {
            return angle >= start || angle <= end
        }
    }
}
