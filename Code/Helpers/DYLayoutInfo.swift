//
//  DYLayoutInfo.swift
//  circle_snap
//
//  Created by Mario Lopez on 12/6/24.
//

import Foundation
import SwiftUI
import SpriteKit


struct DYLayoutInfo {
    
    // MARK: Constants
    static let minimumConditionScore: Int = 5
    
    static let baseSpeed: Double = 0.005
    static let speedUpMultiplier: Double = 0.75
    
    static let iceSpeedMultiplier: Double = 1.5
    static let sandSpeedMultiplier: Double = 0.5
    static let mudBaseShakeAmplitude: Double = 0.0085
    static let mudShakeScalingFactor: Double = 0.01
    
    
    // MARK: Adjusted based on screensize
    
    var circleTrackRadius: CGFloat = 150.0
    var circleTrackLineWidth: CGFloat = 50.0
    var circleTrackNodeSideLength: CGFloat = 50.0
    var nodeRadius: CGFloat = 22.5
    var cloudMovementRange: CGFloat = 20.0
    
    var conditionPatchSize: CGFloat = 80.0
    var conditionScaleReference: CGFloat = 1.0
    
    var scoreFontSize: CGFloat = 70.0
    var tutorialLabelFontSize: CGFloat = 20.0
    
    var startNodePosition: CGPoint = .zero
    var circleTrackNodePosition: CGPoint = .zero
    var cloudNodePosition: CGPoint = .zero
    var playerNodePosition: CGPoint = .zero
    var tutorialOverlayNodePosition: CGPoint = .zero

}
    
