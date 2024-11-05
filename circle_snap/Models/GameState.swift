//
//  GameState.swift
//  circle_snap
//
//  Created by Duy Nguyen on 11/4/24.
//

import SwiftUI
import Combine

struct GameState {
    var progress: Double = 0.0
    var randomNodeAngle: Double = Double.random(in: 0..<360)
    var scale: CGFloat = 1.0
    var shakeOffset: CGFloat = 0
    var isGlowing: Bool = false
    var lastClickProgress: Double = 0.0
    
    // score system
    var score: Int = 0
    var combo: Int = 0
    var highestCombo: Int = 0
    var lastHitAccuracy: String = ""
    
    var lives: Int = 3
    
    var gameTimer: Int = 10
    var timer: AnyCancellable?
}
