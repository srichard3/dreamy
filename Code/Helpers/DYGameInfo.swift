//
//  DYGameInfo.swift
//  circle_snap
//
//  Created by Sam Richard on 12/18/24.
//

import Foundation

class DYGameInfo {
    var score: Int = 0
    var progress: Double = 0.0
    var currentGameStatus: GameStatus = .starting
    
    func reset() {
        score = 0
        progress = 0.0
        currentGameStatus = .starting
    }
    
    func updateScore(_ score: Int) {
        self.score += score
    }
    
    func updateGameStatus(_ status: GameStatus) {
        self.currentGameStatus = status
    }
}
